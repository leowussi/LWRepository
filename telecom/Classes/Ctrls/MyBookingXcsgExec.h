//
//  MyBookingXcsgExec.h
//  telecom
//
//  Created by ZhongYun on 15-1-3.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface MyBookingXcsgExec : BaseViewController
@property(nonatomic, assign)int opType;
@property(nonatomic, retain)NSMutableDictionary* task;
@property(nonatomic, retain)UIViewController* listVC;
@end
