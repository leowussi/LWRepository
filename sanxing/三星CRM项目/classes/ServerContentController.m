//
//  ServerContentController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ServerContentController.h"
#import "CRMHelper.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFUrl.h"
#import "ZYFHttpTool.h"

@interface ServerContentController ()

@property (nonatomic,strong) NSArray *serversData;

@end

@implementation ServerContentController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kSystemScreenWidth, kSystemScreenHeight) style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"服务内容"];
    

    [self getServersFromServer];
    
    
}

/**
 *  从服务器获取当前工单的服务内容
 */

-(void)getServersFromServer
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSString *urlStr = kServerContent;
    NSString *urlString = [NSString stringWithFormat:@"%@?page=1&id=%@",urlStr,self.saleList.Id];
    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.serversData = json;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.serversData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"servers";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    if (indexPath.section == 0) {
        ZYFSaleList *sale = [self.serversData objectAtIndex:indexPath.row];
//        for (ZYFFormattedValue *formate in sale.formatValueArray) {
//            if ([formate.myKey isEqualToString:@"new_name"]) {
//                UIFont *textLabelFont = [UIFont systemFontOfSize:24];
//                cell.textLabel.font = textLabelFont;
//                cell.textLabel.text = formate.myValueString;
//            }
//        }
        for (ZYFAttributes *attr in sale.attrArray) {
            if ([attr.myKey isEqualToString:@"new_name"]) {
                UIFont *textLabelFont = [UIFont systemFontOfSize:24];
                cell.textLabel.font = textLabelFont;
                cell.textLabel.text = attr.myValueString;
            }
            if ([attr.myKey isEqualToString:@"new_fill_in_request"]) {
                UIFont *detailFont = [UIFont systemFontOfSize:18];
                cell.detailTextLabel.font = detailFont;
                cell.detailTextLabel.textColor = [UIColor grayColor];
                cell.detailTextLabel.numberOfLines = 2;
                cell.detailTextLabel.text = attr.myValueString;

            }
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}



@end
