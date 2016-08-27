//
//  PeopleNumDetailTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/8/17.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "PeopleNumDetailTableViewCell.h"

@implementation PeopleNumDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.titleLable = [UnityLHClass initUILabel:@"周期工作:" font:15.0 color:[UIColor blackColor] rect:CGRectMake(10, 10, 100, 20)];
        [self.contentView addSubview:self.titleLable];
        
        self.nameLable = [UnityLHClass initUILabel:@"蓄电池组维护周期（月）" font:13.0 color:[UIColor blackColor] rect:CGRectMake(80, 10, kScreenWidth-100, 20)];
        [self.contentView addSubview:self.nameLable];
        
        self.contentLable = [UnityLHClass initUILabel:@"宝山  文宝苑  徐美云" font:12.0 color:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] rect:CGRectMake(10, 30, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.contentLable];
        
        self.dateLable = [UnityLHClass initUILabel:@"2015/08/10" font:12.0 color:[UIColor grayColor] rect:CGRectMake(kScreenWidth-100, 30, 100, 20)];
        [self.contentView addSubview:self.dateLable];
        
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
