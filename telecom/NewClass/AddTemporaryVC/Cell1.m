//
//  Cell1.m
//  KuanJiaDemo
//
//  Created by 郝威斌 on 15/3/11.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "Cell1.h"

@implementation Cell1

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 5, 30)];
        self.leftImageView.backgroundColor = RGBCOLOR(65, 144, 0);
        self.leftImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.leftImageView];
        
        self.titleLabel = [UnityLHClass initUILabel:@"cell1" font:13.0 color:[UIColor blackColor] rect:CGRectMake(20, 10, 280, 20)];
        [self.contentView addSubview:self.titleLabel];
        
        UIImage *downImg = [UIImage imageNamed:@"新增自定义任务-手动输入-箭头-下"];
        self.arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-60, 15, downImg.size.width/1.5, downImg.size.height/1.5)];
        self.arrowImageView.image = downImg;
        self.arrowImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.arrowImageView];
        
       
    }
    return self;
}
- (void)changeArrowWithUp:(BOOL)up
{
    if (up) {
        self.arrowImageView.image = [UIImage imageNamed:@"新增自定义任务-手动输入-箭头-上.png"];
    }else
    {
        self.arrowImageView.image = [UIImage imageNamed:@"新增自定义任务-手动输入-箭头-下.png"];
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
