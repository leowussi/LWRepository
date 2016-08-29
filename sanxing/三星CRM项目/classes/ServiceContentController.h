//
//  ServiceContentController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/12.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

@class ServiceContentController;
@protocol ServiceContentControllerDelegate <NSObject>

/**
 *  服务内容代理
 *
 *  @param ctrl         控制器
 *  @param rowString    服务内容文本
 *  @param serviceIntro 服务说明文本
 *  @param isNum        实际数量是否可编辑
 */
-(void)serviceContentController:(ServiceContentController*) ctrl didSelectedRow:(NSString *)rowString serviceIntro:(NSString *)serviceIntro isNum:(BOOL)isNum;
/**
 *  把当前控制前对应的saleList传出去
 *
 *  @param ctrl     控制器
 *  @param saleList 当前工作内容的saleList
 */

@optional
-(void)serviceContentController:(ServiceContentController*) ctrl saleList:(ZYFSaleList*)saleList;


@end

@interface ServiceContentController : UITableViewController

/**
 *  工作日志的数据，但不是工作日志明细(logdetails)的数据,
 */
@property (nonatomic,strong) ZYFSaleList *sale ;

@property (nonatomic,assign) id<ServiceContentControllerDelegate> delegate;

@property (nonatomic,copy) NSString *selectedString;
@property (nonatomic,assign,getter=isShowCheckmark) BOOL *showCheckmark;


@end
