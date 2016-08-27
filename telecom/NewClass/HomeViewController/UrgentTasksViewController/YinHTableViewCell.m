//
//  YinHTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/5/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "YinHTableViewCell.h"
#import "fashion.h"
@implementation YinHTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLable = [UnityLHClass initUILabel:@"曹路" font:13.0 color:[UIColor blackColor] rect:CGRectMake(30, 8, 150, 20)];
        [self.contentView addSubview:self.titleLable];
        
        self.dateLable = [UnityLHClass initUILabel:@"张士波 2015/05/22" font:11.0 color:[UIColor colorWithRed:60.0/255.0 green:177.0/255.0 blue:235.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-110, 8, 150, 20)];
        [self.contentView addSubview:self.dateLable];
        
        self.contentLable = [UnityLHClass initUILabel:@"主驾驶的骄傲收购价驾驶的骄傲收购价驾驶的骄傲收购价艾丝凡" font:11.0 color:[UIColor grayColor] rect:CGRectMake(30, 33, kScreenWidth-60, 30)];
        self.contentLable.numberOfLines = 0;
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
