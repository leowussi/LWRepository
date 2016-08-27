//
//  ZiChanModel.h
//  telecom
//
//  Created by Sundear on 16/4/11.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZiChanModel : NSObject
/**
 *  "searchResult": "检索情况（0：记录条数正常   1：记录条数>20）",
 "assetsNumber": "主资产号",
 "assetDes": "资产描述",
 "manufacturerName": "资产制造商",
 "address": "地址",
 "mngDeptDes": "实物管理部门描述",
 "useDeptDes": "使用部门描述",
 "lei": "类",
 "xiang": "项",
 "mu": "目",
 "jie": "节"
 */
/**
*  检索情况（0：记录条数正常   1：记录条数>20）
*/
@property(nonatomic,copy)NSString *searchResult;
/**
 *  主资产号
 */
@property(nonatomic,copy)NSString *assetsNumber;
/**
*  资产描述
*/
@property(nonatomic,copy)NSString *assetDes;
/**
 *  资产制造商
 */
@property(nonatomic,copy)NSString *manufacturerName;
/**
 *  地址
 */
@property(nonatomic,copy)NSString *address;
/**
 *  实物管理部门描述
 */
@property(nonatomic,copy)NSString *mngDeptDes;
/**
 * 使用部门描述
 */
@property(nonatomic,copy)NSString *useDeptDes;
/**
 * 类
 */
@property(nonatomic,copy)NSString *lei;
/**
 * 项"
 */
@property(nonatomic,copy)NSString *xiang;
/**
 * 目"
 */
@property(nonatomic,copy)NSString *mu;
/**
 * 节"
 */
@property(nonatomic,copy)NSString *jie;

@end
