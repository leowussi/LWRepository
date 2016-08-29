//
//  OrderSummaryController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/20.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

@class OrderSummaryController;

@protocol OrderSummaryControllerDelegate <NSObject>

-(void)orderSummaryController:(OrderSummaryController*)ctrl changeText:(NSString*)changeText;

@end

@interface OrderSummaryController : UIViewController

//上一级控制器传过来的事先已经有的文本
@property (nonatomic,copy) NSString *summaryText;
/**
 *  工作日志对应的saleList模型
 */
@property (nonatomic,strong) ZYFSaleList *saleList;

@property (nonatomic,assign) id<OrderSummaryControllerDelegate> delegate;

//非待填写不能编辑，但可以查看
@property (nonatomic,assign) BOOL editable;



@end
