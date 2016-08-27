//
//  DatePickerView.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

- (void)deliverDateAndTime:(NSString *)dateAndTime withBtn:(NSInteger)btnTag;

@end

@interface DatePickerView : UIView

@property(nonatomic,assign) id <DatePickerViewDelegate>delegate;

- (IBAction)cancelAction:(id)sender;
- (IBAction)selectAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIDatePicker *seekForDateAndTime;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) IBOutlet UIButton *selectBtn;
@property (retain, nonatomic) IBOutlet UIView *lienView;

@property(nonatomic,assign)NSInteger btnTag;
@end
