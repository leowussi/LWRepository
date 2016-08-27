//
//  YZMarkShapeLayer.m
//  CircleChart
//
//  Created by 锋 on 16/8/3.
//  Copyright © 2016年 holden. All rights reserved.
//

#import "YZMarkShapeLayer.h"

@interface YZMarkShapeLayer ()

@property (nonatomic, strong) CATextLayer *percentageLayer;

@end

@implementation YZMarkShapeLayer

- (instancetype)initWithFrame:(CGRect)frame startPoint:(CGPoint)sPoint middlePoint:(CGPoint)mPoint endPoint:(CGPoint)ePoint foregroundColor:(UIColor *)foregroundColor description:(NSString *)desc
{
    self = [super init];
    if (self) {
        self.frame = frame;
        
        self.strokeColor = [UIColor blackColor].CGColor;
//        self.fillColor = [UIColor grayColor].CGColor;
        self.lineWidth = .5f;
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(sPoint.x, sPoint.y, 4, 4)];
        [path moveToPoint:CGPointMake(sPoint.x + 2, sPoint.y + 2)];
        [path addLineToPoint:mPoint];
        [path moveToPoint:mPoint];
        [path addLineToPoint:ePoint];
        
        self.path = path.CGPath;
        
        _percentageLayer = [CATextLayer layer];
        _percentageLayer.frame = CGRectMake(mPoint.x < ePoint.x ? mPoint.x : ePoint.x, mPoint.y - 18, fabs(mPoint.x - ePoint.x), 18);
        _percentageLayer.contentsScale = 2;
        _percentageLayer.font = (__bridge CFTypeRef _Nullable)([UIFont boldSystemFontOfSize:13]);
        _percentageLayer.fontSize = 14;
        _percentageLayer.alignmentMode = kCAAlignmentCenter;
        _percentageLayer.foregroundColor = foregroundColor.CGColor;
        [self addSublayer:_percentageLayer];
        
        CATextLayer *descLayer = [CATextLayer layer];
        descLayer.frame = CGRectMake(mPoint.x < ePoint.x ? mPoint.x : ePoint.x, mPoint.y, fabs(mPoint.x - ePoint.x), 40);
        descLayer.contentsScale = 2;
        descLayer.fontSize = 12;
        descLayer.wrapped = YES;
        descLayer.string = desc;
        descLayer.alignmentMode = kCAAlignmentCenter;
        descLayer.foregroundColor = [UIColor blackColor].CGColor;
        [self addSublayer:descLayer];
    }
    
    return self;
}

- (void)setPercentage:(CGFloat)percentage
{
    _percentageLayer.string = [NSString stringWithFormat:@"%.2f%%",percentage * 100];
}

@end
