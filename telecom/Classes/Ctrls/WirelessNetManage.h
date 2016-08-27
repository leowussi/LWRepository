//
//  WirelessNetManage.h
//  telecom
//
//  Created by ZhongYun on 14-8-22.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface WirelessNetManage : BaseViewController
@property(nonatomic,copy)NSString* keyword;
- (void)loadData:(NSString*)keyword;
@end
