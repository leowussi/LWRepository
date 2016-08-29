//
//  ZYFExpenseSubmitController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/16.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFExpenseSubmitController.h"
#import "LogsFooterView.h"
#import "ZYFEditStringController.h"
#import "ZYFLogsDetail.h"
#import "AssignStatusController.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFUrl.h"
#import "ZYFHttpTool.h"
#import "LogDetailsController.h"
#import "ServiceContentController.h"
#import "ExpenseTypeController.h"

@interface ZYFExpenseSubmitController () <ZYFEditStringControllerDelegate,ExpenseTypeControllerDelegate>

@end

@implementation ZYFExpenseSubmitController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"费用登记详细"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.saleList.dispalyCols.keyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"zyfexpensesubmit";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0) {
        if (self.saleList == nil) {
            
        }else{
            ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
            if (attr.myValueString) {
                NSString *valueString = [NSString stringWithFormat:@"%@",attr.myValueString];
                cell.detailTextLabel.text = valueString;
            }else if(attr.lookUp){
                cell.detailTextLabel.text = attr.lookUp.Name;
            }else if (attr.pickList){
                //如果是picklist类型，从formattedValue中（格式化后的）来显示
                for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
                    if ([format.myKey isEqualToString:attr.myKey]) {
                        cell.detailTextLabel.text = format.myValueString;
                    }
                }
            }else{
                //如果是date类型，从formattedValue中（格式化后的）来显示
                for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
                    if ([format.myKey isEqualToString:attr.myKey]) {
                        cell.detailTextLabel.text = format.myValueString;
                    }
                }
            }
            
            ZYFDisplayCols *disPlayCol = self.saleList.dispalyCols;
            NSString *nameString = [disPlayCol.nameArray objectAtIndex:indexPath.row];
            cell.textLabel.text = nameString;
            
            //editable表示当前行是否需要编辑
            NSNumber *editable = [disPlayCol.editableArray objectAtIndex:indexPath.row];
            
            if (editable.intValue) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editable) {
        
        ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
        
        if ([attr.myKey isEqualToString:@"new_fee"]) {
            //费用
            ZYFEditStringController *editCtrl = [[ZYFEditStringController alloc]init];
            editCtrl.info = @"new_fee";
            editCtrl.delegate = self;
            NSMutableArray *cellDataArray = [NSMutableArray array];
            [cellDataArray addObject:@"费用"];
            [cellDataArray addObject:attr.myValueString];
            editCtrl.cellData = cellDataArray;
            [self.navigationController pushViewController:editCtrl animated:YES];
        }
        if ([attr.myKey isEqualToString:@"new_order_fee_type"]) {
            //派工费用类型
            ExpenseTypeController *expenseCtrl = [[ExpenseTypeController alloc]init];
            expenseCtrl.delegate = self;
            [self.navigationController pushViewController:expenseCtrl animated:YES];
        }
    }
}


#pragma mark ---ZYFEditStringControllerDelegate

-(void)editStringController:(ZYFEditStringController *)ctrl editString:(NSString *)editString
{
    //费用
    if ([ctrl.info isEqualToString:@"new_fee"]) {
        for (ZYFAttributes *attr in self.saleList.attrArray) {
            if ([attr.myKey isEqualToString:@"new_fee"]) {
                //费用
                attr.myValueString = editString;
                [self updateServerData:editString type:@"new_fee" keyString:@""];
            }
        }
    }
}

#pragma mark ---ExpenseTypeControllerDelegate

/**
 *  ExpenseTypeController的代理方法
 *
 *  @param ctrl        ctrl
 *  @param keyString   汉字描述部分
 *  @param valueString 对应的数字标识部分
 */

-(void)expenseTypeController:(ExpenseTypeController *)ctrl key:(NSString *)keyString value:(NSString *)valueString
{
    //    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
    //    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //    cell.detailTextLabel.text = keyString;
    
    [self updateServerData:valueString type:@"new_order_fee_type" keyString:keyString];
}


-(void)updateServerData:(NSString *)editString type:(NSString*) typeString keyString:(NSString *)keyString
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //如果是费用
    if ([typeString isEqualToString:@"new_fee"]) {
        params[@"new_fee"] = editString;
    }
    //如果是派工费用类型
    if ([typeString isEqualToString:@"new_order_fee_type"]) {
        params[@"new_order_fee_type"] = editString;
    }
    
    params[@"LogicalName"] = self.saleList.LogicalName;
    params[@"Id"] = self.saleList.Id;
    
    NSString *urlString = kUpdateExpenseSubmit;
    [ZYFHttpTool postWithURL:urlString params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        NSString *code = dictionary[@"Code"];
        if (code.intValue == 1) {
            //如果成功，刷新界面
            //如果是picklist类型，从formattedValue中（格式化后的）来显示
            for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
                if ([format.myKey isEqualToString:@"new_order_fee_type"]) {
                    format.myValueString = keyString;
                }
            }
            
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:msg];

        }
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}




@end
