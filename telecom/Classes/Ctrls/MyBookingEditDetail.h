//
//  MyBookingEditDetail.h
//  telecom
//
//  Created by ZhongYun on 14-6-16.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface MyBookingEditDetail : BaseViewController
@property (nonatomic,assign)NSMutableDictionary* data;
@property (nonatomic,copy)void(^respBlock)(id resp);
@end
