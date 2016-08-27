//
//  SubRegionRefList.h
//  telecom
//
//  Created by ZhongYun on 14-7-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface SubRegionRefList : BaseViewController
@property (nonatomic,retain)NSArray* subRegionRefData;
@property (nonatomic,copy)void(^respBlock)(NSInteger selected);
@end
