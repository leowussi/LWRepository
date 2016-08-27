//
//  MyBookingListView.h
//  telecom
//
//  Created by ZhongYun on 14-12-26.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define YY_SGRW       1
#define YY_SGYY       2

@interface MyBookingListView : UIView
@property (nonatomic, retain)NSDictionary* typeInfo;
- (void)viewDidLoad;
@end
