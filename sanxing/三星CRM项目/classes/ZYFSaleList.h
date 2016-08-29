//
//  ZYFSaleList.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/2.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYFDisplayCols.h"
#import "ZYFAttributes.h"
#import "ZYFFormattedValue.h"

/**
 *  工单，最大的模型（售后相关的数据都包含在该模型的内部）
 */
@class ZYFForm;
@class ZYFGroup;

//通知消息的状态
typedef NS_ENUM(NSInteger, MSGMessageState) {
    MSGMessageStateOpened, //打开
    MSGMessageStateClosed //关闭
};

@interface ZYFSaleList : NSObject <NSCoding>

@property (nonatomic,strong) NSArray *Attributes;
@property (nonatomic,strong) NSArray *FormattedValues;
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *LogicalName;

@property (nonatomic,strong) ZYFDisplayCols *dispalyCols;

//@property (nonatomic,strong) ZYFGroup *group;

//通知消息的状态
@property (nonatomic,assign) MSGMessageState msgState;

/**
 *  每次请求得到的数据的当前页数，用于每次刷新时，页数加1
 */
@property (nonatomic,assign) NSInteger page;
/**
 *  判断下拉刷新是否有新的数据
 */
@property (nonatomic,assign,getter=isMore) BOOL more;

/**
 *  解析得到的存储attr的模型的数组
 */
@property (nonatomic,strong) NSArray *attrArray;
@property (nonatomic,strong) NSArray *formatValueArray;
@property (nonatomic,strong) NSArray *groupArray;



-(instancetype)initWithDict:(NSDictionary*)dict displayCols:(ZYFDisplayCols*)displayCol;
+(instancetype)saleListWithDict:(NSDictionary*)dict displayCols:(ZYFDisplayCols*)displayCol;

-(instancetype)initWithDict:(NSDictionary*)dict groupArray:(NSArray *)groupArray;
+(instancetype)saleListWithDict:(NSDictionary*)dict groupArray:(NSArray*)groupArray;



@end
