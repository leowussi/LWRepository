//
//  ProblemsController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/1.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProblemsController;

@protocol  ProblemsControllerDelegate <NSObject>

-(void)problemsController:(ProblemsController*)ctrl key:(NSString*)keyString value:(NSString *)valueString;

@end

@interface ProblemsController : UITableViewController

//大类，yes，   小类，no
@property (nonatomic,assign) BOOL isBigType;

@property (nonatomic,assign) id<ProblemsControllerDelegate> delegate;


@end
