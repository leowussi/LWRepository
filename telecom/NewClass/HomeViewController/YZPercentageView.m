//
//  YZPercentageView.m
//  CircleChart
//
//  Created by 锋 on 16/8/3.
//  Copyright © 2016年 holden. All rights reserved.
//

#import "YZPercentageView.h"
#import "YZMarkShapeLayer.h"
#import "YZPercentageShapeLayer.h"

@implementation YZPercentageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addPercentageCircleChart];
        //接单及时率
        YZMarkShapeLayer *onTimeLayer = [[YZMarkShapeLayer alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 76, 100, 100) startPoint:CGPointMake(100, 0) middlePoint:CGPointMake(77, 34) endPoint:CGPointMake(12, 34) foregroundColor:[UIColor colorWithRed:58/255.0 green:160/255.0 blue:247/255.0 alpha:1] description:@"接单及时率"];
        [self.layer addSublayer:onTimeLayer];

        //处理及时率
        YZMarkShapeLayer *handleLayer = [[YZMarkShapeLayer alloc] initWithFrame:CGRectMake(0, 0, 100, 100) startPoint:CGPointMake(94, 66) middlePoint:CGPointMake(77, 34) endPoint:CGPointMake(12, 34) foregroundColor:[UIColor colorWithRed:171/255.0 green:220/255.0 blue:78/255.0 alpha:1] description:@"处理及时率"];
        [self.layer addSublayer:handleLayer];
        
        //重复障碍率
        YZMarkShapeLayer *hinderLayer = [[YZMarkShapeLayer alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + 50, 0, 100, 100) startPoint:CGPointMake(0, 70) middlePoint:CGPointMake(40, 34) endPoint:CGPointMake(100, 34) foregroundColor:[UIColor colorWithRed:167/255.0 green:177/255.0 blue:184/255.0 alpha:1] description:@"重复障碍率"];
        [self.layer addSublayer:hinderLayer];
        
        //每百网元障碍数
        YZMarkShapeLayer *hinderNumberLayer = [[YZMarkShapeLayer alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + 60, self.frame.size.height/2 - 20, 100, 100) startPoint:CGPointMake(0, 0) middlePoint:CGPointMake(40, 34) endPoint:CGPointMake(90, 34) foregroundColor:[UIColor colorWithRed:219/255.0 green:107/255.0 blue:125/255.0 alpha:1] description:@"每百网元障碍数"];
        [self.layer addSublayer:hinderNumberLayer];
        
        //作业计划总数超时率
        YZMarkShapeLayer *overtimeLayer = [[YZMarkShapeLayer alloc] initWithFrame:CGRectMake(self.frame.size.width/2 + 22, self.frame.size.height/2 + 30, 150, 150) startPoint:CGPointMake(1, 1) middlePoint:CGPointMake(56, 60) endPoint:CGPointMake(130, 60) foregroundColor:[UIColor colorWithRed:216/255.0 green:170/255.0 blue:27/255.0 alpha:1] description:@"作业计划总数超时率"];
        [self.layer addSublayer:overtimeLayer];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)tapGesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(percentageViewDidClicked:)]) {
        [_delegate percentageViewDidClicked:self];
    }
}


//圈圈
- (void)addPercentageCircleChart
{
    YZPercentageShapeLayer *blueLayer = [[YZPercentageShapeLayer alloc]initWithCenter:CGPointMake(self.frame.size.width/2, 125) bounds:CGRectMake(0, 0, 190, 190) lineWidth:11 strokeColor:[UIColor colorWithRed:58/255.0 green:160/255.0 blue:247/255.0 alpha:1]];
    [self.layer addSublayer:blueLayer];
    
    YZPercentageShapeLayer *greenLayer = [[YZPercentageShapeLayer alloc]initWithCenter:CGPointMake(self.frame.size.width/2, 125) bounds:CGRectMake(0, 0, 168, 168) lineWidth:11 strokeColor:[UIColor colorWithRed:171/255.0 green:220/255.0 blue:78/255.0 alpha:1]];
    [self.layer addSublayer:greenLayer];
    
    YZPercentageShapeLayer *grayLayer = [[YZPercentageShapeLayer alloc]initWithCenter:CGPointMake(self.frame.size.width/2, 125) bounds:CGRectMake(0, 0, 146.5, 146.5) lineWidth:10 strokeColor:[UIColor colorWithRed:167/255.0 green:177/255.0 blue:184/255.0 alpha:1]];
    [self.layer addSublayer:grayLayer];
    
    YZPercentageShapeLayer *redLayer = [[YZPercentageShapeLayer alloc]initWithCenter:CGPointMake(self.frame.size.width/2, 125) bounds:CGRectMake(0, 0, 126, 126) lineWidth:10 strokeColor:[UIColor colorWithRed:219/255.0 green:107/255.0 blue:125/255.0 alpha:1]];
    [self.layer addSublayer:redLayer];

    YZPercentageShapeLayer *yellowLayer = [[YZPercentageShapeLayer alloc]initWithCenter:CGPointMake(self.frame.size.width/2, 125) bounds:CGRectMake(0, 0, 108, 108) lineWidth:9 strokeColor:[UIColor colorWithRed:216/255.0 green:170/255.0 blue:27/255.0 alpha:1]];
    [self.layer addSublayer:yellowLayer];
    
}

- (void)setPercentageArray:(NSArray *)percentageArray
{
    _percentageArray = percentageArray;
    
    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < 5) {
            YZPercentageShapeLayer *percentageLayer = (YZPercentageShapeLayer *)obj;
            percentageLayer.percentage = [[percentageArray objectAtIndex:idx%5] floatValue];
        }else {
            YZMarkShapeLayer *markLayer = (YZMarkShapeLayer *)obj;
            markLayer.percentage = [[percentageArray objectAtIndex:idx%5] floatValue];
        }
        
    }];
 
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, .5f);
    //蓝色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:58/255.0 green:160/255.0 blue:247/255.0 alpha:1].CGColor);
    CGContextStrokeEllipseInRect(context, CGRectMake(self.frame.size.width/2 - 90, 35, 180 , 180));
    //绿色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:171/255.0 green:220/255.0 blue:78/255.0 alpha:1].CGColor);
    CGContextStrokeEllipseInRect(context, CGRectMake(self.frame.size.width/2 - 78, 47, 156 , 156));
    //灰色
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextStrokeEllipseInRect(context, CGRectMake(self.frame.size.width/2 - 68, 57, 136 , 136));
    //黄色
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:216/255.0 green:170/255.0 blue:27/255.0 alpha:1].CGColor);
    CGContextStrokeEllipseInRect(context, CGRectMake(self.frame.size.width/2 - 58, 67, 116 , 116));

}


@end
