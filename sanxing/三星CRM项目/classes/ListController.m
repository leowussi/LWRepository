//
//  ListController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/24.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ListController.h"
#import "ZYFHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFGroup.h"
#import "ZYFForm.h"
#import "ZYFSaleList.h"
#import "TableContentController.h"
#import "CRMHelper.h"
#import "SCNavTabBarController.h"
#import "ZYFRelateEntity.h"
#import "PopoverView.h"
#import "ZYFURLTableSearch.h"

@interface ListController () <UISearchBarDelegate>
{
    BOOL _isSearch;/**false,表示不是搜索请求；true是搜索请求*/
}

@property (nonatomic,strong ) NSArray *listOldData;

@property (nonatomic,weak) UIButton *rightButton;
//作为每次刚进入该页面时的url备份
@property (nonatomic,copy) NSString *baseUrlString;

@end

@implementation ListController

- (void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    //头部添加搜索框
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kSystemScreenWidth, 44)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isSearch = false;
    self.title = self.titleString;
    self.baseUrlString = self.urlString;
    //向服务器请求数据
    [self getDataFromServer:1];
    //导航栏右上角的条件筛选按钮
    [self setupMoreItem];
    //下拉刷新
    [self addRefresh];
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
    if (self.listData.count) {
        ZYFSaleList *sale = [self.listData lastObject];
        page = sale.page  + 1;
    }
    NSLog(@"page === %ld",page);
    [self getDataFromServer:page];
}

- (void)setupMoreItem
{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    [rightButton setTitle:@"更多选项" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.hidden = YES;
    self.rightButton = rightButton;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)rightButtonClicked:(UIButton *)sender
{
    CGPoint point = CGPointMake(sender.frame.origin.x + sender.frame.size.width/2, sender.frame.origin.y + sender.frame.size.height);
    if (self.listData.count > 0) {
        ZYFSaleList *anySale = [self.listData firstObject];
        ZYFGroup *anyGroup = [anySale.groupArray firstObject];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (ZYFRelateEntity *relate in anyGroup.relateEntityOfListArray) {
            NSString *title = relate.name;
            [titleArray addObject:title];
        }
        NSArray *titles = titleArray;

        PopoverView *pop = [[PopoverView alloc] initWithPoint:point titles:titles images:nil];
        pop.selectRowAtIndex = ^(NSInteger index){
            NSLog(@"select index:%ld", index);
            ZYFRelateEntity *relate = anyGroup.relateEntityOfListArray[index];
            NSString *urlString = [NSString stringWithFormat:@"%@?formxml=%@",kTableSearchMain,relate.formxml];
            self.urlString = urlString;
            self.listData = nil;
            self.listOldData = nil;
            [self getDataFromServer:1];
        };
        [pop show];
    }

}
//获取更多选项的title数组
- (NSArray *)getMoreItemTitleArray
{
    if (self.listData.count > 0) {
        ZYFSaleList *anySale = [self.listData firstObject];
        ZYFGroup *anyGroup = [anySale.groupArray firstObject];
        NSMutableArray *titleArray = [NSMutableArray array];
        for (ZYFRelateEntity *relate in anyGroup.relateEntityOfListArray) {
            NSString *title = relate.name;
            [titleArray addObject:title];
        }
        return (NSArray*)titleArray;
    }else{
        return nil;
    }
}

- (void)getDataFromServer:(NSInteger)page
{
    if (page == 0) {
        page = 1;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@&page=%ld",self.urlString,page];
    [ZYFHttpTool getWithURLCacheXML:urlString params:nil success:^(id json) {
        NSMutableArray *mutableData = (NSMutableArray *)json;
        if (mutableData.count == 0) {
            if (_isSearch) {
                [MBProgressHUD showError:@"没有搜索到相关数据"];
                self.listData = nil;
                [self.tableView reloadData];
            }else{
                
            }
            _isSearch = NO;
        }

        //1、判断本次请求得到的数据是否和已经请求得到的数据为同一条数据，如果为同一条，则不追加到模型数据中
        ZYFSaleList *nowSale = [mutableData lastObject];
        ZYFSaleList *oldSale = [self.listOldData lastObject];
        
        if (nowSale.page == oldSale.page) {
//            [MBProgressHUD showError:@"没有更多的可用数据"];
            [self.refreshControl endRefreshing];
            return ;
        }
        
        [mutableData addObjectsFromArray:self.listOldData];
        self.listData = mutableData;
        self.listOldData = self.listData;
        
        [self.refreshControl endRefreshing];
        
        //2、判断更多选项中有没有数据,如果没有数据，将更多选项按钮隐藏
        NSArray *titleArray = [self getMoreItemTitleArray];
        if (titleArray.count == 0) {
            self.rightButton.hidden = YES;
        }else{
            self.rightButton.hidden = NO;
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];

    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"listControllerCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    ZYFSaleList *sale = self.listData[indexPath.row];
    //list类型数据只有一个组
    ZYFGroup *group = [sale.groupArray firstObject];
    
    for (ZYFAttributes *attr in sale.attrArray) {
        if ([attr.myKey isEqualToString:group.leftList]) {
            cell.textLabel.text = [self getCellTextWithZYFAttribute:attr];
        }else if ([attr.myKey isEqualToString:group.rightList]){
            cell.detailTextLabel.text = [self getCellTextWithZYFAttribute:attr];
        }
    }
    NSLog(@"cell.text=%@",cell.textLabel.text);
    
    return cell;
}

- (NSString *)getCellTextWithZYFAttribute:(ZYFAttributes*)attr
{
    if ( ! attr.myKey) {
        return @"attr.mykey======nil";
    }
    if (attr.myValueString) {
        return attr.myValueString;
    }else if (attr.lookUp){
        return attr.lookUp.Name;
    }else if (attr.pickList){
        return attr.pickList.value;
    }else{
        return @"一个不在预料范围内的值";
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableContentController *ctrl = [[TableContentController alloc]init];
    ZYFSaleList *sale = [[ZYFSaleList alloc]init];
    if (indexPath.row <= self.listData.count - 1) {
        sale = [self.listData objectAtIndex:indexPath.row];
    }
    
    ctrl.tableSearchSaleList = sale;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - <UISearchBarDelegate>
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchText = searchBar.text;
    //搜索的接口
    self.urlString = [NSString stringWithFormat:@"%@&value=%@",self.baseUrlString,searchText];
    //防止url中包含中文时会报错
    self.urlString = [self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.listData = nil;
    self.listOldData = nil;
    _isSearch = YES;
    [self getDataFromServer:1];
}



@end
