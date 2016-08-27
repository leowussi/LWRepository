//
//  AppDelegate.m
//  telecom
//
//  Created by ZhongYun on 14-6-11.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "AssiMainViewController.h"
#import "LoginView.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "RootTAMViewController.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import <ShareSDK/ShareSDK.h>
#import "BackLocation.h"
#import "UIView+border.h"
#import "HomeViewController.h"
#include <sys/utsname.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "RNCachingURLProtocol.h"
#import "BuildingResourceMapController.h"
#import "CoreStatus.h"
#import "HWBProgressHUD.h"
#import "MKNetworkKit.h"

AppDelegate* g_app = nil;
@interface AppDelegate ()<BMKGeneralDelegate,UIAlertViewDelegate,CoreStatusProtocol>
{
    NSMutableDictionary* m_openUrl;
    BMKMapManager* _mapManager;
    UIViewController* m_mainVC;
    CLLocationManager *locationManager;
    NSString* str_net_v;
    
    UIView *_alertView;
}
@end

BMKMapManager* _mapManager;
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    
    [ShareSDK registerApp:@"b27bde002944"];//您的ShareSDK的AppKey
    
    //添加微信应用 注册网址 http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:@"wx6ec1b210a8a22e5c"
                           wechatCls:[WXApi class]];
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wx6ec1b210a8a22e5c"
                           appSecret:@"ac689ffb03a2eb0a772890fdcdb35d50"
                           wechatCls:[WXApi class]];
    
    [self appInit];
    
    [self RecordSystemInfo];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0]];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    if ([[user objectForKey:@"sucess"] isEqualToString:@"1"]) {//登陆成功
        NSString *str= [[NSUserDefaults standardUserDefaults]objectForKey:@"selectRootVC"];

        if ([str isEqualToString:@"BuildingResourceMapController"]) {//有i楼宇权限   直接进入i楼宇？
            [self ILouYU];
        }
        if ([[user objectForKey:@"entrance"] isEqualToString:@"2"]) {
            [self ILouYU];
        }else{
            [self IyunWei];
        }
        if([str isEqualToString:@"RootTAMViewController"]) {
            [self IyunWei];
        }
    }else{
        LoginViewController* rootVc = [[LoginViewController alloc] init];
        
        DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:rootVc];
        self.menuController = rootController;
        
        RightViewController *rightController = [[RightViewController alloc] init];
        rootController.rightViewController = rightController;
        
        self.window.rootViewController = rootController;
        [self.window setBackgroundColor:[UIColor whiteColor]];
        [self.window makeKeyAndVisible];
    }
    
    mainThread(checkVersion, nil);
    
#if !TARGET_IPHONE_SIMULATOR
    [self initAppPush:application Options:launchOptions];
#endif
    return YES;
}
-(void)IyunWei{
    RootTAMViewController* rootVc = [[RootTAMViewController alloc] init];//进入i运维
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:rootVc];
    self.menuController = rootController;
    
    RightViewController *rightController = [[RightViewController alloc] init];
    rootController.rightViewController = rightController;
    self.window.rootViewController = rootController;
    [self.window setBackgroundColor:[UIColor whiteColor]];
    [self.window makeKeyAndVisible];

}
-(void)ILouYU{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    BuildingResourceMapController *buildingResourceCtrl = [[BuildingResourceMapController alloc] init];
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:buildingResourceCtrl];
    
    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:navCtrl];
    appDelegate.menuController = rootController;
    
    RightViewController *rightController = [[RightViewController alloc] init];
    rootController.rightViewController = rightController;
    
    [appDelegate.window setBackgroundColor:[UIColor whiteColor]];
    [appDelegate.window makeKeyAndVisible];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0]];
    
    appDelegate.window.rootViewController = rootController;

}

//当网络改变时

