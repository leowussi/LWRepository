//
//  PoliticalAndCompanyOrderCell.m
//  telecom
//
//  Created by SD0025A on 16/3/30.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "PoliticalAndCompanyOrderCell.h"
#import "PoliticalAndCompanyOrderModel.h"
@implementation PoliticalAndCompanyOrderCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configModel:(PoliticalAndCompanyOrderModel *)model
{
    
    NSInteger hour = model.danger.integerValue;
        if (hour>0 && hour<24) {
        self.contentView.backgroundColor = COLOR(250, 247, 203);
        self.leftImageView.image = [UIImage imageNamed:@"icon0yellow@2x"];
    }
    if (hour<0) {
        self.contentView.backgroundColor = COLOR(254, 243, 248);
        self.leftImageView.image = [UIImage imageNamed:@"icon0red@2x"];
    }else{
            self.contentView.backgroundColor = [UIColor whiteColor];
            self.leftImageView.image = [UIImage imageNamed:@"icon0.png"];
    }

    self.cusNameLabel.text = model.cusName;
    self.orderNoLabel.text = model.orderNo;
    self.timeLabel.text = model.workNo;
    self.statusLabel.text = model.status;
    self.crmTypeLabel.text = model.crmType;
    self.timeLabel.text = model.finishTime;
}
@end
