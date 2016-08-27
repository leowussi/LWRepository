//
//  YZSearchResultTableViewCell.m
//  CheckResourcesChange
//
//  Created by 锋 on 16/4/29.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZSearchResultTableViewCell.h"
#import "Masonry.h"

@implementation YZSearchResultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        _label_time = [[UILabel alloc] init];
        _label_time.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_label_time];
        
        _label_infoNumber = [[UILabel alloc] init];
        _label_infoNumber.textColor = [UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1];
        _label_infoNumber.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_label_infoNumber];
        
        _label_status = [[UILabel alloc] init];
        _label_status.textColor = [UIColor colorWithRed:246/255.0 green:0/255.0 blue:0/255.0 alpha:1];
        _label_status.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_label_status];
        
        _label_taskType = [[UILabel alloc] init];
        _label_taskType.textColor = [UIColor colorWithRed:135/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
        _label_taskType.textAlignment = NSTextAlignmentRight;
        
        _label_taskType.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_label_taskType];

        _label_profession = [[UILabel alloc] init];
        _label_profession.textColor = [UIColor colorWithRed:95/255.0 green:196/255.0 blue:0/255.0 alpha:1];
        _label_profession.textAlignment = NSTextAlignmentRight;
        _label_profession.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_label_profession];
        
        _label_resoure = [[UILabel alloc] init];
        _label_resoure.textColor = [UIColor colorWithRed:135/255.0 green:135/255.0 blue:135/255.0 alpha:1];
        _label_resoure.textAlignment = NSTextAlignmentRight;
        _label_resoure.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_label_resoure];
        
        _imageView_accessory = [[UIImageView alloc] init];
        _imageView_accessory.image = [UIImage imageNamed:@"yellow_point"];
        [self.contentView addSubview:_imageView_accessory];
        
        [_label_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.top.offset(8);
            make.width.offset(200);
            make.height.offset(20);
        }];
        
        [_label_infoNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.top.offset(28);
            make.width.offset(240);
            make.height.offset(20);
        }];
        
        [_label_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.top.offset(48);
            make.width.offset(200);
            make.height.offset(20);
        }];
        
        [_label_taskType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(8);
            make.right.offset(-18);
            make.width.offset(140);
            make.height.offset(20);
        }];
        
        [_label_profession mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(28);
            make.right.offset(-8);
            make.width.offset(140);
            make.height.offset(20);
        }];

        [_label_resoure mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(48);
            make.right.offset(-8);
            make.width.offset(200);
            make.height.offset(20);
        }];
        
        [_imageView_accessory mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(12);
            make.right.offset(-5);
            make.width.offset(10);
            make.height.offset(10);
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
