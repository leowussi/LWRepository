//
//  SelectTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/5/25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SelectTableViewCell.h"
#import "fashion.h"
@implementation SelectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self creat];
    }
    return self;
}

- (void)creat
{
    UIImage *leftImg = [UIImage imageNamed:@"map_icon2.png"];
    self.leftLable = [UnityLHClass initUILabel:@"机房" font:13.0 color:[UIColor grayColor] rect:CGRectMake(leftImg.size.width/2+10, 12, 100, 20)];
    [self.contentView addSubview:self.leftLable];

    
    self.leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, leftImg.size.width/2, leftImg.size.height/2)];
    self.leftImgView.image = leftImg;
    [self.contentView addSubview:self.leftImgView];
    
    UIImage *selectImg = [UIImage imageNamed:@"select_none.png"];
    if (m_checkImageView == nil)
    {
        m_checkImageView = [[UIImageView alloc] initWithImage:selectImg];
        m_checkImageView.frame = CGRectMake(kScreenWidth-120, 13, selectImg.size.width/2, selectImg.size.height/2);
        [self.contentView addSubview:m_checkImageView];
    }
}

- (void)setChecked:(BOOL)checked{
    if (checked)
    {
        m_checkImageView.image = [UIImage imageNamed:@"select.png"];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
    }
    else
    {
        m_checkImageView.image = [UIImage imageNamed:@"select_none.png"];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    m_checked = checked;
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
