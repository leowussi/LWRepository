//
//  EditorUserDetailController.m
//  telecom
//
//  Created by SD0025A on 16/7/20.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
// 详情1  编辑使用人


#import "EditorUserDetailController.h"


@interface EditorUserDetailController ()

@end

@implementation EditorUserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}
- (void)createUI
{
    self.navigationItem.title = @"编辑使用人";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //右边item
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"checkBtn"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

@end
