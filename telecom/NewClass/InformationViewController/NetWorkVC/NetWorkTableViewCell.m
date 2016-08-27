//
//  NetWorkTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/7/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "NetWorkTableViewCell.h"
#import "masonry.h"

@implementation NetWorkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.leftLable = [UnityLHClass initUILabel:@"网元名称 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 5, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable];
        
        self.leftLable1 = [UnityLHClass initUILabel:@"网元类型 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 25, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable1];
        
        self.leftLable2 = [UnityLHClass initUILabel:@"网元状态 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 45, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable2];
        
        self.leftLable3 = [UnityLHClass initUILabel:@"厂商 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 65, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable3];
        
        self.leftLable4 = [UnityLHClass initUILabel:@"入网时间 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 85, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable4];
        
        self.leftLable5 = [UnityLHClass initUILabel:@"专业类型 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 105, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable5];
        
        _leftLable6 = [UnityLHClass initUILabel:@"所在机房 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 125, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable6];
        
        _leftLable7 = [UnityLHClass initUILabel:@"机房地址 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 145, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable7];
        
        _leftLable8 = [UnityLHClass initUILabel:@"型号 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 165, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable8];
        
        self.leftLable9 = [UnityLHClass initUILabel:@"软件版本 :" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 185, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.leftLable9];
        
        
        self.rightLable = [UnityLHClass initUILabel:@"MMSI4" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 5, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.rightLable];
        
        self.rightLable1 = [UnityLHClass initUILabel:@"MMSI" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 25, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.rightLable1];
        
        self.rightLable2 = [UnityLHClass initUILabel:@"在用" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 45, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.rightLable2];
        
        self.rightLable3 = [UnityLHClass initUILabel:@"朗讯" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 65, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.rightLable3];
        
        self.rightLable4 = [UnityLHClass initUILabel:@"2009/01/06" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 85, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.rightLable4];
        
        self.rightLable5 = [UnityLHClass initUILabel:@"交换" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 105, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.rightLable5];
        
        _rightLable6 =[UnityLHClass initUILabel:@"" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 125, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.rightLable6];
        
        _rightLable7 =[UnityLHClass initUILabel:@"" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 145, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.rightLable7];
        
        _rightLable8 =[UnityLHClass initUILabel:@"" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 165, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.rightLable8];
        
        self.rightLable9 = [UnityLHClass initUILabel:@"R25Patch10" font:12.0 color:[UIColor blackColor] rect:CGRectMake(80, 185, kScreenWidth-120, 20)];
        [self.contentView addSubview:self.rightLable9];
        
        _jiaoZhengButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_jiaoZhengButton setBackgroundImage:[UIImage imageNamed:@"资源矫正"] forState:UIControlStateNormal];
        [self.contentView addSubview:_jiaoZhengButton];
        [_jiaoZhengButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(22);
            make.height.offset(22);
            make.right.offset(-10);
            make.bottom.offset(-10);
        }];
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
