//
//  GeJieGongGaoViewController.m
//  telecom
//
//  Created by Sundear on 16/1/7.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//


#import "GeJieGongGaoViewController.h"
#import "SCNavTabBarController.h"
#import "DetailViewController.h"
#import "SheBeiViewController.h"
#import "LiuZhuangLogViewController.h"

#define UIdiciveW ([UIScreen mainScreen].bounds.size.width)
#define UIdiciveH ([UIScreen mainScreen].bounds.size.height)
#define ViewWidth  ([UIScreen mainScreen].bounds.size.width-40)

@interface GeJieGongGaoViewController ()<UIScrollViewDelegate>
{

    
}
@property(nonatomic,strong)UIView *view1;
@end

@implementation GeJieGongGaoViewController


-(void)viewDidLoad{
    [self addNavigationLeftButton];
//    [self httpSend];
    DetailViewController *sevenViewController = [[DetailViewController alloc] init];
    sevenViewController.title = @"详细信息";
    sevenViewController.dic=self.infoDic;
    
    SheBeiViewController *eightViewController = [[SheBeiViewController alloc] init];
    eightViewController.title = @"设备列表";
    eightViewController.shebeiArray = self.shebeiArray;
    
    LiuZhuangLogViewController *ninghtViewController = [[LiuZhuangLogViewController alloc] init];
    ninghtViewController.title = @"流转日志";
    ninghtViewController.LiuZhuznagArray = self.liuZhuang;
    
    SCNavTabBarController *navTabBarController = [[SCNavTabBarController alloc] init];
    navTabBarController.subViewControllers = @[ sevenViewController, eightViewController, ninghtViewController];
    navTabBarController.showArrowButton = NO;
    [navTabBarController addParentController:self];
    
    
}



@end
