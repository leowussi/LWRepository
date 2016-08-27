//
//  LQCellONU.h
//  telecom
//
//  Created by Sundear on 16/3/29.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OnuModel;
@interface LQCellONU : UITableViewCell
@property(nonatomic,strong)OnuModel *model;
//校正按钮
@property (nonatomic, strong) UIButton *jiaoZhengButton;

+(instancetype)tableView:(UITableView *)tableView;
@end
