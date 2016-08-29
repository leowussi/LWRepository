//
//  HandleResultController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/25.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HandleResultController;

@protocol  HandleResultControllerDelegate <NSObject>

-(void)handleResultController:(HandleResultController*)ctrl key:(NSString*)keyString value:(NSString *)valueString;

@end



@interface HandleResultController : UITableViewController

@property (nonatomic,assign) id<HandleResultControllerDelegate> delegate;


@end
