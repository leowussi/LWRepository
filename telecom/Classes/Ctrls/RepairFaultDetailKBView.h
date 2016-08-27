//
//  RepairFaultDetailKBView.h
//  telecom
//
//  Created by ZhongYun on 14-11-17.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TI_DETAIL_KB   1
#define TI_RECORD_KB   2

@interface RepairFaultDetailKBView : UIView
@property (nonatomic, retain)NSDictionary* typeInfo;
@property(nonatomic,retain)NSDictionary* workInfo;
- (void)buildView;
@end
