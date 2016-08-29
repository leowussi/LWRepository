//
//  SettingCell.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "SettingCell.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width


@implementation SettingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *headerLineView = [[UIView alloc]init];
        [headerLineView setBackgroundColor:[UIColor lightGrayColor]];
        headerLineView.frame = CGRectMake(0, 0, kScreenWidth, 1);
        [self.contentView addSubview:headerLineView];
        
        
        UIView *footLineView = [[UIView alloc]init];
        [footLineView setBackgroundColor:[UIColor lightGrayColor]];
        footLineView.frame = CGRectMake(0, self.bounds.size.height, kScreenWidth, 1);
        [self.contentView addSubview:footLineView];
    }
        return self;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}



@end
