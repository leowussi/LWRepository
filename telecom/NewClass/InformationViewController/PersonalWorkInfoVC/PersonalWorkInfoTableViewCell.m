//
//  PersonalWorkInfoTableViewCell.m
//  telecom
//
//  Created by iOS开发工程师 on 15/11/4.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "PersonalWorkInfoTableViewCell.h"

@implementation PersonalWorkInfoTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.leftLable = [UnityLHClass initUILabel:@"里  程 ：" font:13.0 color:[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] rect:CGRectMake(10, 5, 80, 20)];
        [self.contentView addSubview:self.leftLable];
        
        self.rightLable = [UnityLHClass initUILabel:@"里  程 ：" font:13.0 color:[UIColor colorWithRed:159.0/255.0 green:159.0/255.0 blue:159.0/255.0 alpha:1.0] rect:CGRectMake(100, 5, 80, 20)];
        [self.contentView addSubview:self.rightLable];
        
        
        
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
