//
//  ZYFLogsDetail.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/10.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFLogsDetail.h"
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
#import "ServiceContentController.h"
#import "ZYFShowLongStringController.h"
#import "ZYFProductTypeController.h"

@interface ZYFLogsDetail () <ServiceContentControllerDelegate,ZYFEditStringControllerDelegate,ZYFShowLongStringControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,assign,getter=isNum) BOOL num;
/**
 *  保存时，ServiceContentControllerDelegate传回来的saleList
 */
@property (nonatomic,strong) ZYFSaleList *serviceContentSaleList;

//实际数量
@property (nonatomic,copy) NSString *realityNum;

//服务说明
@property (nonatomic,copy) NSString *serviceIntro;
//产品型号
@property (nonatomic,copy) NSString *productType;
//电话号码
@property (nonatomic,copy) NSString *phoneNum;

@end

@implementation ZYFLogsDetail

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"日志明细"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.saleList.dispalyCols.keyArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"zyflogDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    if (indexPath.section == 0) {
        if (self.saleList == nil) {
            
        }else{
            ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
            NSLog(@"attr.mykey == %@",attr.myKey);
            if (attr.myValueString) {
                NSString *valueString = [NSString stringWithFormat:@"%@",attr.myValueString];
                cell.detailTextLabel.text = valueString;
                if ([attr.myKey isEqualToString:@"new_tel"]) {
                    //去掉电话号码之间的空格
                    NSString *newPhoneString = [attr.myValueString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:newPhoneString];
                    NSRange contentRange = {0,[contentStr length]};
                    [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:contentRange];
                    [contentStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
                    cell.detailTextLabel.attributedText = contentStr;
                    
                    //长按电话cell，可以编辑该cell
                    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(editPhoneNum:)];
                    longGesture.delegate = self;
                    [cell addGestureRecognizer:longGesture];
                }
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
        
        for (ZYFAttributes *attr in self.saleList.attrArray) {
            if ([attr.myKey isEqualToString:@"new_customer_service_contentid"]) {
                //服务内容
                self.num = YES;
            }
        }
    }
    
    return cell;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
{
    return NO;
}

- (void)editPhoneNum:(UILongPressGestureRecognizer*)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        //        NSLog(@"begin111");
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        //        NSLog(@"change222");
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        ZYFShowLongStringController *ctrl = [[ZYFShowLongStringController alloc]init];
        ctrl.textString = cell.detailTextLabel.text;
        ctrl.editable = YES;
        ctrl.indexPath = indexPath;
        ctrl.delegate = self;
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editable) {
        
        
        ZYFAttributes *attr = [self.saleList.attrArray objectAtIndex:indexPath.row];
        
        //如果是电话号码
        if ([attr.myKey isEqualToString:@"new_tel"]) {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",attr.myValueString];
            //去掉电话号码之间的空格
            NSString *newPhoneString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newPhoneString]]];
            [self.view addSubview:callWebview];
        }
        
        if (indexPath.row == 5) {
            //服务内容
            ServiceContentController *serviceCtrl = [[ServiceContentController alloc]init];
            serviceCtrl.sale = self.saleList;
            serviceCtrl.delegate = self;
            serviceCtrl.showCheckmark = YES;
            serviceCtrl.selectedString = attr.lookUp.Name;
            [self.navigationController pushViewController:serviceCtrl animated:YES];
        }else if (indexPath.row == 6){
            //服务说明
            ZYFShowLongStringController *ctrl = [[ZYFShowLongStringController alloc]init];
            ctrl.editable = YES;
            //给ctrl 的文本框赋值
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            ctrl.textString = cell.detailTextLabel.text;
            ctrl.delegate = self;
            ctrl.indexPath = indexPath;
            [self.navigationController pushViewController:ctrl animated:YES];
        }else if (indexPath.row == 7){
            //实际数量
            if (self.isNum) {
                //可以编辑
                ZYFEditStringController *editCtrl = [[ZYFEditStringController alloc]init];
                editCtrl.showNumKeyboard = YES;//显示数字键盘
                editCtrl.delegate = self;
                NSMutableArray *cellDataArray = [NSMutableArray array];
                [cellDataArray addObject:@"实际数量"];
                
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                if (cell.detailTextLabel.text) {
                    [cellDataArray addObject:cell.detailTextLabel.text];
                }else{
                    [cellDataArray addObject:@""];
                }
                editCtrl.cellData = cellDataArray;
                
                [self.navigationController pushViewController:editCtrl animated:YES];
            }else{
                //不可以编辑
                [MBProgressHUD showError:@"不能编辑"];
            }
        }else if (indexPath.row == 8){
            //产品型号
            ZYFProductTypeController *ctrl = [[ZYFProductTypeController alloc]init];
            ctrl.productType = ^(NSString *type){
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
                cell.detailTextLabel.text = type;
                self.productType = type;
                [self changeServerData];

            };
            [self.navigationController pushViewController:ctrl animated:YES];
        }
    }
    
}

