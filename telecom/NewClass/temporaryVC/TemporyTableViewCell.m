//
//  TemporyTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "TemporyTableViewCell.h"

@implementation TemporyTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.View = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth-30, 20)];
        self.View.backgroundColor = RGBCOLOR(240, 240, 240);
        [self.contentView addSubview:self.View];
        
        self.leftLable = [UnityLHClass initUILabel:@"任务内容 :" font:13.0 color:RGBCOLOR(0, 140, 216) rect:CGRectMake(5, 10, 80, 20)];
        [self.contentView addSubview:self.leftLable];
        
        self.leftLable1 = [UnityLHClass initUILabel:@"任务地点 :" font:13.0 color:RGBCOLOR(0, 140, 216) rect:CGRectMake(5, 30, 80, 20)];
        [self.contentView addSubview:self.leftLable1];
        
        self.View1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth-30, 20)];
        self.View1.backgroundColor = RGBCOLOR(240, 240, 240);
        [self.contentView addSubview:self.View1];
        
        self.leftLable2 = [UnityLHClass initUILabel:@"任务完成时间 :" font:13.0 color:RGBCOLOR(0, 140, 216) rect:CGRectMake(5, 50, 90, 20)];
        [self.contentView addSubview:self.leftLable2];
        
        self.leftLable3 = [UnityLHClass initUILabel:@"任务完成人 :" font:13.0 color:RGBCOLOR(0, 140, 216) rect:CGRectMake(5, 70, 80, 20)];
        [self.contentView addSubview:self.leftLable3];
        
      /////////////////////////////////////////////////////////////////////////////
        
        self.taskContent = [UnityLHClass initUILabel:@"机房清扫灰尘" font:12.0 color:RGBCOLOR(125, 121, 121) rect:CGRectMake(85, 10, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.taskContent];
        
        self.taskAddress = [UnityLHClass initUILabel:@"复旦校园网" font:12.0 color:RGBCOLOR(125, 121, 121) rect:CGRectMake(85, 30, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.taskAddress];
        
        self.taskDate = [UnityLHClass initUILabel:@"2015/07/22" font:12.0 color:RGBCOLOR(125, 121, 121) rect:CGRectMake(95, 50, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.taskDate];
        
        self.taskPeople = [UnityLHClass initUILabel:@"张三" font:12.0 color:RGBCOLOR(125, 121, 121) rect:CGRectMake(85, 70, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.taskPeople];
        
        
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
