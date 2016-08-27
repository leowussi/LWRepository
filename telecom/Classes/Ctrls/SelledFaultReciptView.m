//
//  SelledFaultReciptView.m
//  telecom
//
//  Created by SD0025A on 16/5/31.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SelledFaultReciptView.h"

@implementation SelledFaultReciptView


//- (instancetype)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder]) {
//        //默认是否联系用户
//        _isContact = NO;
//        
//    }
//    return self;
//}
- (IBAction)yesAction:(UIButton *)sender {
    _isContact = YES;
    sender.selected = YES;
    self.noBtn.selected = NO;
    [self.yesBtn setImage:[UIImage imageNamed:@"check_ok@2x"] forState:UIControlStateSelected];
    [self.noBtn setImage:[UIImage imageNamed:@"check_no@2x"] forState:UIControlStateNormal];
    self.nameTextField.enabled = YES;
    self.phoneTextField.enabled = YES;
    
}
- (IBAction)noAction:(UIButton *)sender {
    _isContact = NO;
    sender.selected = YES;
    self.yesBtn.selected = NO;
    [self.noBtn setImage:[UIImage imageNamed:@"check_ok@2x"] forState:UIControlStateSelected];
   
    [self.yesBtn setImage:[UIImage imageNamed:@"check_no@2x"] forState:UIControlStateNormal];
    self.nameTextField.enabled = NO;
    self.phoneTextField.enabled = NO;
}
- (IBAction)searchBtn:(UIButton *)sender {
   [self.delegate chooseFaultReason];

}
- (IBAction)uploadBtn:(UIButton *)sender {
   
    [self.delegate uploadFile];
}
@end
