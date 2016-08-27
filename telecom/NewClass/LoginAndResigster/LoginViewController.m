//
//  LoginViewController.m
//  i YunWei
//
//  Created by 郝威斌 on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "RootTAMViewController.h"
#import "PWSliderViewController.h"
#import "AgreementViewController.h"
#import "DeviceUtil.h"
#import "ChooseEntranceController.h"

void getConfig(void);
void getiPowerAccessToken(void);
@interface LoginViewController ()<UITextFieldDelegate>
{
    UILabel *telLable;
    
    NSInteger gouTag;
    NSString *strUser;
    NSString *strPwd;
    UIButton *gouBtn;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    bgImgView.image = [UIImage imageNamed:@"loginn_bg.png"];
    bgImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgImgView];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    strUser = [user objectForKey:@"userName"];
    strPwd = [user objectForKey:@"userPwd"];
    
    NSArray *placeholderArray = [[NSArray alloc]initWithObjects:@"用户名",@"密码", nil];
    for (int i = 0; i < placeholderArray.count; i++) {
        UITextField *userFiled = [[UITextField alloc]initWithFrame:CGRectMake(50, kScreenHeight-300+i*55, kScreenWidth-100, 40)];
        userFiled.borderStyle = UITextBorderStyleRoundedRect;
        userFiled.layer.masksToBounds = YES;
        userFiled.layer.cornerRadius = 20;
        userFiled.delegate = self;
        userFiled.tag = 100+i;
        userFiled.placeholder = [placeholderArray objectAtIndex:i];
        userFiled.backgroundColor = [UIColor clearColor];
        userFiled.textColor = [UIColor whiteColor];
        userFiled.textAlignment = NSTextAlignmentCenter;
        userFiled.font = [UIFont systemFontOfSize:13.0];
        userFiled.layer.borderColor = [UIColor whiteColor].CGColor;
        userFiled.layer.borderWidth = 1.0;
        [bgImgView addSubview:userFiled];
        
        
        if (i == 0) {
            userFiled.text = [user objectForKey:@"userName"];
        }
        
        if (i == 1) {
            userFiled.secureTextEntry = YES;
            userFiled.text = [user objectForKey:@"userPwd"];
        }
    }
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setFrame:CGRectMake(50, kScreenHeight-300+2*55, kScreenWidth-100, 40)];
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:[UIColor whiteColor]];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 20;
    [loginBtn addTarget:self action:@selector(loginBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgImgView addSubview:loginBtn];
    
    
    
    
    gouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gouBtn setBackgroundImage:[UIImage imageNamed:@"未勾选.png"] forState:UIControlStateNormal];
    [gouBtn setBackgroundImage:[UIImage imageNamed:@"勾选.png"] forState:UIControlStateSelected];
    
    [gouBtn setFrame:CGRectMake(kScreenWidth-240, kScreenHeight-300+2*55+55, [UIImage imageNamed:@"勾选.png"].size.width/1.3, [UIImage imageNamed:@"勾选.png"].size.height/1.3)];
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"select"]isEqualToString:@"select"]) {
        gouBtn.selected = YES;
    }
    [gouBtn addTarget:self action:@selector(gouBtn:) forControlEvents:UIControlEventTouchUpInside];
    gouBtn.titleLabel.text = @"1";
    [self.view addSubview:gouBtn];
    
    
    UILabel *gouLable = [UnityLHClass initUILabel:@"我已仔细阅读并接受用户协议" font:10.0 color:[UIColor colorWithRed:138.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-220, kScreenHeight-300+2*55+53, 200, 20)];
    gouLable.userInteractionEnabled = YES;
    [self.view addSubview:gouLable];
    
    UIButton *agreementBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
    agreementBtn.backgroundColor = [UIColor clearColor];
    [agreementBtn addTarget:self action:@selector(agreementBtn) forControlEvents:UIControlEventTouchUpInside];
    [gouLable addSubview:agreementBtn];
    
    UIImage *telImg = [UIImage imageNamed:@"tel"];
    UIImageView *telImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-230, kScreenHeight-30, telImg.size.width/2, telImg.size.height/2)];
    telImgView.image = telImg;
    [self.view addSubview:telImgView];
    
    UILabel *severLable = [UnityLHClass initUILabel:@"技术服务热线 :" font:10.0 color:[UIColor colorWithRed:138.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-210, kScreenHeight-30, 100, 20)];
    [self.view addSubview:severLable];
    
    telLable = [UnityLHClass initUILabel:@"55666608" font:10.0 color:[UIColor colorWithRed:138.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-140, kScreenHeight-30, 100, 20)];
    telLable.userInteractionEnabled = YES;
    [self.view addSubview:telLable];
    
    
    UIButton *callBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    callBtn.backgroundColor = [UIColor clearColor];
    [callBtn addTarget:self action:@selector(callBtn) forControlEvents:UIControlEventTouchUpInside];
    [telLable addSubview:callBtn];
    
    //    getiPowerAccessToken();
    //    getConfig();
}


