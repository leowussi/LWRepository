//
//  VersionController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/30.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "VersionController.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFUrlTask.h"
#import "ZYFHttpTool.h"
#import "GDataXMLNode.h"

@interface VersionController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
//当前手机在使用的版本号
@property (nonatomic,copy) NSString *currentVersion;

@end

@implementation VersionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    //当前label显示的版本号
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersionNum =[infoDict objectForKey:@"CFBundleVersion"];
    self.versionLabel.text = [NSString stringWithFormat:@"当前版本：%@",currentVersionNum];
    self.currentVersion = currentVersionNum;

}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self.type isEqualToString:@"版本更新"]) {
        [self checkForUpdate];
    }
}

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

- (void)checkForUpdate
{
    [MBProgressHUD showMessage:nil toView:self.view ];
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
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //跳转到ios下载界面
        NSURL *url = [NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://sxcrm.auxgroup.com:6064/app/ios/sxapp.plist"];
        [[UIApplication sharedApplication]openURL:url];
    }
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.navigationController popViewControllerAnimated:YES];
}





@end
