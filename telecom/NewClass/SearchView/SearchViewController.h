//
//  SearchViewController.h
//  telecom
//
//  Created by 郝威斌 on 15/5/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@interface SearchViewController : SXABaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)UITableView *historyTableView;
@property(strong,nonatomic)UITableView *searchTableView;

@end
