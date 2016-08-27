//
//  YZRiskOperationDetailViewController.h
//  telecom
//
//  Created by 锋 on 16/6/20.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZRiskOperationDetailViewController : UIViewController

//工单id
@property (nonatomic, copy) NSString *riskId;
//工单流水号
@property (nonatomic, copy) NSString *workNo;

@property (nonatomic, strong) NSArray *dataArray;

//高度数组
@property (nonatomic, strong) NSArray *heightArray;

@end
