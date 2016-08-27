//
//  SHTiaoZhuanViewController.m
//  telecom
//
//  Created by Sundear on 16/2/24.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SHTiaoZhuanViewController.h"

@interface SHTiaoZhuanViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *tab;
}

@end

@implementation SHTiaoZhuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
}
-(void)setupTable{
    tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tab.dataSource = self;
    tab.delegate = self;
    tab.rowHeight=40;
    tab.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tab];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.DeleArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"shaixuan12";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.DeleArray[indexPath.row][@"name"];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate Select:self.DeleArray[indexPath.row][@"name"] withID:self.DeleArray[indexPath.row][@"id"]And:indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
