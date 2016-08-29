//
//  WorkLogController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/13.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "WorkLogController.h"
#import "ZYFLogsController.h"
#import "CRMHelper.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFLogsController.h"
#import "ZYFUrl.h"
#import "HWNavigationController.h"
#import "AddLogController.h"
#import "ZYFHttpTool.h"
#import "ZYFURLWorkLogs.h"

@interface WorkLogController () <AddLogControllerDelegate>

@property (nonatomic,strong) NSArray *logsData;

@end

@implementation WorkLogController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSystemScreenWidth, kSystemScreenHeight) style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"工作日志"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getLogsFromServer];
}

/**
 *  从服务器获取当前工单的logs
 */

-(void)getLogsFromServer
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSString *urlString = kWorkerLogs;
    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.logsData = json;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.logsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"logs";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        //        cell.textLabel.text = @"日志:";
        
        ZYFSaleList *sale = [self.logsData objectAtIndex:indexPath.row];
        for (ZYFFormattedValue *format in sale.formatValueArray) {
            if ([format.myKey isEqualToString:@"new_request_date"]) {
                NSString *text = [NSString stringWithFormat:@"%@",format.myValueString];
                cell.textLabel.text = text;
            }
        }
        for (ZYFAttributes *attr in sale.attrArray) {
            if ([attr.myKey isEqualToString:@"new_order_status"]) {
                for (ZYFFormattedValue *format in sale.formatValueArray) {
                    if ([format.myKey isEqualToString:attr.myKey]) {
                        NSString *text = [NSString stringWithFormat:@"%@",format.myValueString];
                        cell.detailTextLabel.text = text;
                    }
                }
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //日志
    ZYFSaleList *sale = [self.logsData objectAtIndex:indexPath.row];
    
    ZYFLogsController *logsCtrl = [[ZYFLogsController alloc]init];
    logsCtrl.saleList = sale;
    [self.navigationController pushViewController:logsCtrl animated:YES];
}

#pragma mark AddLogControllerDelegate
-(void)addLogController:(AddLogController *)ctrl isFinished:(BOOL)isFinished
{
    if (isFinished) {
        //如果接收到成功添加的数据
        [self getLogsFromServer];
    }
}




@end
