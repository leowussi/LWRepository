//
//  MyRepairFaultListKB.m
//  telecom
//
//  Created by ZhongYun on 14-11-15.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#define pageSize  20

#import "MyRepairFaultListKB.h"
#import "MyRepairFaultDetailKB.h"
#import "MJRefresh.h"
#import "BackwardCheckController.h"
#import "FaultInfoCell2.h"

NSArray* testData(void);
@interface MyRepairFaultListKB ()<UITableViewDelegate, UITableViewDataSource, MJRefreshBaseViewDelegate, UISearchBarDelegate,FaultInfoCell2Delegate>
{
    UISearchBar* m_searchBar;
    UITableView* m_table;
    NSMutableArray* m_data;
    MJRefreshHeaderView * m_refreshHeader;
    MJRefreshFooterView * m_refreshFooter;
    
    UIView *_chooseInfoView;
    NSString *_urlString;
    BOOL _isHiden;
    
    //UILabel *_titleLabel;
    UIButton *_rightSecondBtn;
    
    int _curPage;
}
@end

@implementation MyRepairFaultListKB

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isHiden = YES;
    _curPage = 1;
    m_data = [[NSMutableArray alloc] init];
    
    m_searchBar = [[UISearchBar alloc] initWithFrame:RECT(0, 64, APP_W, NAV_H)];
    m_searchBar.delegate = self;
    m_searchBar.placeholder = @"请输入工单号";
    m_searchBar.translucent = YES;
    m_searchBar.keyboardType = UIKeyboardTypeDefault;
    m_searchBar.backgroundColor = [UIColor lightGrayColor];
    m_searchBar.hidden = YES;
    [self.view addSubview:m_searchBar];
    
    m_table = [[UITableView alloc] initWithFrame:RECT(0, 64, APP_W, (SCREEN_H-64)) style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = 130;
    m_table.delegate = self;
    m_table.dataSource = self;
    m_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:m_table];
    
    m_refreshHeader = [[MJRefreshHeaderView alloc] init];
    m_refreshHeader.delegate = self;
    m_refreshHeader.scrollView = m_table;
    
    m_refreshFooter = [[MJRefreshFooterView alloc] init];
    m_refreshFooter.delegate = self;
    m_refreshFooter.scrollView = m_table;
    
    [self setUpRightBarButton];
    [self createChooseInfoBtn];
    
    [self memorySelectedItem];
    
//    if (self.memoryUrlType == nil || [self.memoryUrlType isEqualToString:NW_GetRepairFault]) {
//        self.title = @"我的客保故障单";
//        _urlString = NW_GetRepairFault;
//        [self loadDataWithRequire:NW_GetRepairFault];
//    }
//    
//    if (self.memoryUrlType != nil && [self.memoryUrlType isEqualToString:AssiGetSharedFaultList]) {
//        self.title = @"我的共享故障单";
//        _urlString = AssiGetSharedFaultList;
//        [self loadDataWithRequire:AssiGetSharedFaultList];
//    }
}

- (void)memorySelectedItem
{
    if (self.memoryUrlType == nil || [self.memoryUrlType isEqualToString:NW_GetRepairFault]) {
        
        if (self.memoryFlagType == nil || [self.memoryFlagType isEqualToString:@"1"]) {
            self.title = @"我的客保故障单";
            _urlString = NW_GetRepairFault;
            [self loadDataWithRequire:NW_GetRepairFault flag:@"1" condition:nil];
        }
        
        if (self.memoryFlagType != nil && [self.memoryFlagType isEqualToString:@"2"]) {
            self.title = @"工位故障单";
            _urlString = NW_GetRepairFault;
            [self loadDataWithRequire:NW_GetRepairFault flag:@"2" condition:nil];
        }
        
    }
    
    if (self.memoryUrlType != nil && [self.memoryUrlType isEqualToString:AssiGetSharedFaultList]) {
        self.title = @"我的共享故障单";
        _urlString = AssiGetSharedFaultList;
        [self loadDataWithRequire:AssiGetSharedFaultList flag:nil condition:nil];
    }
    
    if (self.memoryUrlType != nil && [self.memoryUrlType isEqualToString:kGetHistoryFault]) {
        self.title = @"我的历史故障单";
        _urlString = kGetHistoryFault;
        [self loadDataWithRequire:kGetHistoryFault flag:nil condition:nil];
    }
}

