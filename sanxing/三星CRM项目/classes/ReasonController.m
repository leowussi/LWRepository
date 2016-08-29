//
//  ReasonController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/23.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ReasonController.h"

@interface ReasonController ()

@end

@implementation ReasonController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"申请原因"];
//    
//
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 1.1;
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.masksToBounds = YES;
    self.textView.editable = NO;
    self.textView.text = self.reasonString;
}
//
//-(void)save
//{
//    if ([self.delegate respondsToSelector:@selector(reasonController:reasonString:)]) {
//        [self.delegate reasonController:self reasonString:self.textView.text];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}
//

@end
