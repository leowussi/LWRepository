//
//  RoomTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/7/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "RoomTableViewCell.h"

@implementation RoomTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.leftLable = [UnityLHClass initUILabel:@"所属区局 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:232.0/255.0 alpha:1.0] rect:CGRectMake(10, 15, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable];
        
        self.leftLable1 = [UnityLHClass initUILabel:@"所属局站 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:232.0/255.0 alpha:1.0] rect:CGRectMake(10, 35, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable1];
        
        self.leftLable2 = [UnityLHClass initUILabel:@"机房名称 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:232.0/255.0 alpha:1.0] rect:CGRectMake(10, 55, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable2];
        
        self.leftLable3 = [UnityLHClass initUILabel:@"楼层 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:232.0/255.0 alpha:1.0] rect:CGRectMake(10, 75, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable3];
        
        self.leftLable4 = [UnityLHClass initUILabel:@"专业 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:232.0/255.0 alpha:1.0] rect:CGRectMake(10, 95, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable4];
        
        self.leftLable5 = [UnityLHClass initUILabel:@"机房状态 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:232.0/255.0 alpha:1.0] rect:CGRectMake(10, 115, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable5];
        
        
        self.qujuLable = [UnityLHClass initUILabel:@"东区电信局" font:13.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 15, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.qujuLable];
        
        self.juzhanLable = [UnityLHClass initUILabel:@"复旦大学本部" font:13.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 35, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.juzhanLable];
        
        self.nameLable = [UnityLHClass initUILabel:@"复旦大学本部" font:13.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 55, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.nameLable];
        
        self.floorLable = [UnityLHClass initUILabel:@"1" font:13.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(50, 75, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.floorLable];
        
        self.proLable = [UnityLHClass initUILabel:@"综合" font:13.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(50, 95, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.proLable];
        
        self.ztLable = [UnityLHClass initUILabel:@"在用" font:13.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 115, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.ztLable];
        
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
