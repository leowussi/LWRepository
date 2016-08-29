//
//  ZYFEditDateController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/8.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFEditDateController.h"
#import "CRMHelper.h"


@interface ZYFEditDateController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,copy) NSString *selectedDate;

- (IBAction)dateChanged:(UIDatePicker *)sender;

@end

@implementation ZYFEditDateController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    saveItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = saveItem;
    
//    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self.view setBackgroundColor:rgb(235,235,241)];

    self.datePicker.backgroundColor = [UIColor whiteColor];
    
    NSDate *myDate = [self convertDateFromString:self.date];
    
//    //设置时间格式
//    self.datePicker.datePickerMode=UIDatePickerModeDate;
//    //设置中文显示
//    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
//    [self.datePicker setLocale:locale];
    
    
    [self.datePicker setDate:myDate];
    self.selectedDate = self.date;
}

-(NSString *)date
{
    NSDate *now = [NSDate date];
    if (_date == nil || _date.length == 0) {
        _date = [self stringFromDate:now];
    }else{
        if (_date.length >= 10) {
            NSRange range = NSMakeRange(0, 10);
            _date =[_date substringWithRange:range];
        }
    }
    return _date;
}

-(NSDate*) convertDateFromString:(NSString*)uiDate
{
    //如果穿过来的时间为空，则把日期调整为当前时间
    if (uiDate == nil) {
        NSDate *date = [NSDate date];
        return date;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateFormat:@"dd-MM-yyyy"];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
//    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

-(void)save
{
    if ([self.delegate respondsToSelector:@selector(editDateChanged:dateStr:)]) {
        [self.delegate editDateChanged:self dateStr:self.selectedDate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (IBAction)dateChanged:(UIDatePicker *)sender {
    NSDate *selectedDate = sender.date;
    NSString *dateString = [self stringFromDate:selectedDate];
    
    self.selectedDate = dateString;
}
@end
