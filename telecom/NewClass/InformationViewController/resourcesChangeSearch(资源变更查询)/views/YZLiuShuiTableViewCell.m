//
//  YZLiuShuiTableViewCell.m
//  CheckResourcesChange
//
//  Created by 锋 on 16/5/3.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZLiuShuiTableViewCell.h"
#import "Masonry.h"

@implementation YZLiuShuiInfo

- (instancetype)initWithParserDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
    
        _string_department = [dict objectForKey:@"startdeptnm"];
        _string_status = [dict objectForKey:@"action"];
        _string_time = [dict objectForKey:@"dealtime"];
        NSString *remark = [dict objectForKey:@"remark"];
        NSString *startdealrole = [dict objectForKey:@"startdealrole"];        
        if ([_string_status isEqualToString:@"转派"] || [_string_status isEqualToString:@"转派 "]) {

            NSString *enddeptrole = [dict objectForKey:@"enddeptrole"];

            NSString *enddeptnm = [dict objectForKey:@"enddeptnm"];
            _string_desc = [NSString stringWithFormat:@"%@\n转派给:%@\n转派给:%@\n处理说明:%@",startdealrole,enddeptnm,enddeptrole,remark];
           

        }else{
            _string_desc = [NSString stringWithFormat:@"%@\n处理说明:%@",startdealrole,remark];
        }

    }
    return self;
}

@end

@implementation YZLiuShuiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _label_department = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, 200, 26)];
        _label_department.textColor = [UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1];
        _label_department.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:_label_department];
        
        _label_desc = [[UILabel alloc] init];
        _label_desc.font = [UIFont systemFontOfSize:15];
        _label_desc.textColor = [UIColor colorWithRed:135/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
        _label_desc.numberOfLines = 0;
        [self.contentView addSubview:_label_desc];
        
        _label_status = [[UILabel alloc] init];
        _label_status.textAlignment = NSTextAlignmentRight;
        _label_status.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:_label_status];
        [_label_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(30);
            make.right.offset(-16);
            make.width.offset(80);
            make.height.offset(26);
        }];
        
        _label_time = [[UILabel alloc] init];
        _label_time.font = [UIFont systemFontOfSize:15];
        _label_time.textColor = [UIColor colorWithRed:135/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
        _label_time.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_label_time];
        [_label_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-8);
            make.right.offset(-16);
            make.width.offset(160);
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
