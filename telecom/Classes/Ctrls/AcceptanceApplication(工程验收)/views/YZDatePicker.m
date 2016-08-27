//
//  YZDatePicker.m
//  telecom
//
//  Created by 锋 on 16/5/31.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#define AB_TITLE_H    44
#define AB_BTN_H      44

#import "YZDatePicker.h"

@interface YZDatePicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIPickerView *_pickerView;
    UIDatePicker* _datePicker;
}
@end

@implementation YZDatePicker

- (instancetype)init
{
    self = [super initWithFrame:RECT(0, 0, SCREEN_W, SCREEN_H)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3];
        
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 20);
        backgroundView.bounds = CGRectMake(0, 0, 290, 300);
        backgroundView.backgroundColor = COLOR(227, 227, 227);;
        [self addSubview:backgroundView];
        
        backgroundView.layer.cornerRadius = 4;
        backgroundView.backgroundColor = [UIColor whiteColor];
        backgroundView.layer.shadowColor = [UIColor blackColor].CGColor;
        backgroundView.layer.shadowOffset = CGSizeMake(0, 5);
        backgroundView.layer.shadowRadius = 4;
        backgroundView.layer.shadowOpacity = .3f;
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.center = CGPointMake(backgroundView.frame.size.width/2, 30);
        titleLabel.bounds = CGRectMake(0, 0, 100, 40);
        titleLabel.text = @"请选择时间";
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [backgroundView addSubview:titleLabel];
        //下划线
        CALayer *lineLayer = [CALayer layer];
        lineLayer.backgroundColor = [UIColor grayColor].CGColor;
        lineLayer.frame = CGRectMake(0, 49, backgroundView.frame.size.width, 0.5);
        [backgroundView.layer addSublayer:lineLayer];
        //日期
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, backgroundView.frame.size.width - 45, 206)];
        _datePicker.backgroundColor = [UIColor clearColor];
        _datePicker.date = [NSDate date];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];

        _datePicker.minimumDate = [NSDate date];
        _datePicker.datePickerMode = UIDatePickerModeDate;

        [backgroundView addSubview:_datePicker];
        
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(backgroundView.frame.size.width - 75, 50, 75, 206)];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [backgroundView addSubview:_pickerView];
        
        //底部的按钮
        CALayer *bottomLineLayer = [CALayer layer];
        bottomLineLayer.backgroundColor = [UIColor grayColor].CGColor;
        bottomLineLayer.frame = CGRectMake(0, backgroundView.frame.size.height - 45, 290, 1);
        [backgroundView.layer addSublayer:bottomLineLayer];
        
        UIButton *trueButton = [UIButton buttonWithType:UIButtonTypeCustom];
        trueButton.frame = CGRectMake(144.25, backgroundView.frame.size.height - 44, 144.75, 44);
        [trueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [trueButton setTitle:@"确定" forState:UIControlStateNormal];
        [trueButton addTarget:self action:@selector(trueButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:trueButton];
        
        UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        otherButton.frame = CGRectMake(0, backgroundView.frame.size.height - 44, 144.75, 44);
        [otherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [otherButton setTitle:@"取消" forState:UIControlStateNormal];
        [otherButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:otherButton];
        
        
        CALayer *aLineLayer = [CALayer layer];
        aLineLayer.backgroundColor = [UIColor grayColor].CGColor;
        aLineLayer.frame = CGRectMake(139.75, backgroundView.frame.size.height - 44, 0.5, 44);
        [backgroundView.layer addSublayer:aLineLayer];
    }
    return self;
}

- (void)trueButtonClicked
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *timeString = [dateFormatter stringFromDate:_datePicker.date];
    NSRange range;
    range.location = 11;
    range.length = 2;
    timeString = [timeString stringByReplacingCharactersInRange:range withString:[NSString stringWithFormat:@"%d",[_pickerView selectedRowInComponent:0]]];
    NSLog(@"%@",timeString);
    _respBlock(timeString);
    [self removeFromSuperview];
}

- (void)cancelButtonClicked
{
    [self removeFromSuperview];
}

#pragma mark == pickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 24;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 32;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%d时",row];
}

- (void)scrollToCurrentTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"HH";
   NSString *timeString = [dateFormatter stringFromDate:date];
    [_pickerView selectRow:[timeString integerValue] inComponent:0 animated:NO];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
