//
//  GoodsViewController.m
//  telecom
//
//  Created by Sundear on 16/4/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "GoodsViewController.h"
#import "GoodsTableViewCell.h"
#import "GoodsModel.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "MBProgressHUD+MJ.h"
#import "DetailGoodsViewController.h"

@interface GoodsViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>{
    MJRefreshFooterView* m_refreshfooter;
    BOOL select;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *tableVview;
@property(nonatomic,assign)int wzStuatsId;
@property(nonatomic,copy)NSString *searchCondition;
@property(nonatomic,strong)UIView *BackView;
@end

@implementation GoodsViewController
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"物资借用记录列表";
    [self addNavigationRightButton:@"3_1.png"];
    [self SetSearchBarWithPlachTitle:@"请输入要搜索的物品名称或借用人"];
    self.tableVview = [[UITableView alloc]initWithFrame:RECT(0, 118, kScreenWidth, kScreenHeight-118) style:UITableViewStylePlain];
    self.tableVview.delegate= self;
    self.tableVview.dataSource = self;
    self.tableVview.rowHeight=158;
    [self.tableVview registerNib:[UINib nibWithNibName:@"GoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"GoodsTableViewCellID"];
    
    [self.view addSubview:self.tableVview];
//    [self httpSend:nil];
    
    m_refreshfooter = [[MJRefreshFooterView alloc] init];
    m_refreshfooter.delegate = self;
    m_refreshfooter.scrollView = self.tableVview;
    
    [self addFilterview];
    
}
-(void)addFilterview{
    NSArray *titleArray = @[@"未借出待审核",@"已借出"];
    self.BackView = [[UIView alloc]initWithFrame:RECT(kScreenWidth+100, 64, 100, 64)];
    self.BackView.backgroundColor = RGBCOLOR(244, 244, 244);
    for (int i = 0; i<titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.frame = RECT(0, 32*i, 100, 32);
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [self.BackView addSubview:btn];
    }
    [self.view addSubview:self.BackView];
    [self.view bringSubviewToFront:self.BackView];
}
-(void)rightAction{

    self.BackView.x==kScreenWidth-100 ? [UIView animateWithDuration:0.25 animations:^{
        self.BackView.x =kScreenWidth+100;
    }] :[UIView animateWithDuration:0.25 animations:^{
        self.BackView.x =kScreenWidth-100;
    }];
    
}
-(void)btnClick:(UIButton *)btn{
    if (btn.tag==0) {
        self.wzStuatsId = 3;
    }else{
        self.wzStuatsId = 1;
    }
    [self rightAction];
    [self httpSend:nil];
}


-(void)dealloc{
    [m_refreshfooter free];
    i = 0;
}
static int i = 1;
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    i++;
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    par[URL_TYPE] = @"wzResource/GetWZBorrowRecord";
    if (self.wzStuatsId) {
        par[@"wzStuatsId"] = @(self.wzStuatsId);
    }else{}
    if (self.searchCondition) {
        par[@"searchCondition"] = self.searchCondition;
    }else{}
    par[@"curPage"] = @(i);
    __weak typeof(self) WeakSelf = self;
    httpPOST2(par, ^(id result) {
        DLog(@"%@",result[@"list"]);
        [WeakSelf.dataArray addObjectsFromArray:[GoodsModel objectArrayWithKeyValuesArray:result[@"list"]]];
        [WeakSelf.tableVview reloadData];
        [m_refreshfooter endRefreshing];
    }, ^(id result) {
        [m_refreshfooter endRefreshing];
        i--;
    });
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.BackView.x == kScreenWidth-100) {
        [UIView animateWithDuration:0.25 animations:^{
            self.BackView.x =kScreenWidth+100;
        }];
    }
}
-(void)httpSend:(NSString *)resourceId{
    i=1;
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    par[URL_TYPE] = @"wzResource/GetWZBorrowRecord";
    if (self.wzStuatsId) {
        par[@"wzStuatsId"] = @(self.wzStuatsId);
    }else{}
    if (self.searchCondition) {
      par[@"searchCondition"] = self.searchCondition;
    }else{}
    __weak typeof(self) WeakSelf = self;
    httpPOST2(par, ^(id result) {
        DLLog(@"%@",result[@"list"]);
        [WeakSelf.dataArray removeAllObjects];
        [WeakSelf.dataArray addObjectsFromArray:[GoodsModel objectArrayWithKeyValuesArray:result[@"list"]]];
        [WeakSelf.tableVview reloadData];
    }, ^(id result) {
        [MBProgressHUD showError:@"请求失败"];
    });

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsTableViewCellID"];

    cell.model = self.dataArray[indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailGoodsViewController *vc = [[DetailGoodsViewController alloc]init];
    __weak typeof(self) weakSelf = self;
    vc.bolck  = ^{
        [weakSelf httpSend:nil];
    };
    vc.Model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)searchBtn{

        [self httpSend:nil];

}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.searchCondition=textField.text;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.searchCondition = textField.text;
    [self httpSend:self.searchCondition];
    return YES;
}
@end
