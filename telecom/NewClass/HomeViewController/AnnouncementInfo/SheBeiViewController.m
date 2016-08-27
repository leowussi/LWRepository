//
//  SheBeiViewController.m
//  telecom
//
//  Created by Sundear on 16/1/15.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SheBeiViewController.h"
#import "SheBeiTableViewCell.h"

@interface SheBeiViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *myTableView;
}

@end

@implementation SheBeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 20,[UIScreen mainScreen].bounds.size.width-40, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.rowHeight=94;
    
    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    myTableView.bounces=NO;
    if (iOSv6) {
        myTableView.contentInset = UIEdgeInsetsMake(0, 0, 124, 0);//底部设置额外滚动区域  iPhone4 table显示不全
    }
    [self.view addSubview:myTableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shebeiArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SheBeiTableViewCell *cell = [SheBeiTableViewCell tabcell:tableView];
    cell.model=self.shebeiArray[indexPath.row];
    DLog(@"%@",self.shebeiArray[indexPath.row]);
    return cell;
}
@end
