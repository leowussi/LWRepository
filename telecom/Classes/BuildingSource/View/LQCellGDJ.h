//
//  CellGDJ.h
//  telecom
//
//  Created by Sundear on 16/3/28.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GdjModel.h"

@interface LQCellGDJ : UITableViewCell
@property(nonatomic,strong)GdjModel *model;
//校正按钮
@property (nonatomic, strong) UIButton *jiaoZhengButton;

+(instancetype)tableView:(UITableView *)tableView;
@end
