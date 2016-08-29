//
//  LogsFooterView.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/7.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "LogsFooterView.h"

@implementation LogsFooterView

-(instancetype)init
{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"LogsFooterView" owner:nil options:nil]lastObject];
        self.textView.layer.borderColor = [UIColor grayColor].CGColor;
        self.textView.layer.borderWidth = 1.1;
        self.textView.layer.cornerRadius = 3;
        self.textView.layer.masksToBounds = YES;
        
        self.saveBtn.layer.cornerRadius = 5;
        self.saveBtn.hidden = YES;
    }
    return self;
}

//- (IBAction)save:(UIButton *)sender {
//}
@end
