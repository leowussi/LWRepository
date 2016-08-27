//
//  backTextView.m
//  telecom
//
//  Created by SD0025A on 16/6/3.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "backTextView.h"

@implementation backTextView


- (IBAction)goAction:(UIButton *)sender {
    self.hidden = YES;
    [self.delegate backOrderWithText:self.textView.text];
    self.textView.text = nil;
    UIButton *btn = (UIButton *)[self.superview viewWithTag:200];
    btn.enabled = YES;
}

- (IBAction)backAction:(UIButton *)sender {
    self.hidden = YES;
    self.textView.text = nil;
    UIButton *btn = (UIButton *)[self.superview viewWithTag:200];
    btn.enabled = YES;
}
@end
