//
//  YZPercentageShapeLayer.h
//  CircleChart
//
//  Created by 锋 on 16/8/3.
//  Copyright © 2016年 holden. All rights reserved.
//
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface YZPercentageShapeLayer : CAShapeLayer

@property (nonatomic, assign) CGFloat percentage;

- (instancetype)initWithCenter:(CGPoint)centerPoint bounds:(CGRect)bounds lineWidth:(CGFloat)lineWith strokeColor:(UIColor *)strokeColor;
- (void)strokeChart;

@end
