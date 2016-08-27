//
//  DetailGoodsViewController.m
//  telecom
//
//  Created by Sundear on 16/4/5.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "DetailGoodsViewController.h"
#import "DetailView.h"



@interface DetailGoodsViewController ()

@end

@implementation DetailGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DetailView *nibview = [[[NSBundle mainBundle]loadNibNamed:@"DetailView" owner:nil options:nil]lastObject];
    nibview.y = 64;
    nibview.Model = self.Model;
    __weak typeof(self) weakself = self;
    nibview.bolckk = ^{
        [weakself.navigationController popViewControllerAnimated:YES];
        weakself.bolck();
    };
    [self.view addSubview:nibview];
}

@end
