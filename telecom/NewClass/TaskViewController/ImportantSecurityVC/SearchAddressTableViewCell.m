//
//  SearchAddressTableViewCell.m
//  telecom
//
//  Created by 郝威斌 on 15/10/21.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "SearchAddressTableViewCell.h"
#define  kScreenWidth  [[UIScreen mainScreen] bounds].size.width

@implementation SearchAddressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLable = [UnityLHClass initUILabel:@"" font:13.0 color:[UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:233.0/255.0 alpha:1.0] rect:CGRectMake(10, 5, kScreenWidth-110, 20)];
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
