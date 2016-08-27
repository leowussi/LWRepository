//
//  LoginView.m
//  telecom
//
//  Created by ZhongYun on 14-6-11.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "LoginView.h"
#import "DeviceUtil.h"
#import "fashion.h"
#import "AppDelegate.h"
//void getConfig(void);
//void getiPowerAccessToken(void);

@interface LoginView ()<UITextFieldDelegate>
{
    UITextField *userFiled;
    UILabel *telLable;
}
@end

@implementation LoginView

- (id)init
{
    self = [super initWithFrame:RECT(0, 0, SCREEN_W, SCREEN_H)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        [user objectForKey:@"userText"];
//        [user objectForKey:@"userpwd"];
//        NSLog(@"%@\n%@",[user objectForKey:@"userText"],[user objectForKey:@"userpwd"]);
        
        //        newImageView(self, @[@50, @"loginn_bg_.png"]);
        UIImageView *bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        bgImgView.image = [UIImage imageNamed:@"loginn_bg.png"];
        bgImgView.userInteractionEnabled = YES;
        [self addSubview:bgImgView];
        
        NSArray *placeholderArray = [[NSArray alloc]initWithObjects:@"用户名",@"密码", nil];
        for (int i = 0; i < placeholderArray.count; i++) {
            userFiled = [[UITextField alloc]initWithFrame:CGRectMake(50, kScreenHeight-300+i*55, kScreenWidth-100, 40)];
            userFiled.borderStyle = UITextBorderStyleRoundedRect;
            userFiled.layer.masksToBounds = YES;
            userFiled.layer.cornerRadius = 20;
            userFiled.delegate = self;
            userFiled.tag = 100+i;
            userFiled.placeholder = [placeholderArray objectAtIndex:i];
            userFiled.textAlignment = NSTextAlignmentCenter;
            userFiled.font = [UIFont systemFontOfSize:13.0];
            userFiled.backgroundColor = [UIColor clearColor];
            userFiled.textColor = [UIColor whiteColor];
            userFiled.layer.borderColor = [UIColor whiteColor].CGColor;
            userFiled.layer.borderWidth = 1.0;
        
            [bgImgView addSubview:userFiled];
        
            if (i == 1) {
                userFiled.secureTextEntry = YES;
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
        [loginBtn addTarget:self action:@selector(loginBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [bgImgView addSubview:loginBtn];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapGestureRecognizer];
        
//        [bgImgView release];
//        [userFiled release];
//        [loginBtn release];
//        [tapGestureRecognizer release];
        
        
    }
    UIImage *gouImg = [UIImage imageNamed:@"dagou.png"];
    UIButton *gouBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gouBtn setBackgroundImage:gouImg forState:UIControlStateNormal];
    [gouBtn setFrame:CGRectMake(kScreenWidth-240, kScreenHeight-300+2*55+55, gouImg.size.width/1.3, gouImg.size.height/1.3)];
    [self addSubview:gouBtn];
    
    UILabel *gouLable = [UnityLHClass initUILabel:@"我已仔细阅读并接受用户协议" font:10.0 color:[UIColor colorWithRed:138.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-220, kScreenHeight-300+2*55+53, 200, 20)];
    [self addSubview:gouLable];
    
    UIImage *telImg = [UIImage imageNamed:@"tel"];
    UIImageView *telImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-230, kScreenHeight-30, telImg.size.width/2, telImg.size.height/2)];
    telImgView.image = telImg;
    [self addSubview:telImgView];
    
    UILabel *severLable = [UnityLHClass initUILabel:@"技术服务热线 :" font:10.0 color:[UIColor colorWithRed:138.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-210, kScreenHeight-30, 100, 20)];
    [self addSubview:severLable];
    
    telLable = [UnityLHClass initUILabel:@"55666608" font:10.0 color:[UIColor colorWithRed:138.0/255.0 green:145.0/255.0 blue:149.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-140, kScreenHeight-30, 100, 20)];
    telLable.userInteractionEnabled = YES;
    [self addSubview:telLable];
    
    
    UIButton *callBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    callBtn.backgroundColor = [UIColor clearColor];
    [callBtn addTarget:self action:@selector(callBtn) forControlEvents:UIControlEventTouchUpInside];
    [telLable addSubview:callBtn];
    
    return self;
}


-(void)callBtn
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",telLable.text];
    
    NSURL *telURL =[NSURL URLWithString:telUrl];// 貌似tel:// 或者 tel: 都行
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    
    //记得添加到view上
    
    [self addSubview:callWebview];
}

- (void)loginBtnTouched:(id)sender
{
    NSString* user = ((UITextField*)[self viewWithTag:100]).text;
    NSString* pswd = ((UITextField*)[self viewWithTag:101]).text;
    
    if (user.length==0 || pswd.length==0) {
        return;
    }
    
    httpGET1(@{URL_TYPE:NW_loginapp,
               @"Userid":user,
               @"Password":pswd},
             ^(id result) {
                 
//                 NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
//                 [userDefault setObject:user forKey:@"userText"];
//                 [userDefault setObject:pswd forKey:@"userpwd"];
                 
                 USET(U_ACCOUNT, user);
                 USET(U_PSWD, pswd);
                 USET(U_NAME, result[@"username"]);
                 USET(U_TOKEN, result[@"accessToken"]);
                 
                 mainThread(onloginSuccess, nil);
                 [UIView animateWithDuration:0.3 animations:^{
                     self.fx = -APP_W;
                 } completion:^(BOOL finished) {
                     [self removeFromSuperview];
                 }];
             });
    
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    CGRect frame = self.frame;
    frame.origin.y -=110;
    frame.size.height +=110;
    self.frame = frame;
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.frame = frame;
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap
{
    [self endEditing:YES];
}

- (void)onloginSuccess
{
    INIT_LOG_FILE;
    getiPowerAccessToken();
    getConfig();
    doDeviceToken(1);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end

//void getConfig(void)
//{
//    NSString* deviceModel = [DeviceUtil hardwareSimpleDescription];
//    NSDictionary* param = @{URL_TYPE:NW_GetConfig,
//                            @"deviceType":@"1",
//                            @"appVersion":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
//                            @"osVersion":[[UIDevice currentDevice] systemVersion],
//                            @"deviceModel":deviceModel};
//    httpGET1(param, ^(id result) {
//        USET(U_CONFIG, result);
//        NOTIF_POST(USER_CONFIG, nil);
//    });
//}



void showLogin()
{
    if (UGET(U_TOKEN)) {
        INIT_LOG_FILE;
//        getiPowerAccessToken();
//        getConfig();
        return;
    }
    LoginView* login = [[LoginView alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:login];
//    [login release];
}

//void doDeviceToken(int opType)
//{
//#if defined(V_TELECOM)
//    if (UGET(DEVICE_TOKEN)==nil || UGET(U_TOKEN)==nil) {
//        return;
//    }
//#elif defined(V_ASSISTOR)
//    if (UGET(ASSI_IMSI)==nil || UGET(ASSI_CONSTRUCTOR)==nil) {
//        return;
//    }
//#endif
//    NSString* url = (opType==1 ? NW_bindDeviceToken : NW_unBindDeviceToken);
//    httpGET1(@{URL_TYPE:url, @"deviceToken":UGET(DEVICE_TOKEN)}, ^(id result) {
//        USET(DEVICE_BIND_OK, (opType==1 ? @"OK" : nil));
//    });
//}

