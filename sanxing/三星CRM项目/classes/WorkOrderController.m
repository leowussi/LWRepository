//
//  WorkOrderController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/4.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "WorkOrderController.h"
#import "ZYFDelayApplyController.h"
#import "LogsController.h"
#import "DelaysController.h"
#import "ServerContentController.h"
#import "ZYFEditStringController.h"
#import "ZYFEditDateController.h"
#import "ZYFEditLookupController.h"
#import "ZYFTaskController.h"
#import "ZYFShowLongStringController.h"
#import "DownPhotoController.h"
#import "PostPhotoController.h"
#import "ZYFUrl.h"


@interface WorkOrderController () <ZYFShowLongStringControllerDelegate>

@end

@implementation WorkOrderController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"派工信息";
    //    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    //    longGesture.minimumPressDuration = 3.0;
    //    [self.tableView addGestureRecognizer:longGesture];
}

//- (void)longPress:(UILongPressGestureRecognizer *)longGesture
//{
//    CGPoint point = [longGesture locationInView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    if ([cell.textLabel.text isEqualToString:@"电话"]) {
//        ZYFShowLongStringController *ctrl = [[ZYFShowLongStringController alloc]init];
//        ctrl.textString = cell.detailTextLabel.text;
//        ctrl.editable = YES;
//        ctrl.indexPath = indexPath;
//        ctrl.delegate = self;
//        [self.navigationController pushViewController:ctrl animated:YES];
//    }
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.saleList.attrArray.count;
    }else{
        return [self getSectionTwoData].count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"workOrderCtrl";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    if (indexPath.section == 0) {
        ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
        ZYFDisplayCols *disPlayCol = self.saleList.dispalyCols;
        cell.textLabel.text = [disPlayCol.nameArray objectAtIndex:indexPath.row];
        
        NSNumber *editable = [disPlayCol.editableArray objectAtIndex:indexPath.row];
        if (editable.intValue) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        //给电话号码设置下划线
        if ([attr.myKey isEqualToString:@"new_customer_service_work_order.new_mobilephone"] || [attr.myKey isEqualToString:@"new_customer_service_work_order.new_mobile"]) {
            //去掉电话号码之间的空格
            NSString *newPhoneString = [attr.myValueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:newPhoneString];
            NSRange contentRange = {0,[contentStr length]};
            [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:contentRange];
            [contentStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
            cell.detailTextLabel.attributedText = contentStr;
            
//            //长按电话cell，可以编辑该cell
//            UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(editPhoneNum:indexPath:)];
//            [cell addGestureRecognizer:longGesture];
            
        }else{
            cell.detailTextLabel.text = [self getValueString:attr];
        }
        
    }else if(indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSArray *sectionArray = [self getSectionTwoData];
        cell.textLabel.text = [sectionArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

//- (void)editPhoneNum:(UILongPressGestureRecognizer*)longGesture indexPath:(NSIndexPath*)indexPath
//{
//    ZYFShowLongStringController *ctrl = [[ZYFShowLongStringController alloc]init];
////    ctrl.textString = cell.detailTextLabel.text;
//    ctrl.editable = YES;
//    ctrl.indexPath = indexPath;
//    ctrl.delegate = self;
//    [self.navigationController pushViewController:ctrl animated:YES];
//}

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ZYFDisplayCols *disPlayCol = self.saleList.dispalyCols;
        ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
        
        //如果是电话号码
        if ([attr.myKey isEqualToString:@"new_customer_service_work_order.new_mobilephone"] || [attr.myKey isEqualToString:@"new_customer_service_work_order.new_mobile"]) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",attr.myValueString];
            //去掉电话号码之间的空格
            NSString *newPhoneString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newPhoneString]]];
            [self.view addSubview:callWebview];
        }
        //如果是任务，多行需要一个新的页面来显示
        if ([attr.myKey isEqualToString:@"new_customer_service_work_order.new_remark_task"] || [attr.myKey isEqualToString:@"new_customer_service_work_order.new_address"]) {
            //            ZYFTaskController *taskCtrl = [[ZYFTaskController alloc]init];
            //            taskCtrl.text = attr.myValueString;
            //            [self.navigationController pushViewController:taskCtrl animated:YES];
            ZYFShowLongStringController *ctrl = [[ZYFShowLongStringController alloc]init];
            ctrl.textString = attr.myValueString;
            ctrl.editable = NO;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
        
        //editable表示当前行是否需要编辑
        NSNumber *editable = [disPlayCol.editableArray objectAtIndex:indexPath.row];
        //type表示进行编辑时，根据当前行对应的类型显示对应的编辑界面
        NSString *type = [disPlayCol.valueArray objectAtIndex:indexPath.row];
        //name表示对应的中文名字
        NSString *name = [disPlayCol.nameArray objectAtIndex:indexPath.row];
        
        if (editable.intValue) {
            //如果可以编辑,跳转到相应地编辑界面
            
            if ([type isEqualToString:@"string"]) {
                ZYFEditStringController *stringCtrl = [[ZYFEditStringController alloc]initWithStyle:UITableViewStyleGrouped];
                NSMutableArray *cellDataArray = [NSMutableArray array];
                [cellDataArray addObject:name];
                [cellDataArray addObject:[self getValueString:attr]];
                stringCtrl.cellData = cellDataArray;
                
                [self.navigationController pushViewController:stringCtrl animated:YES];
            }else if ([type isEqualToString:@"picklist"]){
                ZYFEditLookupController *lookupCtrl = [[ZYFEditLookupController alloc]init];
                [self.navigationController pushViewController:lookupCtrl animated:YES];
            }else if ([type isEqualToString:@"lookup"]){
                ZYFEditLookupController *lookupCtrl = [[ZYFEditLookupController alloc]init];
                [self.navigationController pushViewController:lookupCtrl animated:YES];
            }else if ([type isEqualToString:@"datetime"]){
                ZYFEditDateController *dateCtrl = [[ZYFEditDateController alloc]init];
                NSString *date = [self getValueString:attr];
                dateCtrl.date = date;
                [self.navigationController pushViewController:dateCtrl animated:YES];
            }else{
                //                NSLog(@"不是一个预先定义好的类型");
            }
            
        }else{
            //如果当前cell类型不可以编辑
            
        }
    }else{
        if (indexPath.row == 0){
            //日志
            LogsController *logsCtrl = [[LogsController alloc]init];
            logsCtrl.saleList = self.saleList;
            [self.navigationController pushViewController:logsCtrl animated:YES];
        }else if(indexPath.row == 1){
            //延期申请
            DelaysController *delayCtrl = [[DelaysController alloc]init];
            delayCtrl.saleList = self.saleList;
            [self.navigationController pushViewController:delayCtrl animated:YES];
        }else if (indexPath.row == 2){
            //上传照片
            PostPhotoController *ctrl = [[PostPhotoController alloc]init];
            //            ctrl.cleanTaskId = self.saleList.Id;
            NSString *urlStr = kPostPhotoAfterSale;
            NSString *urlString = [NSString stringWithFormat:@"%@?action=task&entityname=new_customer_service_require&id=%@",urlStr,self.saleList.Id];
            ctrl.urlString = urlString;
            [self.navigationController pushViewController:ctrl animated:YES];
        }else if (indexPath.row == 3){
            //查看照片
            DownPhotoController *ctrl = [[DownPhotoController alloc]init];
            ctrl.cleanTaskId = self.saleList.Id;
            NSString *url = kDownLoadPhotoAfterSale;
            NSString *urlString = [NSString stringWithFormat:@"%@?id=%@",url,self.saleList.Id];
            ctrl.urlString = urlString;
            [self.navigationController pushViewController:ctrl animated:YES];
            
        }
        
        
        
        
        
    }
}

-(NSArray*)getSectionTwoData
{
    NSArray *sectionData = @[@"工作日志",@"延期申请",@"上传照片",@"查看照片"];
    
    return sectionData;
}

#pragma mark - ZYFShowLongStringControllerDelegate
- (void)showLongStringController:(ZYFShowLongStringController *)ctrl editString:(NSString *)editString
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ctrl.indexPath];
    cell.detailTextLabel.text = editString;
}



@end
