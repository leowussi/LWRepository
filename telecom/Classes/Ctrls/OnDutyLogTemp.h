//
//  OnDutyLogTemp.h
//  telecom
//
//  Created by ZhongYun on 14-8-19.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface OnDutyLogTemp : BaseViewController
@property(nonatomic,retain)NSArray* data;
@property(nonatomic,copy)void(^respBlock)(id resp);
@property(nonatomic,assign)NSInteger defIndex;
@property(nonatomic,copy)NSString* defText;
@end
