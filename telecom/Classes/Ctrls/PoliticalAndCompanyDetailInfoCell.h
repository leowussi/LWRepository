//
//  PoliticalAndCompanyDetailInfoCell.h
//  telecom
//
//  Created by SD0025A on 16/4/7.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PoliticalAndCompanyOrderModel;

@interface PoliticalAndCompanyDetailInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *cusName;
@property (weak, nonatomic) IBOutlet UILabel *groupNo;
@property (weak, nonatomic) IBOutlet UILabel *linkName;
@property (weak, nonatomic) IBOutlet UILabel *crmTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderStatus;
@property (weak, nonatomic) IBOutlet UILabel *finishTime;
- (void)configModel:(PoliticalAndCompanyOrderModel *)model;
@end
