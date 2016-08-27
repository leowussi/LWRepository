//
//  YuYueTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/5/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "YuYueTableViewCell.h"
#import "fashion.h"
@implementation YuYueTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLable = [UnityLHClass initUILabel:@"远程开门(张士波)" font:13.0 color:[UIColor colorWithRed:60.0/255.0 green:177.0/255.0 blue:235.0/255.0 alpha:1.0] rect:CGRectMake(30, 8, 150, 20)];
        [self.contentView addSubview:self.titleLable];
        
        self.contentLable = [UnityLHClass initUILabel:@"曹路电力机房" font:12.0 color:[UIColor blackColor] rect:CGRectMake(30, 33, 150, 20)];
        [self.contentView addSubview:self.contentLable];
        
        self.nameLable = [UnityLHClass initUILabel:@"设备上电" font:12.0 color:[UIColor grayColor] rect:CGRectMake(kScreenWidth-200, 33, 150, 20)];
        [self.contentView addSubview:self.nameLable];
        
        self.dateLable = [UnityLHClass initUILabel:@"2015/05/20 15:12:59" font:12.0 color:[UIColor colorWithRed:60.0/255.0 green:177.0/255.0 blue:235.0/255.0 alpha:1.0] rect:CGRectMake(kScreenWidth-150, 55, 150, 20)];
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
