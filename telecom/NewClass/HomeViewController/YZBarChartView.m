//
//  YZBarChartView.m
//  Chat
//
//  Created by 锋 on 16/7/25.
//  Copyright © 2016年 holden. All rights reserved.
//

#import "YZBarChartView.h"
#import <CoreText/CoreText.h>

@interface YZBarChartView ()
{
    NSArray *_workOrderNameArray;
}
@end

@implementation YZBarChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _workOrderNameArray = [NSArray arrayWithObjects:@"作业计划工单",@"障碍工单",@"资源变更工单",@"业务开通单",@"工程配合工单",@"风险操作工单",@"指挥任务工单",@"现场请求支持工单", nil];
        
        for (int i = 0; i < _workOrderNameArray.count; i++) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(107.5, 32 + 22 * i, 0, 14)];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:11];
            label.backgroundColor = [UIColor colorWithRed:206/255.0 green:216/255.0 blue:33/255.0 alpha:1];

            [self addSubview:label];
        }
        
    }
    return self;
}

- (void)setWorkOrderNumbers:(NSArray *)workOrderNumbers
{ 
    _workOrderNumbers = workOrderNumbers;
    
    NSInteger maxNumber = 0;
    for (NSString *numberStr in workOrderNumbers) {
        NSInteger number = [numberStr integerValue];
        if (maxNumber < number) {
            maxNumber = number;
        }
    }
    
    if (maxNumber == 0) {
        return;
    }
    
    CGFloat space = (kScreenWidth - 132)/maxNumber;
    CGFloat time = 1.2f/maxNumber;
    NSArray *textArray = [self subviews];
    
    
    [textArray enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [UIView animateWithDuration:time * [_workOrderNumbers[idx] floatValue] animations:^{
            obj.frame = CGRectMake(107.5, 32 + 22 * idx, space *[_workOrderNumbers[idx] floatValue], 14);
        } completion:^(BOOL finished) {
            obj.text = _workOrderNumbers[idx];
        }];
        
    }];
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    UIFont *font = [UIFont systemFontOfSize:12.0];//设置
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentRight;//设置对齐方式
    NSMutableDictionary *attributeDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil];
    [_workOrderNameArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj drawInRect:CGRectMake(6, 32 + 22 * idx, 96, 16) withAttributes:attributeDict];
    }];
 
    //x和y坐标名称
    [attributeDict setObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
    
    [@"工单类型" drawInRect:CGRectMake(6, 8, 96, 20) withAttributes:attributeDict];
    [@"数量" drawInRect:CGRectMake(kScreenWidth - 120, 208, 96, 20) withAttributes:attributeDict];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    //画x,y轴
    CGContextMoveToPoint(context, 107, 8);
    CGContextAddLineToPoint(context, 107, 206);
    CGContextAddLineToPoint(context, kScreenWidth - 18, 206);
    
    //画方向箭头
    CGContextMoveToPoint(context, 103, 14);
    CGContextAddLineToPoint(context, 107, 8);
    CGContextAddLineToPoint(context, 111, 14);
    
    CGContextMoveToPoint(context, kScreenWidth - 24, 202);
    CGContextAddLineToPoint(context, kScreenWidth - 18, 206);
    CGContextAddLineToPoint(context, kScreenWidth - 24, 210);
    
    CGContextStrokePath(context);
    
    
}


@end
