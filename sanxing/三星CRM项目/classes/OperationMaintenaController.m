//
//  OperationMaintenaController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/16.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "OperationMaintenaController.h"

#import "BusinessCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFSaleList.h"
#import "ZYFDisplayCols.h"
#import "ZYFUrlTask.h"
#import "TaskContentController.h"
#import "ZYFHttpTool.h"


@interface OperationMaintenaController ()
{
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}

/**
 *  要显示的数据
 */
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSArray *oldData;

//记录当前所选中的segment中的index
@property (nonatomic,assign) NSInteger segmentIndex;

@property (nonatomic,copy) NSMutableString *detailString;


@end

@implementation OperationMaintenaController



- (void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"集抄",@"台区",@"公专变"]];
    segment.tintColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    
    //默认选中集中器
    segment.selectedSegmentIndex = 0;
    [self segmentChanged:segment];
    
    self.navigationItem.titleView = segment;
    [self getDataFromServer:1 url:kMainTaskMuster];
    [self addRefresh];
}

-(void)segmentChanged:(UISegmentedControl*) segment
{
    NSInteger index = segment.selectedSegmentIndex;
    self.segmentIndex = index;
    self.data = nil;
    self.oldData = nil;
    
    NSString *urlStr = [self getUrlWithIndex:index];
    [self getDataFromServer:1 url:urlStr];
    
}

-(NSString *)getUrlWithIndex:(NSInteger)index
{
    NSString *urlStr = @"";
    //每次更改，先清空当前界面的数据，再等待请求
    if (self.segmentIndex == index) {

    }else{
        self.data = nil;
        self.oldData = nil;
    }

    [self.tableView reloadData];
    switch (index) {
        case 0:
            //集中器
            urlStr = kMainTaskMuster;
            break;
        case 1:
            //采集器
            urlStr = kMainTaskCollect;
            break;
        case 2:
            //电表
            urlStr = kMainTaskElectricMeter;
            break;
        default:
            break;
    }
    return urlStr;
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
    if (self.data.count) {
        ZYFSaleList *sale = [self.data lastObject];
        page = sale.dispalyCols.page  + 1;
    }
    
    NSString *urlStr = [self getUrlWithIndex:self.segmentIndex];
    [self getDataFromServer:page url:urlStr];
    
}

- (void)getDataFromServer:(NSInteger)page url:(NSString *)urlStr
{
    NSString *urlString = [NSString stringWithFormat:@"%@?page=%ld",urlStr,page];

    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id json) {
        NSMutableArray *mutableData = (NSMutableArray *)json;
        if (mutableData.count > 0) {
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
        }else{
            [self.refreshControl endRefreshing];
            [self.tableView reloadData];

        }

    } failure:^(NSError *error) {
        [self.refreshControl endRefreshing];
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];

}

-(void)leftBtnClick
{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


//-(void)setSearchBar
//{
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    searchBar.placeholder = @"搜索";
//    self.tableView.tableHeaderView = searchBar;
//    
//    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    
//    searchDisplayController.searchResultsDataSource = self;
//    searchDisplayController.searchResultsDelegate = self;
//}



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
    
    cell.imageView.image = [UIImage imageNamed:@"work_order.png"];
    
    if (tableView == self.tableView) {
        ZYFSaleList *sale = [[ZYFSaleList alloc]init];
        @try {
            sale  = self.data[indexPath.row];
            self.detailString  = nil;

        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
        for (int i = 0; i < sale.attrArray.count; i ++) {
            ZYFAttributes *attr = [sale.attrArray objectAtIndex:i];
            if (self.segmentIndex == 1) {
                //台区显示
                if ([attr.myKey isEqualToString:@"new_operation_tg.new_collect_point_name"]) {
                    UIFont *textLabelFont = [UIFont systemFontOfSize:14];
                    cell.textLabel.font = textLabelFont;
                    cell.textLabel.text = [NSString stringWithFormat:@"地址: %@",attr.myValueString];
                }
            }else{
                //其他显示
                if ([attr.myKey isEqualToString:@"new_user_address"]) {
                    UIFont *textLabelFont = [UIFont systemFontOfSize:14];
                    cell.textLabel.font = textLabelFont;
                    cell.textLabel.text = [NSString stringWithFormat:@"地址: %@",attr.myValueString];
                }
            }

//            if ([attr.myKey isEqualToString:@"new_operation_tg.new_sum"] || [attr.myKey isEqualToString:@"new_operation_tg.new_sumok"] || [attr.myKey isEqualToString:@"new_operation_tg.new_success"]) {
                UIFont *detailFont = [UIFont systemFontOfSize:16];
                cell.detailTextLabel.font = detailFont;
                cell.detailTextLabel.textColor = [UIColor grayColor];
                cell.detailTextLabel.numberOfLines = 2;
                cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                cell.detailTextLabel.text = [self getDetailText:attr];
//            }
        }
    }else{
        cell.textLabel.text = filterData[indexPath.row];
        cell.detailTextLabel.text = filterData[indexPath.row];
    }
    
    return cell;
}

- (NSMutableString *)detailString
{
    if (_detailString == nil) {
        _detailString = [NSMutableString string];
    }
    return _detailString;
}

- (NSString *)getDetailText: (ZYFAttributes *)attr
{
    if ([attr.myKey isEqualToString:@"new_operation_tg.new_sum"]) {
        [self.detailString appendString:attr.myValueString];
        [self.detailString appendString:@"/"];
    }
    if ([attr.myKey isEqualToString:@"new_operation_tg.new_sumok"]) {
        [self.detailString appendString:attr.myValueString];
        [self.detailString appendString:@"/"];
    }
    if ([attr.myKey isEqualToString:@"new_operation_tg.new_success"]) {
        if (attr.myValueString) {
            //取小数点后两位
            if (attr.myValueString.length >= 5) {
                NSString *subStr = [attr.myValueString substringToIndex:5];
                [self.detailString appendString:subStr];
            }else{
                [self.detailString appendString:attr.myValueString];
            }
        }
    }
    return (NSString *)self.detailString;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.tableView) {
        TaskContentController *taskCtrl = [[TaskContentController alloc]init];
        if (self.segmentIndex == 1) {
            taskCtrl.type = @"taiqu";   /**台区*/
        }else if(self.segmentIndex == 0){
            taskCtrl.type = @"jichao"; /**集抄*/
        }else{
            taskCtrl.type = @"";
        }
        taskCtrl.indexRow = indexPath.row;
        taskCtrl.segmentIndex = self.segmentIndex;
        [self.navigationController pushViewController:taskCtrl animated:YES];
    }else{
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}




@end
