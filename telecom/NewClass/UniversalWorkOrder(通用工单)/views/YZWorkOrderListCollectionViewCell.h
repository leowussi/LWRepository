//
//  YZWorkOrderListCollectionViewCell.h
//  telecom
//
//  Created by 锋 on 16/6/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZWorkOrderListCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label_workOrderId;

@property (nonatomic, strong) UILabel *label_status;
@property (nonatomic, strong) UILabel *label_createTime;

@property (nonatomic, strong) UILabel *label_detail;

- (void)updateWorkOrderIdLabelHeight:(CGFloat)height_workOrderId detailLabelHeight:(CGFloat)height_detail;



@end
