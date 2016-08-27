//
//  YZImageAccessoryTableViewCell.m
//  telecom
//
//  Created by 锋 on 16/6/27.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZImageAccessoryTableViewCell.h"
#import "Masonry.h"

@implementation YZImageAccessoryTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"附件名称:";
        [self.contentView addSubview:titleLabel];
        
        _label_accessoryName = [[UILabel alloc] init];
        _label_accessoryName.font = [UIFont systemFontOfSize:16];
        _label_accessoryName.textColor = [UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1];
        [self.contentView addSubview:_label_accessoryName];
        
        _label_time = [[UILabel alloc] init];
        _label_time.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_label_time];
        
        _label_name = [[UILabel alloc] init];
        _label_name.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_label_name];
        
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.right.offset(-8);
            make.top.offset(8);
            make.height.offset(22);
        }];
        
        
        [_label_accessoryName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.right.offset(-8);
            make.top.equalTo(titleLabel.mas_bottom).offset(0);
            make.height.offset(22);
        }];

        
        [_label_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.right.offset(-8);
            make.top.equalTo(_label_accessoryName.mas_bottom).offset(0);
            make.height.offset(22);
        }];

        [_label_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.right.offset(-8);
            make.top.equalTo(_label_time.mas_bottom).offset(0);
            make.height.offset(22);
        }];

    }
    
    return self;
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
