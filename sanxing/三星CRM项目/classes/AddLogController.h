//
//  AddLogController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/7.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

@class AddLogController;

@protocol AddLogControllerDelegate <NSObject>

-(void)addLogController:(AddLogController*)ctrl isFinished:(BOOL)isFinished;

@end

@interface AddLogController : UITableViewController

/**
 *  工作日志对应的saleList模型
 */
@property (nonatomic,strong) ZYFSaleList *saleList ;

@property (nonatomic,assign) id<AddLogControllerDelegate> delegate;

@end
