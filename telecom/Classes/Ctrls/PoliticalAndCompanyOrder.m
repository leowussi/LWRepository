//
//  PoliticalAndCompanyOrder.m
//  telecom
//
//  Created by SD0025A on 16/3/30.
//  Copyright © 2016年 ZhongYun. All rights reserved.


#import "PoliticalAndCompanyOrder.h"
#import "PoliticalAndCompanySelledFaultDetail.h"
#import "MJRefresh.h"
#import "PoliticalAndCompanyOrderCell.h"
#import "PoliticalAndCompanyOrderModel.h"
#import "PoliticalAndCompanySelledFaultCell.h"
#import "PoliticalAndCompanySelledFaultModel.h"

#import "PoliticalAndCompanyOrderDetail.h"
#define SellingFault   @"Medium/sellingOrderList"//售中业务
#define SelledFault    @"Trouble/SaleTroubleList"//售后故障单
@interface PoliticalAndCompanyOrder ()<UITableViewDataSource,UITableViewDelegate>
{
//    BOOL _isHiden;//_chooseInfoView是否显示
//    NSInteger _curPage;
//    
//    UISearchBar *m_searchBar;
//    //搜索按钮
//    UIButton *_searchBtn;
//    //选择项
//    UIView *_chooseInfoView;
    
}
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *m_table;
@end
//政企工单控制器
@implementation PoliticalAndCompanyOrder

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    //[self createChooseInfoBtn];
   // [self setUpRightBarButton];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downloadData];
}
- (void)downloadData
{
    [self.dataArray removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[URL_TYPE] = self.urlType;
    param[@"workNo"] = @"";
    httpGET2(param, ^(id result) {
        if ([self.urlType isEqualToString:SellingFault]) {
            //政企业务开通
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary  *)result;
                NSArray *array = dict[@"return_data"];
                self.dataArray = [PoliticalAndCompanyOrderModel arrayOfModelsFromDictionaries:array error:nil];
                }
                [self.m_table reloadData];
            }else if ([self.urlType isEqualToString:SelledFault]){
            //售后故障单
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)result;
                NSArray *array = dict[@"return_data"];
                self.dataArray = [PoliticalAndCompanySelledFaultModel arrayOfModelsFromDictionaries:array error:nil];
                [self.m_table reloadData];
            }
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    
}
//懒加载数据源数组
- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

