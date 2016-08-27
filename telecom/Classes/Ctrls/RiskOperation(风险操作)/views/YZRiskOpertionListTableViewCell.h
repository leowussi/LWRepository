//
//  YZRiskOpertionListTableViewCell.h
//  telecom
//
//  Created by 锋 on 16/6/20.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZRiskOpertionListTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *label_time;

@property (nonatomic, strong) UILabel *label_status;
@property (nonatomic, strong) UILabel *label_workOrderId;

@property (nonatomic, strong) UILabel *label_profession;
@property (nonatomic, strong) UILabel *label_riskKind;

@property (nonatomic, strong) UILabel *label_title;


@end

@interface YZRiskOpertionList : NSObject

//工单id
@property (nonatomic, copy) NSString *riskId;
//工单流水号
@property (nonatomic, copy) NSString *workNo;

@property (nonatomic, copy) NSString *applyStartTime;
@property (nonatomic, copy) NSString *applyEndTime;
@property (nonatomic, copy) NSString *status;
//工单编号
@property (nonatomic, copy) NSString *workOrderId;

@property (nonatomic, copy) NSString *profession;
@property (nonatomic, copy) NSString *riskKind;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) CGFloat height_title;
//显示的字段数组
@property (nonatomic, strong) NSMutableArray *showDetailArray;
@property (nonatomic, strong) NSMutableArray *showMoreArray;
//字段高度
@property (nonatomic, strong) NSMutableArray *detailHeightArray;
@property (nonatomic, strong) NSMutableArray *moreHeightArray;

- (void)getDetailTextHeight;



- (YZRiskOpertionList *)initWithParserWithDictionary:(NSDictionary *)dict;

@end