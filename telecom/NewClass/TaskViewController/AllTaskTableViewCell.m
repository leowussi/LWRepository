//
//  AllTaskTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/7/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AllTaskTableViewCell.h"

@implementation AllTaskTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLable = [UnityLHClass initUILabel:@"周期工作 ：" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 5, 80, 20)];
        [self.contentView addSubview:self.titleLable];
        
        self.nameLable = [UnityLHClass initUILabel:@"蓄电池组维护周期（月）" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(75, 5, kScreenWidth-110, 20)];
        self.nameLable.lineBreakMode = NSLineBreakByWordWrapping;
        self.nameLable.numberOfLines = 0;
        [self.contentView addSubview:self.nameLable];
        
        self.contentLable = [UnityLHClass initUILabel:@"浦东 曹路   张三" font:12.0 color:[UIColor blackColor] rect:CGRectMake(10, 35, kScreenWidth-130, 20)];
        self.contentLable.lineBreakMode = NSLineBreakByWordWrapping;
        self.contentLable.numberOfLines = 0;
        [self.contentView addSubview:self.contentLable];
        
        self.dateLable = [UnityLHClass initUILabel:@"2015-07-21" font:12.0 color:[UIColor lightGrayColor] rect:CGRectMake(kScreenWidth-100, 35, kScreenWidth-40, 20)];
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
