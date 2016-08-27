//
//  MyBookingEvaluateController.h
//  telecom
//
//  Created by liuyong on 15/7/16.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@interface MyBookingEvaluateController : SXABaseViewController
@property (strong, nonatomic) IBOutlet UITextField *banzuInfo;
@property (strong, nonatomic) IBOutlet UITextField *banzuInfo2;
@property (strong, nonatomic) IBOutlet UIImageView *star1;
@property (strong, nonatomic) IBOutlet UIImageView *star2;
@property (strong, nonatomic) IBOutlet UIImageView *star3;
@property (strong, nonatomic) IBOutlet UIImageView *star4;
@property (strong, nonatomic) IBOutlet UIImageView *star5;
@property (strong, nonatomic) IBOutlet UITextView *evaluateInfo;
@property (strong, nonatomic) IBOutlet UIView *fileView;
@property (strong, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (strong, nonatomic) IBOutlet UISwitch *switchChoose;
- (IBAction)switch:(UISwitch *)sender;

@property(nonatomic,strong)NSMutableDictionary *taskDict;

@end
