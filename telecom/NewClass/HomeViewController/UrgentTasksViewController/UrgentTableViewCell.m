//
//  UrgentTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/5/20.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "UrgentTableViewCell.h"
#import "fashion.h"
@implementation UrgentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.titleLable = [UnityLHClass initUILabel:@"故障(严重)" font:13.0 color:[UIColor blackColor] rect:CGRectMake(30, 8, 150, 20)];
        [self.contentView addSubview:self.titleLable];
        
        self.dateLable = [UnityLHClass initUILabel:@"2015/05/20" font:13.0 color:[UIColor colorWithRed:60.0/255.0 green:177.0/255.0 blue:235.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-100, 8, 150, 20)];
        [self.contentView addSubview:self.dateLable];
        
        self.contentLable = [UnityLHClass initUILabel:@"主驾驶的骄傲收购价艾丝凡" font:12.0 color:[UIColor blackColor] rect:CGRectMake(30, 33, 150, 20)];
        [self.contentView addSubview:self.contentLable];
        
        self.leftView = [[UIView alloc]initWithFrame:CGRectMake(10, 8, 5, 45)];
        self.leftView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.leftView];
        
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
