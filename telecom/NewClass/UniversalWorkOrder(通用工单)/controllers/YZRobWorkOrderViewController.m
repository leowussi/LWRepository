//
//  YZRobWorkOrderViewController.m
//  telecom
//
//  Created by 锋 on 16/6/14.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZRobWorkOrderViewController.h"
#import "YZWorkOrderHeaderView.h"
#import "YZWorkOrderTableViewCell.h"
#import "YZWorkOrderTitleTableViewCell.h"
#import "YZWorkOrderList.h"
#import "YZWorkOrderDetailViewController.h"
#import "MyBookingSgyyDetail.h"

@interface YZRobWorkOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSArray *_titleArray;
    NSMutableArray *_dataArray;
    NSMutableArray *_headerArray;
    
    NSMutableDictionary *_detailListDict;
    
    //记录被抢的随工单的索引
    NSIndexPath *_workOrderIndexPath;
}
@end

@implementation YZRobWorkOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"可抢工单";
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    // Do any additional setup after loading the view.
    [self loadData];
    [self loadLocalData];
    [self createTableView];
}

#pragma marl -- 加载本地数据
- (void)loadLocalData
{
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //监听随工单是否被抢
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeWorkOrder:) name:BOOKING_UPDATE_SGRW object:nil];
    
}

//移除被抢的随工单
- (void)removeWorkOrder:(NSNotification *)notification
{
    YZWorkOrderList *list = _dataArray[_workOrderIndexPath.section][_workOrderIndexPath.row];

    [self deleteRowAtIndexPath:_workOrderIndexPath workOrderList:list];

}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 64, kScreenWidth - 20, kScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [self createTableViewHeaderView];
    [self.view addSubview:_tableView];
    
}

- (UIView *)createTableViewHeaderView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 22)];
    header.backgroundColor = RGBCOLOR(235, 238, 243);
    return header;
}

#pragma mark -- 加载远程数据
//请求各个详情列表数据
- (void)queryWorkOrderListDetailListWithSectionIndex:(NSInteger)section workOrderType:(NSString *)type Completion:(void(^)(NSArray *listArray))listBlock
{
    if (_titleArray == nil) {
        _titleArray = [[NSArray alloc] initWithObjects:@"故障单",@"业务开通单",@"风险操作工单",@"作业计划",@"指挥任务单",@"随工单",@"资源变更工单",@"请求支撑单", nil];
    }
    NSInteger index = [_titleArray indexOfObject:type];
    NSString *siteId = [_headerArray[section] objectForKey:@"siteId"];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"commonBill/QuerySiteBillList";
    paraDict[@"siteId"] = siteId;
    paraDict[@"billType"] = [NSString stringWithFormat:@"%d",index + 1];
    paraDict[@"type"] = @"3";
    NSLog(@"%@",paraDict);
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        UIFont *font = [UIFont systemFontOfSize:13];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        NSArray *listArray = [result objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
            YZWorkOrderList *list = [[YZWorkOrderList alloc] initWithParserDictionary:dict withFont:font width:kScreenWidth - 90 billTypeId:index + 1];
            [array addObject:list];
        }
        listBlock(array);
        
    }, ^(id result) {
        NSLog(@"%@",result);
    });
}


- (void)loadData
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"commonBill/QueryRobableBill";
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        NSArray *listArray = [result objectForKey:@"list"];
        if ([[result objectForKey:@"result"] isEqualToString:@"0000000"] && listArray.count == 0) {
            [self showAlertWithTitle:@"提示" :@"无可抢工单" :@"确定" :nil];
            return ;
        }
        if (_headerArray == nil) {
            _headerArray = [[NSMutableArray alloc] initWithCapacity:0];
        }else{
            [_dataArray removeAllObjects];
        }
        
        NSArray *keyArray = [NSArray arrayWithObjects:@"workPlanNums",@"workFollowNums", nil];
        NSArray *titleArray = [NSArray arrayWithObjects:@"作业计划",@"随工单", nil];
        [listArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:0];
            NSInteger total = 0;
            for (int i = 0; i < titleArray.count; i++) {
                if ([obj objectForKey:keyArray[i]] == nil) {
                    continue;
                }
                YZWorkOrderList *list = [[YZWorkOrderList alloc] initWithWorkOrderName:titleArray[i] workOrderNums:[[obj objectForKey:keyArray[i]] stringValue]];
                [sectionArray addObject:list];
                total = [[obj objectForKey:keyArray[i]] integerValue] + total;
            }
            
            NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:sectionArray,@"array",[obj objectForKey:@"siteName"],@"siteName",[NSString stringWithFormat:@"%d",total],@"count",[obj objectForKey:@"siteId"],@"siteId", nil];
            [_headerArray addObject:tempDict];
            [_dataArray addObject:[NSMutableArray arrayWithCapacity:0]];
            
        }];
        [_tableView reloadData];
    }, ^(id result) {
        
    });
    
    
}

