//
//  WeekWorkTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/5/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "WeekWorkTableViewCell.h"
#import "fashion.h"
@implementation WeekWorkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLable = [UnityLHClass initUILabel:@"曹路(电力):蓄电池组维护周期(月)" font:13.0 color:[UIColor blackColor] rect:CGRectMake(20, 8, kScreenWidth-40, 20)];
        [self.contentView addSubview:self.titleLable];
        
        self.contentLable = [UnityLHClass initUILabel:@"1站点" font:12.0 color:[UIColor colorWithRed:60.0/255.0 green:177.0/255.0 blue:235.0/255.0 alpha:1.0] rect:CGRectMake(20, 33, 150, 20)];
        [self.contentView addSubview:self.contentLable];
        
        
        self.dateLable = [UnityLHClass initUILabel:@"2015/05/20" font:12.0 color:[UIColor colorWithRed:60.0/255.0 green:177.0/255.0 blue:235.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-100, 33, 150, 20)];
        [self.contentView addSubview:self.dateLable];
        
        
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
