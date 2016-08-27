//
//  YZResourcesChangeSearchViewController.m
//  CheckResourcesChange
//
//  Created by 锋 on 16/4/29.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZResourcesChangeSearchViewController.h"
#import "YZSiftViewController.h"
#import "YZSearchResultTableViewCell.h"
#import "YZResourcesChangeDetailViewController.h"
#import "StandardizeViewController.h"

@interface YZResourcesChangeSearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_tableView;
    //搜索框
    UITextField *_seaFiled;
    
    NSMutableArray *_dataArray;
}
//记录筛选的条件
@property (nonatomic, strong) NSMutableDictionary *recordSelectedDict;

@end


@implementation YZResourcesChangeSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = RGBCOLOR(235, 238, 243);
    _baseScrollView.backgroundColor = RGBCOLOR(235, 238, 243);
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self setsSearchBarWithPlachTitle:@"请输入资源变更工单"];
    [self createRecordSelectedArray];
    [self createTableView];
    [self addBarButtonItem];
    [self addNavigationLeftButton];
}

- (void)addBarButtonItem
{
    self.navigationItem.title = @"资源变更工单查询";
    UIButton *rightItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemButton.frame = CGRectMake(0, 0, 30, 30);
    [rightItemButton setBackgroundImage:[UIImage imageNamed:@"nav_filter"] forState:UIControlStateNormal];
    [rightItemButton addTarget:self action:@selector(rightBarbuttonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightItemButton];
    
    //增加标准化手册按钮
    UIImage* icon = [UIImage imageNamed:@"wenhao.png"];
    UIButton* commitBtn3 = [[UIButton alloc] initWithFrame:RECT(0, 0,30, 30)];
    [commitBtn3 setImage:[icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    commitBtn3.titleLabel.font = FontB(Font3);
    [commitBtn3 addTarget:self action:@selector(standardize:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:commitBtn3];

    self.navigationItem.rightBarButtonItems = @[rightItem,item3];
    
}

//增加标准化手册
- (void)standardize:(UIButton *)btn
{
    StandardizeViewController *ctrl = [[StandardizeViewController alloc] init];
    NSString *urlStr = [[NSString stringWithFormat:@"http://%@/doc-app/doc/p/search.do?search.do?key=&and=现场资源管理",ADDR_IP] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    ctrl.request = request;
    [self.navigationController pushViewController:ctrl animated:YES];
}


- (void)rightBarbuttonItemClicked
{
    YZSiftViewController *siftVC = [[YZSiftViewController alloc] init];
    siftVC.recordSelectedDict = _recordSelectedDict;
    [self.navigationController pushViewController:siftVC animated:YES];
    
    siftVC.completionBlock = ^{
        
        [self searchBtn];
    };
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(12, 122, kScreenWidth - 24, kScreenHeight - 140) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1].CGColor;
    _tableView.layer.borderWidth = .5;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 74;
    [self.view addSubview:_tableView];
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YZSearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
     }
    cell.label_time.text = [_dataArray[indexPath.row] objectForKey:@"createtime"];
    cell.label_infoNumber.text = [_dataArray[indexPath.row] objectForKey:@"orderid"];
    cell.label_status.text =  [_dataArray[indexPath.row] objectForKey:@"status"];

    cell.label_taskType.text = [_dataArray[indexPath.row] objectForKey:@"major"];
    cell.label_profession.text = [_dataArray[indexPath.row] objectForKey:@"subtype"];
    cell.label_resoure.text = [_dataArray[indexPath.row] objectForKey:@"faulttype"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZResourcesChangeDetailViewController *detailVC = [[YZResourcesChangeDetailViewController alloc] init];
    detailVC.infoId = [_dataArray[indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

//搜索视图
- (void)setsSearchBarWithPlachTitle:(NSString *)str{
    UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectZero];
    rightLable.text = @"      ";
    [rightLable setFont:[UIFont systemFontOfSize:13.0]];
    rightLable.alpha = 0.5;
    [rightLable sizeToFit];
    
    _seaFiled = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-80, 28)];
    _seaFiled.backgroundColor = [UIColor whiteColor];
    _seaFiled.rightViewMode = UITextFieldViewModeAlways;
    _seaFiled.rightView = rightLable;
    _seaFiled.placeholder = str;
    _seaFiled.font = [UIFont systemFontOfSize:13.0];
    _seaFiled.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    _seaFiled.layer.borderWidth = 0.6f;
    _seaFiled.layer.cornerRadius = 14.0f;
    _seaFiled.delegate = self;
    _seaFiled.returnKeyType = UIReturnKeySearch;
    //    [self.view addSubview:seaFiled];
    
    UIImage *btnImg = [UIImage imageNamed:@"2.9.png"];
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:btnImg forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(kScreenWidth-30-btnImg.size.width, 0, btnImg.size.width/2, btnImg.size.height/1.9)];
    [searchBtn addTarget:self action:@selector(searchBtn) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:searchBtn];
    
    UIImage *seaImg = [UIImage imageNamed:@"sea.png"];
    UIImageView *seaImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, seaImg.size.width/2, seaImg.size.height/2)];
    seaImgView.image = seaImg;
    [searchBtn addSubview:seaImgView];
    
    
    UIView *backview = [[UIView alloc]init];
    backview.frame = CGRectMake(32, 80, kScreenWidth, 28);
    [backview addSubview:_seaFiled];
    [backview addSubview:searchBtn];
    [self.view addSubview:backview];

}
//搜索
- (void)searchBtn
{

    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"adjustRes/QueryAdjustResByConditions";
    paraDict[@"orderId"] = _seaFiled.text;
    if (!_recordSelectedDict) {
        [self createRecordSelectedArray];
    }
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    NSArray *array = [_recordSelectedDict objectForKey:@"0"];
    for (NSString * str in array) {
        [arr addObject:[NSString stringWithFormat:@"%d",[str integerValue] + 1]];
    }
    paraDict[@"subType"] = [arr componentsJoinedByString:@","];
    
    arr = [NSMutableArray arrayWithCapacity:0];
    array = [_recordSelectedDict objectForKey:@"1"];
    for (NSString * str in array) {
        [arr addObject:[NSString stringWithFormat:@"%d",[str integerValue] + 1]];
    }
    
    paraDict[@"major"] = [arr componentsJoinedByString:@","];
    
    arr = [NSMutableArray arrayWithCapacity:0];
    array = [_recordSelectedDict objectForKey:@"2"];
    for (NSString * str in array) {
        [arr addObject:[NSString stringWithFormat:@"%d",[str integerValue] + 1]];
    }
    
    paraDict[@"status"] = [arr componentsJoinedByString:@","];
    array = [_recordSelectedDict objectForKey:@"3"];
    paraDict[@"regoin"] = [[array lastObject] isEqualToString:@"3"] ? @"2" : [array lastObject];
    
    NSLog(@"%@",paraDict);
    httpPOST(paraDict, ^(id result) {
        if (![[result objectForKey:@"result"] isEqualToString:@"0000000"]){
            [self showAlertWithTitle:@"提示" :[result objectForKey:@"error"] :@"确定" :nil];
            return ;
        }
        NSArray *listArray = [result objectForKey:@"list"];
        [_dataArray removeAllObjects];

        if (listArray.count == 0) {
            [self showAlertWithTitle:@"提示" :@"没有符合条件的数据" :@"确定" :nil];
        }else {
        
            [_dataArray addObjectsFromArray:listArray];
            _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        }
        [_tableView reloadData];
    }, ^(id result) {
        NSLog(@"%@",result);
    });
}

//获取保存在本地的筛选条件
- (void)createRecordSelectedArray
{
    NSMutableDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"conditionSift"];
    if (dict == nil) {
        _recordSelectedDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }else{
        _recordSelectedDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (NSString *key in dict) {
            NSArray *array = [dict objectForKey:key];
            NSMutableArray *mutArray = [NSMutableArray arrayWithArray:array];
            [_recordSelectedDict setObject:mutArray forKey:key];
        };
    }
    
    
}

#pragma mark -- textField代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self searchBtn];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
