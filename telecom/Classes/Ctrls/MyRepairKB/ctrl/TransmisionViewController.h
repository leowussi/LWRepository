//
//  TransmisionViewController.h
//  telecom
//
//  Created by liuyong on 15/8/3.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@interface TransmisionViewController : SXABaseViewController
@property (strong, nonatomic) IBOutlet UILabel *orderNoLabel;
@property (strong, nonatomic) IBOutlet UILabel *handlePersonLabel;
@property (strong, nonatomic) IBOutlet UILabel *handelDeptLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkBtn;
- (IBAction)checkAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *workStationLabel;
@property (strong, nonatomic) IBOutlet UITextView *transferReasonTextView;
@property (strong, nonatomic) IBOutlet UITextView *transferDescTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *bottomScrollView;

@property (nonatomic,copy)NSString *orderNo;

@end
