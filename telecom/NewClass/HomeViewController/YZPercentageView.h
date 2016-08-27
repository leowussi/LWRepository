//
//  YZPercentageView.h
//  CircleChart
//
//  Created by 锋 on 16/8/3.
//  Copyright © 2016年 holden. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YZPercentageViewDelegate;

@interface YZPercentageView : UIView

@property (nonatomic, assign) id<YZPercentageViewDelegate> delegate;
//设置比率
@property (nonatomic, strong) NSArray *percentageArray;

@end

@protocol YZPercentageViewDelegate <NSObject>

@optional
- (void)percentageViewDidClicked:(YZPercentageView *)chartView;

@end