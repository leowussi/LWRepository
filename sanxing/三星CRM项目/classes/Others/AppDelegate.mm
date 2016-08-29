//
//  AppDelegate.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/12.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "AppDelegate.h"
#import "ZYFUrl.h"
#import "ZYFHttpTool.h"
#import "CRMHelper.h"
#import "LoginController.h"
#import "ZYFUrlTask.h"
#import "SDWebImageManager.h"
#import "MBProgressHUD+MJ.h"
#import <BaiduMapAPI/BMapKit.h>//引入所有的头文件

//只提醒一次可以升级
static NSString *const kOneceUpdateTips = @"OneceUpdateTips";
//保存被拒绝的版本号
static NSString *const kRejectVersion = @"rejectVersion";

@interface AppDelegate () <UIAlertViewDelegate>

@property (nonatomic,strong) NSString *deviceToken;
//当前服务器可用版本
@property (nonatomic,copy) NSString *currentServerVersion;
//百度地图manager
@property (nonatomic,strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //每次进来初始化登陆状态为false
    [ZYFUserDefaults setBool:NO forKey:ZYFLoginSucess];
    //检查更新
    [self checkForUpdate];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //注册远程通知
    [self loadRemoteNotify:application withOptions:launchOptions];
    //百度地图
    [self loadBaiduMapWithApplication:application withOptions:launchOptions];

    return YES;
}

#pragma mark - 注册远程通知
- (void)loadRemoteNotify:(UIApplication*)application withOptions:(NSDictionary *)launchOptions
{
    if ([UIDevice currentDevice].systemVersion.doubleValue <= 8.0) {
        // 不是iOS8
        UIRemoteNotificationType type = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        // 当用户第一次启动程序时就获取deviceToke
        // 该方法在iOS8以及过期了
        // 只要调用该方法, 系统就会自动发送UDID和当前程序的Bunle ID到苹果的APNs服务器
        [application registerForRemoteNotificationTypes:type];
    }else
    {
        // iOS8
        UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
        // 注册通知类型
        [application registerUserNotificationSettings:settings];
        
        // 申请试用通知
        [application registerForRemoteNotifications];
    }
    
    // 1.取出数据
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"userInfo ======== %@",userInfo);
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postDeviceToken) name:ZYFLoginSucessNotify object:nil];
}

//#pragma mark - 百度地图
- (void)loadBaiduMapWithApplication:(UIApplication*)application withOptions:(NSDictionary *)launchOptions
{
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数  //测试rp33dj3VGk9nYcUWTKlPKqXA
    BOOL ret = [_mapManager start:@"3FU617DiBpX6S2LclyiMbDbH"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager map start failed!");
    }
}


#pragma mark -- 远程通知

/**
 *  获取到用户对应当前应用程序的deviceToken时就会调用
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSLog(@"%@", deviceToken);
    // f1fa050a 2623b33c 65183a16 cc680c76 632b2808 5a69d6a1 75ebbb07 681f624f
    NSString *deviceTokenString = [NSString stringWithFormat:@"%@",deviceToken];
    self.deviceToken = deviceTokenString;
    //1、登陆前收到,保存下来，收到通知发送
    //2、登陆后收到,已经收到deviceToken
    //1和2两种情况可以通过通知来解决
    
    //3、登陆后收到,发送通知时未收到deviceToken
    BOOL isLoginSucess = [ZYFUserDefaults boolForKey:ZYFLoginSucess];
    if (isLoginSucess) {
        //如果没登陆时，就收到devicetoken，此时只保存，不发送
        [self postDeviceToken];
    }
}

-(void)postDeviceToken
{
    if (self.deviceToken != nil && self.deviceToken.length > 0) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //只往服务器发一次就行了
            [self dealDeviceToken];
        });
    }
}

- (void)dealDeviceToken
{
    NSString *curSystemVersion = [UIDevice currentDevice].systemVersion;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //去掉第一个字符"<"
    self.deviceToken = [self.deviceToken stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    //去掉最后一个字符">"
    self.deviceToken = [self.deviceToken stringByReplacingCharactersInRange:NSMakeRange(self.deviceToken.length - 1, 1) withString:@""];
    
    params[@"new_deviceid"] = self.deviceToken;
    params[@"new_type"] = @"1";
    params[@"new_version"] = curSystemVersion;
    
    NSString *urlString = kAPNS;
    [ZYFHttpTool postWithURL:urlString params:params success:^(id json) {
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        NSString *code = dictionary[@"Code"];
        if (code.intValue == 1) {
            NSLog(@"上传deviceToken成功");
        }else{
            
        }
        NSLog(@"msg == %@",msg);
        
    } failure:^(NSError *error) {
        //        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error == %@",error);
        
    }];
}

#pragma mark -- 接收到推送消息后

/*
 ios7以前苹果支持多任务, iOS7以前的多任务是假的多任务
 而iOS7开始苹果才真正的推出了多任务
 */
