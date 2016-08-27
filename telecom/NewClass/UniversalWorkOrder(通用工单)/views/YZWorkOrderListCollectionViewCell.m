//
//  YZWorkOrderListCollectionViewCell.m
//  telecom
//
//  Created by 锋 on 16/6/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZWorkOrderListCollectionViewCell.h"
#import "Masonry.h"

@implementation YZWorkOrderListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 2;
        
        UILabel *workOrderLabel = [[UILabel alloc] init];
        workOrderLabel.font = [UIFont systemFontOfSize:12];
        workOrderLabel.text = @"工单编号:";
        [self.contentView addSubview:workOrderLabel];
        
        UILabel *workOrderDescLabel = [[UILabel alloc] init];
        workOrderDescLabel.font = [UIFont systemFontOfSize:12];
        workOrderDescLabel.text = @"工单说明:";
        [self.contentView addSubview:workOrderDescLabel];
        
        
        _label_workOrderId = [[UILabel alloc] init];
        _label_workOrderId.font = [UIFont systemFontOfSize:13];
        _label_workOrderId.numberOfLines = 2;
        _label_workOrderId.textColor = [UIColor colorWithRed:46/255.0 green:141/255.0 blue:222/255.0 alpha:1];
        [self.contentView addSubview:_label_workOrderId];


        
        UILabel *statusLabel = [[UILabel alloc] init];
        statusLabel.font = [UIFont systemFontOfSize:12];
        statusLabel.text = @"状态:";
        [self.contentView addSubview:statusLabel];
        
        _label_status = [[UILabel alloc] init];
        _label_status.font = [UIFont systemFontOfSize:13];
        _label_status.textColor = [UIColor colorWithRed:46/255.0 green:141/255.0 blue:222/255.0 alpha:1];
        [self.contentView addSubview:_label_status];
        
        UILabel *createTimeLabel = [[UILabel alloc] init];
        createTimeLabel.font = [UIFont systemFontOfSize:12];
        createTimeLabel.text = @"创建时间:";
        [self.contentView addSubview:createTimeLabel];
        
        _label_createTime = [[UILabel alloc] init];
        _label_createTime.font = [UIFont systemFontOfSize:13];
        _label_createTime.textColor = [UIColor colorWithRed:46/255.0 green:141/255.0 blue:222/255.0 alpha:1];
        [self.contentView addSubview:_label_createTime];

        //工单编号和工单说明标题
        [workOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.top.offset(8);
            make.width.offset(56);
            make.height.offset(15);
        }];
        
        [workOrderDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.top.offset(26);
            make.width.offset(56);
            make.height.offset(15);
        }];

        
        [_label_workOrderId mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(workOrderLabel.mas_right).offset(0);
            make.top.offset(8);
            make.right.offset(-8);
            make.height.offset(16);
        }];
               //状态
        [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.bottom.offset(-8);
            make.width.offset(31);
            make.height.offset(15);
        }];
        
        [_label_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(statusLabel.mas_right).offset(0);
            make.bottom.offset(-8);
            make.right.offset(-8);
            make.height.offset(15);
        }];
        
        //创建时间
        [_label_createTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(0);
            make.bottom.offset(-8);
            make.width.offset(76);
            make.height.offset(15);
        }];
        
        [createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_label_createTime.mas_left).offset(0);
            make.bottom.offset(-8);
            make.width.offset(52);
            make.height.offset(15);
        }];
        
        _label_detail = [[UILabel alloc] init];
        _label_detail.font = [UIFont systemFontOfSize:13];
        _label_detail.textColor = [UIColor colorWithRed:46/255.0 green:141/255.0 blue:222/255.0 alpha:1];
        _label_detail.numberOfLines = 8;
        [self.contentView addSubview:_label_detail];

        [_label_detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(workOrderDescLabel.mas_bottom).offset(0);
            make.left.offset(32);
            make.right.offset(-8);
            make.height.offset(16);
        }];
    }
    
    return self;
}

- (void)updateWorkOrderIdLabelHeight:(CGFloat)height_workOrderId detailLabelHeight:(CGFloat)height_detail
{
    [_label_workOrderId mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height_workOrderId);
    }];
    
    [_label_detail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height_detail);
    }];
}

@end
