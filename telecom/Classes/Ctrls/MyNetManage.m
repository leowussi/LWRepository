//
//  MyNetManage.m
//  telecom
//
//  Created by ZhongYun on 14-8-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyNetManage.h"
#import "WirelessNetManage.h"

#define ROW_H   50
@interface MyNetManage ()

@end

@implementation MyNetManage

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的网管";
    
    CGFloat pos_y = self.navBarView.ey + 10;
    UIButton* btnPower = [[UIButton alloc] initWithFrame:RECT(10, pos_y, APP_W-20, ROW_H)];
    btnPower.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnPower.layer.borderWidth = 0.5;
    [btnPower addTarget:self action:@selector(onBtnPowerTouched:) forControlEvents:UIControlEventTouchUpInside];
    [btnPower setBackgroundImage:color2Image([UIColor whiteColor]) forState:UIControlStateNormal];
    [btnPower setBackgroundImage:color2Image(RGB(0xF0F0F0)) forState:UIControlStateHighlighted];
    [self.view addSubview:btnPower];
    
    newImageView(btnPower, @[@(50), @"nm_power.png", RECT_OBJ(10, 10, 30, 30)]);
    newLabel(btnPower, @[@51, RECT_OBJ(50, (ROW_H-Font2)/2, 100, Font2), [UIColor blackColor], Font(Font2), @"动力"]);
    newImageView(btnPower, @[@(52), @"arrow_right.png", RECT_OBJ(btnPower.fw-18, (btnPower.fh-14)/2, 8, 14)]);
    
    
    pos_y += (ROW_H-0.5);
    UIButton* btnWireless = [[UIButton alloc] initWithFrame:RECT(10, pos_y, APP_W-20, ROW_H)];
    btnWireless.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btnWireless.layer.borderWidth = 0.5;
    [btnWireless addTarget:self action:@selector(onBtnWirelessTouched:) forControlEvents:UIControlEventTouchUpInside];
    [btnWireless setBackgroundImage:color2Image([UIColor whiteColor]) forState:UIControlStateNormal];
    [btnWireless setBackgroundImage:color2Image(RGB(0xF0F0F0)) forState:UIControlStateHighlighted];
    [self.view addSubview:btnWireless];
    
    newImageView(btnWireless, @[@(60), @"nm_wirless.png", RECT_OBJ(10, 10, 30, 30)]);
    newLabel(btnWireless, @[@61, RECT_OBJ(50, (ROW_H-Font2)/2, 100, Font2), [UIColor blackColor], Font(Font2), @"无线"]);
    newImageView(btnWireless, @[@(62), @"arrow_right.png", RECT_OBJ(btnPower.fw-18, (btnPower.fh-14)/2, 8, 14)]);

    
    [btnPower release];
    [btnWireless release];
}

- (void)onBtnPowerTouched:(id)sender
{
    NSString* strUrl = format(@"iPower://iPowerDK?accessToken=%@", UGET(U_POWER_TOKEN));
    NSString *unicodeURL = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:unicodeURL]];
}

- (void)onBtnWirelessTouched:(id)sender
{
    WirelessNetManage* vc = [[WirelessNetManage alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

@end
