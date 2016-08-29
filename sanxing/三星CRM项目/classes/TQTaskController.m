//
//  TQTaskController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/25.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "TQTaskController.h"
#import "BusinessCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFSaleList.h"
#import "ZYFDisplayCols.h"
#import "ZYFUrlTask.h"
#import "TaskContentController.h"


@interface TQTaskController ()
{
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}

/**
 *  要显示的数据
 */
@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,strong) NSArray *oldData;

/**
 *  工单
 */
@property (nonatomic,strong) NSArray *workList;


@end

@implementation TQTaskController



- (void)viewDidLoad {
    [super viewDidLoad];

    //        [self setSearchBar];
    [self setTitle:@"台区任务"];
    
    [self getDataFromServer:1];
    
    [self addRefresh];
}

-(NSMutableArray *)data
{
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}

-(void)addRefresh
{
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉获得更多任务"];
    [self.refreshControl beginRefreshing];
    
    [self.refreshControl addTarget:self action:@selector(getMoreData) forControlEvents:UIControlEventValueChanged];
    
}

-(void)getMoreData
{
    NSLog(@"%s,getMoreData",__func__);
    NSInteger page = 0;
    //如果当前已经请求过数据，那么把当前的page发给服务端
    if (self.data.count) {
        ZYFSaleList *sale = [self.data lastObject];
        page = sale.dispalyCols.page  + 1;
    }
    NSLog(@"page === %d",page);
    [self getDataFromServer:page];
}

- (void)getDataFromServer:(NSInteger)page
{
    //    [MBProgressHUD showMessage:nil toView:self.view ];
    
    AFHTTPRequestOperationManager *businessMgr = [AFHTTPRequestOperationManager manager];
    NSString *urlStr = kTaiQuTask;
    //台区的sale
    NSString *tqId = @"";
    for (ZYFAttributes *attr in self.TQSale.attrArray) {
        if ([attr.myKey isEqualToString:@"new_operation_tgid"]) {
            tqId = attr.lookUp.Id;
        }
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?page=%ld&new_operation_tgid=%@",urlStr,page,tqId];
    
    AFJSONRequestSerializer *afJsonRequestSerializer = [[AFJSONRequestSerializer alloc] init];
    [afJsonRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    businessMgr.requestSerializer = afJsonRequestSerializer;
    businessMgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [businessMgr GET:urlString parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves   error:nil];
                 
                 ZYFDisplayCols *displayCols = [ZYFDisplayCols displayColWithDict:dictionary];
                 
                 //判断本次请求得到的数据是否和已经请求得到的数据为同一条数据，如果为同一条，则不追加到模型数据中
                 ZYFSaleList *lastSale = [self.data lastObject];
                 if (displayCols.page == lastSale.dispalyCols.page) {
                     [self.refreshControl endRefreshing];
                     return ;
                 }
                 
                 // 2、解析Entity
                 NSArray *entityarray = dictionary[@"Entitys"];
                 
                 NSMutableArray *saleArray = [NSMutableArray array];
                 for (NSDictionary *dict in entityarray) {
                     //构造每个实体(Entity)的模型
                     ZYFSaleList *saleList = [ZYFSaleList saleListWithDict:dict displayCols:displayCols];
                     [saleArray addObject:saleList];
                     NSLog(@"%s,saleList=== %@",__func__,saleList.Id);
                 }
                 //                 [self.data addObject:saleArray];
                 //每次把新刷新的数据放在最上面
                 [saleArray addObjectsFromArray:self.oldData];
                 
                 self.data = saleArray;
                 self.oldData = self.data;
                 [self.refreshControl endRefreshing];
                 
                 [self.tableView reloadData];
                 
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [self.refreshControl endRefreshing];
                 
             }];
}

-(void)leftBtnClick
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    self.tableView.tableHeaderView = searchBar;
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.data.count;
    }else{
        //谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        filterData =  [[NSArray alloc] initWithArray:[self.data filteredArrayUsingPredicate:predicate]];
        return filterData.count;
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"mycell";
    BusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[BusinessCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    cell.imageView.image = [UIImage imageNamed:@"work_order.png"];
    
    if (tableView == self.tableView) {
        ZYFSaleList *sale = self.data[indexPath.row];
        for (int i = 0; i < sale.attrArray.count; i ++) {
            ZYFAttributes *attr = [sale.attrArray objectAtIndex:i];
            if ([attr.myKey isEqualToString:@"new_name"]) {
                cell.textLabel.text = [NSString stringWithFormat:@"工单: %@",attr.myValueString];
            }
            if ([attr.myKey isEqualToString:@"new_ammeter_install_position"]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"地址: %@",attr.myValueString];
            }
        }
        
    }else{
        cell.textLabel.text = filterData[indexPath.row];
        cell.detailTextLabel.text = filterData[indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        
//        ZYFSaleList *sale = self.data[indexPath.row];
        TaskContentController *taskCtrl = [[TaskContentController alloc]init];
        taskCtrl.indexRow = indexPath.row;
        [self.navigationController pushViewController:taskCtrl animated:YES];
    }else{
        
    }
}

@end
