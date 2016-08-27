//
//  LiuZhuangLogViewController.m
//  telecom
//
//  Created by Sundear on 16/1/18.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "LiuZhuangLogViewController.h"
#import "LiuZhuangTableViewCell.h"

@interface LiuZhuangLogViewController ()<UITableViewDelegate,UITableViewDataSource>{
    UITableView *myTableView;
}

@end

@implementation LiuZhuangLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 20,[UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.rowHeight=79;
    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    
    if (iOSv6) {
        myTableView.contentInset = UIEdgeInsetsMake(0, 0, 124, 0);
    }
    myTableView.bounces=NO;
    [self.view addSubview:myTableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.LiuZhuznagArray.count;
    DLog(@"%@",self.LiuZhuznagArray);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiuZhuangTableViewCell *cell = [LiuZhuangTableViewCell tabcell:tableView];
    cell.model=self.LiuZhuznagArray[indexPath.row];
    return cell;
}

@end
