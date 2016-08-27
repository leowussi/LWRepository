//
//  SegmentView.m
//  telecom
//
//  Created by SD0025A on 16/3/31.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SegmentView.h"

@interface SegmentView ()
@property (nonatomic,strong) UIView *yellowLine;
@end
@implementation SegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height-5);
        [leftBtn setTitle:@"详细信息" forState:UIControlStateNormal];
        leftBtn.tag = 100;
        [leftBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        leftBtn.selected = YES;
        [leftBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:leftBtn];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(self.bounds.size.width/2, 0, self.bounds.size.width/2, self.bounds.size.height-5);
        [rightBtn setTitle:@"流水信息" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        rightBtn.tag = 200;
        [rightBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        
        //底部黄线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-1, self.bounds.size.width, 1)];
        line.backgroundColor = [UIColor orangeColor];
        [self addSubview:line];
        //移动黄线
        self.yellowLine = [[UIView alloc ]initWithFrame:CGRectMake(0, self.bounds.size.height-5, self.bounds.size.width/2, 4)];
        self.yellowLine.backgroundColor = [UIColor orangeColor];
        [self addSubview:self.yellowLine];
        
        
    }
    return self;
}
- (void)click:(UIButton *)btn
{
    btn.selected = YES;
    
  UIButton * leftBtn = (UIButton *)[self viewWithTag:100];
  UIButton * rightBtn = (UIButton *)[self viewWithTag:200];
    if (btn == leftBtn) {
        rightBtn.selected = NO;
    }else{
        leftBtn.selected = NO;
    }
       [UIView animateWithDuration:0.5 animations:^{
        float x = btn.frame.origin.x;
        self.yellowLine.frame = CGRectMake(x, self.yellowLine.frame.origin.y, self.yellowLine.bounds.size.width, self.yellowLine.bounds.size.height);
    }];
    [self.delegate clickSegmentView:btn];
}
@end
