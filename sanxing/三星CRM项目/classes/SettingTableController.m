//
//  SettingTableController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "SettingTableController.h"
#import "SettingCell.h"
#import "HeaderView.h"
#import "LoginController.h"
#import "ZYFUrl.h"
#import "MBProgressHUD+MJ.h"
#import "CRMHelper.h"
#import "VersionController.h"
#import "SDWebImageManager.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kAlertYesButton 1

@interface SettingTableController () <UIAlertViewDelegate>

@property (nonatomic,strong) NSArray *cellImages;

@end

@implementation SettingTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setTitle:@"设置"];
    
    [self setHeaderView];
    [self setFooterView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

-(void)setHeaderView
{
    HeaderView *headerView = [[HeaderView alloc]init];
    self.tableView.tableHeaderView = headerView;
}

-(void)setFooterView
{
    UIView *footBgView = [[UIView alloc]init];
    footBgView.bounds = CGRectMake(0, 0, 0, 100);
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"退出登陆" forState:UIControlStateNormal];
    button.bounds = CGRectMake(0, 0, 180, 33);
    [button.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    button.center = CGPointMake(self.view.bounds.size.width / 2.0, 80);
    
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    [footBgView addSubview:button];
    
    self.tableView.tableFooterView = footBgView;
    
}

-(void)logout
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"退出后,之前的相关信息将被清空,确定退出?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定退出", nil];
    [alert show];
    
}

#pragma mark -- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == kAlertYesButton) {
        //    NSUserDefaults中的本地化删除
        //        [ZYFUserDefaults removeObjectForKey:ZYFAccountKey];
        //        [ZYFUserDefaults removeObjectForKey:ZYFPwdKey];
        //        [ZYFUserDefaults removeObjectForKey:ZYFRmbPwdKey];
        [ZYFUserDefaults removeObjectForKey:ZYFAutoLoginKey];
        [ZYFUserDefaults removeObjectForKey:ZYFDeviceToken];
        [ZYFUserDefaults removeObjectForKey:ZYFSignInSucess];
        [ZYFUserDefaults removeObjectForKey:ZYFSignOutSucess];
        
        [self deleteCredient];
        
        //跳转到主界面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UINavigationController *targetVC = [storyboard instantiateInitialViewController];
        
        self.view.window.rootViewController = targetVC;
    }
}

- (void)deleteCredient
{
    //1、
    NSDictionary *credentialsDict = [[NSURLCredentialStorage sharedCredentialStorage] allCredentials];
    if ([credentialsDict count] > 0) {
        // the credentialsDict has NSURLProtectionSpace objs as keys and dicts of userName => NSURLCredential
        NSEnumerator *protectionSpaceEnumerator = [credentialsDict keyEnumerator];
        id urlProtectionSpace;
        // iterate over all NSURLProtectionSpaces
        while (urlProtectionSpace = [protectionSpaceEnumerator nextObject]) {
            NSEnumerator *userNameEnumerator = [[credentialsDict objectForKey:urlProtectionSpace] keyEnumerator];
            id userName;
            // iterate over all usernames for this protectionspace, which are the keys for the actual NSURLCredentials
            while (userName = [userNameEnumerator nextObject]) {
                NSURLCredential *cred = [[credentialsDict objectForKey:urlProtectionSpace] objectForKey:userName];
                [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:cred forProtectionSpace:urlProtectionSpace];
            }
        }
    }
    
    //2、
    NSURLCache *sharedCache = [NSURLCache sharedURLCache];
    [sharedCache removeAllCachedResponses];
    
    //3、
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [cookieStorage cookies];
    for (NSHTTPCookie *cookie in cookies) {
        [cookieStorage deleteCookie:cookie];
        NSLog(@"deleted cookie");
    }
    
    [ZYFUserDefaults synchronize];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"settings";
    SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.imageView.image = [UIImage imageNamed:self.cellImages[indexPath.row]];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"版本更新";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = @"版本说明";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = @"密码管理";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 3) {
        cell.textLabel.text = @"缓存清理";
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cache2.png"]];
        imageView.bounds = CGRectMake(0, 0, 40, 40);
        cell.accessoryView = imageView;
    }
    
    return cell;
}


-(NSArray *)cellImages
{
    if (_cellImages == nil) {
        _cellImages = @[@"cache",@"version",@"passwd",@"local"];
    }
    
    return _cellImages;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        //版本更新
        VersionController *ctrl = [[VersionController alloc]init];
        ctrl.type = @"版本更新";
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }else if (indexPath.row == 1){
        //版本说明
        VersionController *ctrl = [[VersionController alloc]init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (indexPath.row == 2){
        //密码管理
        [MBProgressHUD showSuccess:@"该功能尚未开放"];
    }else if (indexPath.row == 3){
        
        [MBProgressHUD showMessage:nil toView:self.view];
        //缓存清理
        SDWebImageManager *mgr = [SDWebImageManager sharedManager];
        // 2.清除内存缓存
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [mgr.imageCache clearMemory];
            NSUInteger imageCount = [mgr.imageCache getDiskCount];
            NSString *cleanMsg = [NSString stringWithFormat:@"共清理了%ld张图片和其他资源",imageCount];
            [mgr.imageCache clearDiskOnCompletion:^{
                [MBProgressHUD showSuccess:cleanMsg];
            }];
        });
    }
}





@end
