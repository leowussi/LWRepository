//
//  ClientDetailController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/9/22.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ClientDetailController.h"
#import "ZYFSaleList.h"
#import "ZYFGroup.h"
#import "ZYFForm.h"
#import "LookupController.h"
#import "CRMHelper.h"
#import "ListController.h"
#import "ZYFShowLongStringController.h"
#import "PostPhotoController.h"


@interface ClientDetailController () <ZYFShowLongStringControllerDelegate>

@end

@implementation ClientDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"客户信息";
//    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZYFGroup *group = [self.tableSearchSaleList.groupArray objectAtIndex:indexPath.section];
    ZYFForm *form = [group.formArray objectAtIndex:indexPath.row];
    ZYFAttributes *attr = [[ZYFAttributes alloc]init];
    attr = self.tableSearchSaleList.attrArray[indexPath.row];
    
    NSString *type = form.ColsType;
    ZYFLog(@"type==%@",form.ColsType);
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
    else if ([type isEqualToString:@"lookup"]){
        NSString *urlStr = @"";
        NSString *schemName = form.relateEntity.scheamname;
        NSString *urlString = [NSString stringWithFormat:@"%@?%@=%@&formxml=%@&entityid=%@",urlStr,schemName,attr.lookUp.Id,form.relateEntity.formxml,attr.lookUp.Id];
        
        LookupController *lookupCtrl = [[LookupController alloc]init];
        lookupCtrl.urlString = [CRMHelper translateRegularUrlWithString:urlString];
        [self.navigationController pushViewController:lookupCtrl animated:YES];
    }
    //如果类型是类似于日志明细类的list类型
   else if ([type isEqualToString:@"list"]) {
        NSString *urlStr = @"";
        NSString *schemName = form.relateEntity.scheamname;
        NSString *entityId = self.tableSearchSaleList.Id;
        NSString *urlString = [NSString stringWithFormat:@"%@?formxml=%@&logicalname=%@&%@=%@",urlStr,form.relateEntity.formxml,form.relateEntity.logicalname,schemName,entityId];
        ListController *listCtrl = [[ListController alloc]init];
        listCtrl.urlString = [CRMHelper translateRegularUrlWithString:urlString];
        [self.navigationController pushViewController:listCtrl animated:YES];
    }
    else if ([type isEqualToString:@"picklist"]) {
        
    }
    else if ([type isEqualToString:@"money"]) {
        
    }else if ([type isEqualToString:@"img"]){
        //上传照片
        PostPhotoController *ctrl = [[PostPhotoController alloc]init];
        //            ctrl.cleanTaskId = self.saleList.Id;
//        NSString *urlStr = kPostPhotoAfterSale;
        NSString *urlStr = @"";
//        NSString *urlString = [NSString stringWithFormat:@"%@?action=task&entityname=new_customer_service_require&id=%@",urlStr,self.saleList.Id];
        NSString *urlString = @"";
        ctrl.urlString = urlString;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else{
        ZYFShowLongStringController *ctrl = [[ZYFShowLongStringController alloc]init];
        ctrl.textString = attr.myValueString;
        ctrl.editable = YES;
        ctrl.indexPath = indexPath;
        ctrl.delegate = self;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

#pragma mark - ZYFShowLongStringControllerDelegate
- (void)showLongStringController:(ZYFShowLongStringController *)ctrl editString:(NSString *)editString
{
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ctrl.indexPath];
    cell.detailTextLabel.text = editString;
}

@end
