//
//  YZWorkOrderHeaderView.h
//  telecom
//
//  Created by 锋 on 16/6/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZWorkOrderHeaderView : UITableViewHeaderFooterView

@property (nonatomic, strong) UIButton *button_siteName;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UILabel *label_number;

@end
