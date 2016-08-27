//
//  MyFindHiddenTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/8/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyFindHiddenTableViewCell.h"
#import "fashion.h"

@implementation MyFindHiddenTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [UnityLHClass initUILabel:@"隐患编号" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] rect:CGRectMake(10, 10, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.titleLabel];
        
        self.classLabel = [UnityLHClass initUILabel:@"网元/对象" font:12.0 color:[UIColor blackColor] rect:CGRectMake(10, 30, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.classLabel];
        
        self.ztLabel = [UnityLHClass initUILabel:@"当前状态" font:12.0 color:[UIColor blackColor] rect:CGRectMake(10, 45, kScreenWidth-20, 20)];
        [self.contentView addSubview:self.ztLabel];
        
        self.dateLabel = [UnityLHClass initUILabel:@"2015/08/19" font:13.0 color:[UIColor grayColor] rect:CGRectMake(kScreenWidth-130, 45, kScreenWidth-20, 20)];
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
