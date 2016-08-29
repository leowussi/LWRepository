//
//  ZYFDelayApplyController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFDelayApplyController.h"
#import "CRMHelper.h"
#import "ZYFDatePickerController.h"
#import "ZYFDelayApplyView.h"

#import "ZYFEditStringController.h"
#import "ZYFEditDateController.h"
#import "ZYFEditLookupController.h"

#import "ZYFUrl.h"
#import "AFNetworking.h"
#import "ZYFHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ReasonController.h"

@interface ZYFDelayApplyController () <ZYFEditDateControllerDelegate>

@property (nonatomic,strong) UIView *dateView;
@property (nonatomic,copy) NSString *sectionTwoData;
@property (nonatomic,weak) ZYFDelayApplyView *footerView;

@end

@implementation ZYFDelayApplyController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    ZYFDelayApplyView *footerView = [[ZYFDelayApplyView alloc]init];
    //    self.tableView.tableFooterView = footerView;
    //    self.footerView = footerView;
    
    //给textview设置键盘
    //    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    //    [self.tableView addGestureRecognizer:tapGesture];
    
    
}

-(void)dismissKeyBoard
{
    [self.view endEditing:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.saleList.attrArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"zyfDelays";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0) {
        if (self.saleList == nil) {
            //            cell.textLabel.text = [[self getSectionOneData]objectAtIndex:indexPath.row];
        }else{
            ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
            ZYFDisplayCols *disPlayCol = self.saleList.dispalyCols;
            cell.textLabel.text = [disPlayCol.nameArray objectAtIndex:indexPath.row];
            
            //根据是否可以编辑，设置cell显示样式
            NSNumber *editable = [disPlayCol.editableArray objectAtIndex:indexPath.row];
            if (editable.intValue) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            
            if (attr.myValueString) {
                cell.detailTextLabel.text = attr.myValueString;
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
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZYFDisplayCols *disPlayCol = self.saleList.dispalyCols;
        ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
        if (indexPath.row == 3) {
            if ([attr.myKey isEqualToString:@"new_application_remark"]) {
                //申请原因
                ReasonController *ctrl = [[ReasonController alloc]init];
                ctrl.reasonString = attr.myValueString;
                [self.navigationController pushViewController:ctrl animated:YES];
            }else{
                [MBProgressHUD showError:@"申请原因为空"];
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

/**
 *  新加的延期申请，想服务器发送保存请求
 */
-(void)save
{
    
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSString *urlString = kDelayApplySave;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"new_delay_time"] = self.sectionTwoData;
    params[@"new_application_remark"] = self.footerView.textView.text;
    NSString *str = [NSString stringWithFormat:@"%@,%@",self.saleList.LogicalName,self.saleList.Id];
    params[@"new_customer_service_work_orderid"] = str;
    for (ZYFAttributes *attr in self.saleList.attrArray) {
        if ([attr.myKey isEqualToString:@"new_pre_time"]) {
            params[@"new_pre_time"] = attr.myValueString;
        }
    }
    
    [ZYFHttpTool putWithURL:urlString params:params success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        NSString *code = dictionary[@"Code"];
        
        if (code.intValue == 1) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else{
            [MBProgressHUD showError:msg];

        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"error === %@",error);
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
}

#pragma mark - ZYFEditDateControllerDelegate

-(void)editDateChanged:(ZYFEditDateController *)editDateCtrl dateStr:(NSString *)dateString
{
    self.sectionTwoData = dateString;
    [self.tableView reloadData];
}

-(NSString *)sectionTwoData
{
    if (_sectionTwoData == nil) {
        _sectionTwoData = @"";
    }
    return _sectionTwoData;
}

@end
