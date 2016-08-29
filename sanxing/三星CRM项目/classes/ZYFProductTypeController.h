//
//  ZYFProductTypeController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/9/30.
//  Copyright © 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZYFSaleList;

@interface ZYFProductTypeController : UITableViewController

@property (nonatomic,strong) ZYFSaleList *sale ;
@property (nonatomic,copy) void (^productType)(NSString *type);


@end
