//
//  YZAcceptanceListViewController.m
//  AcceptanceApplication
//
//  Created by 锋 on 16/5/16.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZAcceptanceListViewController.h"
#import "YZAcceptanceListTableViewCell.h"
#import "YZRemindListViewController.h"
#import "YZAcceptanceDetailViewController.h"
#import "MJRefresh.h"
#import "YZAcceptanceUnqualifiedViewController.h"
#import "StandardizeViewController.h"

@interface YZAcceptanceListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    CALayer *_selectedLineLayer;
    //底部的scrollView
    UIScrollView *_basicScrollView;
    
    NSMutableArray *_dataArray;
    
    //下拉刷新
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_refreshFooter;
    
    NSInteger _nextPage;
}
@end

@implementation YZAcceptanceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"验收清单";
    _nextPage = 1;
    [self createHeaderButton];
    [self createBasicScrollView];
    [self createTableView];
    [self mjRefresh];
    
    [self addNavigationLeftButton];
    
    
    //增加标准化手册按钮
    UIImage* Icon = [UIImage imageNamed:@"wenhao.png"];
    UIButton* commitBtn3 = [[UIButton alloc] initWithFrame:RECT(0, 0,30, 30)];
    [commitBtn3 setImage:[Icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    commitBtn3.titleLabel.font = FontB(Font3);
    [commitBtn3 addTarget:self action:@selector(standardize:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:commitBtn3];
    self.navigationItem.rightBarButtonItem = item3;
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAcceptanceList) name:@"updateAcceptanceList" object:nil];
}

//增加标准化手册
- (void)standardize:(UIButton *)btn
{
    StandardizeViewController *ctrl = [[StandardizeViewController alloc] init];
    NSString *urlStr = [[NSString stringWithFormat:@"http://%@/doc-app/doc/p/search.do?search.do?key=&and=工程现场验收",ADDR_IP] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    ctrl.request = request;
    [self.navigationController pushViewController:ctrl animated:YES];
}


- (void)updateAcceptanceList
{
    [_dataArray removeAllObjects];
    _nextPage = 1;
    [self loadDataWithNextPage:_nextPage pageSize:10];
}

- (void)dealloc
{
    [_refreshHeader free];
    [_refreshFooter free];
}
- (void)mjRefresh
{
    _refreshHeader = [MJRefreshHeaderView header];
    _refreshHeader.scrollView = _tableView;
    [_refreshHeader beginRefreshing];
    __weak YZAcceptanceListViewController *selfVC = self;
    __block NSInteger nextPage = _nextPage;
    _refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        nextPage = 1;
        [selfVC loadDataWithNextPage:nextPage pageSize:10];
    };
    
    
    _refreshFooter = [MJRefreshFooterView footer];
    _refreshFooter.scrollView = _tableView;
    _refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        nextPage ++;
        [selfVC loadDataWithNextPage:nextPage pageSize:10];
    };
    
}

- (void)loadDataWithNextPage:(NSInteger)next pageSize:(NSInteger)pageSize
{
    NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
    para1[URL_TYPE] = @"MyTask/WithWork/GetProjectCheckList";
    para1[@"curPage"] = [NSNumber numberWithInteger:next];
    para1[@"pageSize"] = [NSNumber numberWithInteger:pageSize];
    httpPOST(para1, ^(id result) {
        NSLog(@"%@",result);
        [_refreshHeader endRefreshing];
        [_refreshFooter endRefreshing];
        if (_dataArray == nil) {
            _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
            
        }
        if (next == 1) {
            [_dataArray removeAllObjects];
        }
        NSArray *listArray = [result objectForKey:@"list"];

        if (next == 1 && listArray.count == 0) {
            [self showAlertWithTitle:@"提示" :@"没有符合条件的数据" :@"确定" :nil];
        }else {
            for (NSDictionary *dict in listArray) {
                YZAcceptanceList *list = [[YZAcceptanceList alloc] initWithParserDictionary:dict];
                [_dataArray addObject:list];
            }

        }
        [_tableView reloadData];
    }, ^(id result) {
        if (next == 1) {
            [self showAlertWithTitle:@"提示" :[result objectForKey:@"error"] :@"确定" :nil];
        }
        
        [_refreshHeader endRefreshing];
        [_refreshFooter endRefreshing];
    });
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 107) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 154;
    _tableView.backgroundColor = [UIColor colorWithRed:235/255.0 green:238/255.0 blue:243/255.0 alpha:1];
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [_basicScrollView addSubview:_tableView];
    
}

