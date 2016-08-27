//
//  YZAcceptanceListTableViewCell.m
//  AcceptanceApplication
//
//  Created by 锋 on 16/5/16.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZAcceptanceListTableViewCell.h"

@implementation YZAcceptanceList


- (instancetype)initWithParserDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _string_projectname = [dict objectForKey:@"projectName"];
        _checkId = [dict objectForKey:@"checkId"];
        NSString *checkResult = [dict objectForKey:@"checkResult"];
        if ([checkResult isKindOfClass:[NSNull class]]) {
            checkResult = @"";
        }
        _checkResult = checkResult;
        NSString *desc = nil;
        if ([dict objectForKey:@"remindStartTime"]) {
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [mutDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [mutDict setObject:@"" forKey:key];
                }
            }];
            desc = [NSString stringWithFormat:@"%@    %@\n%@~%@\n%@     %@",[mutDict objectForKey:@"taskAppointmentNo"],[mutDict objectForKey:@"regionName"],[[mutDict objectForKey:@"remindStartTime"] isEqualToString:@""] ? @"" : [[mutDict objectForKey:@"remindStartTime"] substringToIndex:13],[[mutDict objectForKey:@"remindEndTime"] isEqualToString:@""] ? @"" : [[mutDict objectForKey:@"remindEndTime"] substringToIndex:13],[mutDict objectForKey:@"projectSiteName"],[mutDict objectForKey:@"projectRoomName"]];
        }else{
            desc = [NSString stringWithFormat:@"%@    %@\n%@~%@\n%@     %@",[dict objectForKey:@"taskAppointmentNo"],[dict objectForKey:@"regionName"],[[dict objectForKey:@"startTime"] isEqualToString:@""] ? @"" : [[dict objectForKey:@"startTime"] substringToIndex:13],[[dict objectForKey:@"endTime"] isEqualToString:@""] ? @"" : [[dict objectForKey:@"endTime"] substringToIndex:13],[dict objectForKey:@"projectSiteName"],[dict objectForKey:@"projectRoomName"]];
        }
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 10;
        
        _string_desc = [[NSMutableAttributedString alloc] initWithString:desc attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraphStyle}];
        
        
    }
    return self;
}

@end

@implementation YZAcceptanceListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contianDeleteButton:(BOOL)isShow
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:243/255.0 alpha:1];
        if (isShow) {
            
            _button_delete = [UIButton buttonWithType:UIButtonTypeCustom];
            _button_delete.frame = CGRectMake(kScreenWidth - 12 -64, 12, 60, 132);
            [_button_delete setTitle:@"删除" forState:UIControlStateNormal];
            _button_delete.backgroundColor = [UIColor redColor];
            [self.contentView addSubview:_button_delete];

        }
        _view_background = [[UIView alloc] initWithFrame:CGRectMake(12, 12, kScreenWidth - 24, 132)];
        _view_background.backgroundColor = [UIColor whiteColor];
        _view_background.layer.cornerRadius = 4;
        _view_background.layer.shadowOpacity = .3;
        _view_background.layer.shadowRadius = 4;
        _view_background.layer.shadowColor = [UIColor blackColor].CGColor;
        _view_background.layer.shadowOffset = CGSizeMake(0, 2);
        [self.contentView addSubview:_view_background];
        
        _label_title = [[UILabel alloc] initWithFrame:CGRectMake(20, 6, kScreenWidth - 30, 36)];
        _label_title.font = [UIFont boldSystemFontOfSize:22];
        [_view_background addSubview:_label_title];
        
        _label_desc = [[UILabel alloc] initWithFrame:CGRectMake(18, 26, kScreenWidth - 50, 108)];
        _label_desc.numberOfLines = 0;
        [_view_background addSubview:_label_desc];
        
        CALayer *imageLayer = [CALayer layer];
        imageLayer.frame = CGRectMake(kScreenWidth - 60, 60, 30, 30);
        
        imageLayer.contents = (id)[UIImage imageNamed:@"右"].CGImage;
        [_view_background.layer addSublayer:imageLayer];
        
        

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
