//
//  YZChooseChangeTableViewCell.m
//  ResouceChanged
//
//  Created by 锋 on 16/5/3.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZChooseChangeTableViewCell.h"
#import "Masonry.h"

@implementation YZIndexTextField

//- (void)layoutSublayersOfLayer:(CALayer *)layer {
//    [super layoutSublayersOfLayer:layer];
//}

@end

@implementation YZChooseChangeTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _label_title = [[UILabel alloc] init];
        _label_title.numberOfLines = 0;
        _label_title.frame = CGRectMake(16, 4, 120, 40);
        [self.contentView addSubview:_label_title];
        
        _textField_choose = [[YZIndexTextField alloc] initWithFrame:CGRectMake(130, 13, kScreenWidth - 141, 24)];
        _textField_choose.layer.cornerRadius = 4;
        _textField_choose.layer.borderColor = [UIColor grayColor].CGColor;
        _textField_choose.layer.borderWidth = .5;
        _textField_choose.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        _textField_choose.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_textField_choose];
        
        
        _imageView_accessory = [[UIImageView alloc] init];
        _imageView_accessory.image = [UIImage imageNamed:@"week_right"];
        _imageView_accessory.frame = CGRectMake(_textField_choose.frame.size.width - 24, 1, 23, 24);
        _imageView_accessory.transform = CGAffineTransformMakeRotation(M_PI/2);
        [_textField_choose addSubview:_imageView_accessory];

        _control_choose = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, _textField_choose.frame.size.width, _textField_choose.frame.size.height)];
        [_textField_choose addSubview:_control_choose];
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
