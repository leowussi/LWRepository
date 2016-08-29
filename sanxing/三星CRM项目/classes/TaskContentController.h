//
//  TaskContentController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/20.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

@interface TaskContentController : UITableViewController

@property (nonatomic,copy) NSString *type;

@property (nonatomic,assign)NSInteger indexRow;

@property (nonatomic,assign) NSInteger segmentIndex;

@end