//显示导航条
- (void)createUI
{
    if ([self.urlType isEqualToString:SelledFault]) {
        self.title = @"我的售后工单";
    }else{
        self.title = @"售中业务开通";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    _isHiden = YES;
//    _curPage = 1;
//    m_searchBar = [[UISearchBar alloc] initWithFrame:RECT(0, 64, APP_W, NAV_H)];
//    m_searchBar.delegate = self;
//    m_searchBar.placeholder = @"请输入工单号";
//    m_searchBar.translucent = YES;
//    m_searchBar.keyboardType = UIKeyboardTypeDefault;
//    m_searchBar.backgroundColor = [UIColor lightGrayColor];
//    m_searchBar.hidden = YES;
//    [self.view addSubview:m_searchBar];
    
    self. m_table = [[UITableView alloc] initWithFrame:RECT(0, 64, APP_W, (SCREEN_H-64)) style:UITableViewStylePlain];
    self.m_table.backgroundColor = [UIColor whiteColor];
    self.m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.m_table.bounces = YES;
    self.m_table.rowHeight = 130;
    self.m_table.delegate = self;
    self.m_table.dataSource = self;
    self.m_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.m_table.separatorColor = [UIColor whiteColor];
    [self.view addSubview:self. m_table];
    
}
#pragma mark - 选择视图
//- (void)createChooseInfoBtn
//{
//    _chooseInfoView = [[UIView alloc] initWithFrame:CGRectMake(APP_W, STATUS_H+NAV_H, 120, 60)];
//    _chooseInfoView.backgroundColor = COLOR(239, 239, 239);
//    _chooseInfoView.layer.borderWidth = 1;
//    _chooseInfoView.layer.borderColor = COLOR(239, 239, 239).CGColor;
//    [self.view addSubview:_chooseInfoView];
//    
//    UIButton *sellingBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [sellingBtn setTitle:@"售中业务开通" forState:UIControlStateNormal];
//    [sellingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    sellingBtn.frame = CGRectMake(0, 0, 120, 30);
//    [sellingBtn addTarget:self action:@selector(sellingAction:) forControlEvents:UIControlEventTouchUpInside];
//    sellingBtn.tag = 9000;
//    [_chooseInfoView addSubview:sellingBtn];
//    
//    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 120, 1)];
//    lineView1.backgroundColor = [UIColor grayColor];
//    lineView1.alpha = 0.5;
//    [_chooseInfoView addSubview:lineView1];
//    
//    UIButton *selledBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    [selledBtn setTitle:@"售后故障单" forState:UIControlStateNormal];
//    [selledBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    selledBtn.frame = CGRectMake(0, 30, 120, 30);
//    [selledBtn addTarget:self action:@selector(selledAction:) forControlEvents:UIControlEventTouchUpInside];
//    selledBtn.tag = 9001;
//    [_chooseInfoView addSubview:selledBtn];
//    
//    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 120, 1)];
//    lineView2.backgroundColor = [UIColor grayColor];
//    lineView2.alpha = 0.5;
//    [_chooseInfoView addSubview:lineView2];
//    
//}
////售中业务开通
//- (void)sellingAction:(UIButton *)btn
//{
//    [UIView animateWithDuration:0.2 animations:^{
//        CGRect tempFrame = _chooseInfoView.frame;
//        tempFrame.origin.x = APP_W;
//        _chooseInfoView.frame = tempFrame;
//    }];
//    _isHiden = YES;
//    self.navigationItem.title = @"我的售中工单";
//    self.urlType = SellingFault;
//    [self downloadData];
//}
////售后故障单
//- (void)selledAction:(UIButton *)btn
//{
//    [UIView animateWithDuration:0.2 animations:^{
//        CGRect tempFrame = _chooseInfoView.frame;
//        tempFrame.origin.x = APP_W ;
//        _chooseInfoView.frame = tempFrame;
//        _isHiden = YES;
//    }];
//    self.navigationItem.title = @"我的售后工单";
//    self.urlType = SelledFault;
//    [self downloadData];
//}
//#pragma mark - 右侧按钮
//- (void)setUpRightBarButton
//{
//    // 信封按钮
//    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    UIImage *image = [UIImage imageNamed:@"KBaddtionalAction.png"];
//    self.rightBtn.frame = CGRectMake(APP_W-40, 7, image.size.width/1.2, image.size.height/1.2);
//    [self.rightBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [self.rightBtn addTarget:self action:@selector(ShowChooseInfo:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    //搜索按钮
//    _searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    _searchBtn.frame = RECT(APP_W-90, 7, 30, 30);
//    [_searchBtn setImage:[[UIImage imageNamed:@"search_btn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
//    [_searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:_searchBtn];
    
//    self.navigationItem.rightBarButtonItem = item1;
//}
//信封按钮的显示和隐藏
//- (void)ShowChooseInfo:(UIButton *)senderBtn
//{
//    if (_isHiden == YES) {
//        [UIView animateWithDuration:0.2 animations:^{
//            CGRect tempFrame = _chooseInfoView.frame;
//            tempFrame.origin.x = APP_W - 120;
//            _chooseInfoView.frame = tempFrame;
//        }];
//        _isHiden = NO;
//    }else{
//        [UIView animateWithDuration:0.2 animations:^{
//            CGRect tempFrame = _chooseInfoView.frame;
//            tempFrame.origin.x = APP_W;
//            _chooseInfoView.frame = tempFrame;
//        }];
//        _isHiden = YES;
//    }
//}
//#pragma mark - searchAction 搜索
//- (void)searchAction
//{
//    [UIView animateWithDuration:0.3f animations:^{
//        m_searchBar.hidden = NO;
//        [m_searchBar becomeFirstResponder];
//        [self. m_table setFrame:RECT(0, m_searchBar.ey, APP_W, (SCREEN_H-m_searchBar.ey))];
//    }];
//}

#pragma mark - UITableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.urlType isEqualToString:SellingFault]) {
        static NSString *cellId = @"politicalAndCompanyOrder";
        PoliticalAndCompanyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PoliticalAndCompanyOrderCell" owner:self options:nil]firstObject];
        }
        PoliticalAndCompanyOrderModel *model = self.dataArray[indexPath.row];
        [cell configModel:model];
        return cell;
    }else if ([self.urlType isEqualToString:SelledFault]){
        static NSString *cellId = @"politicalAndCompanySelledFaultCell";
        PoliticalAndCompanySelledFaultCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"PoliticalAndCompanySelledFaultCell" owner:self options:nil]firstObject];
        }
        PoliticalAndCompanySelledFaultModel *model = self.dataArray[indexPath.row];
        [cell configModel:model];
        return cell;
    }else{
        return nil;
    }
}
//选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.urlType  isEqualToString:SellingFault]) {
        PoliticalAndCompanyOrderDetail *deatail = [[PoliticalAndCompanyOrderDetail alloc] init];
        PoliticalAndCompanyOrderModel *model = self.dataArray[indexPath.row];
        deatail.workNo = model.workNo;
        deatail.orderNO = model.orderNo;
        
        [self.navigationController pushViewController:deatail animated:YES];
    }else if ([self.urlType isEqualToString:SelledFault]){
        PoliticalAndCompanySelledFaultDetail *detail = [[PoliticalAndCompanySelledFaultDetail alloc] init];
        PoliticalAndCompanySelledFaultModel *model = self.dataArray[indexPath.row];
        detail.workNo = model.workNo;
        detail.orderNO = model.orderNo;
        
        [self.navigationController pushViewController:detail animated:YES];
    }
}
//#pragma mark - UISearchBar代理方法
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    m_searchBar.showsCancelButton = YES;
//    return YES;
//}
//
//- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
//{
//    [m_searchBar resignFirstResponder];
//    m_searchBar.showsCancelButton = NO;
//    return YES;
//}
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    
//}
//- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
//{
//    [m_searchBar resignFirstResponder];
//    m_searchBar.showsCancelButton = YES;
//    m_searchBar.text = @"";
//    [UIView animateWithDuration:0.3f animations:^{
//        m_searchBar.hidden = YES;
//        [self. m_table setFrame:RECT(0, 64, APP_W, (SCREEN_H-64))];
//    }];
//}

@end
