//
//  LoginController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/17.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "LoginController.h"
#import "MBProgressHUD+MJ.h"
#import "CRMHelper.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "CRMHelper.h"
#import "ZYFUrl.h"
#import "ZYFHttpTool.h"
#import "ZYFUrl.h"
#import "DesEncrypt.h"

@interface LoginController () <NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextField *accountTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *secretTextFeild;
@property (weak, nonatomic) IBOutlet UISwitch *autoLoginSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *rememberSwitch;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property(strong,nonatomic)UIWebView *webView;

- (IBAction)autoLogin:(UISwitch *)sender;
- (IBAction)remeberScret:(UISwitch *)sender;
- (IBAction)login:(UIButton *)sender;

@end

@implementation LoginController


- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *path = [CRMHelper createFilePathWithFileName:@"jdslf"];
    
    self.loginBtn.layer.cornerRadius = 10.0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(accountTextFeildChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    //首先从沙盒账户信息
    self.accountTextFeild.text = [ZYFUserDefaults objectForKey:ZYFAccountKey];
    self.rememberSwitch.on = [ZYFUserDefaults boolForKey:ZYFRmbPwdKey];
    //如果是记住密码,则自动填充账号密码
    if (self.rememberSwitch.on) {
        self.secretTextFeild.text = [ZYFUserDefaults objectForKey:ZYFPwdKey];
    }
    
    //如果本地上次设置自动登陆，则自动登陆账号
    self.autoLoginSwitch.on = [ZYFUserDefaults boolForKey:ZYFAutoLoginKey];
    if (self.autoLoginSwitch.isOn) {
        [self login:nil];
    }
}

- (void)accountTextFeildChanged
{
    self.secretTextFeild.text = @"";
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

- (IBAction)autoLogin:(UISwitch *)sender {
    if (self.autoLoginSwitch.isOn) {
        self.rememberSwitch.on = YES;
    }
}

- (IBAction)remeberScret:(UISwitch *)sender {
    if ( ! self.rememberSwitch.isOn) {
        self.autoLoginSwitch.on = NO;
    }
}

- (IBAction)login:(UIButton *)sender {
    if (self.accountTextFeild.text.length <= 0  || self.secretTextFeild.text.length <= 0 || self.accountTextFeild.text == nil || self.secretTextFeild.text == nil) {
        [MBProgressHUD showError:@"账号或密码不能为空"];
    }else{
        if ( ! [CRMHelper isEnableNetWork]) {
            //如果当前网络不能工作
            [self performSegueWithIdentifier:@"login2Main" sender:nil];
        }else{
//            [self vertifyByServer];
            [self loginTest];
        }
    }
}

- (void)loginTest
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *afJsonRequestSerializer = [[AFJSONRequestSerializer alloc] init];
    [afJsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    mgr.requestSerializer = afJsonRequestSerializer;
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    mgr.shouldUseCredentialStorage = YES;
    
    NSString *urlString = kLogin;
//    NSString *urlString = @"http://100.100.100.64:6066/api/Home/login";
//    NSString *urlString = @"http://100.100.100.68:61112/api/Home/login";


    
    //判断每次输入账号时，是否把“auxgroup\”也输入进来了
    if ([self.accountTextFeild.text hasPrefix:@"auxgroup\\"]) {
        self.accountTextFeild.text = [self.accountTextFeild.text substringWithRange:NSMakeRange(9, self.accountTextFeild.text.length - 9)];
    }
    
    //去空格
    self.accountTextFeild.text = [self.accountTextFeild.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.secretTextFeild.text = [self.secretTextFeild.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    char *usenameKey = "username";
    char *passwdKey = "password";
    const char *encrypUserName = [DesEncrypt sharedDesEncrypt]->encryptText([self.accountTextFeild.text UTF8String],usenameKey);
    const char *encrypPasswd = [DesEncrypt sharedDesEncrypt]->encryptText([self.secretTextFeild.text UTF8String],passwdKey);


    params[@"username"] = [NSString stringWithUTF8String:encrypUserName];
    params[@"password"] = [NSString stringWithUTF8String:encrypPasswd];
    params[@"logon"] = @"0";
    params[@"type"] = @"pad";
    
    [mgr GET:urlString parameters:params
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves   error:nil];
         NSString *msg = dictionary[@"Msg"];
         NSString *code = dictionary[@"Code"];
         NSString *cookie = dictionary[@"cookie"];
         if (code.intValue == 1) {
             //如果登陆成功,把当前的账号、密码、以及状态保存到沙盒中去
             [ZYFUserDefaults setObject:self.accountTextFeild.text forKey:ZYFAccountKey];
             [ZYFUserDefaults setObject:self.secretTextFeild.text forKey:ZYFPwdKey];
             [ZYFUserDefaults setBool:self.rememberSwitch.isOn forKey:ZYFRmbPwdKey];
             [ZYFUserDefaults setBool:self.autoLoginSwitch.isOn forKey:ZYFAutoLoginKey];
             
             [MBProgressHUD showSuccess:@"登陆成功"];
             [self performSegueWithIdentifier:@"login2Main" sender:nil];
             
             //登陆状态成功为yes
             [ZYFUserDefaults setBool:YES forKey:ZYFLoginSucess];
             [[NSNotificationCenter defaultCenter]postNotificationName:ZYFLoginSucessNotify object:self];
         }else{
             [MBProgressHUD showError:msg];
         }

     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD showError:@"登陆失败"];
     }];
    
}

