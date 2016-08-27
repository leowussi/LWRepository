//
//  MyTaskListViewController.h
//  telecom
//
//  Created by ZhongYun on 14-6-14.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface MyTaskListViewController : BaseViewController

@property(nonatomic, retain)NSDictionary* site;

@property(nonatomic, copy)NSString* planDate;

@property(nonatomic,readonly)NSInteger todoNum;

@property(nonatomic, copy)NSString *strTaskID;

@property(nonatomic, copy)NSString *strTaskStatus;

@property(nonatomic, assign)NSInteger taskTag;

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count;
@end
