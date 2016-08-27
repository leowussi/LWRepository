//
//  SearchTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/5/29.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SearchTableViewCell.h"
#import "fashion.h"
@implementation SearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImage *leftImg = [UIImage imageNamed:@"search_gray_btn.png"];
        self.leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12, leftImg.size.width/2.5, leftImg.size.height/2.5)];
        self.leftImgView.image = leftImg;
        [self.contentView addSubview:self.leftImgView];
        
        UIImage *rightImg = [UIImage imageNamed:@"zuo.png"];
        self.rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-50, 15, rightImg.size.width/2, rightImg.size.height/2)];
        self.rightImgView.image = rightImg;
        [self.contentView addSubview:self.rightImgView];
        
        self.titleLable = [UnityLHClass initUILabel:@"国泰路" font:13.0 color:[UIColor lightGrayColor] rect:CGRectMake(50, 12, kScreenWidth-100, 20)];
        [self.contentView addSubview:self.titleLable];
        
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
