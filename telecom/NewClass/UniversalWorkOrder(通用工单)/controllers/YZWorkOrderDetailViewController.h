//
//  YZWorkOrderDetailViewController.h
//  telecom
//
//  Created by 锋 on 16/6/30.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZWorkOrderDetailViewController : UIViewController

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, copy) NSString *workOrderId;

@property (nonatomic, strong) NSMutableArray *imageArray;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