#pragma mark - 右侧按钮
- (void)setUpRightBarButton
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"KBaddtionalAction.png"];
    self.rightBtn.frame = CGRectMake(APP_W-40, 7, image.size.width/1.2, image.size.height/1.2);
    [self.rightBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(ShowChooseInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    _rightSecondBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _rightSecondBtn.frame = RECT(APP_W-90, 7, 30, 30);
    [_rightSecondBtn setImage:[[UIImage imageNamed:@"search_btn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_rightSecondBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:_rightSecondBtn];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
}

#pragma mark - searchAction
- (void)searchAction
{
    [UIView animateWithDuration:0.3f animations:^{
        m_searchBar.hidden = NO;
        [m_searchBar becomeFirstResponder];
        [m_table setFrame:RECT(0, m_searchBar.ey, APP_W, (SCREEN_H-m_searchBar.ey))];
    }];
}

- (void)leftAction
{
//    if (self.delegate) {
//        [self.delegate deliverMemorySelectItem:self.urlType];
//    }
//    [self.navigationController popViewControllerAnimated:YES];
    
//    if (self.delegate) {
//        [self.delegate deliverMemorySelectItem:self.urlType urlFlag:self.flagType];
//    }//注销此行优先加载 我的客保故障单
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 选择项
- (void)createChooseInfoBtn
{
    _chooseInfoView = [[UIView alloc] initWithFrame:CGRectMake(APP_W, STATUS_H+NAV_H, 120, 150)];
    _chooseInfoView.backgroundColor = COLOR(239, 239, 239);
    _chooseInfoView.layer.borderWidth = 1;
    _chooseInfoView.layer.borderColor = COLOR(239, 239, 239).CGColor;
    [self.view addSubview:_chooseInfoView];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"我的客保故障单" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 120, 30);
    [btn1 addTarget:self action:@selector(KBFaultInfo:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 9000;
    [_chooseInfoView addSubview:btn1];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 120, 1)];
    lineView1.backgroundColor = [UIColor grayColor];
    lineView1.alpha = 0.5;
    [_chooseInfoView addSubview:lineView1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"我的共享故障单" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(0, 30, 120, 30);
    [btn2 addTarget:self action:@selector(shareFaultInfo:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 9001;
    [_chooseInfoView addSubview:btn2];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 120, 1)];
    lineView2.backgroundColor = [UIColor grayColor];
    lineView2.alpha = 0.5;
    [_chooseInfoView addSubview:lineView2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn3 setTitle:@"工位故障单" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.frame = CGRectMake(0, 60, 120, 30);
    [btn3 addTarget:self action:@selector(workerStationFaultInfo:) forControlEvents:UIControlEventTouchUpInside];
    btn3.tag = 9002;
    [_chooseInfoView addSubview:btn3];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 89, 120, 1)];
    lineView3.backgroundColor = [UIColor grayColor];
    lineView3.alpha = 0.5;
    [_chooseInfoView addSubview:lineView3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn4 setTitle:@"我的历史故障单" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn4.frame = CGRectMake(0, 90, 120, 30);
    [btn4 addTarget:self action:@selector(historyFaultInfo:) forControlEvents:UIControlEventTouchUpInside];
    btn4.tag = 9003;
    [_chooseInfoView addSubview:btn4];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 119, 120, 1)];
    lineView4.backgroundColor = [UIColor grayColor];
    
    [_chooseInfoView addSubview:lineView4];
    
    //增加售中工单
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn5 setTitle:@"售中业务开通" forState:UIControlStateNormal];
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn5.frame = CGRectMake(0, 120, 120, 30);
    [btn5 addTarget:self action:@selector(saleBusinessInfo:) forControlEvents:UIControlEventTouchUpInside];
    btn5.tag = 9004;
    [_chooseInfoView addSubview:btn5];
    UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 149, 120, 1)];
    lineView5.backgroundColor = [UIColor grayColor];
    lineView5.alpha = 0.5;
    [_chooseInfoView addSubview:lineView5];
    
    
}
#pragma mark - 售中业务开通
- (void)saleBusinessInfo:(UIButton *)saleBusinessBtn
{
    if (saleBusinessBtn.tag == 9004) {
        self.title = @"售中业务开通";
        [m_data removeAllObjects];
        _urlString = NW_GetRepairFault;
        [self loadDataWithRequire:NW_GetRepairFault flag:@"1" condition:nil];
        
        //收回选项卡
        UIView *superView = saleBusinessBtn.superview;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect tempFrame = superView.frame;
            tempFrame.origin.x = APP_W;
            superView.frame = tempFrame;
            _isHiden = YES;
        }];
    }

}

