//
//  MyResourceHeaderView.m
//  telecom
//
//  Created by 郝威斌 on 15/7/27.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyResourceHeaderView.h"

@implementation MyResourceHeaderView

- (id)initWithFrame:(CGRect)aRect {
    self = [super initWithFrame:aRect];
    if(self != nil){
        self.backgroundColor=[UIColor grayColor];
        
        self.label1= [[UILabel alloc]initWithFrame:CGRectMake(15, 2, 250, 20)];
        self.label1.textColor = [UIColor whiteColor];
        [self addSubview:self.label1];
        
        self.label2= [[UILabel alloc]initWithFrame:CGRectMake(15, 22, 180, 20)];
        self.label2.textColor = [UIColor whiteColor];
        [self addSubview:self.label2];
        
        self.label3= [[UILabel alloc]initWithFrame:CGRectMake(200, 2, 180, 20)];
        self.label3.textColor = [UIColor whiteColor];
        [self addSubview:self.label3];
        
        self.bgBtn= [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        [self addSubview:self.bgBtn];
        
        
        //--校正按钮
        _jiaoZhengButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_jiaoZhengButton setBackgroundImage:[UIImage imageNamed:@"资源矫正2"]forState:UIControlStateNormal];
        _jiaoZhengButton.frame = CGRectMake(255, 23, 22, 22);
        [self addSubview:_jiaoZhengButton];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
