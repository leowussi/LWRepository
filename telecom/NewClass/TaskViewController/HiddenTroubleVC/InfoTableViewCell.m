//
//  InfoTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/8/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "InfoTableViewCell.h"
#import "fashion.h"

@implementation InfoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [UnityLHClass initUILabel:@"动作  综合管理员" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] rect:CGRectMake(10, 10, 200, 20)];
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel = [UnityLHClass initUILabel:@"任务处理内容" font:12.0 color:[UIColor blackColor] rect:CGRectMake(10, 30, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.contentLabel];
        
        self.dateLabel = [UnityLHClass initUILabel:@"2015/08/19 13:28:48" font:12.0 color:[UIColor grayColor] rect:CGRectMake(kScreenWidth-150, 30, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.dateLabel];
        
        
        
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
