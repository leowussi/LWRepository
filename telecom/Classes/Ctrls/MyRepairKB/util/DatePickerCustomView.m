//
//  DatePickerCustomView.m
//  telecom
//
//  Created by liuyong on 16/1/21.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "DatePickerCustomView.h"

@interface DatePickerCustomView ()
{
    UIDatePicker *_datePicker;
    UIButton *_chooseBtn;
    UIButton *_cancleBtn;
    UIView *_lineView;
    
    NSString *_type;
    NSInteger _btnTag;
    NSIndexPath *_indexPath;
}
@end

@implementation DatePickerCustomView


- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type indexPath:(NSIndexPath *)indexPath btnTag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        _btnTag = tag;
        _indexPath = indexPath;
        self.backgroundColor = [UIColor colorWithRed:238/255.f green:238/255.f blue:238/255.f alpha:1.0f];
        self.userInteractionEnabled = YES;
        self.layer.borderWidth = 0.5f;
        self.layer.borderColor = [UIColor colorWithRed:238/255.f green:238/255.f blue:238/255.f alpha:1.0f].CGColor;
        
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 216)];
        _datePicker.userInteractionEnabled = YES;
        NSLog(@"%f,%f",_datePicker.frame.size.width,_datePicker.frame.size.height);
        _datePicker.date = [NSDate date];
        if ([type isEqualToString:@"year_month_day"]) {
            _datePicker.datePickerMode = UIDatePickerModeDate;
        }else if ([type isEqualToString:@"hour_minute"]){
            _datePicker.datePickerMode = UIDatePickerModeTime;
        }else if ([type isEqualToString:@"hour_minute_second"]){
            _datePicker.datePickerMode = UIDatePickerModeTime;
        }
        [self addSubview:_datePicker];
        
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _cancleBtn.frame = CGRectMake(0, CGRectGetMaxY(_datePicker.frame), self.bounds.size.width/2-1, 35);
        [_cancleBtn setTitle:@"取  消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancleBtn setBackgroundColor:[UIColor orangeColor]];
        [_cancleBtn addTarget:self action:@selector(cancleAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancleBtn];
        [self bringSubviewToFront:_cancleBtn];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cancleBtn.frame), _cancleBtn.frame.origin.y, 1, _cancleBtn.bounds.size.height)];
        _lineView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lineView];
        
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _chooseBtn.frame = CGRectMake(CGRectGetMaxX(_lineView.frame), _cancleBtn.frame.origin.y, self.bounds.size.width/2-1, 35);
        [_chooseBtn setTitle:@"确  定" forState:UIControlStateNormal];
        [_chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chooseBtn setBackgroundColor:[UIColor orangeColor]];
        [_chooseBtn addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chooseBtn];
        [self bringSubviewToFront:_chooseBtn];
        
    }
    return self;
}


- (void)cancleAction:(UIButton *)cancleBtn
{
    if (self.delegate) {
        [self.delegate cancle];
    }
}

- (void)chooseAction:(UIButton *)chooseBtn
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    if ([_type isEqualToString:@"year_month_day"]) {
        dateFormatter.dateFormat = @"yyyy-MM-dd";
    }else if ([_type isEqualToString:@"hour_minute"]){
        dateFormatter.dateFormat = @"HH-mm";
    }else if ([_type isEqualToString:@"hour_minute_second"]){
        dateFormatter.dateFormat = @"HH-mm-ss";
    }
    NSString *dateString = [dateFormatter stringFromDate:_datePicker.date];
    if (self.delegate) {
        [self.delegate deliverDatePickerResult:dateString indexPath:_indexPath btn:_btnTag];
    }
}
@end
