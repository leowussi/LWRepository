//
//  HXTableViewController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/9/22.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXTableViewController : UITableViewController

@property (nonatomic,weak) UISearchBar *serarchBar;

//searchBar的tap时的代理方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;

//下拉刷新时，会调用该接口
- (void)getMoreDataByRefresh;

//点击右上角加号按钮，创建一条新的
- (void)add;

@end
