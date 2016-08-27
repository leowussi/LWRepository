//
//  GoodsModel.h
//  telecom
//
//  Created by Sundear on 16/4/6.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

-(instancetype)initWithDic:(NSDictionary *)dict;
/**
 *  resourceId”： “物资类型”
 */
@property(nonatomic,strong)NSString *wzType;
/**
*  resourceId”： “物资主键ID”
*/
@property(nonatomic,strong)NSString *resourceId;
/**
 *  物资名称”
 */
@property(nonatomic,strong)NSString *wzName;
/**
 *  物资状态ID”
 */
@property(nonatomic,strong)NSString *wzStuatsId;
/**
 *  物资状态”
 */
@property(nonatomic,strong)NSString *wzStuats;
/**
 *  物资管理员
 */
@property(nonatomic,strong)NSString *wzManager;
/**
 *  编码
 */
@property(nonatomic,strong)NSString *wzCode;
/**
 *  物品备注
 */
@property(nonatomic,strong)NSString *wzRemark;
/**
 *  “借用人
 */
@property(nonatomic,strong)NSString *borrowPerson;
/**
 *  借用日期
 */
@property(nonatomic,strong)NSString *borrowDate;
/**
 *  联系人
 */
@property(nonatomic,strong)NSString *contactWay;

/**
 *   “department” ：“借用人部门”，
 */

@property(nonatomic,strong)NSString *department;
/**
 “remark” ：“备注
 */
@property(nonatomic,strong)NSString *remark;
/**
 *  申请id
 */
@property(nonatomic,strong)NSString *applyId;
/**
 *  管理员id
 */
@property(nonatomic,strong)NSString *userId;
/**
 *  申请状态id
 */
@property(nonatomic,strong)NSString *wzApplyStuatsId;
/**
 *  resourceId”： “物资主键ID”，
 “wzName”：“物资名称”，	“wzStuatsId”：“物资状态ID”，
 “wzStuats”: ”物资状态”，
 “wzManager”:”物资管理员”，
 “wzCode”：	“编码	”	，
 “wzRemark”：“物品备注”,
 
 “borrowPerson“ ：“借用人”，
 “borrowDate“：“借用日期”，
 “contactWay“：“联系人”，
 “department” ：“借用人部门”，
 “remark” ：“备注
 */
@end
