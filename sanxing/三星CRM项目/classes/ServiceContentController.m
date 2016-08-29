//
//  ServiceContentController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/12.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ServiceContentController.h"
#import "ZYFHttpTool.h"
#import "ZYFUrl.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFAttributes.h"
#import "ZYFEditStringController.h"
#import "ZYFEditDateController.h"
#import "ZYFPickList.h"
#import "ZYFEditLookupController.h"


@interface ServiceContentController ()

@property (nonatomic,strong) NSArray *serviceContents;

@property (nonatomic,strong) ZYFDisplayCols *displayCols;

@end

@implementation ServiceContentController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"服务内容"];
    [self getLogsFromServer];
}



-(void)getLogsFromServer
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSString *urlStr = kServiceContent;
    NSString *urlString = [NSString stringWithFormat:@"%@",urlStr];
    
    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.serviceContents = json;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.serviceContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *ID = @"servicecontent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    //工作内容对应的sale
    ZYFSaleList *sale = [self.serviceContents objectAtIndex:indexPath.row];
    
    if (sale == nil) {
        
    }else{
        for (ZYFAttributes *attr in sale.attrArray) {
            
            if ([attr.myKey isEqualToString:@"new_name"]) {
                cell.textLabel.text = attr.myValueString;
            }
            if ([attr.myKey isEqualToString:@"new_type"]) {
                if (attr.myValueString) {
                    cell.detailTextLabel.text = attr.myValueString;
                }else if(attr.lookUp){
                    cell.detailTextLabel.text = attr.lookUp.Name;
                }else if (attr.pickList){
                    //如果是picklist类型，从formattedValue中（格式化后的）来显示
                    for (ZYFFormattedValue *format in sale.formatValueArray) {
                        if ([format.myKey isEqualToString:attr.myKey]) {
                            cell.detailTextLabel.text = format.myValueString;
                        }
                    }
                }else{
                    //如果是date类型，从formattedValue中（格式化后的）来显示
                    for (ZYFFormattedValue *format in sale.formatValueArray) {
                        if ([format.myKey isEqualToString:attr.myKey]) {
                            cell.detailTextLabel.text = format.myValueString;
                        }
                    }
                }
            }
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
    //2、参数2
    NSString *serviceIntro = @"";
    //3、参数3
    BOOL isNum = false;
    ZYFSaleList *sale = [self.serviceContents objectAtIndex:indexPath.row];
    for (ZYFAttributes *attr in sale.attrArray) {
        if ([attr.myKey isEqualToString:@"new_fill_in_request"]) {
            //参数2
            serviceIntro = attr.myValueString;
        }
    }

    //以实际数量为准
    if ([cell.detailTextLabel.text isEqualToString:@"实际数量为准"]) {
        isNum = YES;
    }else{
        isNum = NO;
    }
    if ([self.delegate respondsToSelector:@selector(serviceContentController:saleList:)]) {
        ZYFSaleList *sale = [self.serviceContents objectAtIndex:indexPath.row];
        // 把当前控制前对应的saleList传出去
        [self.delegate serviceContentController:self saleList:sale];
    }
    
    if ([self.delegate respondsToSelector:@selector(serviceContentController:didSelectedRow:serviceIntro:isNum:)]) {
        [self.delegate serviceContentController:self didSelectedRow:rowText serviceIntro:serviceIntro isNum:isNum];
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}


@end
