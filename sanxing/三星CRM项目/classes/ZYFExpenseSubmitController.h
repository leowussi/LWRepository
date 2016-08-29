//
//  ZYFExpenseSubmitController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/16.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

@interface ZYFExpenseSubmitController : UITableViewController


/**
 *  费用登记的saleList
 */

@property (nonatomic,strong) ZYFSaleList *saleList ;

//非待填写不能编辑，但可以查看
@property (nonatomic,assign) BOOL editable;

@end