- (void)ShowChooseInfo:(UIButton *)senderBtn
{
    if (_isHiden == YES) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect tempFrame = _chooseInfoView.frame;
            tempFrame.origin.x = APP_W - 120;
            _chooseInfoView.frame = tempFrame;
        }];
        _isHiden = NO;
    }else{
        [UIView animateWithDuration:0.2 animations:^{
            CGRect tempFrame = _chooseInfoView.frame;
            tempFrame.origin.x = APP_W;
            _chooseInfoView.frame = tempFrame;
        }];
        _isHiden = YES;
    }
}

#pragma mark - 客保故障单
- (void)KBFaultInfo:(UIButton *)btn
{
    if (btn.tag == 9000) {
        self.title = @"我的客保故障单";
        [m_data removeAllObjects];
        _urlString = NW_GetRepairFault;
        [self loadDataWithRequire:NW_GetRepairFault flag:@"1" condition:nil];
        
        //收回选项卡
        UIView *superView = btn.superview;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect tempFrame = superView.frame;
            tempFrame.origin.x = APP_W;
            superView.frame = tempFrame;
            _isHiden = YES;
        }];
    }
}

#pragma mark - 共享故障单
- (void)shareFaultInfo:(UIButton *)btn
{
    if (btn.tag == 9001) {
        self.title = @"我的共享故障单";
        [m_data removeAllObjects];
        _urlString = AssiGetSharedFaultList;
        [self loadDataWithRequire:AssiGetSharedFaultList flag:nil condition:nil];
        
        //收回选项卡
        UIView *superView = btn.superview;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect tempFrame = superView.frame;
            tempFrame.origin.x = APP_W;
            superView.frame = tempFrame;
            _isHiden = YES;
        }];
    }
    
}

#pragma mark - 工位故障单
- (void)workerStationFaultInfo:(UIButton *)btn
{
    if (btn.tag == 9002) {
        self.title = @"工位故障单";
        [m_data removeAllObjects];
        _urlString = NW_GetRepairFault;
        [self loadDataWithRequire:NW_GetRepairFault flag:@"2" condition:nil];
        
        //收回选项卡
        UIView *superView = btn.superview;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect tempFrame = superView.frame;
            tempFrame.origin.x = APP_W;
            superView.frame = tempFrame;
            _isHiden = YES;
        }];
        
    }
}

#pragma mark - 历史故障单
- (void)historyFaultInfo:(UIButton *)btn
{
    if (btn.tag == 9003) {
        self.title = @"我的历史故障单";
        [m_data removeAllObjects];
        _urlString = kGetHistoryFault;
        [self loadDataWithRequire:kGetHistoryFault flag:nil condition:nil];
        
        //收回选项卡
        UIView *superView = btn.superview;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect tempFrame = superView.frame;
            tempFrame.origin.x = APP_W;
            superView.frame = tempFrame;
            _isHiden = YES;
        }];
        
    }
}