#pragma mark ---ServiceContentControllerDelegate

-(void)serviceContentController:(ServiceContentController *)ctrl didSelectedRow:(NSString *)rowString serviceIntro:(NSString *)serviceIntro isNum:(BOOL)isNum
{
    for (ZYFAttributes *attr in self.saleList.attrArray) {
        if ([attr.myKey isEqualToString:@"new_customer_service_contentid"]) {
            //服务内容
            attr.lookUp.Name = rowString;
        }
        if ([attr.myKey isEqualToString:@"new_customer_service_content_des"]) {
            //服务说明
            attr.myValueString = serviceIntro;
        }
        if (![rowString isEqualToString:@"参数设置"]) {
            //如果从参数设置切换到其他状态，实际数量应该清空
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = @"";
            self.realityNum = @"";
        }
        [self.tableView reloadData];
    }
    self.num = isNum;
    [self changeServerData];
}

-(void)serviceContentController:(ServiceContentController *)ctrl saleList:(ZYFSaleList *)saleList
{
    self.serviceContentSaleList =saleList;
}

#pragma mark ---ZYFEditStringControllerDelegate

-(void)editStringController:(ZYFEditStringController *)ctrl editString:(NSString *)editString
{
    //实际数量
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = editString;
    self.realityNum = editString;
    
    [self changeServerData];
}

-(void)changeServerData
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //服务内容对应的logincname和id
    if ( ! (self.serviceContentSaleList.Id == nil || self.serviceContentSaleList.Id.length <= 0)){
        NSString *serviceLogincalAndId = [NSString stringWithFormat:@"%@,%@",self.serviceContentSaleList.LogicalName,self.serviceContentSaleList.Id];
        params[@"new_customer_service_contentid"] = serviceLogincalAndId;
    }
    
    //工作日志明细对应的id和logicalName
    
    params[@"LogicalName"] = self.saleList.LogicalName;
    params[@"Id"] = self.saleList.Id;
    
    //服务说明
    if (self.serviceIntro && self.serviceIntro.length > 0) {
        params[@"new_customer_service_content_des"] = self.serviceIntro;
    }
    
    //实际数量
    if (self.realityNum) {
        params[@"new_performance"] = self.realityNum;
        
    }else{
        self.realityNum = @"";
    }
    //产品型号
    if (self.productType && self.productType.length > 0) {
        params[@"new_producttype"] = self.productType;
    }else{
        params[@"new_producttype"] = @"";
    }
    //电话号码
    if (self.phoneNum && self.phoneNum.length > 0) {
        params[@"new_tel"] = self.phoneNum;
    }
    
    NSString *urlString = kServiceContentSave;
    [ZYFHttpTool postWithURL:urlString params:params success:^(id json) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *msg = dictionary[@"Msg"];
        NSString *code = dictionary[@"Code"];
        
        if (code.intValue == 1) {
            [MBProgressHUD showSuccess:msg];
        }else{
            [MBProgressHUD showError:msg];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark -- ZYFShowLongStringControllerDelegate
-(void)showLongStringController:(ZYFShowLongStringController *)ctrl editString:(NSString *)editString
{
    //服务说明
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ctrl.indexPath];
    NSString *cellText = cell.textLabel.text;
    cell.detailTextLabel.text = editString;
    
    if ([cellText isEqualToString:@"服务说明"]) {
        //服务说明
        self.serviceIntro = editString;
    }else if ([cellText isEqualToString:@"电话"]){
        //电话号码
        self.phoneNum = editString;
    }
    
    [self changeServerData];
    
}







@end
