//
//  ZYFDatePickerController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFDatePickerController.h"
#import "CRMHelper.h"

@interface ZYFDatePickerController ()

@end

@implementation ZYFDatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    [self setDatePicker];
}

-(void)setDatePicker
{
//    CGFloat kHeight = 150.0;
    // 初始化UIDatePicker
//    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,kSystemScreenHeight - kHeight, kSystemScreenWidth, kHeight)];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kSystemScreenHeight * 0.3, kSystemScreenWidth, kSystemScreenHeight)];

    // 设置时区
    [datePicker setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    // 设置当前显示时间
    //    [datePicker setDate:tempDate animated:YES];
    // 设置显示最大时间（此处为当前时间）
    //    [datePicker setMaximumDate:[NSDate date]];
    // 设置UIDatePicker的显示模式
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    // 当值发生改变的时候调用的方法
    [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    // 获得当前UIPickerDate所在的时间
    NSDate *selected = [datePicker date];
}

-(void)datePickerValueChanged
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
