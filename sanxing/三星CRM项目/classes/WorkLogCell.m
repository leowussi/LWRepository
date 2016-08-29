//
//  WorkLogCell.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/15.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "WorkLogCell.h"

@implementation WorkLogCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"WorkLogCell" owner:nil options:nil]lastObject];
    }
    return self;
}

@end
