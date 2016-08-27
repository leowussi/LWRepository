//
//  MyBookingList.h
//  telecom
//
//  Created by ZhongYun on 14-6-15.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface MyBookingList : BaseViewController
@property(nonatomic,copy)NSString* planDate;
@property(nonatomic,copy)NSString* siteId;
- (void)apsToList;
- (void)apsToDetail:(NSString*)detailId;
@end
