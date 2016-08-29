//
//  ZYFLogsController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFLogsController.h"
#import "LogsFooterView.h"
#import "ZYFEditStringController.h"
#import "ZYFEditDateController.h"
#import "ZYFEditLookupController.h"

#import "ZYFLogsDetail.h"
#import "AssignStatusController.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFUrl.h"
#import "ZYFHttpTool.h"
#import "LogDetailsController.h"
#import "ExpenseSubmitController.h"
#import "OrderSummaryController.h"
#import "ZYFShowLongStringController.h"

@interface ZYFLogsController () <AssignStatusControllerDelegate,ZYFEditDateControllerDelegate,OrderSummaryControllerDelegate>

@property (nonatomic,weak) LogsFooterView *footerView;

@end

@implementation ZYFLogsController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"日志"];
    //    [self setFooterView];
}

-(void)setFooterView
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        //因为服务说明相关的信息放在footview中显示,派工状态也放在section2中
        return self.saleList.dispalyCols.keyArray.count - 2;
    }else if(section == 1){
        //工作日志明细，费用登记
        return [self getSectionTwoData].count;
    }else{
        //派工总结
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"zyflogs";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0) {
        if (self.saleList == nil) {
            
        }else{
            ZYFAttributes *attr = [[ZYFAttributes alloc]init];
            //如果当前改行的字段不是一个空的字段
            attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"要求填写时间";
                for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
                    if (format.myKey) {
                        if ([format.myKey isEqualToString:@"new_request_date"]) {
                            cell.detailTextLabel.text = format.myValueString;
                        }
                    }
                    
                }
            }else if (indexPath.row == 1){
                cell.textLabel.text = @"派工完成时间";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
                    if (format.myKey) {
                        if ([format.myKey isEqualToString:@"new_end_order_time"]) {
                            cell.detailTextLabel.text = format.myValueString;
                        }
                    }
                }
            }
            else if (indexPath.row == 2){
                cell.textLabel.text = @"派工单主题";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                for (ZYFAttributes *attr in self.saleList.attrArray) {
                    if ([attr.myKey isEqualToString:@"new_customer_service_work_order.new_subject"]) {
                        cell.detailTextLabel.text = attr.myValueString;
                    }
                }
            }
        }
    }else if(indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSArray *sectionArray = [self getSectionTwoData];
        cell.textLabel.text = [sectionArray objectAtIndex:indexPath.row];
    }else if (indexPath.section == 2){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"派工总结";
            
            for (ZYFAttributes *attr  in self.saleList.attrArray) {
                if ([attr.myKey isEqualToString:@"new_order_summary"]) {
                    cell.detailTextLabel.text = attr.myValueString;
                }
            }
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"派工状态";
            
            for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
                if ([format.myKey isEqualToString:@"new_order_status"]) {
                    cell.detailTextLabel.text = format.myValueString;
                }
            }
            
        }
        
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSNumber *editable = nil;
        ZYFDisplayCols *disPlayCol = self.saleList.dispalyCols;
        ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
        
        //editable表示当前行是否需要编辑
        editable = [disPlayCol.editableArray objectAtIndex:indexPath.row];
        //如果派工状态为待填写，则所有的选项都可以编辑,并且此时hidden保存按钮
        for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
            if ([format.myKey isEqualToString:@"new_order_status"]) {
                if ([format.myValueString isEqualToString:@"待填写"]) {
                    self.footerView.saveBtn.hidden = NO;
                }else{
                    editable = [NSNumber numberWithInt:0];
                    self.footerView.saveBtn.hidden = YES;
                }
            }
        }
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textLabel.text isEqualToString:@"派工完成时间"]) {
            
            for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
                if ([format.myKey isEqualToString:@"new_order_status"]) {
                    if ([format.myValueString isEqualToString:@"待填写"]) {
                        ZYFEditDateController *dateCtrl = [[ZYFEditDateController alloc]init];
                        dateCtrl.delegate = self;
                        if (indexPath.row < self.saleList.attrArray.count) {
                            NSString *date = cell.detailTextLabel.text;
                            dateCtrl.date = date;
                        }
                        [self.navigationController pushViewController:dateCtrl animated:YES];
                    }
                }
            }
            
        }else if ([cell.textLabel.text isEqualToString:@"派工单主题"]){
            ZYFShowLongStringController *ctrl = [[ZYFShowLongStringController alloc]init];
            ctrl.editable = NO;
            ctrl.textString = cell.detailTextLabel.text;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
    }else if(indexPath.section == 1){
        
        NSNumber *editableSection1 = nil;
        //如果派工状态为待填写，则所有的选项都可以编辑,并且此时hidden保存按钮
        for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
            if ([format.myKey isEqualToString:@"new_order_status"]) {
                if ([format.myValueString isEqualToString:@"待填写"]) {
                    editableSection1 = [NSNumber numberWithInt:1];
                }else{
                    editableSection1 = [NSNumber numberWithInt:0];
                    self.footerView.saveBtn.hidden = YES;
                }
            }
        }
        
        if (indexPath.row == 0) {
            //工作日志明细
            LogDetailsController *detailCtrl = [[LogDetailsController alloc]init];
            detailCtrl.editable = editableSection1.intValue;
            detailCtrl.saleList = self.saleList;
            [self.navigationController pushViewController:detailCtrl animated:YES];
        }else if (indexPath.row == 1){
            //费用登记
            ExpenseSubmitController *expenseCtrl = [[ExpenseSubmitController alloc]init];
            expenseCtrl.editable = editableSection1.intValue;
            expenseCtrl.saleList = self.saleList;
            [self.navigationController pushViewController:expenseCtrl animated:YES];
        }
        //        }
    }else if (indexPath.section == 2){
        ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
        NSNumber *editableSection1 = nil;
        //如果派工状态为待填写，则所有的选项都可以编辑,并且此时hidden保存按钮
        for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
            if ([format.myKey isEqualToString:@"new_order_status"]) {
                if ([format.myValueString isEqualToString:@"待填写"]) {
                    editableSection1 = [NSNumber numberWithInt:1];
                }else{
                    editableSection1 = [NSNumber numberWithInt:0];
                    self.footerView.saveBtn.hidden = YES;
                }
            }
        }
        if (indexPath.row == 0) {
            //派工总结
            OrderSummaryController *sumCtrl = [[OrderSummaryController alloc]init];
            
            sumCtrl.saleList = self.saleList;
            sumCtrl.delegate = self;
            if (editableSection1.intValue) {
                sumCtrl.editable = YES;
            }else{
                sumCtrl.editable = NO;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            sumCtrl.summaryText =  cell.detailTextLabel.text;
            [self.navigationController pushViewController:sumCtrl animated:YES];
        }else if (indexPath.row == 1){
            //如果选中的是派工状态
            if (editableSection1.intValue) {
                AssignStatusController *ctrl = [[AssignStatusController alloc]init];
                ctrl.delegate = self;
                [self.navigationController pushViewController:ctrl animated:YES];
                
            }else{
                return;
            }
        }
    }
}

