//
//  SelectRoom.h
//  telecom
//
//  Created by ZhongYun on 14-6-16.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface SelectRoom : BaseViewController
@property (nonatomic,copy)void(^respBlock)(id result);
@end
