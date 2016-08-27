//
//  YZWorkOrderTitleTableViewCell.m
//  telecom
//
//  Created by 锋 on 16/6/19.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZWorkOrderTitleTableViewCell.h"

@implementation YZWorkOrderTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithRed:216/255.0 green:240/255.0 blue:1 alpha:1];
        _layer_accessory = [CALayer layer];
        _layer_accessory.contents = (id)[UIImage imageNamed:@"right_arrow"].CGImage;
        _layer_accessory.position = CGPointMake(kScreenWidth - 34, 18);
        _layer_accessory.bounds = CGRectMake(0, 0, 9, 16);
        [self.contentView.layer addSublayer:_layer_accessory];
        
        
        _label_title = [[UILabel alloc] initWithFrame:CGRectMake(12, 8, 100, 20)];
        _label_title.font = [UIFont systemFontOfSize:14];
        _label_title.textColor = [UIColor colorWithRed:46/255.0 green:141/255.0 blue:222/255.0 alpha:1];
        [self.contentView addSubview:_label_title];
        
        _label_number = [[UILabel alloc] initWithFrame:CGRectMake(120, 8, 40, 20)];
        _label_number.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_label_number];
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
