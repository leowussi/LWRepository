//
//  ZYFEditableCell.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/8.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFEditableCell.h"

@implementation ZYFEditableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"ZYFEditableCell" owner:nil options:nil]lastObject];
    }
    return self;
}

-(void)setShowNumKeyboard:(BOOL)showNumKeyboard
{
    if (showNumKeyboard) {
        self.textfield.keyboardType = UIKeyboardTypeNumberPad;
    }
}


@end
