//
//  CustomDatePickerView.m
//  telecom
//
//  Created by liuyong on 15/12/1.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#define kTag 22222

#import "CustomDatePickerView.h"

@implementation CustomDatePickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:220.f/255.0f green:220.f/255.0f blue:220.f/255.0f alpha:1.0f];
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 4;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.masksToBounds = YES;
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(-20, 0, 0, 0)];
        datePicker.tag = kTag;
        datePicker.datePickerMode = UIDatePickerModeDate;
        [self addSubview:datePicker];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(datePicker.frame), self.bounds.size.width, 1)];
        lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:lineView];
        
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(lineView.frame), self.bounds.size.width/2-0.5, 30);
        [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cancleBtn addTarget:self action:@selector(cancleAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancleBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cancleBtn.frame), cancleBtn.frame.origin.y+2, 1, 26)];
        line.backgroundColor = [UIColor grayColor];
        [self addSubview:line];
        
        UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        ensureBtn.frame = CGRectMake(CGRectGetMaxX(line.frame), cancleBtn.frame.origin.y, self.bounds.size.width/2-0.5, 30);
        [ensureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        ensureBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [ensureBtn addTarget:self action:@selector(ensureAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ensureBtn];
    }
    return self;
}

- (void)cancleAction
{
    if (self.delegate) {
        [self.delegate cancleBtnClick];
    }
}

- (void)ensureAction
{
    UIDatePicker *temp = (UIDatePicker *)[self viewWithTag:kTag];
    if (self.delegate) {
        [self.delegate deliverDateWith:date2str(temp.date, @"YYYY.MM")];
    }
}

@end
