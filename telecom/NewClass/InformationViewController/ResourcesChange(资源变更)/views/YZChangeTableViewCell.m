//
//  YZChangeTableViewCell.m
//  ResouceChanged
//
//  Created by 锋 on 16/4/26.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZChangeTableViewCell.h"

@implementation YZChangeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _label_title = [[UILabel alloc] init];
        _label_title.numberOfLines = 0;
        _label_title.frame = CGRectMake(16, 4, 120, 40);
        [self.contentView addSubview:_label_title];
        
        CGRect rect = [UIScreen mainScreen].bounds;
        
        _textField_choose = [[UITextView alloc] initWithFrame:CGRectMake(130, 15, rect.size.width - 141, 80)];
        _textField_choose.font = [UIFont systemFontOfSize:14];
        _textField_choose.layer.cornerRadius = 4;
        _textField_choose.layer.borderColor = [UIColor grayColor].CGColor;
        _textField_choose.layer.borderWidth = .5;
        _textField_choose.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:_textField_choose];
               
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