#pragma mark -- tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = _dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZWorkOrderList *list = _dataArray[indexPath.section][indexPath.row];
    
    if (list.workOrderName) {
        YZWorkOrderTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"title"];
        if (!cell) {
            cell = [[YZWorkOrderTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"title"];
        }
        
        cell.label_title.text = list.workOrderName;
        
        cell.label_number.text = list.workOrderNums;
        
        if (list.cellSelected) {
            cell.layer_accessory.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
        }else{
            cell.layer_accessory.transform = CATransform3DIdentity;
        }
        
        return cell;
    }
    
    YZWorkOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detail"];
    if (!cell) {
        cell = [[YZWorkOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detail" isCanRob:YES];
        [cell.button_rob addTarget:self action:@selector(robButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.button_rob.buttonIndexPath = indexPath;
    
    cell.label_workOrderId.text = list.billNo;
    cell.label_status.text = list.status;
    cell.label_createTime.text = list.createTime;
    [cell.label_detail setAttributedText:list.billContent];
    [cell updateWorkOrderIdLabelHeight:16 detailLabelHeight:list.height_billContent];
    
    return cell;
}

#pragma mark -- 抢单操作
- (void)robButtonClicked:(YZRobIndexButton *)sender
{
    YZWorkOrderList *list = _dataArray[sender.buttonIndexPath.section][sender.buttonIndexPath.row];
    if (list.billTypeId == 6) {
        _workOrderIndexPath = sender.buttonIndexPath;
        MyBookingSgyyDetail* vc = [[MyBookingSgyyDetail alloc] init];
        vc.appointmentId = list.billId;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    NSInteger index = list.billTypeId == 4 ? 1 : 2;
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[@"id"] = list.billId;
    paraDict[@"type"] = [NSString stringWithFormat:@"%d",index];
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    paraDict[@"operationTime"] = operationTime;
    paraDict[@"accessToken"] = accessToken;
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/commonBill/RobBill.json",ADDR_IP,ADDR_DIR];
    AFHTTPRequestOperationManager *manger = [[AFHTTPRequestOperationManager alloc] init];
    [manger POST:requestUrl parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
        NSString *obj = [responseObject objectForKey:@"result"];
        if ([obj isEqualToString:@"true"]) {
           
            [self deleteRowAtIndexPath:sender.buttonIndexPath workOrderList:list];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"抢单成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];

        }else if ([obj isEqualToString:@"false"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该工单已被抢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

}

- (void)deleteRowAtIndexPath:(NSIndexPath *)indexPath workOrderList:(YZWorkOrderList *)list
{
    NSString *workOrderName = list.billTypeId == 4 ? @"作业计划":@"随工单";
    NSMutableArray *deleteArray = [_detailListDict objectForKey:[NSString stringWithFormat:@"%d-%@",indexPath.section,workOrderName]];
    [deleteArray removeObject:list];
    
    [_dataArray[indexPath.section] removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    NSMutableDictionary *sectionDict = _headerArray[indexPath.section];
    NSString *count = [sectionDict objectForKey:@"count"];
    [sectionDict  setObject:[NSString stringWithFormat:@"%d",[count integerValue] - 1] forKey:@"count"];
    NSArray *titleListArray = _dataArray[indexPath.section];
    for (YZWorkOrderList *workOrderList in titleListArray) {
        if ([workOrderList.workOrderName isEqualToString:workOrderName]) {
            workOrderList.workOrderNums = [NSString stringWithFormat:@"%d",[workOrderList.workOrderNums integerValue] - 1];
        }
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationFade];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YZWorkOrderHeaderView *headerView = [_tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[YZWorkOrderHeaderView alloc] initWithReuseIdentifier:@"header"];
        [headerView.button_siteName addTarget:self action:@selector(headerViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSDictionary *dict = _headerArray[section];
    [headerView.button_siteName setTitle:[dict objectForKey:@"siteName"] forState:UIControlStateNormal];
    headerView.label_number.text = [dict objectForKey:@"count"];
    headerView.button_siteName.tag = section;
    
    NSArray *sectionArray = _dataArray[section];
    if (sectionArray.count > 0) {
        headerView.isSelected = YES;
    }else{
        headerView.isSelected = NO;
    }
    
    return headerView;
}

- (void)headerViewClicked:(UIButton *)sender
{
    YZWorkOrderHeaderView *headerView = (YZWorkOrderHeaderView *)[_tableView headerViewForSection:sender.tag];
    headerView.isSelected = !headerView.isSelected;
    if (headerView.isSelected) {
        NSDictionary *dict = _headerArray[sender.tag];
        [_dataArray[sender.tag] addObjectsFromArray:[dict objectForKey:@"array"]];
    }else{
        NSMutableArray *array = _dataArray[sender.tag];
        for (YZWorkOrderList *list in array) {
            list.cellSelected = NO;
        }
        [array removeAllObjects];
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZWorkOrderList *list = _dataArray[indexPath.section][indexPath.row];
    if (!list.workOrderName || [list.workOrderName isEqualToString:@""]) {
        return;
        /*
        YZWorkOrderDetailViewController *workOrderDetailVC = [[YZWorkOrderDetailViewController alloc] init];
        workOrderDetailVC.workOrderId = list.billId;
        workOrderDetailVC.typeId = list.billTypeId;
        [self.navigationController pushViewController:workOrderDetailVC animated:YES];
        
        return;
         */
    }
    if (!_detailListDict) {
        _detailListDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    NSArray *insertArray = [_detailListDict objectForKey:[NSString stringWithFormat:@"%d-%@",indexPath.section,list.workOrderName]];
    YZWorkOrderTitleTableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    if (list.cellSelected) {
        
        [self deleteDataWithIndexPath:indexPath array:insertArray];
        cell.layer_accessory.transform = CATransform3DIdentity;
    }else{
        if (insertArray == nil) {
            [self queryWorkOrderListDetailListWithSectionIndex:indexPath.section workOrderType:list.workOrderName Completion:^(NSArray *listArray) {
                [self insertDataWithIndexPath:indexPath array:listArray];
                [_detailListDict setObject:listArray forKey:[NSString stringWithFormat:@"%d-%@",indexPath.section,list.workOrderName]];
            }];
        }else{
            [self insertDataWithIndexPath:indexPath array:insertArray];
            
        }
        cell.layer_accessory.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
    }
    
    list.cellSelected = !list.cellSelected;
}

#pragma mark -- 插入和删除数据
- (void)insertDataWithIndexPath:(NSIndexPath *)indexPath array:(NSArray *)listArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < listArray.count; i++) {
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:indexPath.row + i + 1 inSection:indexPath.section];
        [array addObject:insertIndexPath];
        
    }
    
    NSMutableArray *sectionArray = [_dataArray objectAtIndex:indexPath.section];
    [sectionArray insertObjects:listArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, listArray.count)]];
    
    [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
}

- (void)deleteDataWithIndexPath:(NSIndexPath *)indexPath array:(NSArray *)listArray
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < listArray.count; i++) {
        NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:indexPath.row + i + 1 inSection:indexPath.section];
        [array addObject:insertIndexPath];
        
    }
    
    NSMutableArray *sectionArray = [_dataArray objectAtIndex:indexPath.section];
    [sectionArray removeObjectsInArray:listArray];
    
    [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -- 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZWorkOrderList *list = _dataArray[indexPath.section][indexPath.row];
    return list.height_billContent + 65;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
