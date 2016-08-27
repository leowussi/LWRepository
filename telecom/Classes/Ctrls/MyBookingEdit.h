//
//  MyBookingEdit.h
//  telecom
//
//  Created by ZhongYun on 14-6-15.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

#define OP_ADD      1
#define OP_EDIT     2

@interface MyBookingEdit : BaseViewController
@property(nonatomic,copy)NSString* appointmentId;
@property (nonatomic,copy)void(^respBlock)(id resp);
@end
