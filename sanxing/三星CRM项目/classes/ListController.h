//
//  ListController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/24.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListController : UITableViewController

@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,copy) NSString *titleString;

@property (nonatomic,strong ) NSArray *listData;



@end
