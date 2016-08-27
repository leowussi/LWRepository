//
//  YZResourcesInfoDetailTableViewCell.m
//  CheckResourcesChange
//
//  Created by 锋 on 16/5/3.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZResourcesInfoDetailTableViewCell.h"

@implementation YZSystemDetailTableViewCell

@end

@implementation YZResourcesInfoDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier

{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _label_title = [[UILabel alloc] initWithFrame:CGRectMake(14, 2, 108, 40)];
        _label_title.textColor = TEXTCOLOR;
        _label_title.font = [UIFont boldSystemFontOfSize:15];
        _label_title.numberOfLines = 0;
        [self.contentView addSubview:_label_title];
        
        _label_detail = [[UILabel alloc] initWithFrame:CGRectMake(120, 4, kScreenWidth - 120, 36)];
        _label_detail.font = [UIFont systemFontOfSize:15];
        _label_detail.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
        _label_detail.numberOfLines = 0;
        [self.contentView addSubview:_label_detail];
        
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
