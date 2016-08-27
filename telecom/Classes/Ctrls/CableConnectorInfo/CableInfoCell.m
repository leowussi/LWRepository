//
//  CableInfoCell.m
//  telecom
//
//  Created by liuyong on 15/11/11.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "CableInfoCell.h"
#import "Masonry.h"

@implementation CableInfoCell

- (void)awakeFromNib {
    // Initialization code
    _jiaoZhengButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_jiaoZhengButton setBackgroundImage:[UIImage imageNamed:@"资源矫正"] forState:UIControlStateNormal];
    _jiaoZhengButton.frame = CGRectMake(kScreenWidth - 50, 72, 22, 22);
    [self addSubview:_jiaoZhengButton];
    
   
}

- (void)configCellWith:(CableConnectorInfoModel *)model
{
    self.rackNameLabel.text = model.rackName;
    self.countLabel.text = [NSString stringWithFormat:@"%d",model.count];
    self.roomLabel.text = model.roomName;
    self.roomAddressLabel.text = model.roomAddress;
}

@end
