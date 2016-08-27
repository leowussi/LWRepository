//
//  RepairFaultDetailView.h
//  telecom
//
//  Created by ZhongYun on 14-8-8.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TI_DETAIL   1
#define TI_RECORD   2
#define TI_WARNING  3
#define TI_MACHINE  4

@interface RepairFaultDetailView : UIView
@property (nonatomic, retain)NSDictionary* typeInfo;
@property (nonatomic, copy)NSString* faultId;
@property (nonatomic, copy)NSString* faultNo;
- (void)buildView;
@end
