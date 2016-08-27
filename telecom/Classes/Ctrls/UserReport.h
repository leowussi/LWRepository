//
//  UserReport.h
//  telecom
//
//  Created by ZhongYun on 14-9-21.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface UserReport : BaseViewController
@property(nonatomic,retain)NSMutableArray* sites;
- (void)showReportData:(NSArray*)list;
@end
