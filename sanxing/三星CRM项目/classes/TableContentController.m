//
//  TableContentController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/19.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "TableContentController.h"
#import "ZYFForm.h"
#import "ZYFGroup.h"
#import "ZYFHttpTool.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFURLTableSearch.h"
#import "ListController.h"
#import "LookupController.h"

@interface TableContentController ()

@end

@implementation TableContentController

- (void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"表单内容";
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.tableSearchSaleList.groupArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    ZYFGroup *group = [self.tableSearchSaleList.groupArray objectAtIndex:section];
    return group.formArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"tableContentCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    ZYFGroup *group = [self.tableSearchSaleList.groupArray objectAtIndex:indexPath.section];
    ZYFForm *form = [group.formArray objectAtIndex:indexPath.row];
    ZYFAttributes *attr = [[ZYFAttributes alloc]init];
    for (ZYFAttributes *attr1 in self.tableSearchSaleList.attrArray) {
        if ([attr1.myKey isEqualToString:form.ColsKey]) {
            attr = attr1;
        }
    }
    cell.textLabel.text = form.ColsName;
    ZYFLog(@"form.ColsName===%@",form.ColsName);
    
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
        ZYFLog(@"attr.lookup.Name===%@",attr.lookUp.Name);
    }else if ([type isEqualToString:@"datetime"]){
        cell.detailTextLabel.text = attr.myDateTime;
        ZYFLog(@"attr.mydateTime===%@",attr.myDateTime);
        
    }else if ([type isEqualToString:@"picklist"]){
        cell.detailTextLabel.text = attr.pickList.value;
        ZYFLog(@"attr.pickList.value===%@",attr.pickList.value);
    }else if ([type isEqualToString:@"status"]){
        cell.detailTextLabel.text = attr.pickList.value;
        ZYFLog(@"attr.pickList.value===%@",attr.pickList.value);
        
    }else{
        cell.detailTextLabel.text = attr.myValueString;
        ZYFLog(@"myValueString===%@",attr.myValueString);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYFGroup *group = [self.tableSearchSaleList.groupArray objectAtIndex:indexPath.section];
    ZYFForm *form = [group.formArray objectAtIndex:indexPath.row];
    ZYFAttributes *attr = [[ZYFAttributes alloc]init];
    for (ZYFAttributes *attr1 in self.tableSearchSaleList.attrArray) {
        if ([attr1.myKey isEqualToString:form.ColsKey]) {
            attr = attr1;
        }
    }
    
    NSString *type = form.ColsType;
    //如果类型是电话、邮件或者url地址
    if ([type isEqualToString:@"stringtel"] || [type isEqualToString:@"stringemail"] || [type isEqualToString:@"stringurl"]){
        UIWebView * callWebview = [[UIWebView alloc] init];
        NSString *string = [NSMutableString string];
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
        //去掉电话号码,邮件或者url之间的空格
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:string]]];
        [self.view addSubview:callWebview];
        return;
    }
    //如果type是lookup
    if ([type isEqualToString:@"lookup"]){
        NSString *urlStr = kTableSearchMain;
        NSString *schemName = form.relateEntity.scheamname;
        NSString *urlString = [NSString stringWithFormat:@"%@?%@=%@&formxml=%@&entityid=%@",urlStr,schemName,attr.lookUp.Id,form.relateEntity.formxml,attr.lookUp.Id];
        
        LookupController *lookupCtrl = [[LookupController alloc]init];
        lookupCtrl.urlString = [CRMHelper translateRegularUrlWithString:urlString];
        [self.navigationController pushViewController:lookupCtrl animated:YES];
    }
    //如果类型是类似于日志明细类的list类型
    if ([type isEqualToString:@"list"]) {
        NSString *urlStr = kList;
        NSString *schemName = form.relateEntity.scheamname;
        NSString *entityId = self.tableSearchSaleList.Id;
        NSString *urlString = [NSString stringWithFormat:@"%@?formxml=%@&logicalname=%@&%@=%@",urlStr,form.relateEntity.formxml,form.relateEntity.logicalname,schemName,entityId];
        ListController *listCtrl = [[ListController alloc]init];
        listCtrl.urlString = [CRMHelper translateRegularUrlWithString:urlString];
        [self.navigationController pushViewController:listCtrl animated:YES];
    }
    
    if ([type isEqualToString:@"list"]) {
    
    }
    
    if ([type isEqualToString:@"money"]) {
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ZYFGroup *group = [self.tableSearchSaleList.groupArray objectAtIndex:section];
    return group.name;
}




@end
