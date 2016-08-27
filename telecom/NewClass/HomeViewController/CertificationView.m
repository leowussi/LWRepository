//
//  CertificationView.m
//  JingRong360
//
//  Created by 锋 on 14-5-13.
//  Copyright (c) 2014年 qian.sundear. All rights reserved.
//

#import "CertificationView.h"

@implementation CertificationView
{
    
    CGFloat na;
    
    CGFloat timeFloat;
}

- (id)initWithFrame:(CGRect)frame viewInt:(NSInteger)withInt
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
           na = 0.75;
    
        
        
        timeFloat= 1.50*(withInt/100.0);
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
        [timer fire];
        
        
//        UIImageView * backView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 125, 125)];
//        [backView setCenter:CGPointMake(161, 151)];
//        [backView setImage:[UIImage imageNamed:@"0603-zhizhen.png"]];
//        [self addSubview:backView];
        
        
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    //  背景圆
    CGImageRef image = [UIImage imageNamed:@"0603-yuan.png"].CGImage;
    CGContextSaveGState(context);
    CGRect touchRect = CGRectMake(93, 10.5, 136, 136);
    CGContextDrawImage(context, touchRect, image);
    CGContextRestoreGState(context);
    
   //  圆
    CGContextSetLineWidth(context, 6.0);//线的宽度
    CGContextAddArc(context, 160, 80, 60, 0.75*PI, (na+=0.01)*PI, 0); //添加一个圆
    if (na <= 1.28) {
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);//画笔线的颜色
        CGContextSetRGBFillColor(context, 1, 0, 0, 1);
        CGContextSetRGBFillColor(context1, 1, 0, 0, 1);
    }else if (na > 1.28&&na<=1.65){
        CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);//画笔线的颜色
        CGContextSetRGBFillColor(context, 1, 1, 0, 1);
        CGContextSetRGBFillColor(context1, 1, 1, 0, 1);
    }else{
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:68.0/255.0 green:175.0/255.0 blue:251.0/255.0 alpha:1.0].CGColor);//画笔线的颜色
        CGContextSetRGBFillColor(context, 68.0/255.0, 175.0/255.0, 251.0/255.0, 1);
        CGContextSetRGBFillColor(context1, 68.0/255.0, 175.0/255.0, 251.0/255.0, 1);
    }
    CGContextStrokePath(context); //绘制路径
    
    
    // 画两头的圆
    CGFloat x3 = 160+cos(0.75*PI)*60;
    CGFloat y3 = 80+sin(0.75*PI)*60;
    
    CGFloat x4 = 160+cos(na*PI)*60;
    CGFloat y4 = 80+sin(na*PI)*60;
    
    
    CGContextFillEllipseInRect(context, CGRectMake(x3-3, y3-3, 6.0, 6.0));
    CGContextFillEllipseInRect(context1, CGRectMake(x4-3, y4-3, 6.0, 6.0));
    
    
    
    
    
    // 中间的小圆
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);//画笔线的颜色
    CGContextSetLineWidth(context, 2.0);//线的宽度
    CGContextAddArc(context, 160, 80, 6, 0, 2*PI, 0); //添加一个圆
    CGContextStrokePath(context); //绘制路径
    
    
//    CGContextSetRGBStrokeColor(context, 0.5, 0.5, 0.5, 0.5);//线条颜色
    
    // 画线
    CGFloat x1 = 160+cos((na)*PI)*6;
    CGFloat y1 = 80+sin((na)*PI)*6;
    
    CGFloat x2 = 160+cos((na)*PI)*60;
    CGFloat y2 = 80+sin((na)*PI)*60;
    
    CGContextMoveToPoint(context, x1, y1);
    CGContextAddLineToPoint(context, x2,y2);
    CGContextStrokePath(context);
    
}

- (void)timer:(NSTimer*)timer
{
//    if (na >= 2.23) {
//        [timer invalidate];
//    }
//    
//    
//    [self setNeedsDisplay];
    
    
    
    if (na >= 0.73+timeFloat) {
        [timer invalidate];
    }
    
    
    [self setNeedsDisplay];

}





@end
