//
//  AddDelayController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/22.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

@class ZYFDelayApplyController;
@protocol ZYFDelayApplyControllerDelegate <NSObject>

-(void)delayApplyController:(ZYFDelayApplyController*)ctrl isFinished:(BOOL)isFinish;

@end
@interface AddDelayController : UITableViewController
@property (nonatomic,strong) ZYFSaleList *saleList ;
@property (nonatomic,assign) id<ZYFDelayApplyControllerDelegate> delegate;

@end
