//
//  LookupController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/24.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "LookupController.h"
#import "ZYFHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFGroup.h"
#import "ZYFForm.h"
#import "ZYFSaleList.h"
#import "TableContentController.h"
#import "ZYFURLTableSearch.h"
#import "ListController.h"

@interface LookupController ()

@property (nonatomic,strong ) NSArray *lookupData;

@end

@implementation LookupController

- (void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDataFromServer];
    
}

- (void)getDataFromServer
{
    [MBProgressHUD showMessage:nil toView:self.view];
    [ZYFHttpTool getWithURLCacheXML:self.urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.lookupData = (NSArray *)json;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    ZYFSaleList *sale = [self.lookupData firstObject];
    return sale.groupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ZYFSaleList *sale = [self.lookupData firstObject];
    ZYFGroup *group = [sale.groupArray objectAtIndex:section];
    return group.formArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"tableContentCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    ZYFSaleList *sale = [self.lookupData firstObject];
    ZYFGroup *group = [sale.groupArray objectAtIndex:indexPath.section];
    ZYFForm *form = [group.formArray objectAtIndex:indexPath.row];
    ZYFAttributes *attr = [[ZYFAttributes alloc]init];
    for (ZYFAttributes *attr1 in sale.attrArray) {
        if ([attr1.myKey isEqualToString:form.ColsKey]) {
            attr = attr1;
        }
    }
    
    cell.textLabel.text = form.ColsName;
    
    NSString *type = form.ColsType;
    if ([type isEqualToString:@"stringtel"] || [type isEqualToString:@"stringemail"] || [type isEqualToString:@"stringurl"]){
        if (attr.myValueString) {
            NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:attr.myValueString];
            NSRange contentRange = {0,[contentStr length]};
            [contentStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:contentRange];
            [contentStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
            cell.detailTextLabel.attributedText = contentStr;
        }
    }else if ([type isEqualToString:@"lookup"]){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = attr.lookUp.Name;
    }else if ([type isEqualToString:@"datetime"]){
        cell.detailTextLabel.text = attr.myDateTime;
    }else if ([type isEqualToString:@"picklist"]){
        cell.detailTextLabel.text = attr.pickList.value;
    }else if ([type isEqualToString:@"status"]){
        cell.detailTextLabel.text = attr.pickList.value;
    }else{
        cell.detailTextLabel.text = attr.myValueString;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYFSaleList *sale = [self.lookupData firstObject];

    ZYFGroup *group = [sale.groupArray objectAtIndex:indexPath.section];
    ZYFForm *form = [group.formArray objectAtIndex:indexPath.row];
    ZYFAttributes *attr = [[ZYFAttributes alloc]init];
    for (ZYFAttributes *attr1 in sale.attrArray) {
        if ([attr1.myKey isEqualToString:form.ColsKey]) {
            attr = attr1;
        }
    }
    
    NSString *type = form.ColsType;
    //如果类型是电话、邮件或者url地址
    if ([type isEqualToString:@"stringtel"] || [type isEqualToString:@"stringemail"] || [type isEqualToString:@"stringurl"]){
        UIWebView * callWebview = [[UIWebView alloc] init];
        NSMutableString *string = [NSMutableString string];
        if ([type isEqualToString:@"stringtel"]){
            //如果是电话号码
            string = [[NSMutableString alloc] initWithFormat:@"tel:%@",attr.myValueString];
        }else if ([type isEqualToString:@"stringemail"]){
            string = [[NSMutableString alloc] initWithFormat:@"mailto:%@",attr.myValueString];
        }else if ([type isEqualToString:@"stringurl"]){
            string = [[NSMutableString alloc] initWithFormat:@"%@",attr.myValueString];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:string]];
            return;
        }
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
        [self.view addSubview:callWebview];
        return;
    }
    //如果type是lookup
    if ([type isEqualToString:@"lookup"]){
        NSString *urlStr = kLookup;
        NSString *urlString = [NSString stringWithFormat:@"%@?id=%@&formxml=%@&logicalname=%@",urlStr,attr.lookUp.Id,form.relateEntity.formxml,form.relateEntity.logicalname];
//        NSString *urlString = [NSString stringWithFormat:@"%@?scheamnanem=%@",urlStr,attr.lookUp.Id];

        if (form.relateEntity.type == nil || form.relateEntity.type.length <= 0 || [form.relateEntity.type isEqualToString:@"1"]) {
            //如果type不为空，则通过页面来显示相应地数据
            LookupController *lookupCtrl = [[LookupController alloc]init];
            lookupCtrl.urlString = urlString;
            [self.navigationController pushViewController:lookupCtrl animated:YES];
        }else{
            //如果type类型为空，通过浏览器来调用
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:form.relateEntity.formxml]];
        }
    }
    //如果类型是类似于日志明细类的list类型
    if ([type isEqualToString:@"list"]) {
        NSString *urlStr = kList;
        NSString *urlString = [NSString stringWithFormat:@"%@?formxml=%@&logicalname=%@",urlStr,form.relateEntity.formxml,form.relateEntity.logicalname];
        ListController *listCtrl = [[ListController alloc]init];
        listCtrl.urlString = urlString;
        [self.navigationController pushViewController:listCtrl animated:YES];
    }
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ZYFSaleList *sale = [self.lookupData firstObject];

    ZYFGroup *group = [sale.groupArray objectAtIndex:section];
    return group.name;
}


@end
