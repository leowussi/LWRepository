//
//  ShaiXuanViewController.m
//  telecom
//
//  Created by Sundear on 16/2/24.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "ShaiXuanViewController.h"
#import "SHTiaoZhuanViewController.h"

@interface ShaiXuanViewController ()<UITableViewDelegate,UITableViewDataSource,SHTiaoZhuanViewControllerDelegate>{
    UITableView *tab;
    NSArray *arr1;
    NSMutableString *param;
    NSMutableArray *QuanArray;
    NSMutableArray *IDArray;
    NSIndexPath *index;
}


@end

@implementation ShaiXuanViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    param = [NSMutableString string];
    [self setArray];
    [self setRightBtn];
    [self setupTable];
}

-(void)setArray{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"YinHuanShaiXuanArray"]==nil) {
        NSMutableArray *arrak = [NSMutableArray array];
        NSMutableArray *arrak1 = [NSMutableArray array];
        for (int i = 0; i<self.arr.count; i++) {
            [arrak addObject:self.arr[i][0][@"name"]];
            [arrak1 addObject:self.arr[i][0][@"id"]];
        }
        QuanArray = [[NSMutableArray alloc]initWithArray:arrak];//存放所有name
        IDArray = [[NSMutableArray alloc]initWithArray:arrak1];//存放所有id
        
    }else{
        NSArray *Sarr=[[NSUserDefaults standardUserDefaults]objectForKey:@"YinHuanShaiXuanArray"];
        QuanArray = [[NSMutableArray alloc]initWithArray:Sarr];
        NSArray *SarID=[[NSUserDefaults standardUserDefaults]objectForKey:@"IDShaiXuanArray"];
        IDArray = [[NSMutableArray alloc]initWithArray:SarID];
    }


}
-(void)setRightBtn{
    self.title = @"筛选";
    UIImage* clearIcon = [UIImage imageNamed:@"nav_clear.png"];
    UIButton* clearBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-clearIcon.size.width), (NAV_H-clearIcon.size.height)/2,
                                                              clearIcon.size.width, clearIcon.size.height)];
    [clearBtn setBackgroundImage:clearIcon forState:0];
    [clearBtn addTarget:self action:@selector(onClearBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem1 = [[UIBarButtonItem alloc] initWithCustomView:clearBtn];
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* checkBtn = [[UIButton alloc] initWithFrame:clearBtn.frame];
    checkBtn.fx = clearBtn.fx - 10 - checkIcon.size.width;
    [checkBtn setBackgroundImage:checkIcon forState:0];
    [checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItems = @[barBtnItem1,barBtnItem2];
}
-(void)onClearBtnTouched:(UIButton *)btn{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"YinHuanShaiXuan"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"YinHuanShaiXuanArray"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IDShaiXuanArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self leftAction];
    
}
-(void)onCheckBtnTouched:(UIButton *)btn{
    param = [IDArray componentsJoinedByString:@","];
    DLog(@"%@",param);
    [[NSUserDefaults standardUserDefaults]setObject:param forKey:@"YinHuanShaiXuan"];
    [[NSUserDefaults standardUserDefaults]setObject:QuanArray forKey:@"YinHuanShaiXuanArray"];
    [[NSUserDefaults standardUserDefaults]setObject:IDArray forKey:@"IDShaiXuanArray"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.ShaiXuan();
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupTable{
    tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    tab.dataSource = self;
    tab.delegate = self;
    tab.rowHeight = 40;
    tab.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tab];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"shaixuan";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        newLabel(cell, @[@51, RECT_OBJ(100, (tab.rowHeight-Font4)/2, 190, Font4), [UIColor blackColor], Font(Font4), QuanArray[indexPath.row]]).textAlignment = NSTextAlignmentRight;
        
    }
    
    arr1= @[@"部门",@"专业",@"隐患分类",@"隐患等级",@"隐患状态"];
    cell.textLabel.text = arr1[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SHTiaoZhuanViewController *vc = [[SHTiaoZhuanViewController alloc]init];
    vc.title =arr1[indexPath.row];
    vc.delegate = self;
    vc.DeleArray = self.arr[indexPath.row];
    index = indexPath;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)Select:(NSString *)str withID:(NSString *)par And:(NSIndexPath *)indexPath{
    ((UILabel*)[[tab cellForRowAtIndexPath:index] viewWithTag:51]).text =str;
    
    [QuanArray replaceObjectAtIndex:index.row withObject:str];
    [IDArray replaceObjectAtIndex:index.row withObject:par];

}


@end
