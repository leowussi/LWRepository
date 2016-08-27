//
//  UIViewController+AllView.m
//  JingRong360
//
//  Created by 锋 on 14-5-4.
//  Copyright (c) 2014年 qian.sundear. All rights reserved.
//

#import "UIViewController+AllView.h"

@implementation UIViewController (AllView)

- (void)backView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"02-01-icon-back.png"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 15, 25)];
    [btn addTarget:self action:@selector(backHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftItem;
}


- (void)backHome
{
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