-(void)coreNetworkChangeNoti:(NSNotification *)noti{
    
    NSString *stateString = nil;
    
    //获取当前网络状态
    
    CoreNetWorkStatus currentStatus = [CoreStatus currentNetWorkStatus];
    //如果当前的网络状态和之前的网络状态一致,则return;
    static CoreNetWorkStatus previousStatus = -1;
    if (previousStatus == currentStatus) {
        return;
    }
    previousStatus = currentStatus;

    switch (currentStatus) {
            
        case CoreNetWorkStatusNone:
            
            stateString = @"无网络";
            
            break;
            
        case CoreNetWorkStatusWifi:
            
            stateString = @"Wifi网络";
            
            break;
            
        case CoreNetWorkStatusWWAN:
            
            stateString = @"蜂窝网络";
            
            break;
            
        case CoreNetWorkStatus2G:
            
            stateString = @"2G网络";
            
            break;
            
        case CoreNetWorkStatus3G:
            
            stateString = @"3G网络";
            
            break;
            
        case CoreNetWorkStatus4G:
            
            stateString = @"4G网络";
            
            break;
            
        case CoreNetWorkStatusUnkhow:
            
            stateString = @"未知网络";
            
            break;
            
        default:
            
            stateString = @"未知网络";
            
            break;
            
    }
    [self showMessage:[NSString stringWithFormat:@"您正处于%@状态",stateString]];
    
}
-(void)showMessage:(NSString *)message{
    

    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    [MBProgressHUD hideHUDForView:view animated:YES];
    HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:view animated:YES];
    
    hideLoading();
    //弹出框的类型
    hud.mode = HWBProgressHUDModeText;
    //弹出框上的文字
    hud.detailsLabelText = message;
    //弹出框的动画效果及时间
    [hud showAnimated:YES whileExecutingBlock:^{
        //执行请求，完成
        sleep(2);
    } completionBlock:^{
        //完成后如何操作，让弹出框消失掉
        [hud removeFromSuperview];
    }];
}

- (void)initAppPush:(UIApplication *)application Options:(NSDictionary *)launchOptions
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }else{
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                                (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    }
}

