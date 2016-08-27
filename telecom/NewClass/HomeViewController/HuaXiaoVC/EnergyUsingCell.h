//
//  EnergyUsingCell.h
//  telecom
//
//  Created by liuyong on 15/12/2.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EnergyUsingModel.h"

@interface EnergyUsingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *stationNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *PUELabel;
@property (strong, nonatomic) IBOutlet UILabel *totalSaveLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;

@property (strong, nonatomic) IBOutlet UILabel *saveLabel;
@property (strong, nonatomic) IBOutlet UILabel *commLabel;

@property (strong, nonatomic) IBOutlet UILabel *deltaPUELabel;
@property (strong, nonatomic) IBOutlet UILabel *T0Label;

- (void)configWithModel:(EnergyUsingModel *)model;

@end
