//
//  LogsController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ZYFSaleList.h"

@interface LogsController : UITableViewController

/**
 *  派工单的saleList
 */
@property (nonatomic,strong) ZYFSaleList *saleList;

@property (nonatomic,strong) NSArray *logsData;


@end
