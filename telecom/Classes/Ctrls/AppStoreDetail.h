//
//  AppStoreDetail.h
//  telecom
//
//  Created by ZhongYun on 14-8-5.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

#define VSTATE_NONE     1
#define VSTATE_NEW      2
#define VSTATE_SAME     3
#define V_STATE         @"V_STATE"

@interface AppStoreDetail : BaseViewController
@property(nonatomic, retain)NSDictionary* dataRow;
@end
