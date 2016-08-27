//
//  FilterViewController.h
//  telecom
//
//  Created by ZhongYun on 14-6-13.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface FilterViewController : BaseViewController
@property (nonatomic,copy)void(^respBlock)(NSString* resp);
@end
