//
//  YZWorkOrderSiftViewController.h
//  telecom
//
//  Created by 锋 on 16/6/14.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZWorkOrderSiftViewController : UIViewController

//判断是否来自于人员去向
@property (nonatomic, assign) BOOL isFromPerson;

//筛选结果提交后的block回调
@property (nonatomic, copy) void(^siftCompletionBlock)(void);

@end
