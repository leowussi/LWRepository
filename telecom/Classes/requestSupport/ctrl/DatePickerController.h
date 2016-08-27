//
//  DatePickerController.h
//  telecom
//
//  Created by SD0025A on 16/6/17.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "BaseViewController.h"

@class DatePickerController;
@protocol DatePickerControllerDelegate <NSObject>

- (void)choosedDate:(NSString *)date picker:(DatePickerController *)picker;

@end
@interface DatePickerController : BaseViewController

@property (weak, nonatomic) IBOutlet UIDatePicker *pickerOne;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerTwo;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,weak) id<DatePickerControllerDelegate> delegate;
@end
