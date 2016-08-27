//
//  YZWorkOrderChartView.h
//  Chat
//
//  Created by 锋 on 16/7/25.
//  Copyright © 2016年 holden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZBarChartView.h"
@protocol YZWorkOrderChartViewDelegate;

@interface YZWorkOrderChartView : UIView

@property (nonatomic, strong, readonly) YZBarChartView *barChartView;
@property (nonatomic, weak) id<YZWorkOrderChartViewDelegate> delegate;

- (void)displayWorkOrderNumbers:(NSArray *)workOrderNumbers;

@end

@protocol YZWorkOrderChartViewDelegate <NSObject>

@optional
- (void)workOrderChartView:(YZWorkOrderChartView *)chartView workOrderButtonClickedAtIndex:(NSUInteger)index;

- (void)workOrderChartViewDidClicked:(YZWorkOrderChartView *)chartView;

@end