#pragma mark - 下载数据的方法
- (void)loadDataWithRequire:(NSString *)require flag:(NSString *)flag condition:(NSString *)condition//切换数据源
{
    self.urlType = require;
    self.flagType = flag;
    NSMutableDictionary *KBFaultInfoPara = [NSMutableDictionary dictionary];
    
    if ([require isEqualToString:NW_GetRepairFault]) {//NW_GetRepairFault工位故障单,我的客保故障单
        KBFaultInfoPara[URL_TYPE] = require;
        KBFaultInfoPara[@"startTime"] = @"";
        KBFaultInfoPara[@"endTime"] = @"";
        KBFaultInfoPara[@"flag"] = flag;
        if (condition != nil) {
            KBFaultInfoPara[@"condition"] = condition;
        }
        
    }else if([require isEqualToString:AssiGetSharedFaultList]){//AssiGetSharedFaultList我的共享故障单
        KBFaultInfoPara[URL_TYPE] = require;
        KBFaultInfoPara[@"userName"] = UGET(U_TOKEN);
        
    }else{//kGetHistoryFault我的历史故障单
        KBFaultInfoPara[URL_TYPE] = require;
        KBFaultInfoPara[@"startTime"] = @"";
        KBFaultInfoPara[@"endTime"] = @"";
        KBFaultInfoPara[@"curPage"] = @(1);
        KBFaultInfoPara[@"pageSize"] = @"20";
    }
    
    httpGET2(KBFaultInfoPara, ^(id result) {
        [m_data removeAllObjects];
        [m_data addObjectsFromArray:result[@"list"]];
        [m_table reloadData];
        [m_refreshHeader endRefreshing];
        [m_refreshFooter endRefreshing];
    }, ^(id result) {
        [m_table reloadData];
        showAlert(result[@"error"]);
        [m_refreshHeader endRefreshing];
        [m_refreshFooter endRefreshing];
    });
}

#pragma mark - 搜索的方法
- (void)loadDataWithRequire:(NSString *)require andSearchText:(NSString *)searchText
{
    if (searchText != nil && searchText.length>0) {
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = require;
        paraDict[@"userName"] = UGET(U_TOKEN);
        paraDict[@"condition"] = searchText;
        
        httpGET2(paraDict, ^(id result) {
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                [m_data removeAllObjects];
                [m_data addObjectsFromArray:result[@"list"]];
                [m_table reloadData];
            }
        }, ^(id result) {
            [m_table reloadData];
            showAlert(result[@"error"]);
        });
    }
}

#pragma mark - 历史故障单搜索的方法
- (void)loadDataWithRequire:(NSString *)require andSearchText:(NSString *)searchText curPage:(int)curPage size:(NSString *)size
{
    if (searchText != nil && searchText.length>0) {
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = require;
        paraDict[@"userName"] = UGET(U_TOKEN);
        paraDict[@"condition"] = searchText;
        paraDict[@"startTime"] = @"";
        paraDict[@"endTime"] = @"";
        paraDict[@"curPage"] = @(curPage);
        paraDict[@"pageSize"] = size;
        
        httpGET2(paraDict, ^(id result) {
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                [m_data removeAllObjects];
                [m_data addObjectsFromArray:result[@"list"]];
                [m_table reloadData];
            }
        }, ^(id result) {
            [m_table reloadData];
            showAlert(result[@"error"]);
        });
    }
}

#pragma mark - 刷新的方法
- (void)loadDataWithRequire:(NSString *)require pageNumber:(int)pageNumber size:(NSString *)size
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = require;
    paraDict[@"startTime"] = @"";
    paraDict[@"endTime"] = @"";
    paraDict[@"curPage"] = @(pageNumber);
    paraDict[@"pageSize"] = size;
    
    httpGET2(paraDict, ^(id result) {
        NSLog(@"%@",result);
        [m_data addObjectsFromArray:result[@"list"]];
        [m_table reloadData];
        [m_refreshHeader endRefreshing];
        [m_refreshFooter endRefreshing];
    }, ^(id result) {
        [m_table reloadData];
        showAlert(result[@"error"]);
        [m_refreshHeader endRefreshing];
        [m_refreshFooter endRefreshing];
    });
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    m_searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = NO;
    
    [m_data removeAllObjects];
    [m_table reloadData];
    
    if ([self.urlType isEqualToString:NW_GetRepairFault]){
        if ([self.flagType isEqualToString:@"1"]) {//客保故障单搜索
            [self loadDataWithRequire:NW_GetRepairFault flag:@"1" condition:m_searchBar.text];
        }else if ([self.flagType isEqualToString:@"2"]){//工位故障单搜索
            [self loadDataWithRequire:NW_GetRepairFault flag:@"2" condition:m_searchBar.text];
        }
    }
    
    if ([self.urlType isEqualToString:AssiGetSharedFaultList]) {//共享故障单搜索
        [self loadDataWithRequire:AssiGetSharedFaultList andSearchText:m_searchBar.text];
    }
    
