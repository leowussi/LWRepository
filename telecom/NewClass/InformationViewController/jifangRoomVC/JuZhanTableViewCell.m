//
//  JuZhanTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/8/11.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "JuZhanTableViewCell.h"

@implementation JuZhanTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.leftLable = [UnityLHClass initUILabel:@"所属区局 :" font:13.0 color:[UIColor colorWithRed:11.0/255.0 green:161.0/255.0 blue:229.0/255.0 alpha:1.0] rect:CGRectMake(10, 5, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable];
        
        self.rightLable = [UnityLHClass initUILabel:@"" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 5, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.rightLable];
        
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
