//
//  AddLogDetailController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

@class AddLogDetailController;

@protocol AddLogDetailControllerDelegate <NSObject>
/**
 *  判断工作明细创建是否完成
 *
 *  @param ctrl     控制器本身
 *  @param isFinish yes，表示创建完成，NO，表示创建失败
 */
-(void)addLogDetailController:(AddLogDetailController*)ctrl didFinishCreate:(BOOL)isFinish;

@end

@interface AddLogDetailController : UITableViewController
/**
 *  工作日志对应的saleList模型,not明细
 */
@property (nonatomic,strong) ZYFSaleList *saleList ;

@property (nonatomic,assign) id<AddLogDetailControllerDelegate> delegate;


@end
