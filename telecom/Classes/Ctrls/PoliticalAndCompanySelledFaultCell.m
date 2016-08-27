//
//  PoliticalAndCompanySelledFaultCell.m
//  telecom
//
//  Created by SD0025A on 16/4/19.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "PoliticalAndCompanySelledFaultCell.h"
#import "PoliticalAndCompanySelledFaultModel.h"

@implementation PoliticalAndCompanySelledFaultCell

- (void)awakeFromNib {
    
}
- (void)configModel:(PoliticalAndCompanySelledFaultModel *)model
{
   NSInteger limit = [model.danger integerValue];
    if (limit<50) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.leftImage.image = [UIImage imageNamed:@"icon0.png"];
    }
    if (limit>=50 &&limit<75) {
        self.contentView.backgroundColor = COLOR(250, 247, 203);
        self.leftImage.image = [UIImage imageNamed:@"icon50@2x"];
    }
    if (limit>=75 &&limit<100) {
        self.contentView.backgroundColor = COLOR(254, 243, 248);
        self.leftImage.image = [UIImage imageNamed:@"icon75@2x"];
    }

   
    if (limit>=100 &&limit<200) {
        self.contentView.backgroundColor = COLOR(251, 216, 231);
        self.leftImage.image = [UIImage imageNamed:@"icon100@2x"];
    }

    if (limit>=200 &&limit<400) {
        self.contentView.backgroundColor = COLOR(251, 216, 231);
        self.leftImage.image = [UIImage imageNamed:@"icon2bei@2x"];
    }
    if (limit>=400 ) {
        self.contentView.backgroundColor = COLOR(251, 216, 231);
        self.leftImage.image = [UIImage imageNamed:@"icon4bei@2x"];
    }




    self.label1.text = [NSString stringWithFormat:@"%@~~%@",model.acceptTime,model.expectTime];
    self.leftImage.image = [UIImage imageNamed:@"icon0.png"];
    self.label2.text = model.orderNo;
    self.label3.text = model.workStatus;
    [self.label3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
    self.label4.text = [NSString stringWithFormat:@"(余：%@)",model.finishTimeLimit];
    [self.label4 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
    self.label5.text= model.workType;
    if (model.groupNo != nil) {
        self.label6.text = @"集团";
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
