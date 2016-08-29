//
//  AssignStatusController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AssignStatusController;

@protocol AssignStatusControllerDelegate <NSObject>

-(void)assignStatusController:(AssignStatusController*)ctrl status:(NSArray*)statusArray;

@end

@interface AssignStatusController : UITableViewController

@property (nonatomic,assign) id<AssignStatusControllerDelegate> delegate;

@end
