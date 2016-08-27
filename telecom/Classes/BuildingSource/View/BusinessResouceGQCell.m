//
//  BusinessResouceGQCell.m
//  telecom
//
//  Created by SD0025A on 16/7/5.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "BusinessResouceGQCell.h"
#import "BusinessResourceModel.h"

@implementation BusinessResouceGQCell

- (void)awakeFromNib {
    self.leftView.layer.borderWidth = 1;
    self.leftView.layer.borderColor = [UIColor grayColor].CGColor;
    self.rightView.layer.borderWidth = 1;
    self.rightView.layer.borderColor = [UIColor grayColor].CGColor;
   
}
- (void)configModel:(BusinessResourceModel *)model
{
    self.label1.text = model.deviceType;
    self.label2.text = model.deviceName;
    self.label3.text = model.onuCode;
    self.label4.text = model.region;
    self.label5.text = model.site;
    self.label6.text = model.room;
    self.label7.text = model.roomAddress;
      self.label9.text = model.obdSubType;
    self.label10.text = model.obdGrade;
    self.label11.text = model.obdManufactuer;
    self.label12.text = model.obdPortTotal;
    self.label13.text = model.obdPortAvailable;
    self.label14.text = model.obdPortTackup;
    self.label15.text = model.obdPortKeep;
    self.label16.text = model.obdState;
    self.label17.text = model.oltUserfor;
    self.label18.text = model.range;
}

@end
