//
//  DatePickerController.m
//  telecom
//
//  Created by SD0025A on 16/6/17.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "DatePickerController.h"

@interface DatePickerController ()
@property (nonatomic,copy) NSString *str1;
@property (nonatomic,copy) NSString *str2;
@end

@implementation DatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(choosedTime) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
    
}


- (IBAction)pickerOne:(UIDatePicker *)sender {
    
   // NSLog(@"开始时间%@",dateStr);
}

- (IBAction)pickerTwo:(UIDatePicker *)sender {
    
   // NSLog(@"结束时间 %@",dateStr);
}
- (void)choosedTime
{
    NSDateFormatter* dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd"]; // 这里是用大写的 H
    NSString* dateStr1 = [dateFormatter1 stringFromDate:[self.pickerOne date]];
    self.str1 = dateStr1;
    
    NSDateFormatter* dateFormatter2 = [[NSDateFormatter alloc] init];
    [dateFormatter2 setDateFormat:@"HH:mm:ss"]; // 这里是用大写的 H
    NSString* dateStr2 = [dateFormatter2 stringFromDate:[self.pickerTwo date]];
    self.str2 = dateStr2;
    
    [self.navigationController popViewControllerAnimated:YES];
    NSString *str = [NSString stringWithFormat:@"%@ %@",self.str1,self.str2];
    [self.delegate choosedDate:str picker:self];
    NSLog(@"%@",str);
}
@end
