//
//  SignInOutController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "SignInOutController.h"
#import "SignInOutView.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "CMSCoinView.h"
#import "CRMHelper.h"

#define kBtnWidth  110


@interface SignInOutController ()

@property (nonatomic,strong) SignInOutView *signInOutView;

@property (nonatomic,strong) UIView *signInView;
@property (nonatomic,strong) UIView *signOutView;

@end

@implementation SignInOutController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    
//    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:@"签到签退"];
    SignInOutView *view = [[SignInOutView alloc]init];
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    
}

//    [self setButtons];
//    
//    //获取签到结果，来显示对应的界面,result==1,显示签到界面，result == 2,显示签退界面
//    NSInteger result =  [ZYFUserDefaults integerForKey:ZYFSignInSucess];
//    if (result == 1) {
//        //登陆进去显示签到
//        [view.signInBtn setPrimaryView:self.signInView];
//        [view.signInBtn setSecondaryView:self.signOutView];
//    }else if(result == 2){
//        //登陆进去显示签退
//        [view.signInBtn setPrimaryView:self.signOutView];
//        [view.signInBtn setSecondaryView:self.signInView];
//    }else{
//        //如果第一次登陆，没有缓存数据,显示签到
//        [view.signInBtn setPrimaryView:self.signInView];
//        [view.signInBtn setSecondaryView:self.signOutView];
//    }
//
//    [view.signInBtn setSpinTime:1.0];
//
//}
//
///**
// *  设置按钮动画
// */
//-(void)setButtons
//{
//    UILabel* signInView = [[UILabel alloc]init];
//    signInView.backgroundColor = [UIColor blueColor];
//    signInView.text = @"签到";
//    signInView.font = [UIFont systemFontOfSize:26];
//    signInView.textColor = [UIColor whiteColor];
//    signInView.textAlignment = NSTextAlignmentCenter;
//
//    self.signInView = signInView;
//    
//    
//    UILabel *signOutView = [[UILabel alloc]init];
//    signOutView.backgroundColor = [UIColor yellowColor];
//    signOutView.text = @"签退";
//    signOutView.font = [UIFont systemFontOfSize:26];
////    signOutView.textColor = [UIColor whiteColor];
//    signOutView.textAlignment = NSTextAlignmentCenter;
//    self.signOutView = signOutView;
//
//}

-(void)leftBtnClick
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}




@end
