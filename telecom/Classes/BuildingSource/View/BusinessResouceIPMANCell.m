//
//  BusinessResouceIPMANCell.m
//  telecom
//
//  Created by SD0025A on 16/7/6.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "BusinessResouceIPMANCell.h"
#import "BusinessResourceModel.h"
@implementation BusinessResouceIPMANCell

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
    self.label3.text = model.region;
    self.label4.text = model.site;
    self.label5.text = model.room;
    self.label6.text = model.roomAddress;
    self.label8.text = model.gTerminalsTotal;
    self.label9.text = model.gTerminalsAvailable;
    self.label10.text = model.gTerminalsTakeup;
    self.label11.text = model.gTerminalsKeep;
    self.label12.text = model.fttoPortAvailable;
    self.label13.text = model.zwswAvaliable;
    self.label14.text = model.tjCirAvaliable;
    self.label15.text = model.range;
    
}
@end
