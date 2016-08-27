//
//  FaultSymController.h
//  telecom
//
//  Created by liuyong on 15/8/10.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@protocol FaultSymControllerDelegate <NSObject>
- (void)deliverFaultSymInfo:(NSString *)FaultSymInfo FaultSymInfoId:(NSString *)FaultSymInfoId;
@end

@interface FaultSymController : SXABaseViewController
@property (strong, nonatomic) IBOutlet UITableView *faultSymTableView;
@property (nonatomic,copy)NSString *workTypeId;
@property(nonatomic,weak)id <FaultSymControllerDelegate> delegate;
@end