//    if ([self.urlType isEqualToString:NW_GetRepairFault]){
//        [self loadDataWithRequire:NW_GetRepairFault andSearchText:m_searchBar.text];
//    }
//    
//    if ([self.urlType isEqualToString:AssiGetSharedFaultList]) {
//        [self loadDataWithRequire:AssiGetSharedFaultList andSearchText:m_searchBar.text];
//    }
}

//- (void)loadDataWithRequire:(NSString *)require andSearchText:(NSString *)searchText
//{
//    
//    if ([self.urlType isEqualToString:kGetHistoryFault]) {//历史故障单搜索
////        [self loadDataWithRequire:kGetHistoryFault andSearchText:m_searchBar.text];
//        [self loadDataWithRequire:kGetHistoryFault andSearchText:m_searchBar.text curPage:1 size:@"20"];
//    }
//}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = YES;
    m_searchBar.text = @"";
    [UIView animateWithDuration:0.3f animations:^{
        m_searchBar.hidden = YES;
        [m_table setFrame:RECT(0, 64, APP_W, (SCREEN_H-64))];
    }];
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
//    if ([self.urlType isEqualToString:NW_GetRepairFault]){
//        [self loadDataWithRequire:NW_GetRepairFault];
//    }
//    
//    if ([self.urlType isEqualToString:AssiGetSharedFaultList]) {
//        [self loadDataWithRequire:AssiGetSharedFaultList];
//    }
    
    if ([self.urlType isEqualToString:NW_GetRepairFault]){
        if ([self.flagType isEqualToString:@"1"]) {//客保故障单刷新
            [self loadDataWithRequire:NW_GetRepairFault flag:@"1" condition:m_searchBar.text];
        }else if ([self.flagType isEqualToString:@"2"]){//工位故障单刷新
            [self loadDataWithRequire:NW_GetRepairFault flag:@"2" condition:m_searchBar.text];
        }
    }
    
    if ([self.urlType isEqualToString:AssiGetSharedFaultList]) {//共享故障单刷新
        [self loadDataWithRequire:AssiGetSharedFaultList andSearchText:m_searchBar.text];
    }
    
    if ([self.urlType isEqualToString:kGetHistoryFault]) {//历史故障单刷新
//        [self loadDataWithRequire:kGetHistoryFault andSearchText:m_searchBar.text];
        _curPage++;
        [self loadDataWithRequire:kGetHistoryFault pageNumber:_curPage size:@"20"];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    
    NSDictionary *rowDict = m_data[indexPath.row];
    
    if ((self.memoryUrlType != nil && [self.memoryUrlType isEqualToString:kGetHistoryFault]) || [self.urlType isEqualToString:kGetHistoryFault])
    {
        if ([rowDict[@"canReview"] isEqualToString:@"1"]) {
            BackwardCheckController *backwardCheckCtrl = [[BackwardCheckController alloc] init];
            backwardCheckCtrl.orderNo = rowDict[@"orderNo"];
            backwardCheckCtrl.workNum = rowDict[@"workNo"];
            [self.navigationController pushViewController:backwardCheckCtrl animated:YES];
        }else{
            showAlert(@"此张故障单不支持逆向考评!");
        }
    }else{
        MyRepairFaultDetailKB * vc = [[MyRepairFaultDetailKB alloc] init];
        vc.workInfo = rowDict;
        vc.originalVc = self.urlType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (m_data.count == 0) {
        return 0;
    }
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (m_data.count == 0)  return nil;
    
    if (m_data.count > 0) {
        static NSString *reuseId = @"reuse";
        FaultInfoCell2 *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FaultInfoCell2" owner:self options:nil] firstObject];
        }
        cell.delegate = self;
        NSDictionary* dataRow = m_data[indexPath.row];
        [cell configFaultInfoCell:dataRow];
        return cell;
    }
    return nil;
}

- (void)showSharePersonInfoWithFaultInfoCell2:(UITapGestureRecognizer *)ges
{
    NSIndexPath *indexPath = [m_table indexPathForRowAtPoint:[ges locationInView:m_table]];
    NSDictionary* temp = m_data[indexPath.row];
    NSString *shareUser = [temp objectForKey:@"sharedUser"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"当前共享人员" message:shareUser delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
}

- (void)dealloc
{
    [m_refreshHeader free];
    [m_refreshFooter free];
}
@end