-(void)callBtn
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",telLable.text];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    
    [self.view addSubview:callWebview];
}

#pragma mark == 用户协议
-(void)agreementBtn
{
    AgreementViewController *agreeVC = [[AgreementViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:agreeVC];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [delegate.window.rootViewController presentViewController:nav animated:YES completion:nil];
    //    [self presentViewController:nav animated:YES completion:nil];
}

-(void)gouBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        [[NSUserDefaults standardUserDefaults]setObject:@"select" forKey:@"select"];
    }else{
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"select"];
    }
}

void getiPowerAccessToken(void)
{
    httpGET1(@{URL_TYPE:NW_GetaccessToken}, ^(id result) {
        if (((NSArray*)result).count > 0) {
            USET(U_POWER_TOKEN, result[@"detail"][@"accessToken"]);
        }
    });
}

void getConfig(void)
{
    USET(U_CONFIG, nil);
    NSString* deviceModel = [DeviceUtil hardwareSimpleDescription];
    NSDictionary* param = @{URL_TYPE:NW_GetConfig,
                            @"deviceType":@"1",
                            @"appVersion":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                            @"osVersion":[[UIDevice currentDevice] systemVersion],
                            @"deviceModel":deviceModel};
    httpGET1(param, ^(id result) {
        
        USET(U_CONFIG, result);
        NOTIF_POST(USER_CONFIG, nil);
    });
}


void doDeviceToken(int opType)
{
    NSString* url = (opType==1 ? NW_bindDeviceToken : NW_unBindDeviceToken);
    
    NSLog(@"%@",UGET(DEVICE_TOKEN));
    
    httpGET1(@{URL_TYPE:url, @"deviceToken":UGET(DEVICE_TOKEN)}, ^(id result) {
        USET(DEVICE_BIND_OK, (opType==1 ? @"OK" : nil));
    });
}
/**
 *  登陆功能 实现
 */
