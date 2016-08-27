//
//  YZStatisticsSiftViewController.h
//  telecom
//
//  Created by 锋 on 16/7/29.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZStatisticsSiftViewController : UIViewController

//筛选结果提交后的block回调
@property (nonatomic, copy) void(^siftCompletionBlock)(void);

@end
