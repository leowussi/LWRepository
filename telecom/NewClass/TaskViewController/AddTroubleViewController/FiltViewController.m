//
//  FiltViewController.m
//  telecom
//
//  Created by Sundear on 16/2/19.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "FiltViewController.h"

@interface FiltViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation FiltViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *FiltableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    FiltableView.rowHeight=40;
    FiltableView.delegate=self;
    FiltableView.dataSource = self;
    [self.view addSubview:FiltableView];
    [self addNavigationLeftButton];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"filterview";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    cell.textLabel.text = self.array[indexPath.row][@"name"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.bloc(self.array[indexPath.row][@"name"],self.array[indexPath.row][@"id"]);
    [self.navigationController popViewControllerAnimated:YES];

}


@end
