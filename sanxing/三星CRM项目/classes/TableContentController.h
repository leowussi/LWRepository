//
//  TableContentController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/19.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

typedef NS_ENUM(NSInteger, TableContentType) {
    TableContentTypeNormal,
    TableContentTypeCreate
};

@interface TableContentController : UITableViewController

@property (nonatomic,strong) ZYFSaleList *tableSearchSaleList;

//类型有两种，一种是查看原有的()，一种是创建一个空的（createType）

@end
