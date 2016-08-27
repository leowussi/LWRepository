//
//  achiveTextView.m
//  telecom
//
//  Created by SD0025A on 16/6/3.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "achiveTextView.h"

@implementation achiveTextView


- (IBAction)yesAction:(UIButton *)sender {
    [self.yesBtn setImage:[UIImage imageNamed:@"check_ok@2x"] forState:UIControlStateNormal];
    [self.noBtn setImage:[UIImage imageNamed:@"check_no@2x"] forState:UIControlStateNormal];
    self.isAffectUser = @"0";
    self.chooseView.hidden = NO;
}
- (IBAction)noAction:(UIButton *)sender {
    [self.noBtn setImage:[UIImage imageNamed:@"check_ok@2x"] forState:UIControlStateNormal];
    [self.yesBtn setImage:[UIImage imageNamed:@"check_no@2x"] forState:UIControlStateNormal];
    self.isAffectUser = @"1";
    self.chooseView.hidden = YES;
    
}
- (IBAction)goAction:(UIButton *)sender {
    self.hidden = YES;
    [self.delegate goActionWithText:self.textView.text isAffectUser:self.isAffectUser startTime:self.startTimeBtn.currentTitle endTime:self.endTimeBtn.currentTitle];
    self.textView.text = nil;
    UIButton *btn = (UIButton *)[self.superview viewWithTag:100];
    btn.enabled = YES;
}

- (IBAction)backAction:(UIButton *)sender {
    self.hidden = YES;
    self.textView.text = nil;
    UIButton *btn = (UIButton *)[self.superview viewWithTag:100];
    btn.enabled = YES;
}

- (IBAction)startTimeAction:(UIButton *)sender {
    [self.delegate choooseBeginDate];
}
- (IBAction)endTimeAction:(UIButton *)sender {
    [self.delegate choooseEndDate];
}
@end
