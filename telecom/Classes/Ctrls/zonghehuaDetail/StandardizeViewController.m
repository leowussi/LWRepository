//
//  StandardizeViewController.m
//  telecom
//
//  Created by SD0025A on 16/5/17.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "StandardizeViewController.h"

@interface StandardizeViewController ()
@property (nonatomic,strong) UIWebView *web;
@end

@implementation StandardizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //增加前进，返回，重载按钮
    //增加标准化手册按钮
    //上一页按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 60, 20);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn setTitle:@"上一页" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backPage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;


    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, APP_W, APP_H)];
    self.web.scalesPageToFit = YES;
    self.web.canGoBack == YES;
    self.web.canGoForward == YES;
    [self.web loadRequest:self.request];
    [self.view addSubview:self.web];
    
}

- (void)backPage:(UIButton *)btn
{
    [self.web goBack];
}

@end
