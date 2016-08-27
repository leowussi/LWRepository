//
//  YZSystemTableViewCell.m
//  ResouceChanged
//
//  Created by 锋 on 16/4/26.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZSystemTableViewCell.h"

@implementation YZSystemTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _label_system  = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 120, 28)];
        [self.contentView addSubview:_label_system];
        
        
        _label_name = [[UILabel alloc] init];
        _label_name.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
        _label_name.numberOfLines = 0;
        _label_name.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_label_name];
        
        _imageView_accessory = [[UIImageView alloc] init];
        CGRect ract = [UIScreen mainScreen].bounds;
        _imageView_accessory.frame = CGRectMake(ract.size.width- 29, 19, 19, 21);
        _imageView_accessory.image = [UIImage imageNamed:@"week_arrow"];
        [self.contentView addSubview:_imageView_accessory];
        
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
