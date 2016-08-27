//
//  YZWorkOrderList.h
//  telecom
//
//  Created by 锋 on 16/6/15.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZWorkOrderList : NSObject

//工单列表
@property (nonatomic, copy) NSString *workOrderName;
@property (nonatomic, copy) NSString *workOrderNums;
//记录cell的选中状态
@property (nonatomic, assign) BOOL cellSelected;


//工单详细列表
@property (nonatomic, copy) NSString *billId;
@property (nonatomic, copy) NSString *billNo;
@property (nonatomic, copy) NSMutableAttributedString *billContent;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) CGFloat height_billNo;
@property (nonatomic, assign) CGFloat height_billContent;

//工单类型id
@property (nonatomic, assign) NSInteger billTypeId;

- (instancetype)initWithWorkOrderName:(NSString *)orderName workOrderNums:(NSString *)count;

- (instancetype)initWithParserDictionary:(NSDictionary *)dict withFont:(UIFont *)font width:(CGFloat)width billTypeId:(NSInteger)typeId;

@end
