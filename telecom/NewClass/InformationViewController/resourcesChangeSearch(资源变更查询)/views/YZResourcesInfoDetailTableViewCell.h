//
//  YZResourcesInfoDetailTableViewCell.h
//  CheckResourcesChange
//
//  Created by 锋 on 16/5/3.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//
#define TEXTCOLOR [UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1]

#import <UIKit/UIKit.h>

@interface YZResourcesInfoDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *label_title;
@property (nonatomic, strong) UILabel *label_detail;

@end

@interface YZSystemDetailTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *label_title;
@property (nonatomic, strong) UILabel *label_name;
@property (nonatomic, strong) UILabel *label_juHao;
@property (nonatomic, strong) UILabel *label_jiFang;
@property (nonatomic, strong) UILabel *label_jiJia;

@end