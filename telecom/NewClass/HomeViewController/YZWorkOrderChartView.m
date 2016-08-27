//
//  YZWorkOrderChartView.m
//  Chat
//
//  Created by 锋 on 16/7/25.
//  Copyright © 2016年 holden. All rights reserved.
//

#import "YZWorkOrderChartView.h"

@implementation YZWorkOrderChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *backgroundLayer = [CALayer layer];
        backgroundLayer.frame = CGRectMake(0, 35, kScreenWidth, self.frame.size.height- 35);
        backgroundLayer.contents = (id)[UIImage imageNamed:@"level_bg"].CGImage;
        [self.layer addSublayer:backgroundLayer];
        self.backgroundColor = [UIColor whiteColor];
        //工单按钮
        NSArray *nameArray = [NSArray arrayWithObjects:@"  当日工单",@"  近期工单",@"  可抢工单", nil];
        NSArray *imageArray = [NSArray arrayWithObjects:@"todayWorkOrder",@"recentWorkOrder",@"robWorkOrder", nil];
        CGFloat width = (kScreenWidth - 2)/3;
        for (int i = 0; i < nameArray.count; i++) {
            UIButton *workOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
            workOrderButton.frame = CGRectMake((width + 1) * i, 0, width, 35);
            workOrderButton.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:193.0/255.0 blue:0.0/255.0 alpha:1.0];
            [workOrderButton setTitle:nameArray[i] forState:UIControlStateNormal];
            workOrderButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [workOrderButton setImage:[UIImage imageNamed:imageArray[i]] forState:UIControlStateNormal];
            workOrderButton.tag = i + 1;
            [workOrderButton addTarget:self action:@selector(workOrderButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:workOrderButton];
        }
        
       
        //图表
        _barChartView = [[YZBarChartView alloc] initWithFrame:backgroundLayer.frame];
        [self addSubview:_barChartView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [_barChartView addGestureRecognizer:tapGesture];
    }
    
    return self;
}


- (void)displayWorkOrderNumbers:(NSArray *)workOrderNumbers
{
    _barChartView.workOrderNumbers = workOrderNumbers;
}

#pragma mark -- 工单被点击
- (void)workOrderButtonClicked:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(workOrderChartView:workOrderButtonClickedAtIndex:)]) {
        [_delegate workOrderChartView:self workOrderButtonClickedAtIndex:sender.tag];
    }
}

- (void)tapGesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(workOrderChartViewDidClicked:)]) {
        [_delegate workOrderChartViewDidClicked:self];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
