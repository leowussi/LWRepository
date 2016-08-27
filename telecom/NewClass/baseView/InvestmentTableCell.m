//
//  InvestmentTableCell.m
//  JingRong360
//
//  Created by 锋 on 14-5-5.
//  Copyright (c) 2014年 qian.sundear. All rights reserved.
//

#import "InvestmentTableCell.h"

@implementation InvestmentTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIImageView* tabView = [UnityLHClass backgroundView:CGRectMake(10, 0, 300, 90) withStr:@"02-changfangxin.png"];
        
        [self.contentView addSubview:tabView];
        for (int i = 0; i<2; i++) {
            UILabel* left = [UnityLHClass initUILabel:@"" font:12 color:[UIColor grayColor] rect:CGRectMake(30, 10+40*i, 100, 20)];
            left.textAlignment = NSTextAlignmentLeft;
            left.tag = 10+i;
            [tabView addSubview:left];
            
            
            
            UILabel* right = [UnityLHClass initUILabel:@"" font:12 color:[UIColor grayColor] rect:CGRectMake(120, 10+40*i, 160, 20)];
            right.textAlignment = NSTextAlignmentRight;
            right.tag = 20+i;
            [tabView addSubview:right];
            
            
            if (i == 0) {
                right.textColor = [UIColor blackColor];
            }
            if (i ==1) {
                [right setFrame:CGRectMake(10, 10+40*i, 280, 20)];
            }
            
        }
        
        self.leftLab = (UILabel*)[self.contentView viewWithTag:10];
        
        self.rightLab1 = (UILabel*)[self.contentView viewWithTag:20];
        self.rightLab2 = (UILabel*)[self.contentView viewWithTag:21];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
