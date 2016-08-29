//
//  AddExpenseSubmitController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/16.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

@class AddExpenseSubmitController;
@protocol AddExpenseSubmitControllerDelegate <NSObject>

-(void)addExpenseSubmitController:(AddExpenseSubmitController*)ctrl isFinish:(BOOL)isFinish;

@end

@interface AddExpenseSubmitController : UITableViewController

//工作日志对应的saleList
@property (nonatomic,strong) ZYFSaleList *saleList ;

@property (nonatomic,assign) id<AddExpenseSubmitControllerDelegate> delegate;

@end
