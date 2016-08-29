//
//  SignInOutView.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/15.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMSCoinView.h"

@interface SignInOutView : UIView
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
//@property (weak, nonatomic) IBOutlet CMSCoinView *signInBtn;
//- (IBAction)signClicked:(UIButton *)sender;
@property (strong, nonatomic)  UIButton *SignInBtn;
@property (strong, nonatomic)  UIButton *SignOutBtn;

@end
