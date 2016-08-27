//
//  CableInfoCell.h
//  telecom
//
//  Created by liuyong on 15/11/11.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CableConnectorInfoModel.h"

@interface CableInfoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *rackNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomLabel;
@property (strong, nonatomic) IBOutlet UILabel *roomAddressLabel;

@property (nonatomic, strong) UIButton *jiaoZhengButton;

- (void)configCellWith:(CableConnectorInfoModel *)model;
@end
