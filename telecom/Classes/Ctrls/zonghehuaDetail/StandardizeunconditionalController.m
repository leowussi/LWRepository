//
//  StandardizeunconditionalController.m
//  telecom
//
//  Created by SD0025A on 16/5/23.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "StandardizeunconditionalController.h"

@interface StandardizeunconditionalController ()
@property (nonatomic,strong) UIWebView *web;
@end

@implementation StandardizeunconditionalController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, APP_W, APP_H)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/doc-app/index.jsp",ADDR_IP]];
    self.web.scalesPageToFit = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:request];
    [self.view addSubview:self.web];
    
    
    //上一页按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 60, 20);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [btn setTitle:@"上一页" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(backPage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item;
    
}

- (void)backPage:(UIButton *)btn
{
    [self.web goBack];
}
@end
