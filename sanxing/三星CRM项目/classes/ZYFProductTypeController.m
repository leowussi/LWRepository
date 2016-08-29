//
//  ZYFProductTypeController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/9/30.
//  Copyright © 2015年 ZYF. All rights reserved.
//

#import "ZYFProductTypeController.h"
#import "ZYFHttpTool.h"
#import "ZYFUrl.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFAttributes.h"
#import "ZYFEditStringController.h"
#import "ZYFEditDateController.h"
#import "ZYFPickList.h"
#import "ZYFEditLookupController.h"
#import "ZYFSaleList.h"


@interface ZYFProductTypeController ()

@property (nonatomic,strong) NSArray *productTypes;

@property (nonatomic,strong) ZYFDisplayCols *displayCols;

@end

@implementation ZYFProductTypeController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"产品型号"];
    [self getLogsFromServer];
}

-(void)getLogsFromServer
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSString *urlStr = kProdcutType ;
    NSString *urlString = [NSString stringWithFormat:@"%@",urlStr];
    
    [ZYFHttpTool getWithURLCacheXML:urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.productTypes = json;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.productTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"servicecontent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    //工作内容对应的sale
    ZYFSaleList *sale = [self.productTypes objectAtIndex:indexPath.row];
    
    if (sale == nil) {
        
    }else{
        if (sale.attrArray) {
            ZYFAttributes *attr = [sale.attrArray firstObject];
            cell.textLabel.text = attr.myValueString;
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //1、参数1
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //选中的行的text文本
    NSString *rowText = cell.textLabel.text;
    if (self.productType) {
        self.productType(rowText);
    }
    [self.navigationController popViewControllerAnimated:YES];

}

@end
