//
//  LogDetailsController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/14.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "LogDetailsController.h"
#import "ZYFLogsController.h"
#import "CRMHelper.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFLogsController.h"
#import "ZYFUrl.h"
#import "HWNavigationController.h"
#import "AddLogController.h"
#import "ZYFHttpTool.h"
#import "ZYFLogsDetail.h"
#import "AddLogDetailController.h"

@interface LogDetailsController () <AddLogDetailControllerDelegate>

@property (nonatomic,strong) NSArray *logDetailData;

@end

@implementation LogDetailsController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSystemScreenWidth, kSystemScreenHeight) style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"工作日志明细"];
    if (self.editable) {
        //添加工作日志按钮
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLogDetail)];
        addItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = addItem;
    }


    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getLogsFromServer) name:@"updateDetailSaleList" object:nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getLogsFromServer];

}

/**
 *  从服务器获取当前工单的logsDetail
 */
#pragma mark getLogsFromServer
-(void)getLogsFromServer
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSString *urlStr = kWorkLogDetail;
    NSString *urlString = [NSString stringWithFormat:@"%@?page=1&id=%@",urlStr,self.saleList.Id];
    
    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.logDetailData = json;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}

#pragma mark -- 增加日志

-(void)addLogDetail
{
    AddLogDetailController *newLogDetail = [[AddLogDetailController alloc]init];
    
    newLogDetail.saleList = self.saleList;
    
    newLogDetail.delegate = self;
    
    HWNavigationController *nav =[[HWNavigationController alloc]initWithRootViewController:newLogDetail];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logDetailData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"logDetails";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"日志明细";
        
        ZYFSaleList *sale = [self.logDetailData objectAtIndex:indexPath.row];
        for (ZYFAttributes *attr in sale.attrArray) {
            if ([attr.myKey isEqualToString:@"new_name"]) {
                NSString *text = attr.myValueString;
                cell.detailTextLabel.text = text;
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYFSaleList *sale = nil;
    if (self.logDetailData) {
        sale = [self.logDetailData objectAtIndex:indexPath.row];
    }else{
        sale = [[ZYFSaleList alloc]initWithDict:nil displayCols:nil];
    }
    
    ZYFLogsDetail *logsDetailCtrl = [[ZYFLogsDetail alloc]init];
    logsDetailCtrl.editable = self.editable;
    logsDetailCtrl.saleList = sale;
    [self.navigationController pushViewController:logsDetailCtrl animated:YES];
}

#pragma mark --- AddLogDetailControllerDelegate

-(void)addLogDetailController:(AddLogDetailController *)ctrl didFinishCreate:(BOOL)isFinish
{
    if (isFinish) {
        //成功创建
        [self getLogsFromServer];
    }else{
        //创建失败
        [MBProgressHUD showError:@"创建失败"];
    }
}

@end
