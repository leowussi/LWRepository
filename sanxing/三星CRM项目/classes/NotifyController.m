//
//  NotifyController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/15.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "NotifyController.h"
#import "NotifyCell.h"
//#import "NotifyContentController.h"
#import "LoginController.h"
#import "Message.h"
#import "CRMHelper.h"
#import "ZYFHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFUrl.h"
#import "ZYFDisplayCols.h"
#import "ZYFSaleList.h"
#import "ZYFAttributes.h"
//#import "ContentController.h"
#import "NotifyDetailController.h"
//#import "MJRefresh.h"

#define kCellHeight 91

static NSString* const kMsgFileName = @"message.data";

@interface NotifyController ()
{
    NSArray *filterData;
    UISearchDisplayController *searchDisplayController;
}

@property (nonatomic,strong) NSMutableArray *messagesData;
//@property (nonatomic,strong) NSMutableArray *localMessageData;


@end

@implementation NotifyController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *color = [UIColor colorWithRed:73.0/255.0 green:170.0/255.0 blue:240.0/255.0 alpha:1.0];

    self.navigationController.navigationBar.tintColor = color;
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getMessage:) name:ZYFMessageReceiveNotify object:nil];
//    [self setSearchBar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;

    [self getMessage:nil];
}

//如果接受到新的通知
- (void)getMessage:(NSNotification *)notification
{

    //刷新数据和用户界面
    NSString *urlString = kMessage;
//    NSString *urlString = @"100.100.100.68:61113/api/new_app_mess/GetAppMesses";

    [MBProgressHUD showMessage:nil toView:self.view];
    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id messages) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.messagesData = messages;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}

#if 0
//如果接受到新的通知
//- (void)getMessage:(NSNotification *)notification
//{
//    //每次先把已经存在本地的数据读出来
//        NSString *filePath = [CRMHelper createFilePathWithFileName:kMsgFileName];
//        NSArray *localSaleArray = [NSArray arrayWithContentsOfFile:filePath];
//        
//        NSMutableArray *mutableArray = [NSMutableArray array];
//        for (NSData *data in localSaleArray) {
//            ZYFSaleList *sale = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//            [mutableArray addObject:sale];
//        }
//
//
//    //刷新数据和用户界面
//    NSString *urlString = kMessage;
//    [MBProgressHUD showMessage:nil toView:self.view];
//    [ZYFHttpTool getWithURL:urlString params:nil success:^(id json) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
//        ZYFDisplayCols *displayCols = [ZYFDisplayCols displayColWithDict:dictionary];
//        NSArray *entityarray = dictionary[@"Entitys"];
//        
//        NSMutableArray *messageArray = [NSMutableArray array];
//        for (NSDictionary *dict in entityarray) {
//            //构造每个实体(Entity)的模型
//            ZYFSaleList *saleList = [ZYFSaleList saleListWithDict:dict displayCols:displayCols];
//            [messageArray addObject:saleList];
//            
//            //转化为本地可以存储的数据
//            NSData *localData = [NSKeyedArchiver archivedDataWithRootObject:saleList];
//            [self.localMessageData addObject:localData];
//            
//        }
////        //比较存储的第一条和本次得到的新数据是不是同一条数据，如果是，则不追加，否则追加
////        ZYFSaleList *currentLastSale1 = [messageArray firstObject];
////        ZYFSaleList *currentLastSale2 = [messageArray lastObject];
////
////        ZYFSaleList *lastLocalSale1 = [mutableArray firstObject];
////        ZYFSaleList *lastLocalSale2 = [mutableArray lastObject];
//
//        
//        //把本地的数据追加到刚获取的数据的后面
//        [messageArray addObjectsFromArray:mutableArray];
//        self.messagesData = messageArray;
//        
//        //把本地可存储的数据写到本地文件中
//        NSString *msgFile = [CRMHelper createFilePathWithFileName:kMsgFileName];
//        NSFileManager *mgr = [NSFileManager defaultManager];
//        
//        [self.localMessageData writeToFile:msgFile atomically:YES];
//        
//        [self.tableView reloadData];
//
//    } failure:^(NSError *error) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        //如果请求失败，显示本地已经有的数据
//        self.messagesData = mutableArray;
//        [self.tableView reloadData];
//
//    }];
//}
#endif

-(void)setSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kCellHeight)];
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
        return self.messagesData.count;
    }else{
        //谓词搜索
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        NSMutableString *msgContent = [NSMutableString string];
        for (ZYFSaleList *sale in self.messagesData) {
            for (ZYFAttributes *attr in sale.attrArray) {
                if ([attr.myKey isEqualToString:@""]) {
                    [msgContent appendString:attr.myValueString];
                }
            }
        }
        filterData =  [[NSArray alloc] initWithArray:[self.messagesData filteredArrayUsingPredicate:predicate]];
        return filterData.count;
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"Notify";
    NotifyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[NotifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    ZYFSaleList *message = self.messagesData[indexPath.row];
    cell.message = message;
    
    if (tableView == self.tableView) {

    }else{
        //        cell.textLabel.text = filterData[indexPath.row];
        //        cell.detailTextLabel.text = filterData[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NotifyDetailController *contentCtrl = [[NotifyDetailController alloc]init];
    ZYFSaleList *message = self.messagesData[indexPath.row];
    message.msgState = MSGMessageStateOpened;
    contentCtrl.message = message;
    [self.navigationController pushViewController:contentCtrl animated:YES];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellHeight;
}


- (NSMutableArray *)messagesData
{
    if (_messagesData == nil) {
        _messagesData = [NSMutableArray array];
    }
    return _messagesData;
}



@end