-(void)vertifyByServer
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *afJsonRequestSerializer = [[AFJSONRequestSerializer alloc] init];
    [afJsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    mgr.requestSerializer = afJsonRequestSerializer;
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    mgr.shouldUseCredentialStorage = YES;
    
    NSString *urlString = kLogin;
    
    //判断每次输入账号时，是否把“auxgroup\”也输入进来了
    if ([self.accountTextFeild.text hasPrefix:@"auxgroup\\"]) {
        self.accountTextFeild.text = [self.accountTextFeild.text substringWithRange:NSMakeRange(9, self.accountTextFeild.text.length - 9)];
    }
    
    //去空格
    self.accountTextFeild.text = [self.accountTextFeild.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.secretTextFeild.text = [self.secretTextFeild.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    NSURLCredential *credential =  [NSURLCredential credentialWithUser:[@"auxgroup\\" stringByAppendingString:self.accountTextFeild.text] password:self.secretTextFeild.text
                                                           persistence:NSURLCredentialPersistenceForSession];
    [mgr setCredential:credential];
    
    [mgr GET:urlString parameters:nil
     success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         //如果登陆成功,把当前的账号、密码、以及状态保存到沙盒中去
         [ZYFUserDefaults setObject:self.accountTextFeild.text forKey:ZYFAccountKey];
         [ZYFUserDefaults setObject:self.secretTextFeild.text forKey:ZYFPwdKey];
         [ZYFUserDefaults setBool:self.rememberSwitch.isOn forKey:ZYFRmbPwdKey];
         [ZYFUserDefaults setBool:self.autoLoginSwitch.isOn forKey:ZYFAutoLoginKey];
         
         [MBProgressHUD showSuccess:@"登陆成功"];
         [self performSegueWithIdentifier:@"login2Main" sender:nil];

         //登陆状态成功为yes
         [ZYFUserDefaults setBool:YES forKey:ZYFLoginSucess];
         [[NSNotificationCenter defaultCenter]postNotificationName:ZYFLoginSucessNotify object:self];

     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         [MBProgressHUD showError:@"登陆失败"];
     }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)postDeviceToken:(NSString *)deviceToken
{
    NSString *curSystemVersion = [UIDevice currentDevice].systemVersion;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //去掉第一个字符"<"
    deviceToken = [deviceToken stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
    //去掉最后一个字符">"
    deviceToken = [deviceToken stringByReplacingCharactersInRange:NSMakeRange(deviceToken.length - 1, 1) withString:@""];
    
    params[@"new_deviceid"] = deviceToken;
    params[@"new_type"] = @"1";
    params[@"new_version"] = curSystemVersion;
    
    NSString *urlString = kAPNS;
    [ZYFHttpTool postWithURL:urlString params:params success:^(id json) {
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves  error:nil];
        NSString *msg = dictionary[@"Msg"];
        NSString *code = dictionary[@"Code"];
        if (code.intValue == 1) {
            NSLog(@"上传deviceToken成功");
        }else{
            
        }
        NSLog(@"msg == %@",msg);
        
    } failure:^(NSError *error) {
        NSLog(@"error == %@",error);
    }];
}




@end