- (void)readAppPush:(UIApplication *)application Payload:(NSDictionary *)payload
{
    application.applicationIconBadgeNumber --;
#if defined(V_TELECOM)
    if ([payload[@"pageId"] isEqualToString:@"MyRepairFaultDetailKB"]) {
        if (self.delegate) {
            [self.delegate appcationDelegatePushToControllerWith:payload[@"workNo"]];
        }
    }
    if ([payload[@"pageId"] isEqualToString:@"YZRiskOperationDetailViewController"]) {
        if (self.delegate) {
            [self.delegate appcationDelegatePushToRiskOperationControllerWith:payload[@"workNo"]];
        }
    }
#elif defined(V_ASSISTOR)
    //    NSString* pageId = payload[@"customPara"][@"pageId"];
    //    AssiMainViewController* mainVC = (AssiMainViewController*)m_mainVC;
    //    if (isPageId(PAGE_APPOINTMENT_LIST)) {
    //        [mainVC apsAssiMain];
    //    } else if (isPageId(PAGE_APPOINTMENT_DETAIL)) {
    //        [mainVC apsAssiDetail:payload[@"customPara"][@"appointmentId"]];
    //    } else if (isPageId(PAGE_SHI_GONG_DETAIL)) {
    //        [mainVC apsAssiMain];
    //    }
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)payload
{
    //ios收到推送消息时,app打开或在后台。消息会发到这里来。
    [self readAppPush:application Payload:payload];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* strToken = [deviceToken description];
    strToken = [[strToken substringWithRange:NSMakeRange(1, [strToken length] - 2)] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //用户在不同设备间登录，必须保证登录的最后一个设备作为接受消息推送的接收设备。
    NSString* localDeviceToken = UGET(DEVICE_TOKEN);
    if ([strToken isEqualToString:localDeviceToken]==NO || (UGET(DEVICE_BIND_OK)==nil))
    {
        USET(DEVICE_TOKEN, strToken);
        //        doDeviceTokenWhenAppLaunch(1);
        NOTIF_POST(DEVICE_TOKEN_RECIVED, nil);
    }
}

void doDeviceTokenWhenAppLaunch(int opType)
{
    NSString* url = (opType==1 ? NW_bindDeviceToken : NW_unBindDeviceToken);
    httpGET1(@{URL_TYPE:url, @"deviceToken":UGET(DEVICE_TOKEN)}, ^(id result) {
        USET(DEVICE_BIND_OK, (opType==1 ? @"OK" : nil));
    });
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if (![self onOpenUrlByOtherApp:[url absoluteString]]) {
        [self gohome];
    }
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [BMKMapView willBackGround];
    [CoreStatus endNotiNetwork:self];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //    [_mapManager stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [BMKMapView didForeGround];
    [CoreStatus beginNotiNetwork:self];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //    [_mapManager stop];
}

-(id)init
{
    if (self = [super init]) {
        g_app = self;
        m_openUrl = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)appInit
{
    addSkipBackupAttributeToItemAtURL([NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()]);
    
    if (iOSv7) {
        [[UINavigationBar appearance] setBarTintColor:APP_COLOR];
        [[UINavigationBar appearance] setTintColor:COLOR(80, 0, 149)];
        [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName:COLOR(80, 0, 149)}];
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:@"nav_btn_back.png"]];
        [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:[UIImage imageNamed:@"nav_btn_back.png"]];
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
    }
    
    initAppPL();
    
    //#if !TARGET_IPHONE_SIMULATOR
    //    [CrashReport shared].blocker = ^{
    //#if defined(V_TELECOM)
    //        return NoNullStr(UGET(U_TOKEN));
    //#elif defined(V_ASSISTOR)
    //        return NoNullStr(UGET(ASSI_IMSI));
    //#endif
    //    };
    //#endif
    
    if (!UGET(APP_SERVER)) {
        USET(APP_SERVER, ADDR_IP);
    }
    
    [self initBaiduMap];
    
    //    [BackLocation shared];
}

- (void)RecordSystemInfo
{
    NSString *application = @"10000";
    
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *carrieroperator = carrier.carrierName;
    if ([carrieroperator isEqualToString:@"中国移动"]) {
        carrieroperator = @"ChinaMobile";
    }else if ([carrieroperator isEqualToString:@"中国联通"]){
        carrieroperator = @"ChinaUnicom";
    }else if ([carrieroperator isEqualToString:@"中国电信"]){
        carrieroperator = @"ChinaTelecom";
    }else{
        carrieroperator = @"Others";
    }
    
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    //系统版本
    NSString *systemName = [[UIDevice currentDevice] systemName];
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSMutableString *osVersion = [NSMutableString string];
    [osVersion appendString:systemName];
    [osVersion appendString:systemVersion];
    
    NSString *deviceType = @"1";
    
    NSString *deviceModel = [self getCurrentDeviceModel];
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[@"application"] = application;
    paraDict[@"operationTime"] = operationTime;
    paraDict[@"carrieroperator"] = carrieroperator;
    paraDict[@"uuid"] = uuid;
    paraDict[@"appVersion"] = appVersion;
    paraDict[@"osVersion"] = osVersion;
    paraDict[@"deviceType"] = deviceType;
    paraDict[@"deviceModel"] = deviceModel;
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/RecordAppSysLog.do?",ADDR_IP,ADDR_DIR];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:requestUrl parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject-%@",responseObject[@"error"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];
}

- (void)getNewVersionInfo
{
    
}

