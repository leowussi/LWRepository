//
//  ExpenseTypeController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/16.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  派工费用类型
 */

@class ExpenseTypeController;

@protocol  ExpenseTypeControllerDelegate <NSObject>

-(void)expenseTypeController:(ExpenseTypeController*)ctrl key:(NSString*)keyString value:(NSString *)valueString;

@end

@interface ExpenseTypeController : UITableViewController

@property (nonatomic,assign) id<ExpenseTypeControllerDelegate> delegate;

@end
