//
//  SettingsViewController.m
//  telecom
//
//  Created by ZhongYun on 14-6-12.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserReport.h"
#import "UserReportFilter.h"
#import "AppStoreList.h"
#import "AppDelegate.h"
#import "LoginView.h"

#define RowHeight       40
#define BRD_COLOR       COLOR(197, 197, 197)
#define LINE_COLOR      COLOR(243, 243, 243)
#define HARPY_CURRENT_VERSION                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

extern void doDeviceToken(int opType);
@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户设置";

    [self addBarObjs];
    [self loadData];
}

- (void)onBtnNextTouched:(id)sender
{
    AppStoreList* vc = [[AppStoreList alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onBtnReportTouched:(id)sender
{
    UserReport* rptVc = [[UserReport alloc] init];
    UserReportFilter* rptfilterVc = [[UserReportFilter alloc] init];
    [self.navigationController pushViewController:rptVc animated:NO];
    [self.navigationController pushViewController:rptfilterVc animated:YES];
    [rptfilterVc release];
    [rptVc release];
}

- (void)loadData
{
    httpGET1(@{URL_TYPE:NW_GetUserInfo}, ^(id result) {
        USET(U_USID, result[@"detail"][@"userId"]);
        ((UILabel*)[self.view viewWithTag:51]).text = result[@"detail"][@"account"];
        ((UILabel*)[self.view viewWithTag:53]).text = result[@"detail"][@"name"];
        ((UILabel*)[self.view viewWithTag:55]).text = result[@"detail"][@"email"];
    });
}

- (void)btnLogoutTouched:(id)sender
{
    
    httpGET1(@{URL_TYPE:NW_logoutapp}, ^(id result) {
        mainThread(toLogout, nil);
    });
}

- (void)toLogout
{
    doDeviceToken(2);
    USET(U_TOKEN, nil);
    USET(U_POWER_TOKEN, nil);
    
    showLogin();
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)addBarObjs
{
    UIView* bar1 = [[UIView alloc] initWithFrame:RECT(10, self.navBarView.ey+15, APP_W-20, RowHeight*3)];
    bar1.backgroundColor = [UIColor whiteColor];
    bar1.layer.borderColor = BRD_COLOR.CGColor;
    bar1.layer.borderWidth = 0.5;
    bar1.layer.cornerRadius = 4;
    [self.view addSubview:bar1];
    //showShadow(bar1, CGSizeMake(1, 1));
    
    UIView* line1 = [[UIView alloc] initWithFrame:RECT(5, RowHeight*1, bar1.fw-10, 0.8)];
    line1.backgroundColor = LINE_COLOR;
    [bar1 addSubview:line1];
    UIView* line2 = [[UIView alloc] initWithFrame:RECT(5, RowHeight*2, bar1.fw-10, 0.8)];
    line2.backgroundColor = LINE_COLOR;
    [bar1 addSubview:line2];
    
    newLabel(bar1, @[@50, RECT_OBJ(10, RowHeight*0 + (RowHeight-Font3)/2, 70, Font3), [UIColor blackColor], FontB(Font3), @"登录账户："]);
    newLabel(bar1, @[@51, RECT_OBJ(80, RowHeight*0 + (RowHeight-Font3)/2, 210, Font3), [UIColor darkGrayColor], FontB(Font3), @""]);
    
    newLabel(bar1, @[@52, RECT_OBJ(10, RowHeight*1 + (RowHeight-Font3)/2, 70, Font3), [UIColor blackColor], FontB(Font3), @"当前用户："]);
    newLabel(bar1, @[@53, RECT_OBJ(80, RowHeight*1 + (RowHeight-Font3)/2, 210, Font3), [UIColor darkGrayColor], FontB(Font3), @""]);
    
    newLabel(bar1, @[@54, RECT_OBJ(10, RowHeight*2 + (RowHeight-Font3)/2, 70, Font3), [UIColor blackColor], FontB(Font3), @"联系方式："]);
    newLabel(bar1, @[@55, RECT_OBJ(80, RowHeight*2 + (RowHeight-Font3)/2, 210, Font3), [UIColor darkGrayColor], FontB(Font3), @""]);
    

    UIView* bar4 = [[UIView alloc] initWithFrame:RECT(10, bar1.ey+15, APP_W-20, RowHeight*1)];
    bar4.backgroundColor = [UIColor whiteColor];
    bar4.layer.borderColor = BRD_COLOR.CGColor;
    bar4.layer.borderWidth = 0.5;
    bar4.layer.cornerRadius = 4;
    [self.view addSubview:bar4];
    
    newLabel(bar4, @[@56, RECT_OBJ(10, (RowHeight-Font3)/2, 150, Font3), [UIColor blackColor], FontB(Font3), @"统计报表"]);
    newImageView(bar4, @[@40, @"arrow_right.png", RECT_OBJ(bar4.fw-10-8, (bar4.fh-16)/2, 8, 16)]);
    UIButton* nextBtn4 = [[UIButton alloc] initWithFrame:RECT(0, 0, bar4.fw, bar4.fh)];
    [nextBtn4 addTarget:self action:@selector(onBtnReportTouched:) forControlEvents:UIControlEventTouchUpInside];
    [bar4 addSubview:nextBtn4];
    
    
    UIView* bar2 = [[UIView alloc] initWithFrame:RECT(10, bar4.ey+15, APP_W-20, RowHeight*1)];
    bar2.backgroundColor = [UIColor whiteColor];
    bar2.layer.borderColor = BRD_COLOR.CGColor;
    bar2.layer.borderWidth = 0.5;
    bar2.layer.cornerRadius = 4;
    [self.view addSubview:bar2];
    
    newLabel(bar2, @[@56, RECT_OBJ(10, (RowHeight-Font3)/2, 150, Font3), [UIColor blackColor], FontB(Font3), @"i运维子应用管理"]);
    newImageView(bar2, @[@40, @"arrow_right.png", RECT_OBJ(bar2.fw-10-8, (bar2.fh-16)/2, 8, 16)]);
    UIButton* nextBtn = [[UIButton alloc] initWithFrame:RECT(0, 0, bar2.fw, bar2.fh)];
    [nextBtn addTarget:self action:@selector(onBtnNextTouched:) forControlEvents:UIControlEventTouchUpInside];
    [bar2 addSubview:nextBtn];
    
    
    UIView* bar3 = [[UIView alloc] initWithFrame:RECT(10, bar2.ey+15, APP_W-20, RowHeight*1.5)];
    bar3.backgroundColor = [UIColor whiteColor];
    bar3.layer.borderColor = BRD_COLOR.CGColor;
    bar3.layer.borderWidth = 0.5;
    bar3.layer.cornerRadius = 4;
    [self.view addSubview:bar3];
    
    newLabel(bar3, @[@57, RECT_OBJ(10, (RowHeight-Font3)/2, 70, Font3), [UIColor blackColor], FontB(Font3), @"软件版本"]);
    UIColor* fcolor = (g_app.existNewVersion ? [UIColor redColor] : [UIColor darkGrayColor]);
    NSString* ver = format(@"当前版本：v%@  (%@)", HARPY_CURRENT_VERSION, (g_app.existNewVersion ? @"有新版本":@"已是最新"));
    newLabel(bar3, @[@58, RECT_OBJ(10, (RowHeight-Font3)/2+Font3+6, bar3.fw-30, Font3), fcolor, FontB(Font3), ver]);

    
    
    UIImage* btnImage = [UIImage imageNamed:@"btn_logout.png"];
    UIButton* loginBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-btnImage.size.width)/2, bar3.ey + 20,
                                                              btnImage.size.width, btnImage.size.height)];
    [loginBtn setBackgroundImage:btnImage forState:0];
    [loginBtn addTarget:self action:@selector(btnLogoutTouched:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"退出登录" forState:0];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:0];
    loginBtn.titleLabel.font = FontB(Font2);
    [self.view addSubview:loginBtn];
    
    [line1 release];
    [line2 release];
    [bar1 release];
    [bar2 release];
    [bar3 release];
    [bar4 release];
}

@end
