//
//  AfterSalesController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "AfterSalesController.h"
#import "BusinessCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFSaleList.h"
#import "ZYFDisplayCols.h"
#import "WorkOrderController.h"
#import "ZYFUrl.h"
#import "CRMHelper.h"
#import "ZYFHttpTool.h"

//typedef enum {
//    string,   //字符串类型
//    lookup,   //lookup类型
//    picklist  //picklist类型
//} displayColType;

@interface AfterSalesController ()
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
 *  当前要显示的所有的字段的key
 */
@property (nonatomic,strong) NSArray *displayColsDictKeysArray;

/**
 *  当前要显示的所有的字段的value
 */
@property (nonatomic,strong) NSArray *displayColsDictValues;

/**
 *  工单
 */
@property (nonatomic,strong) NSArray *workList;


@end

@implementation AfterSalesController

- (void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    
    //        [self setSearchBar];
    [self setTitle:@"售后派工"];
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
    self.refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉获得更多工单"];
    [self.refreshControl beginRefreshing];
    [self.refreshControl addTarget:self action:@selector(getMoreData) forControlEvents:UIControlEventValueChanged];
}

-(void)getMoreData
{
    NSInteger page = 0;
    //如果当前已经请求过数据，那么把当前的page发给服务端
    if (self.data.count) {
        ZYFSaleList *sale = [self.data lastObject];
        page = sale.dispalyCols.page  + 1;
    }
    NSLog(@"page === %ld",page);
    [self getDataFromServer:page];
}

- (void)getDataFromServer:(NSInteger)page
{
    NSString *urlStr = kAfterSaleUrl;
    NSString *urlString = [NSString stringWithFormat:@"%@?page=%ld",urlStr,page];
    
    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id json) {
        NSMutableArray *mutableData = (NSMutableArray *)json;
        //判断本次请求得到的数据是否和已经请求得到的数据为同一条数据，如果为同一条，则不追加到模型数据中
        ZYFSaleList *nowSale = [mutableData lastObject];
        ZYFSaleList *oldSale = [self.oldData lastObject];

        if (nowSale.dispalyCols.page == oldSale.dispalyCols.page) {
            [self.refreshControl endRefreshing];
            return ;
        }
        
        [mutableData addObjectsFromArray:self.oldData];
        self.data = mutableData;
        self.oldData = self.data;
        
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.imageView.image = [UIImage imageNamed:@"common2.png"];
    UIDevice *device = [UIDevice currentDevice];
    
    if (tableView == self.tableView) {
        ZYFSaleList *sale = self.data[indexPath.row];
        for (int i = 0; i < sale.attrArray.count; i ++) {
            ZYFAttributes *attr = [sale.attrArray objectAtIndex:i];
            if ([attr.myKey isEqualToString:@"new_customer_service_work_order.new_name"]) {

                UIFont *textLabelFont = [UIFont systemFontOfSize:14];
                cell.textLabel.font = textLabelFont;
                cell.textLabel.text = [NSString stringWithFormat:@"工单: %@",attr.myValueString];
            }
            if ([attr.myKey isEqualToString:@"new_customer_service_work_order.new_address"]) {
                UIFont *detailFont = [UIFont systemFontOfSize:16];
                cell.detailTextLabel.font = detailFont;
                cell.detailTextLabel.textColor = [UIColor grayColor];
                cell.detailTextLabel.numberOfLines = 2;
                cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;

                cell.detailTextLabel.text = [NSString stringWithFormat:@"地址: %@",attr.myValueString];
            }
//            if ([attr.myKey isEqualToString:@"new_approvalstatus"]) {
//                //根据派工状态，来现实对应的颜色
//            }

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
        ZYFSaleList *sale = self.data[indexPath.row];
        WorkOrderController *workOrderCtrl = [[WorkOrderController alloc]init];
        workOrderCtrl.saleList = sale;
        [self.navigationController pushViewController:workOrderCtrl animated:YES];
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}





@end
