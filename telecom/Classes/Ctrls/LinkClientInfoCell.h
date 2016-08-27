//
//  LinkClientInfoCell.h
//  telecom
//
//  Created by SD0025A on 16/3/31.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//
//链路信息xib
#import <UIKit/UIKit.h>

@class LinkClientInfoModel;
@interface LinkClientInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *linkNo;
@property (weak, nonatomic) IBOutlet UILabel *cusName;
@property (weak, nonatomic) IBOutlet UILabel *cusAddress;
@property (weak, nonatomic) IBOutlet UILabel *contract;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *startInfo;
@property (weak, nonatomic) IBOutlet UILabel *startCompany;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *startContract;
@property (weak, nonatomic) IBOutlet UILabel *startTel;
@property (weak, nonatomic) IBOutlet UILabel *endInfo;
@property (weak, nonatomic) IBOutlet UILabel *endCompany;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;
@property (weak, nonatomic) IBOutlet UILabel *endContract;
@property (weak, nonatomic) IBOutlet UILabel *endTel;


- (void)configModel:(LinkClientInfoModel *)model;
@end