// 接收到远程服务器推送过来的内容就会调用
// 注意: 只有应用程序是打开状态(前台/后台), 才会调用该方法
/// 如果应用程序是关闭状态会调用didFinishLaunchingWithOptions
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /*
     如果应用程序在后台 , 只有用户点击了通知之后才会调用
     如果应用程序在前台, 会直接调用该方法
     即便应用程序关闭也可以接收到远程通知
     */
    NSLog(@"%@", userInfo);
    
}

//接收到远程服务器推送过来的内容就会调用
// ios7以后用这个处理后台任务接收到得远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    /*
     UIBackgroundFetchResultNewData, 成功接收到数据
     UIBackgroundFetchResultNoData, 没有;接收到数据
     UIBackgroundFetchResultFailed 接收失败
     */
    //    NSLog(@"%s",__func__);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"收到一条新的推送消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    NSLog(@"%s,userInfo ==== %@",__func__, userInfo);
    //    [[NSNotificationCenter defaultCenter]postNotificationName:ZYFMessageReceiveNotify object:self userInfo:userInfo];
    [[NSNotificationCenter defaultCenter]postNotificationName:ZYFMessageReceiveNotify object:self userInfo:nil];
    
    
    //可以在此处增加一个通知，将接受到得通知数据传递到需要更新界面的地方
    NSNumber *contentid =  userInfo[@"content-id"];
    if (contentid) {
        //ToDo
        //注意: 在此方法中一定要调用这个调用block, 告诉系统是否处理成功.
        // 以便于系统在后台更新UI等操作
        completionHandler(UIBackgroundFetchResultNewData);
    }else{
        completionHandler(UIBackgroundFetchResultFailed);
    }
    //    [UIApplication sharedApplication].applicationIconBadgeNumber
}

#pragma mark -- 内存警告
/**
 *  当app接收到内存警告
 */
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    
    // 1.取消正在下载的操作
    [mgr cancelAll];
    
    // 2.清除内存缓存
    [mgr.imageCache clearMemory];
}

#pragma mark -- 检查版本更新
//每次更新时候的说明
- (NSString *)updateInfo
{
    NSString  *infoPath = [[NSBundle mainBundle]pathForResource:@"updateInfo" ofType:@"plist"];
    NSArray *infoArray = [NSArray arrayWithContentsOfFile:infoPath];
    NSMutableString *mutableStr = [NSMutableString string];
    for (NSString *info in infoArray) {
        //        ZYFLog(@"info == %@",info);
        [mutableStr appendString:info];
        [mutableStr appendString:@"\n"];
    }
    return (NSString *)mutableStr;
}

- (NSString *)currentServerVersion{
    if (_currentServerVersion == nil) {
        _currentServerVersion = @"";
    }
    return _currentServerVersion;
}

- (void)checkForUpdate
{
    //    [MBProgressHUD showMessage:nil toView:self.window ];
    //当前版本
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersionNum =[infoDict objectForKey:@"CFBundleVersion"];
    
    //获取当前服务端的可用版本号
    NSURL *url = [NSURL URLWithString:kCheckForUpdate];
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfURL:url];
    NSArray *items = dict[@"items"];
    NSDictionary *firstObject = [items firstObject];
    NSDictionary *metadata = firstObject[@"metadata"];
    NSString *versionNum = metadata[@"bundle-version"];
    self.currentServerVersion = versionNum;
    
    NSMutableArray *rejectArray = [ZYFUserDefaults objectForKey:kRejectVersion];
    if ( ! rejectArray) {
        //提醒升级
        if (versionNum.length > 0) {
            if ([currentVersionNum isEqualToString:versionNum]) {
                //没有可用的更新
                NSLog(@"muyou新的版本可以更新");
            }else{
                //有新的版本可以更新
                NSLog(@"有新的版本可以更新");
                NSString *msg = [self updateInfo];
                UIAlertView *updateAlert = [[UIAlertView alloc]initWithTitle:@"有新的更新可用" message:msg delegate:self cancelButtonTitle:@"残忍拒绝" otherButtonTitles:@"马上更新", nil];
                [updateAlert show];
            }
        }
    }else{
        for (NSString *version in rejectArray) {
            if ([version isEqualToString:self.currentServerVersion]) {
                //已经被拒绝升级的不再提醒
                return;
            }else{
                //有新的版本可以更新
                NSLog(@"有新的版本可以更新");
                NSString *msg = [self updateInfo];
                UIAlertView *updateAlert = [[UIAlertView alloc]initWithTitle:@"有新的更新可用" message:msg delegate:self cancelButtonTitle:@"残忍拒绝" otherButtonTitles:@"马上更新", nil];
                [updateAlert show];
            }
        }
    }
    //    [MBProgressHUD hideHUDForView:self.window animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //跳转到ios下载界面
        NSURL *url = [NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://sxcrm.auxgroup.com:6064/app/ios/sxapp.plist"];
        [[UIApplication sharedApplication]openURL:url];
    }else{
        NSMutableArray *rejectVersion = [NSMutableArray array];
        [rejectVersion addObject:self.currentServerVersion];
        [ZYFUserDefaults setObject:rejectVersion forKey:kRejectVersion];
        
        //如果点击了拒绝升级,以后不会再提醒升级
        //        [ZYFUserDefaults setBool:YES forKey:kOneceUpdateTips];
    }
}

@end
