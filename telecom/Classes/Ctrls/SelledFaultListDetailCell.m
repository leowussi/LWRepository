//
//  SelledFaultListDetailCell.m
//  telecom
//
//  Created by SD0025A on 16/4/7.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SelledFaultListDetailCell.h"
#import "SelledFaultListDetailModel.h"
@implementation SelledFaultListDetailCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configModel:(SelledFaultListDetailModel *)model
{
    self.label1.text = model.businessNo;
    self.label2.text = model.orderNo;
    self.label3.text = model.region;
    self.label4.text = model.site;
    self.label7.text = model.acceptTime;
    self.label8.text = model.WORKTYPE;
    self.label9.text = model.workStatus;
    self.label10.text = model.workContent;
    self.label11.text = model.room;
    self.label12.text = model.expectTime;
    self.label13.text = model.contactWay;
    self.label14.text = model.faultLevel;
    self.label15.text = model.faultTimeLimit;
    self.label16.text = model.dealTimeLimit;
    self.label17.text = model.handupTime;
    self.label18.text = model.finishTimeLimit;
    self.label19.text = model.speciality;
    self.label20.text = model.workType1;
    self.label21.text = model.faultPart1;
    self.label22.text = model.faultPart2;
    self.label23.text = model.faultPart3;
    self.label24.text = model.faultPart4;
    self.label25.text = model.faultPart5;
    self.label26.text = model.faultPart6;
    self.label27.text = model.faultPart7;
    self.label28.text = model.faultPart8;
    self.label29.text =  model.source;
    self.label30.text = model.groupNo;
   
}
/*
 workNo
 businessNo
 orderNo
 region
 site
 acceptTime
 workType
 workStatus
 workContent
 room
 expectTime
 contactWay
 faultLevel
 faultTimeLimit
 dealTimeLimit
 handupTime
 finishTimeLimit
 speciality
 */
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
