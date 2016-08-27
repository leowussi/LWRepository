//
//  CompAlertBox.m
//  telecom
//
//  Created by ZhongYun on 14-6-15.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "CompAlertBox.h"

AlertBox* newDatePickerBox(void)
{
    UIDatePicker* datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.backgroundColor = [UIColor clearColor];
    datePicker.date = [NSDate date];
    datePicker.locale = [[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] autorelease];
    //datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //[datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    //datePicker.maximumDate = [NSDate date];
    datePicker.minimumDate = [NSDate date];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.layer.borderWidth = 0.5;
    datePicker.layer.borderColor = COLOR(179, 179, 179).CGColor;
    
    AlertBox* box = [[AlertBox alloc] initWithContentSize:CGSizeMake(APP_W-40, datePicker.fh-1) Btns:@[@"取消", @"确定"]];
    box.title = @"选择日期";
    box.contentView = datePicker;
    box.contentView.fx = -20;
    [datePicker release];
    return box;
}

AlertBox* newTimePickerBox(void)
{
    AlertBox* box = newDatePickerBox();
    box.title = @"选择时间";
    ((UIDatePicker*)box.contentView).datePickerMode = UIDatePickerModeTime;
    return box;
}

