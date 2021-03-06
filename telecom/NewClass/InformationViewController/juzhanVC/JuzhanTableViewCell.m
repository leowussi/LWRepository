//
//  JuzhanTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "JuzhanTableViewCell.h"

@implementation JuzhanTableViewCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgV = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth-30, 20)];
        self.bgV.backgroundColor = RGBCOLOR(250, 250, 250);
        [self.contentView addSubview:self.bgV];
        
        self.leftLable = [UnityLHClass initUILabel:@"所属区局 :" font:13.0 color:[UIColor colorWithRed:11.0/255.0 green:161.0/255.0 blue:229.0/255.0 alpha:1.0] rect:CGRectMake(10, 10, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable];
        
        self.leftLable1 = [UnityLHClass initUILabel:@"局站名称 :" font:13.0 color:[UIColor colorWithRed:11.0/255.0 green:161.0/255.0 blue:229.0/255.0 alpha:1.0] rect:CGRectMake(10, 30, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable1];
        
        self.bgV1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, kScreenWidth-30, 20)];
        self.bgV1.backgroundColor = RGBCOLOR(250, 250, 250);
        [self.contentView addSubview:self.bgV1];
        
        self.leftLable2 = [UnityLHClass initUILabel:@"地址 :" font:13.0 color:[UIColor colorWithRed:11.0/255.0 green:161.0/255.0 blue:229.0/255.0 alpha:1.0] rect:CGRectMake(10, 50, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable2];
        
        self.leftLable3 = [UnityLHClass initUILabel:@"主要用途 :" font:13.0 color:[UIColor colorWithRed:11.0/255.0 green:161.0/255.0 blue:229.0/255.0 alpha:1.0] rect:CGRectMake(10, 70, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable3];
        
        self.bgV2 = [[UIView alloc]initWithFrame:CGRectMake(0, 90, kScreenWidth-30, 20)];
        self.bgV2.backgroundColor = RGBCOLOR(250, 250, 250);
        [self.contentView addSubview:self.bgV2];
        
        self.leftLable4 = [UnityLHClass initUILabel:@"地图X坐标 :" font:13.0 color:[UIColor colorWithRed:11.0/255.0 green:161.0/255.0 blue:229.0/255.0 alpha:1.0] rect:CGRectMake(10, 90, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable4];
        
        self.leftLable5 = [UnityLHClass initUILabel:@"地图Y坐标 :" font:13.0 color:[UIColor colorWithRed:11.0/255.0 green:161.0/255.0 blue:229.0/255.0 alpha:1.0] rect:CGRectMake(10, 110, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable5];
        
        
        ///////////////////////////////////////////////////////////////////
        
        
        self.qujuLable = [UnityLHClass initUILabel:@"浦东" font:12.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 10, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.qujuLable];
        
        self.nameLable = [UnityLHClass initUILabel:@"张扬" font:12.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 30, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.nameLable];
        
        
        self.addressLable = [UnityLHClass initUILabel:@"南泉北路/弄532号" font:12.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(50, 50, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.addressLable];
        
        self.yongtuLable = [UnityLHClass initUILabel:@"枢纽" font:12.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 70, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.yongtuLable];
        
        self.XLable = [UnityLHClass initUILabel:@"121.592802" font:12.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 90, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.XLable];
        
        self.YLable = [UnityLHClass initUILabel:@"31.297829" font:12.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 110, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.YLable];
        
        
        
        
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
