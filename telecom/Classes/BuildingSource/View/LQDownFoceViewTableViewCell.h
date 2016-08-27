//
//  LQDownFoceViewTableViewCell.h
//  telecom
//
//  Created by Sundear on 16/3/24.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQBackView.h"
#import "LQFoceList.h"
@interface LQDownFoceViewTableViewCell : UITableViewCell

//校正按钮
@property (nonatomic, strong) YZIndexButton *jiaoZhengButton;

+(instancetype)cellWithTableView:(UITableView *)table;
@property(nonatomic,strong)LQFoceList *model;
@end
