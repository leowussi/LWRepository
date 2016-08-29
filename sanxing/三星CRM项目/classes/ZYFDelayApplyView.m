//
//  ZYFDelayApplyView.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFDelayApplyView.h"

@implementation ZYFDelayApplyView

-(instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"ZYFDelayApplyView" owner:nil options:nil]lastObject];
        self.textView.layer.borderColor = [UIColor grayColor].CGColor;
        self.textView.layer.borderWidth = 1.1;
        self.textView.layer.cornerRadius = 3;
        self.textView.layer.masksToBounds = YES;
        
//        self.textView.returnKeyType = UIReturnKeyDone;
        
        self.submitBtn.layer.cornerRadius = 5;
        self.submitBtn.hidden = YES;
    }
    return self;
}

//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    [self endEditing:YES];
//}

//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (1 == range.length) {//按下回格键
//        return YES;
//    }
//    if ([text isEqualToString:@"\n"]) {//按下return键
//        //这里隐藏键盘，不做任何处理
//        [textView resignFirstResponder];
//        return NO;
//    }else {
//        if ([textView.text length] < 140) {//判断字符个数
//            return YES;
//        }
//    }
//    return NO;
//}

@end
