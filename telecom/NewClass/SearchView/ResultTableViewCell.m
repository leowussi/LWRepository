//
//  ResultTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/5/29.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "ResultTableViewCell.h"
#import "fashion.h"
@implementation ResultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *leftImg = [UIImage imageNamed:@"locate_icon.png"];
        self.leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, leftImg.size.width/2, leftImg.size.height/2)];
        self.leftImgView.image = leftImg;
        self.leftImgView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.leftImgView];
     
        
        
        self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, leftImg.size.width/2, leftImg.size.height/2)];
        self.leftBtn.backgroundColor = [UIColor clearColor];
        [self.leftImgView addSubview:self.leftBtn];
        
        UIImage *rightImg = [UIImage imageNamed:@"you.png"];
        self.rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-50, 15, rightImg.size.width/2, rightImg.size.height/2)];
        self.rightImgView.image = rightImg;
        [self.contentView addSubview:self.rightImgView];
        
       
        self.titleLable = [UnityLHClass initUILabel:@"国泰路127号 (周期工作)" font:13.0 color:[UIColor orangeColor] rect:CGRectMake(50, 12, kScreenWidth-100, 20)];
        
        [self.contentView addSubview:self.titleLable];
        
        self.contentLable = [UnityLHClass initUILabel:@"五角场 : 周期工作未完成(4)" font:12.0 color:[UIColor lightGrayColor] rect:CGRectMake(50, 25, kScreenWidth-100, 20)];
        [self.contentView addSubview:self.contentLable];
        
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
