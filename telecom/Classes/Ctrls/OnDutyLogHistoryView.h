//
//  OnDutyLogHistoryView.h
//  telecom
//
//  Created by ZhongYun on 14-8-21.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TI_ALLLOG       2
#define TI_AUDITED      1
#define TI_UNAUDIT      0

@interface OnDutyLogHistoryView : UIView
@property (nonatomic, retain)NSDictionary* typeInfo;
- (void)buildView;
- (void)refreshData;
@end
