//
//  LeftViewController.h
//  i YunWei
//
//  Created by 郝威斌 on 15/5/4.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import "SXABaseViewController.h"

@interface LeftViewController : SXABaseViewController <UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UITableView *tableView;

@end
