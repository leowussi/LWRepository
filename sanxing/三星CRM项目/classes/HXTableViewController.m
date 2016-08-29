//
//  HXTableViewController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/9/22.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "HXTableViewController.h"
#import "ZYFHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "CRMHelper.h"

@interface HXTableViewController ()<UISearchBarDelegate>

@end

@implementation HXTableViewController

- (void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    //头部添加搜索框
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kSystemScreenWidth, 44)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    self.serarchBar = searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏右上角的添加按钮
    [self setupRightButton];
    //下拉刷新
    [self addRefresh];
}

#pragma mark - 下拉刷新
-(void)addRefresh
{
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉获得更多信息"];
    [self.refreshControl beginRefreshing];
    [self.refreshControl addTarget:self action:@selector(getMoreDataByRefresh) forControlEvents:UIControlEventValueChanged];
}

- (void)getMoreDataByRefresh
{
    //子类实现方法，子类中实现该方法，用来实现下拉刷新
}

#pragma mark - 右上角加号按钮
- (void)setupRightButton
{
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add)];
    addItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addItem;
}
- (void)add
{
    //点击右上角加号按钮，创建一条新的(子类实现方法)
}

#pragma mark - <UISearchBarDelegate>
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //子类实现该方法，实现搜索功能
}



@end
