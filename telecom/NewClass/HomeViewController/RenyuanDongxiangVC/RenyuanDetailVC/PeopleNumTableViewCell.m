//
//  PeopleNumTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/8/17.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "PeopleNumTableViewCell.h"
#import "fashion.h"

@implementation PeopleNumTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.leftLable = [UnityLHClass initUILabel:@"张怡筠" font:15.0 color:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] rect:CGRectMake(10, 10, 100, 20)];
        [self.contentView addSubview:self.leftLable];
        
        self.nameLable = [UnityLHClass initUILabel:@"宝山宾馆" font:13.0 color:[UIColor grayColor] rect:CGRectMake(70, 10, kScreenWidth-170, 20)];
        [self.contentView addSubview:self.nameLable];
        
        self.numLable = [UnityLHClass initUILabel:@"1 项" font:13.0 color:[UIColor grayColor] rect:CGRectMake(kScreenWidth-110, 10, 85, 20)];
        self.numLable.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.numLable];
        
        
        
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
