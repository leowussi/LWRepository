//
//  WorkInfoController.h
//  telecom
//
//  Created by liuyong on 15/8/10.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@protocol WorkInfoControllerDelegate <NSObject>
- (void)deliverWorkInfo:(NSString *)workInfo workInfoId:(NSString *)workInfoId;
@end

@interface WorkInfoController : SXABaseViewController
@property (nonatomic,copy)NSString *nuId;
@property (strong, nonatomic) IBOutlet UITableView *InfoTableView;
@property(nonatomic,weak)id <WorkInfoControllerDelegate> delegate;
@end
