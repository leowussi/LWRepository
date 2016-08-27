//
//  ZiChanViewController.m
//  telecom
//
//  Created by Sundear on 16/4/11.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "ZiChanViewController.h"
#import "ZIChanTableViewCell.h"
#import "MJExtension.h"
#import "ZiChanModel.h"
#import "ZiChanTabViewDetailVc.h"
#import "ZiChanShaiXuanViewController.h"

@interface ZiChanViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
   
}

@property(nonatomic,strong)UITableView *myTableview;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSString *assetDes;

@end
static NSString *ID = @"ZIChanTableViewCellID";
@implementation ZiChanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资产查询";
    UIView *searchView =  [self SetsSearchBarWithPlachTitle:@"请输入资产编号"];
    
    
    UIButton* filter = [[UIButton alloc] initWithFrame:RECT((APP_W-10-30), (NAV_H-30)/2, 30, 30)];
    [filter setBackgroundImage: [UIImage imageNamed:@"shaixuan.png"] forState:UIControlStateNormal];
    [filter setBackgroundImage:[UIImage imageNamed:@"filter2"] forState:UIControlStateSelected];
    filter.selected = [self hadFilterCondition];
    [filter addTarget:self action:@selector(onFilterBtnTouched) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnItem1 = [[UIBarButtonItem alloc] initWithCustomView:filter];
    self.navigationItem.rightBarButtonItem = barBtnItem1;
    
    [self.view addSubview:searchView];
    self.myTableview.y = CGRectGetMaxY(searchView.frame)+5;
    self.myTableview.height = kScreenHeight-self.myTableview.y-10;
    [self.myTableview registerNib:[UINib nibWithNibName:@"ZIChanTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
}

//判断本地是否有筛选条件
- (BOOL)hadFilterCondition
{
    NSDictionary *conditionDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchAssetSummary"];
    if (conditionDict == nil || conditionDict.count == 0) {
        return NO;
    }
    for (NSString *key in conditionDict) {
        NSString *obj = [conditionDict objectForKey:key];
        if (!(obj == nil || [obj isEqualToString:@""])) {
            return YES;
        }
    }
    return NO;
}

//设置导航条右侧的图片
- (void)setRightNavigationItemImage
{
    UIButton *button = self.navigationItem.rightBarButtonItem.customView;
    button.selected = [self hadFilterCondition];
}

#pragma mark 筛选按钮
-(void)onFilterBtnTouched{
    ZiChanShaiXuanViewController *vc  =[[ZiChanShaiXuanViewController alloc]init];
    vc.block = ^{
        [self httpSend];
        [self setRightNavigationItemImage];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)httpSend{
    [self.view endEditing:YES];
    NSDictionary *conditionDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"SearchAssetSummary"];
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"asset/SearchAssetSummary";
    
    paraDict[@"assetDes"] = [conditionDict objectForKey:@"asset0"];
    paraDict[@"resId"] = [conditionDict objectForKey:@"asset1"];
    paraDict[@"address"] = [conditionDict objectForKey:@"asset2"];
    paraDict[@"remark"] = [conditionDict objectForKey:@"asset3"];
    paraDict[@"sumLXMJ"] = [conditionDict objectForKey:@"asset4"];
    paraDict[@"typeSpec"] = [conditionDict objectForKey:@"asset5"];
    paraDict[@"assetsNumber"] = self.assetDes;
        httpPOST2(paraDict, ^(id result) {
            NSArray *listArray = result[@"list"];
            if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]&& listArray.count == 0) {
                [self showAlertWithTitle:@"提示" :@"没有符合条件的数据" :@"确定" :nil];
            }else {
                NSString *searchResult = [[result objectForKey:@"list"][0] objectForKey:@"searchResult"];
                if ([searchResult isEqualToString:@"1"]) {
                    [self showAlertWithTitle:@"提示" :@"查询结果太多,请输入更多的检索内容！" :@"确定" :nil];
                }
            }
            self.dataArray = [ZiChanModel objectArrayWithKeyValuesArray:result[@"list"]];
            [_myTableview reloadData];
        }, ^(id result) {
            NSLog(@"%@",result);
            showAlert(@"查询不到相关资产，请确认搜索条件");
        });
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZIChanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ZiChanTabViewDetailVc *vc = [[ZiChanTabViewDetailVc alloc]init];
    vc.model = self.dataArray[indexPath.row];
    vc.mark=YES;
    [self.navigationController pushViewController:vc animated:YES];

}



-(void)searchBtn{
    [self httpSend];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.assetDes = textField.text;
    if (textField.text==nil || [textField.text isEqualToString:@""]) {}else{
    [self httpSend];
    }
}

-(UITableView *)myTableview{
    if (!_myTableview) {
        _myTableview = [[UITableView alloc]initWithFrame:CGRectMake(5, 70, kScreenWidth-10, kScreenHeight-5-70) style:UITableViewStylePlain];
        _myTableview.dataSource =self;
        _myTableview.delegate =self;
        _myTableview.rowHeight = 187;
        _myTableview.backgroundColor = [UIColor clearColor];
        _baseScrollView.backgroundColor =RGBCOLOR(249, 249, 249);
        [self.view addSubview:_myTableview];
    }
    return _myTableview;
}
@end
