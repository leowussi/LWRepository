//
//  HangUpViewController.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface HangUpViewController : BaseViewController
@property (nonatomic,copy)NSString *workNum;
@property (nonatomic,copy)NSString *orderNo;
@property (nonatomic,copy)NSString *Reason;
@property (nonatomic,copy)NSString *begin;
@property (nonatomic,copy)NSString *end;
@property (retain, nonatomic) IBOutlet UILabel *listNumber;
@property (retain, nonatomic) IBOutlet UILabel *handlePerson;

@property (retain, nonatomic) IBOutlet UIButton *hangUpReason;
- (IBAction)chooseHangUpReason:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIButton *startDateAndTime;
- (IBAction)chooseStartDateAndTime:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIButton *endDateAndTime;
- (IBAction)chooseEndDateAndTime:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UITextField *hangUpDesc;
@property (retain, nonatomic) IBOutlet UIScrollView *attachmentInfo;
@property (retain, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@end
