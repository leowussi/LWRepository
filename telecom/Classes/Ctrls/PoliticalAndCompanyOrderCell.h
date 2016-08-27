//
//  PoliticalAndCompanyOrderCell.h
//  telecom
//
//  Created by SD0025A on 16/3/30.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PoliticalAndCompanyOrderModel;
@interface PoliticalAndCompanyOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cusNameLabel;// 客户名称
@property (weak, nonatomic) IBOutlet UILabel *orderNoLabel;//工单编号
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;//工单状态
@property (weak, nonatomic) IBOutlet UILabel *crmTypeLabel;//CRM订单类型
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

- (void)configModel:(PoliticalAndCompanyOrderModel *)model;
@end
