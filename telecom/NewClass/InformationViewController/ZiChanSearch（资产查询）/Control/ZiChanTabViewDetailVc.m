//
//  ZiChanTabViewDetailVc.m
//  telecom
//
//  Created by Sundear on 16/4/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "ZiChanTabViewDetailVc.h"
#import "ZIChanTableDetailViewCell.h"
#import "MJExtension.h"
#import "RootTAMViewController.h"
#import "ZiChanDetailModel.h"
#import "RightViewController.h"

@interface ZiChanTabViewDetailVc ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *myTableView;
@end
static NSString *ID = @"ZIChanTableDetailViewCellID";
@implementation ZiChanTabViewDetailVc

-(UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:RECT(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _myTableView.delegate =self;
        _myTableView.dataSource= self;
        [_myTableView registerNib:[UINib nibWithNibName:@"ZIChanTableDetailViewCell" bundle:nil] forCellReuseIdentifier:ID];
        _myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
       
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资产详细";
    [self.view addSubview:self.myTableView];
    
    [self httpSend];
}
-(void)httpSend{
    NSMutableDictionary *par = [NSMutableDictionary dictionary];
    [self.view insertSubview:_baseScrollView atIndex:0];
    par[URL_TYPE] = @"asset/SearchAssetDetail";
    if ([_type isEqualToString:@"2"]) {
        _assetDes = [NSString stringWithFormat:@"000000%@",_assetDes];
    }
    if (self.assetDes == nil) {
       par[@"assetNum"] = self.model.assetsNumber;
    }else{
        par[@"assetNum"] = self.assetDes;
    }
    par[@"type"] = _type;
    httpPOST2(par, ^(id result) {
        NSArray *listArray = result[@"list"];
        if ([result objectForKey:@"result"] && listArray.count == 0) {
            [self showAlertWithTitle:@"提示" :@"查询不到该条资产信息" :@"确认" :nil];
            return ;
        }
        self.dataArray = [ZiChanDetailModel objectArrayWithKeyValuesArray:result[@"list"]];
        [_myTableView reloadData];
    }, ^(id result) {
        NSLog(@"%@",result);
    });
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZIChanTableDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iOSv7) {
        return 570;
    }else{
    ZiChanDetailModel *model = self.dataArray[indexPath.row];
        return model.high;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)leftAction{
    
    if (self.mark == NO) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)dealloc{
    
}

@end
