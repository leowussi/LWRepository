//
//  YZWorkOrderTableViewCell.h
//  telecom
//
//  Created by 锋 on 16/6/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZRobIndexButton;

@interface YZWorkOrderTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *label_workOrderId;
@property (nonatomic, strong) UILabel *label_status;
@property (nonatomic, strong) UILabel *label_createTime;

@property (nonatomic, strong) UILabel *label_detail;

//可抢按钮
@property (nonatomic, strong) YZRobIndexButton *button_rob;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isCanRob:(BOOL)canRob;

- (void)updateWorkOrderIdLabelHeight:(CGFloat)height_workOrderId detailLabelHeight:(CGFloat)height_detail;


@end

@interface YZRobIndexButton : UIButton

@property (nonatomic, strong) NSIndexPath *buttonIndexPath;

@end
