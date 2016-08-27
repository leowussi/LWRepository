//
//  LQfoceListHeadview.h
//  telecom
//
//  Created by Sundear on 16/3/24.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQrowHightModel.h"
@class LQfoceListHeadview;
@protocol LQfoceListHeadviewDelegate <NSObject>

-(void)HeadViewDidClick:(LQfoceListHeadview *)headerView;

@end

@interface LQfoceListHeadview : UITableViewHeaderFooterView

@property(nonatomic,strong)LQrowHightModel *model;
//校正按钮
@property (nonatomic, strong) UIButton *jiaoZhengButton;

@property(nonatomic,weak)id<LQfoceListHeadviewDelegate>delegate;
@property(nonatomic,strong)UIView *buttonView;
@property (nonatomic, assign) BOOL isOpened;


+(instancetype)headCellWithTableView:(UITableView *)table;

@end
