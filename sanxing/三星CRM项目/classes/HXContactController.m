//
//  HXContactController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/9/29.
//  Copyright © 2015年 ZYF. All rights reserved.
//

#import "HXContactController.h"
#import "ZYFSaleList.h"
#import "ClientDetailController.h"

@interface HXContactController ()

@end

@implementation HXContactController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClient)];
    addItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = addItem;
    
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"联系人";
}

- (void)addClient
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ClientDetailController *ctrl = [[ClientDetailController alloc]init];
    ZYFSaleList *sale = [[ZYFSaleList alloc]init];
    if (indexPath.row <= self.listData.count - 1) {
        sale = [self.listData objectAtIndex:indexPath.row];
    }
    
    ctrl.tableSearchSaleList = sale;
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end
