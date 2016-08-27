//
//  BaseViewController.h
//  telecom
//
//  Created by ZhongYun on 14-6-11.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_NAV_TITLE   23100
#define TAG_NAV_LEFT    24100

@interface BaseViewController : UIViewController
@property(nonatomic, retain)UIView* navBarView;
//rightBtn
@property(nonatomic,strong)UIButton *rightBtn;
- (void)popToRootViewController;
- (void)hiddenBottomBar:(BOOL)hide;
- (void)addNavigationLeftButton;
@end
