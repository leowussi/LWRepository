//
//  ResourceTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/7/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "ResourceTableViewCell.h"

@implementation YZJiaoZhengButtom

@end

@implementation ResourceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.leftLable = [UnityLHClass initUILabel:@"机槽 :" font:13.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(10, 5, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable];
        
        self.leftLable1 = [UnityLHClass initUILabel:@"子槽 :" font:13.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(10, 25, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable1];
        
        self.leftLable2 = [UnityLHClass initUILabel:@"子槽状态 :" font:13.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(10, 45, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable2];
        
        self.leftLable3 = [UnityLHClass initUILabel:@"板子类型 :" font:13.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(10, 65, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable3];
        
        self.leftLable4 = [UnityLHClass initUILabel:@"板子型号 :" font:13.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(10, 85, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable4];
        
        
        self.jicaoLable = [UnityLHClass initUILabel:@"01" font:12.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(50, 5, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.jicaoLable];
        
        self.zicaoLable = [UnityLHClass initUILabel:@"1" font:12.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(50, 25, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.zicaoLable];
        
        self.ztLable = [UnityLHClass initUILabel:@"在用" font:12.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 45, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.ztLable];
        
        self.classLable = [UnityLHClass initUILabel:@"BSEC" font:12.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 65, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.classLable];
        
        self.xinghaoLable = [UnityLHClass initUILabel:@"AAAA" font:12.0 color:[UIColor colorWithRed:73.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] rect:CGRectMake(80, 85, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.xinghaoLable];
        
        _jiaoZhengButton = [YZJiaoZhengButtom buttonWithType:UIButtonTypeSystem];
        [_jiaoZhengButton setBackgroundImage:[UIImage imageNamed:@"资源矫正"] forState:UIControlStateNormal];
        _jiaoZhengButton.frame = CGRectMake(255, 85, 22,22);
        [self.contentView addSubview:_jiaoZhengButton];
        
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
