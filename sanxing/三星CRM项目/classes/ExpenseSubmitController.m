//
//  ExpenseSubmitController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/16.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ExpenseSubmitController.h"
#import "CRMHelper.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFUrl.h"
#import "HWNavigationController.h"
#import "ZYFHttpTool.h"
#import "ZYFLogsDetail.h"
#import "ZYFExpenseSubmitController.h"
#import "AddExpenseSubmitController.h"

@interface ExpenseSubmitController () <AddExpenseSubmitControllerDelegate>
/**
 *  费用登记对应的数据
 */
@property (nonatomic,strong) NSArray *expenseSubmitData;

@end

@implementation ExpenseSubmitController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSystemScreenWidth, kSystemScreenHeight) style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"费用类别"];
    if (self.editable) {
        //添加费用登记
        UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addExpenseSubmit)];
        addItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = addItem;
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getExpenseSubmitFromServer];
    
}

/**
 *  从服务器获取当前工单的logs
 */
#pragma mark getExpenseSubmitFromServer
-(void)getExpenseSubmitFromServer
{
    //    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSString *urlStr = kExpenseSubmit;
    NSString *urlString = [NSString stringWithFormat:@"%@?page=1&id=%@",urlStr,self.saleList.Id];
    //    NSString *urlString = [NSString stringWithFormat:@"%@8C78A9CC-206C-4FCC-B184-23C815D5F6E3",urlStr];
    
    
    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.expenseSubmitData = json;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
}

#pragma mark -- 增加日志

-(void)addExpenseSubmit
{
    AddExpenseSubmitController *newExpenseSubmit = [[AddExpenseSubmitController alloc]init];
    
    newExpenseSubmit.saleList = self.saleList;
    
    newExpenseSubmit.delegate = self;
    
    HWNavigationController *nav =[[HWNavigationController alloc]initWithRootViewController:newExpenseSubmit];
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.expenseSubmitData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"expenseSubmit";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        
        //        cell.textLabel.text = @"费用类别";
        
        ZYFSaleList *sale = [self.expenseSubmitData objectAtIndex:indexPath.row];
        for (ZYFAttributes *attr in sale.attrArray) {
            if ([attr.myKey isEqualToString:@"new_order_fee_type"]) {
                for (ZYFFormattedValue *format in sale.formatValueArray) {
                    if ([format.myKey isEqualToString:@"new_order_fee_type"]) {
                        cell.textLabel.text = format.myValueString;
                    }
                }
            }
            if ([attr.myKey isEqualToString:@"new_fee"]) {
                NSString *text = [NSString stringWithFormat:@"%@",attr.myValueString];
                cell.detailTextLabel.text = text;
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYFSaleList *sale = nil;
    if (self.expenseSubmitData) {
        sale = [self.expenseSubmitData objectAtIndex:indexPath.row];
    }else{
        sale = [[ZYFSaleList alloc]initWithDict:nil displayCols:nil];
    }
    
    ZYFExpenseSubmitController *expenseSubmitCtrl = [[ZYFExpenseSubmitController alloc]init];
    expenseSubmitCtrl.editable = self.editable;
    expenseSubmitCtrl.saleList = sale;
    [self.navigationController pushViewController:expenseSubmitCtrl animated:YES];
}

#pragma mark --  AddExpenseSubmitControllerDelegate
-(void)addExpenseSubmitController:(AddExpenseSubmitController *)ctrl isFinish:(BOOL)isFinish
{
    [self getExpenseSubmitFromServer];
}


@end
