//
//  PoliticalAndCompanyDetailInfoCell.m
//  telecom
//
//  Created by SD0025A on 16/4/7.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "PoliticalAndCompanyDetailInfoCell.h"
#import "PoliticalAndCompanyOrderModel.h"
@implementation PoliticalAndCompanyDetailInfoCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configModel:(PoliticalAndCompanyOrderModel *)model
{
    self.orderNo.text = model.orderNo;
    self.cusName.text= model.cusName;
    self.crmTypeLabel.text = model.crmType;
    self.linkName.text = model.linkName;
    self.groupNo.text = model.groupNo;
    self.orderStatus.text = model.status;
    self.finishTime.text = model.finishTime;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
