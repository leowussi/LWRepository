//
//  YZPercentageShapeLayer.m
//  CircleChart
//
//  Created by 锋 on 16/8/3.
//  Copyright © 2016年 holden. All rights reserved.
//

#import "YZPercentageShapeLayer.h"

@implementation YZPercentageShapeLayer

- (instancetype)initWithCenter:(CGPoint)centerPoint bounds:(CGRect)bounds lineWidth:(CGFloat)lineWith strokeColor:(UIColor *)strokeColor
{
    self = [super init];
    if (self) {
        self.position = centerPoint;
        self.bounds = bounds;
        self.lineWidth = lineWith;
        self.strokeColor = strokeColor.CGColor;
        self.fillColor = [UIColor clearColor].CGColor;
      }
    return self;
}

- (void)setPercentage:(CGFloat)percentage
{
    _percentage = percentage;
    [self strokeChart];
}

- (void)strokeChart
{
    if (self.path == nil) {
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2 startAngle:DEGREES_TO_RADIANS(-90) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
        self.path = path.CGPath;
       
    }
    self.strokeEnd   = _percentage;
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = _percentage * 2;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = @0.0f;
    pathAnimation.toValue = @(_percentage);
    [self addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    

}


@end
