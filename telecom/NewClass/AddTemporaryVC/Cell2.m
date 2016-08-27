//
//  Cell2.m
//  KuanJiaDemo
//
//  Created by 郝威斌 on 15/3/11.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "Cell2.h"

@implementation Cell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.titleLabel = [UnityLHClass initUILabel:@"XXXXXX" font:13.0 color:[UIColor grayColor] rect:CGRectMake(10, 10, 280, 20)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];
        
        
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
