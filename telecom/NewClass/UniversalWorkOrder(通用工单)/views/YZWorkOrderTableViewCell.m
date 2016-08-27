//
//  YZWorkOrderTableViewCell.m
//  telecom
//
//  Created by 锋 on 16/6/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZWorkOrderTableViewCell.h"
#import "Masonry.h"

@implementation YZRobIndexButton

@end

@implementation YZWorkOrderTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isCanRob:(BOOL)canRob
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *workOrderLabel = [[UILabel alloc] init];
        workOrderLabel.font = [UIFont systemFontOfSize:12];
        workOrderLabel.text = @"工单编号:\n工单说明:";
        workOrderLabel.numberOfLines = 2;
        [self.contentView addSubview:workOrderLabel];
        
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
            make.height.offset(30);
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
            make.right.offset(-8);
            make.bottom.offset(-8);
            make.width.offset(76);
            make.height.offset(15);
        }];
        
        [createTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_label_createTime.mas_left).offset(0);
            make.bottom.offset(-8);
            make.width.offset(56);
            make.height.offset(15);
        }];
        
        _label_detail = [[UILabel alloc] init];
        _label_detail.font = [UIFont systemFontOfSize:13];
        _label_detail.textColor = [UIColor colorWithRed:46/255.0 green:141/255.0 blue:222/255.0 alpha:1];
        _label_detail.numberOfLines = 0;
        [self.contentView addSubview:_label_detail];
        
        if (canRob) {

            _button_rob = [YZRobIndexButton buttonWithType:UIButtonTypeCustom];
            _button_rob.backgroundColor = [UIColor colorWithRed:130/255.0 green:173/255.0 blue:0 alpha:1];
            [_button_rob setTitle:@"抢" forState:UIControlStateNormal];
            _button_rob.layer.cornerRadius = 15;
            [self.contentView addSubview:_button_rob];
            
            [_button_rob mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.right.offset(-8);
                make.width.offset(30);
                make.height.offset(30);
            }];
            
            [_label_detail mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(workOrderLabel.mas_bottom).offset(2);
                make.left.offset(32);
                make.right.equalTo(_button_rob.mas_left).offset(-2);
                make.height.offset(16);
            }];
            
        }else{
            [_label_detail mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(workOrderLabel.mas_bottom).offset(2);
                make.left.offset(32);
                make.right.offset(-8);
                make.height.offset(16);
            }];

        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)updateWorkOrderIdLabelHeight:(CGFloat)height_workOrderId detailLabelHeight:(CGFloat)height_detail
{
    [_label_workOrderId mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height_workOrderId);
    }];
    
    [_label_detail mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(height_detail + 4);
    }];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
