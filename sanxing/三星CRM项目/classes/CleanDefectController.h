//
//  CleanDefectController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/20.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

/**
 *  消缺明细
 */
@interface CleanDefectController : UITableViewController

//任务内容的saleList
@property (nonatomic,strong) ZYFSaleList *saleList ;

@end