- (void)createBasicScrollView
{
    _basicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 107, kScreenWidth, kScreenHeight - 107)];
    _basicScrollView.pagingEnabled = YES;
    _basicScrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - 107);
    _basicScrollView.directionalLockEnabled = YES;
    _basicScrollView.showsHorizontalScrollIndicator = NO;
    _basicScrollView.delegate = self;
    [self.view addSubview:_basicScrollView];
    
    YZRemindListViewController *remindListVC = [[YZRemindListViewController alloc] init];
    [self addChildViewController:remindListVC];
    remindListVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 107);
    [_basicScrollView addSubview:remindListVC.view];
}

- (void)createHeaderButton
{
    UIButton *acceptanceListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    acceptanceListButton.frame = CGRectMake(0, 64, kScreenWidth/2, 40);
    [acceptanceListButton setTitle:@"验收清单" forState:UIControlStateNormal];
    acceptanceListButton.selected = YES;
    [acceptanceListButton setTitleColor:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1] forState:UIControlStateNormal];
    [acceptanceListButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    acceptanceListButton.tag = 1;
    [acceptanceListButton addTarget:self action:@selector(listButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:acceptanceListButton];
    
    UIButton *remindListButton = [UIButton buttonWithType:UIButtonTypeCustom];
    remindListButton.frame = CGRectMake(kScreenWidth/2, 64, kScreenWidth/2, 40);
    [remindListButton setTitle:@"提醒清单" forState:UIControlStateNormal];
    [remindListButton setTitleColor:[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1] forState:UIControlStateNormal];
    [remindListButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    remindListButton.tag = 2;
    [remindListButton addTarget:self action:@selector(listButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:remindListButton];
    
    
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.frame = CGRectMake(0, 106, kScreenWidth, 1);
    lineLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:lineLayer];
    
    _selectedLineLayer = [[CALayer alloc] init];
    _selectedLineLayer.frame = CGRectMake(0, 104, kScreenWidth/2, 2);
    _selectedLineLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:_selectedLineLayer];
    
    
}
//按钮被点击
- (void)listButtonClicked:(UIButton *)sender
{
    
    if (sender.tag == 1) {
        UIButton *button = [self.view viewWithTag:2];
        button.selected = NO;
        _selectedLineLayer.frame = CGRectMake(0, 104, kScreenWidth/2, 2);
        [_basicScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.navigationItem.title = @"验收清单";
    }else{
        UIButton *button = [self.view viewWithTag:1];
        button.selected = NO;
        _selectedLineLayer.frame = CGRectMake(kScreenWidth/2, 104, kScreenWidth/2, 2);
        [_basicScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
        self.navigationItem.title = @"提醒清单";
    }
    sender.selected = YES;
}


#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZAcceptanceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YZAcceptanceListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" contianDeleteButton:NO];
    }
    YZAcceptanceList *list = [_dataArray objectAtIndex:indexPath.row];
    cell.label_title.text = list.string_projectname;
    [cell.label_desc setAttributedText:list.string_desc];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    YZAcceptanceList *list = _dataArray[indexPath.row];
    if ([list.checkResult isEqualToString:@"不合格"]) {
        YZAcceptanceUnqualifiedViewController *unqualifiedVC = [[YZAcceptanceUnqualifiedViewController alloc] init];
        unqualifiedVC.checkId = list.checkId;
        [self.navigationController pushViewController:unqualifiedVC animated:YES];
        return;
    }
    YZAcceptanceDetailViewController *detailVC = [[YZAcceptanceDetailViewController alloc] init];
    detailVC.checkId = list.checkId;
    [self.navigationController pushViewController:detailVC animated:YES];
}


#pragma mark -- scrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger number = scrollView.contentOffset.x/kScreenWidth;
    if (number == 0) {
        UIButton *selectedButton = [self.view viewWithTag:1];
        selectedButton.selected = YES;
        UIButton *button = [self.view viewWithTag:2];
        button.selected = NO;
        _selectedLineLayer.frame = CGRectMake(0, 104, kScreenWidth/2, 2);
        self.navigationItem.title = @"验收清单";
    }else{
        UIButton *selectedButton = [self.view viewWithTag:2];
        selectedButton.selected = YES;
        UIButton *button = [self.view viewWithTag:1];
        button.selected = NO;
        _selectedLineLayer.frame = CGRectMake(kScreenWidth/2, 104, kScreenWidth/2, 2);
        self.navigationItem.title = @"提醒清单";
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
