//
//  YZMarkShapeLayer.h
//  CircleChart
//
//  Created by 锋 on 16/8/3.
//  Copyright © 2016年 holden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface YZMarkShapeLayer : CAShapeLayer

@property (nonatomic, assign) CGFloat percentage;

- (instancetype)initWithFrame:(CGRect)frame startPoint:(CGPoint)sPoint middlePoint:(CGPoint)mPoint endPoint:(CGPoint)ePoint foregroundColor:(UIColor *)foregroundColor description:(NSString *)desc;

@end
