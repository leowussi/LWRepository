//
//  YZSearchResultTableViewCell.h
//  CheckResourcesChange
//
//  Created by 锋 on 16/4/29.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//
#define TEXT_FONT [UIFont fontWithName:@"Helvetica-Bold" size:15.0]
#import <UIKit/UIKit.h>

@interface YZSearchResultTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *label_time;
@property (nonatomic, strong) UILabel *label_taskType;
@property (nonatomic, strong) UILabel *label_profession;
@property (nonatomic, strong) UILabel *label_infoNumber;
@property (nonatomic, strong) UILabel *label_status;
@property (nonatomic, strong) UILabel *label_resoure;

@property (nonatomic, strong) UIImageView *imageView_accessory;

@end
