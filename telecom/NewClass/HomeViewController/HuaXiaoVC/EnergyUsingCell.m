//
//  EnergyUsingCell.m
//  telecom
//
//  Created by liuyong on 15/12/2.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "EnergyUsingCell.h"

@implementation EnergyUsingCell

- (void)configWithModel:(EnergyUsingModel *)model
{
    self.stationNameLabel.text = model.siteName;
    self.totalSaveLabel.text = [NSString stringWithFormat:@"总节电费:%@",model.totalMinusFee];
    self.saveLabel.text = [NSString stringWithFormat:@"节电费:%@",model.minusFee];
    self.totalLabel.text = [NSString stringWithFormat:@"总电量:%@",model.billValue];
    self.commLabel.text = [NSString stringWithFormat:@"通信电量:%@",model.txValue];
    self.PUELabel.text = [NSString stringWithFormat:@"PUE:%@",model.pue];
    self.deltaPUELabel.text = [NSString stringWithFormat:@"△PUE:%@",model.deltaPue];
    self.T0Label.text = [NSString stringWithFormat:@"T0:%@",model.t0];
}

- (void)awakeFromNib {

}



@end