- (void)checkVersion
{
    NSDictionary* vinfo = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:PLIST_URL]];
    if (!vinfo) {
        return;
    }
    
    NSDictionary* item = vinfo[@"items"][0];
    NSDictionary* metadata = item[@"metadata"];
    str_net_v = metadata[@"bundle-version"];
    NSString *strTitle = metadata[@"releaseNote"];
    
    //忽略这个版本
    NSString *ignoredVersion = UGET(@"ignoredVersion");
    if (ignoredVersion && [str_net_v isEqualToString:ignoredVersion]) {
        return;
    }
    
    NSString* str_app_v = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSArray* net_v = [str_net_v componentsSeparatedByString:@"."];
    NSArray* app_v = [str_app_v componentsSeparatedByString:@"."];
    
    self.netVersion = str_net_v;
    self.existNewVersion = NO;
    for (int i = 0; i < net_v.count; i++) {
        if ([net_v[i] intValue] > [app_v[i] intValue]) {
            self.existNewVersion = YES;
            break;
        }
    }
    
    if (self.existNewVersion == YES) {
        _alertView = [[UIView alloc]initWithFrame:CGRectMake(20, 100, kScreenWidth-40, 265)];
        _alertView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        _alertView.backgroundColor = RGBCOLOR(251, 251, 251);
        _alertView.layer.masksToBounds = YES;
        _alertView.layer.cornerRadius = 10;
        [self.window addSubview:_alertView];
        
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth-40, 20)];
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.text = @"提示";
        titleLab.textColor = [UIColor blackColor];
        titleLab.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        [_alertView addSubview:titleLab];
        
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(5, 35, kScreenWidth-50, 1)];
        lineV.backgroundColor = RGBCOLOR(216, 212, 215);
        [_alertView addSubview:lineV];
        
        UILabel *versionLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, kScreenWidth-40, 20)];
        versionLab.textAlignment = NSTextAlignmentCenter;
        versionLab.text = format(@"有新版本(%@)，是否要更新？", self.netVersion);
        versionLab.textColor = [UIColor blackColor];
        versionLab.font = [UIFont systemFontOfSize:15.0];
        [_alertView addSubview:versionLab];
        
        UIView *lineV1 = [[UIView alloc]initWithFrame:CGRectMake(5, 70, kScreenWidth-50, 1)];
        lineV1.backgroundColor = RGBCOLOR(216, 212, 215);
        [_alertView addSubview:lineV1];

        UITextView *contentView = [[UITextView alloc]initWithFrame:CGRectMake(10, 71, kScreenWidth-60, 150)];
        contentView.text = strTitle;
        contentView.textColor = [UIColor blackColor];
        contentView.backgroundColor = [UIColor clearColor];
        contentView.textAlignment = NSTextAlignmentLeft;
        contentView.showsVerticalScrollIndicator = NO;
        contentView.editable = NO;
        [_alertView addSubview:contentView];
        
        UIView *lineV2 = [[UIView alloc]initWithFrame:CGRectMake(5, 222, kScreenWidth-50, 1)];
        lineV2.backgroundColor = RGBCOLOR(216, 212, 215);
        [_alertView addSubview:lineV2];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setFrame:CGRectMake(5, 230, (kScreenWidth-40)/3-7, 30)];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitle:@"升级" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [cancelBtn setTitleColor:RGBCOLOR(41, 155, 255) forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(okBtn) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn circularBeadColor:RGBCOLOR(216, 212, 215)];
        [cancelBtn circularBead:5];
        [cancelBtn bottomBorder:5];
        [_alertView addSubview:cancelBtn];
        //okBtn
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [okBtn setFrame:CGRectMake(cancelBtn.frame.size.width+10, 230, (kScreenWidth-40)/3-7, 30)];
        okBtn.backgroundColor = [UIColor whiteColor];
        [okBtn setTitle:@"取消" forState:UIControlStateNormal];
        okBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [okBtn setTitleColor:RGBCOLOR(41, 155, 255) forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
        [okBtn circularBeadColor:RGBCOLOR(216, 212, 215)];
        [okBtn circularBead:5];
        [okBtn bottomBorder:5];
        [_alertView addSubview:okBtn];
        
        UIButton *ignoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [ignoreBtn setFrame:CGRectMake((okBtn.frame.size.width+5)*2+5, 230, (kScreenWidth-40)/3-7, 30)];
        ignoreBtn.backgroundColor = [UIColor whiteColor];
        [ignoreBtn setTitle:@"忽略此版本" forState:UIControlStateNormal];
        ignoreBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [ignoreBtn setTitleColor:RGBCOLOR(41, 155, 255) forState:UIControlStateNormal];
        [ignoreBtn addTarget:self action:@selector(ignoreBtn) forControlEvents:UIControlEventTouchUpInside];
        [ignoreBtn circularBeadColor:RGBCOLOR(216, 212, 215)];
        [ignoreBtn circularBead:5];
        [ignoreBtn bottomBorder:5];
        [_alertView addSubview:ignoreBtn];
    }
}


