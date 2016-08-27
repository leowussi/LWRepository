//
//  TaskDetail.h
//  telecom
//
//  Created by ZhongYun on 14-6-20.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface TaskDetail : BaseViewController
@property(nonatomic, retain)NSMutableDictionary* detail;
@property(nonatomic, copy)void (^respBlock)(id result);

@property(nonatomic, assign)NSInteger strVCTag;

@property (nonatomic,assign)BOOL isCallBackAction;
@end
