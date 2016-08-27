//
//  MyTaskMonthView.h
//  telecom
//
//  Created by ZhongYun on 14-12-19.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTaskMonthView : UIView
@property(nonatomic,copy)NSString* condition;
@property(nonatomic,retain)NSDate* date;
@property(nonatomic,retain, readonly)NSDateComponents* dateComp;

- (void)loadData;
- (void)loadDataByMonth:(NSDate *)currMonth;
@end
