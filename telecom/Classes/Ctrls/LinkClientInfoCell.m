//
//  LinkClientInfoCell.m
//  telecom
//
//  Created by SD0025A on 16/3/31.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "LinkClientInfoCell.h"
#import "LinkClientInfoModel.h"
@implementation LinkClientInfoCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configModel:(LinkClientInfoModel *)model
{
    self.linkNo.text = [model.linkNo isEqualToString:@""] ||model.linkNo ==nil ? @" ":model.linkNo;
    self.cusName.text = [model.cusName isEqualToString:@""]||model.cusName ==nil ? @" ":model.cusName;
    self.cusAddress.text = [model.cusAddress isEqualToString:@""]||model.cusAddress ==nil ? @" ":model.cusAddress;
    self.contract.text = [model.contract isEqualToString:@""] ||model.contract ==nil ?  @" ":model.contract;
    
    self.tel.text = [model.tel isEqualToString:@""] ||model.tel ==nil ? @" ":model.tel;
    self.startInfo.text = [model.startInfo  isEqualToString:@""]||model.startInfo ==nil ? @" ":model.startInfo;
    self.startCompany.text = [model.startCompany isEqualToString:@""]  ||model.startCompany ==nil? @" ":model.startCompany;
    self.startAddress.text = [model.startAddress isEqualToString:@""]  ||model.startAddress ==nil ? @" ":model.startAddress;
    self.startContract.text = [model.startContract isEqualToString:@""]  ||model.startContract ==nil ? @" ":model.startContract;
    self.startTel.text = [model.startTel isEqualToString:@""] ||model.startTel ==nil ? @" ":model.startTel;
    self.endInfo.text = [model.endInfo isEqualToString:@""] ||model.endInfo ==nil ? @" ":model.endInfo;
    self.endCompany.text = [model.endCompany isEqualToString:@""]  ||model.endCompany ==nil ? @" ":model.endCompany;
    self.endAddress.text = [model.endAddress isEqualToString:@""]  ||model.endAddress ==nil ? @" ":model.endAddress;
    self.endContract.text = [model.endContract isEqualToString:@""] ||model.endContract ==nil ? @" ":model.endContract;
    self.endTel.text = [model.endTel isEqualToString:@""]  ||model.endTel ==nil ? @" ":model.endTel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
