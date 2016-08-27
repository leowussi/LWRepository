//
//  BusinessResourceDetailCell.m
//  telecom
//
//  Created by SD0025A on 16/7/1.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "BusinessResourceDetailCell.h"
#import "BusinessResourceModel.h"
@implementation BusinessResourceDetailCell

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
    self.label3.text = model.onuCode.length >0 ?model.onuCode :@" ";
    self.label4.text = model.region;
    self.label5.text = model.site;
    self.label6.text = model.room;
    self.label7.text = model.roomAddress;
    self.label9.text = model.lifeCycle;
    self.label10.text = model.voicePortTotal;
    self.label11.text = model.voicePortTackup;
    self.label12.text = model.voicePortAvailable;
    self.label13.text = model.voicePortKeep;
    self.label14.text = model.adslPortTotal;
    self.label15.text = model.adslPortTackup;
    self.label16.text = model.adslPortAvailable;
    self.label17.text = model.adslPortKeep;
    self.label18.text = model.lanPortTotal;
    self.label19.text = model.lanPortTackup;
    self.label20.text = model.lanPortAvailable;
    self.label21.text = model.lanPortKeep;
    self.label22.text = model.range;
    
}
@end
