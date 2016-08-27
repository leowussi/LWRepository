//
//  YZRiskOpertionListTableViewCell.m
//  telecom
//
//  Created by 锋 on 16/6/20.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//
#define KeyArray @[@"orderNo",@"title",@"applyUserName",@"applyCompany",@"deptName",@"status",@"applyType",@"applySpec",@"kind",@"applyStartTime",@"applyEndTime",@"execStartTime",@"reason",@"range",@"isAffectSense",@"execUser",@"matchPerson",@"monitorPerson",@"remark"]
#define MoreKeyArray @[@"isAffectPublic",@"execUserTel",@"matchPersonTel",@"monitorPersonTel",@"cityName",@"equipRange",@"cusServiceAffect",@"rangeAndTime",@"isNeedCoop",@"coopDealTime",@"coopRequire",@"isNeedCoopTest",@"testRequire",@"gpsX",@"gpsY",@"costTime",@"difficultyLevel",@"personNum",@"score",@"skillRequire"]

#import "YZRiskOpertionListTableViewCell.h"
#import "Masonry.h"

@implementation YZRiskOpertionList

- (YZRiskOpertionList *)initWithParserWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        _riskId = NoNullStr([dict objectForKey:@"riskId"]);
        _applyStartTime = NoNullStr([dict objectForKey:@"applyStartTime"]);
        _applyEndTime = NoNullStr([dict objectForKey:@"applyEndTime"]);
        
        _workOrderId = NoNullStr([dict objectForKey:@"orderNo"]);
        _workNo = NoNullStr([dict objectForKey:@"workNo"]);
        _status = NoNullStr([dict objectForKey:@"status"]);
        _profession = NoNullStr([dict objectForKey:@"applySpec"]);
        _riskKind = NoNullStr([dict objectForKey:@"kind"]);
        _title = NoNullStr([dict objectForKey:@"title"]);
        _height_title = [self calculateTextHeight:_title textWidth:kScreenWidth - 24 textFont:[UIFont systemFontOfSize:15]] + 4;
        _showDetailArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < KeyArray.count; i++) {
            [_showDetailArray addObject:NoNullStr([dict objectForKey:KeyArray[i]])];
        }
        _showMoreArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < MoreKeyArray.count; i++) {
            NSString *obj = [dict objectForKey:MoreKeyArray[i]];
            
            [_showMoreArray addObject:NoNullStr(obj)];
        }
    }
    
    return self;
}

- (void)getDetailTextHeight
{
    _detailHeightArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *text in _showDetailArray) {
        CGFloat height = [self calculateTextHeight:text textWidth:kScreenWidth - 146 textFont:[UIFont systemFontOfSize:15]] + 8;
        height = height > 36 ? height : 36;
        [_detailHeightArray addObject:@(height)];
    }
    
    _moreHeightArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSString *text in _showMoreArray) {
        CGFloat height = [self calculateTextHeight:text textWidth:kScreenWidth - 146 textFont:[UIFont systemFontOfSize:15]] + 8;
        height = height > 36 ? height : 36;
        [_moreHeightArray addObject:@(height)];
    }

}

#pragma mark -- 计算文字的高度
- (CGFloat)calculateTextHeight:(NSString *)text textWidth:(CGFloat)width textFont:(UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return ceilf(rect.size.height);
}

@end

@implementation YZRiskOpertionListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _label_time = [[UILabel alloc] init];
        _label_time.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_label_time];

        _label_workOrderId = [[UILabel alloc] init];
        _label_workOrderId.font = [UIFont systemFontOfSize:15];
        _label_workOrderId.textColor = [UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1];
        [self.contentView addSubview:_label_workOrderId];
        
        _label_status = [[UILabel alloc] init];
        _label_status.font = [UIFont systemFontOfSize:15];
        _label_status.textColor = [UIColor colorWithRed:246/255.0 green:0/255.0 blue:78/255.0 alpha:1];
        [self.contentView addSubview:_label_status];

        _label_profession = [[UILabel alloc] init];
        _label_profession.font = [UIFont systemFontOfSize:15];
        _label_profession.textColor = [UIColor colorWithRed:252/255.0 green:193/255.0 blue:0/255.0 alpha:1];
        [self.contentView addSubview:_label_profession];

        _label_riskKind = [[UILabel alloc] init];
        _label_riskKind.font = [UIFont systemFontOfSize:15];
        _label_riskKind.textColor = [UIColor colorWithRed:95/255.0 green:196/255.0 blue:64/255.0 alpha:1];
        _label_riskKind.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_label_riskKind];

        _label_title = [[UILabel alloc] init];
        _label_title.font = [UIFont systemFontOfSize:15];
        _label_title.textColor = [UIColor grayColor];
        [self.contentView addSubview:_label_title];


        [_label_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(8);
            make.left.offset(10);
            make.height.offset(20);
            make.right.offset(-10);
        }];
        
        //工单编号和流程状态
        [_label_workOrderId mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_time.mas_bottom).offset(0);
            make.left.offset(10);
            make.height.offset(20);
            make.right.offset(-64);
        }];
        
        [_label_status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_time.mas_bottom).offset(0);
            make.width.offset(56);
            make.height.offset(20);
            make.right.offset(-10);
        }];

        //专业和风险分类
        [_label_riskKind mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_workOrderId.mas_bottom).offset(0);
            make.width.offset(120);
            make.height.offset(20);
            make.left.offset(kScreenWidth/2);
        }];
        
        [_label_profession mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_workOrderId.mas_bottom).offset(0);
            make.width.offset(120);
            make.height.offset(20);
            make.left.offset(10);
        }];

        
        //工单标题
        [_label_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.offset(-8);
            make.left.offset(8);
            make.height.offset(20);
            make.right.offset(-10);
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