-(void)loginBtn
{
    NSLog(@"%@\n%@",strUser,strPwd);
    
    if (!gouBtn.isSelected) {
        [self showAlertWithTitle:@"提示" :@"亲！请仔细阅读用户协议并勾选！" :@"确定" :nil];
    }else if (strUser == nil || strUser.length <= 0){
        [self showAlertWithTitle:@"提示" :@"请输入用户名" :@"确定" :nil];
    }else if (strPwd == nil || strPwd.length <= 0){
        [self showAlertWithTitle:@"提示" :@"请输入密码" :@"确定" :nil];
    }else{
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"loginapp";
        paraDict[@"Userid"] = strUser;
        paraDict[@"Password"] = strPwd;
        __weak typeof(self) Lgself=self;
        httpGET2(paraDict, ^(id result) {
            
            if (![ADDR_IP isEqualToString:@"main.telecomsh.cn"]) {
                showAlert([NSString stringWithFormat:@"当前连接环境:%@",ADDR_IP]);
            }
            
            
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setObject:@"1" forKey:@"sucess"];
                if ([result[@"hasHouse"] isEqualToString:@"1"]) {
                    [user setObject:@"2" forKey:@"entrance"];
                }else{
                    [user setObject:@"1" forKey:@"entrance"];
                }
                
                [user setObject:strUser forKey:@"userName"];
                [user setObject:strPwd forKey:@"userPwd"];
                
                USET(U_ACCOUNT, strUser);
                USET(U_PSWD, strPwd);
                USET(U_NAME, result[@"username"]);
                USET(U_TOKEN, result[@"accessToken"]);
                
                getiPowerAccessToken();
                getConfig();
                
#if !TARGET_IPHONE_SIMULATOR
                if ((NSString *)UGET(DEVICE_TOKEN) != nil) {
                    doDeviceToken(1);
                }
#endif
                [self saveAuthorityInfo];//保存用户权限信息
                
                [user removeObjectForKey:@"type"];
                
                if ([result[@"hasHouse"] isEqualToString:@"1"]) {
                    ChooseEntranceController *entranceCtrl = [[ChooseEntranceController alloc] init];
                    [self presentViewController:entranceCtrl animated:YES completion:^{
                        nil;
                    }];
                }else{
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                                        RootTAMViewController* rootVc = [[RootTAMViewController alloc] init];
//                    ChooseEntranceController *rootVc = [[ChooseEntranceController alloc] init];
                    DDMenuController *rootController = [[DDMenuController alloc] initWithRootViewController:rootVc];
                    appDelegate.menuController = rootController;
                    
                    //添加右滑的视图
                    RightViewController *rightController = [[RightViewController alloc] init];
                    rootController.rightViewController = rightController;
                    
                    [appDelegate.window setBackgroundColor:[UIColor whiteColor]];
                    [appDelegate.window makeKeyAndVisible];
                    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0]];
                    
                    appDelegate.window.rootViewController = rootController;
                }
                
                //                                [Lgself saveAuthorityInfo];//保存用户权限信息
            }
            
        }, ^(id result) {
            [Lgself showAlertWithTitle:@"提示" :[result objectForKey:@"error"] :@"确定" :nil];
        });
    }
}

- (void)saveAuthorityInfo
{    __weak typeof(self) Lgself=self;
    NSMutableDictionary *authorityPara = [NSMutableDictionary dictionary];
    authorityPara[URL_TYPE] = @"myInfo/GetAuthorityInfo";
    
    httpGET2(authorityPara, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:result[@"viewList"] forKey:@"authorityViewList"];
            [userDefault setObject:result[@"taskList"] forKey:@"authorityTaskList"];
            [userDefault setObject:result[@"infoList"] forKey:@"authorityInfoList"];
            [userDefault setObject:result[@"dailyList"] forKey:@"authorityDailyList"];
            NSString *string = [NSString stringWithFormat:@"%ld",(long)gouTag];
            [userDefault setObject:string forKey:@"gouTag"];
            [userDefault synchronize];
            
            [Lgself setupHomelist];
        }
    },^(id result){
        showAlert(@"用户权限信息未成功录入,请重新登录!");
        [[NSUserDefaults standardUserDefaults] setObject:@"failToSaveAuthorityInfo" forKey:@"flag"];//未成功保存用户权限信息，则保存此flag用来判别
    });
    
}
/**
 *  登陆同时保存首页信息
 */
- (void)setupHomelist
{
    httpGET1(@{URL_TYPE : @"myInfo/GetMenuList"},^(id result) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:result[@"list"] forKey:@"authorityHomeList"];
        [userDefault synchronize];
        DLog(@"%s______%d__________%@_______________",__func__,__LINE__,result[@"list"]);
    });
}

-(void)dealloc{
    DLog(@"_____________________%@",@"登陆页面被销毁。+++++++++++++++++++++");
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.view.frame;
    frame.origin.y -=100;
    frame.size.height +=100;
    self.view.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (textField.tag == 100) {
        strUser = textField.text;
    }else{
        strPwd = textField.text;
    }
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

@end