-(NSString*)getValueString:(ZYFAttributes*)attr
{
    NSString *resultString = @"";
    
    if (attr.myValueString) {
        resultString = attr.myValueString;
    }else if(attr.lookUp){
        resultString = attr.lookUp.Name;
    }else if (attr.pickList){
        //如果是picklist类型，从formattedValue中（格式化后的）来显示
        for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
            if ([format.myKey isEqualToString:attr.myKey]) {
                resultString = format.myValueString;
            }
        }
    }else{
        //如果是date类型，从formattedValue中（格式化后的）来显示
        for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
            if ([format.myKey isEqualToString:attr.myKey]) {
                resultString= format.myValueString;
            }
        }
    }
    return resultString;
}

-(NSArray*)getSectionTwoData
{
    //    NSArray *sectionData = @[@"服务内容:",@"实际数量:",];
    NSArray *sectionData = @[@"工作日志明细",@"费用登记"];
    
    return sectionData;
}

-(NSArray*)getSectionOneData
{
    NSArray *sectionData = @[@"日志编号:",@"任务状态:",@"派工总结:",@"完成时间:"];
    return sectionData;
}

#pragma mark AssignStatusControllerDelegate -- 派工状态
-(void)assignStatusController:(AssignStatusController *)ctrl status:(NSArray *)statusArray
{
    [self save:statusArray];
}
//派工状态更改保存
-(void)save:(NSArray*) statusArray
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"Id"] = self.saleList.Id;
    params[@"LogicalName"] = self.saleList.LogicalName;
    params[@"new_order_status"] = statusArray[1];
    
    NSString *urlString = kWorkLogAssignStatusSave;
    [ZYFHttpTool postWithURL:urlString params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *code = dictionary[@"Code"];
        NSString *msg = dictionary[@"Msg"];
        NSLog(@"msg====%@",msg);
        [MBProgressHUD showSuccess:msg];
        if (code.intValue == 1) {
            for (ZYFFormattedValue *format in self.saleList.formatValueArray) {
                if ([format.myKey isEqualToString:@"new_order_status"]) {
                    format.myValueString = statusArray[0];
                }
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:msg];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *msg = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD showError:msg];
    }];
    
}

#pragma mark -- ZYFEditDateControllerDelegate
-(void)editDateChanged:(ZYFEditDateController *)editDateCtrl dateStr:(NSString *)dateString
{
    NSLog(@"dateString == %@",dateString);
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"LogicalName"] = self.saleList.LogicalName;
    params[@"Id"] = self.saleList.Id;
    
    params[@"new_end_order_time"] = dateString;
    
    NSString *urlString = kWorkLogAssignStatusSave;
    [ZYFHttpTool postWithURL:urlString params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        NSString *code = dictionary[@"Code"];
        if (code.intValue == 1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = dateString;
        }else{
            [MBProgressHUD showError:msg];
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *msg = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD showError:msg];
    }];
}

#pragma mark -- OrderSummaryControllerDelegate
-(void)orderSummaryController:(OrderSummaryController *)ctrl changeText:(NSString *)changeText
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = changeText;
}


@end
