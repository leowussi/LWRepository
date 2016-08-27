//
//  DatePickerView.m
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
     
        self.titleLabel  = [[UILabel alloc] initWithFrame:RECT(8, 0, 165, 37)];
        self.titleLabel.text = @"请选择日期和时间";
        [self addSubview:self.titleLabel];
        
        self.cancelBtn = [[UIButton alloc] initWithFrame:RECT(CGRectGetMaxX(self.titleLabel.frame)+30, 0, 50, 37)];
        [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelBtn];
        
        self.selectBtn = [[UIButton alloc] initWithFrame:RECT(CGRectGetMaxX(self.cancelBtn.frame)+10, 0, 50, 37)];
        [self.selectBtn setTitle:@"确定" forState:UIControlStateNormal];
        [self.selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.selectBtn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectBtn];
        
        self.lienView = [[UIView alloc] initWithFrame:RECT(0, CGRectGetMaxY(self.titleLabel.frame), APP_W, 2)];
        self.lienView.backgroundColor = [UIColor purpleColor];
        [self addSubview:self.lienView];
        
        self.seekForDateAndTime = [[UIDatePicker alloc] initWithFrame:RECT(0, CGRectGetMaxY(self.lienView.frame), APP_W, 185-39)];
        self.seekForDateAndTime.datePickerMode = UIDatePickerModeDateAndTime;
        [self addSubview:self.seekForDateAndTime];
    }
    return self;
}

- (IBAction)cancelAction:(id)sender {
    
    [UIView animateWithDuration:0.2f animations:^{
        CGRect tempFrame = self.frame;
        tempFrame.origin.y = APP_H;
        self.frame = tempFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowing"];
    }];
}

- (IBAction)selectAction:(id)sender {
    
    NSDate *date = self.seekForDateAndTime.date;
    if (self.delegate) {
        [self.delegate deliverDateAndTime:date2str(date, @"yyyy-MM-dd HH:mm") withBtn:self.btnTag];
    }
    
    [self cancelAction:nil];
    
}

//- (void)dealloc {
//    [_seekForDateAndTime release];
//    [_titleLabel release];
//    [_cancelBtn release];
//    [_selectBtn release];
//    [_lienView release];
//    [super dealloc];
//}

@end