#pragma mark == 确定升级
-(void)okBtn
{
    [_alertView removeFromSuperview];
    _alertView = nil;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:format(VERS_FMT, PLIST_URL)]];
    //    [UIView animateWithDuration:0.5f animations:^{
    //        exit(0);
    //    }];
}


#pragma mark == 取消升级
-(void)cancelBtn
{
    [_alertView removeFromSuperview];
    _alertView = nil;
}


#pragma mark == 忽略升级
-(void)ignoreBtn
{
    [_alertView removeFromSuperview];
    _alertView = nil;
    USET(@"ignoredVersion", str_net_v);
}


- (BOOL)onOpenUrlByOtherApp:(NSString*)urlStr
{
    [m_openUrl removeAllObjects];
    m_openUrl[@"url"] = urlStr;
    
    NSString* tmpstr = [urlStr stringByReplacingOccurrencesOfString:@"telecom://" withString:@""];
    NSArray* list1 = [tmpstr componentsSeparatedByString:@"/"];
    
    if (list1.count < 2) return NO; //进入首页;
    m_openUrl[@"appId"] = list1[0];
    NSArray* list2 = [list1[1] componentsSeparatedByString:@"?"];
    
    if (list2.count < 1) return NO; //进入首页;
    m_openUrl[@"apiName"] = list2[0];
    
    if (list2.count >= 2) {
        NSArray* list3 = [list2[1] componentsSeparatedByString:@"&"];
        if (list3.count > 0){
            NSMutableArray* paras = [[NSMutableArray alloc] init];
            for (NSString* item in list3) {
                NSArray* list4 = [item componentsSeparatedByString:@"="];
                if (list4.count == 2) {
                    [paras addObject:@{@"pname":list4[0], @"pvalue":list4[1]}];
                }
            }
            m_openUrl[@"paras"] = paras;
        }
    }
    
    return YES;
}

- (void)gohome
{
    [self application:nil didFinishLaunchingWithOptions:nil];
}

- (void)initBaiduMap
{
    _mapManager = [[BMKMapManager alloc] init];//
    //    dBATNzEjvBcmNuXOg0CpFhNz i运维百度key
    //    MdREZqzOTLkzdZAHcfDFBOAW 测试key
    
    BOOL ret = [_mapManager start:@"dBATNzEjvBcmNuXOg0CpFhNz" generalDelegate:self];
    
    if (!ret) {
        NSLog(@"manager start failed!");
    }else{
        NSLog(@"manager start success!");
    }
}

#pragma mark - 百度地图的检测/授权操作
- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}

//获得设备型号https://www.theiphonewiki.com/wiki/Models
- (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s (A1633/A1688/A1691/A1700)";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus (A1634/A1687/A1690/A1699)";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod touch 6G (A1574)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad mini 3 (A1599)";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad mini 3 (A1600)";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad mini 3 (A1601)";
    
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad mini 4 (A1538)";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad mini 4 (A1550)";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2 (A1566)";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2 (A1567)";
    
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (A1584)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (A1652)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}
@end



@implementation UINavigationControllerEx
- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

@end