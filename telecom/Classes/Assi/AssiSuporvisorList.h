//
//  AssiSuporvisorList.h
//  telecom
//
//  Created by ZhongYun on 14-7-23.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface AssiSuporvisorList : BaseViewController
@property(nonatomic, copy)NSString* selectedId;
@property(nonatomic, copy)void (^respBlock)(NSDictionary* resp);
@end
