//
//  RequestSupportViewController.m
//  telecom
//
//  Created by SD0025A on 16/5/24.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//现场请求支撑清单  界面

#import "RequestSupportViewController.h"
#import "RequestSupportCell.h"
#import "RequestSupportModel.h"
#import "RequestSupportDetailController.h"
#import "AddRequestSupportController.h" //新增请求支撑界面
#define AddRequestListUrl   @"task/SearchSupportTask"
@interface RequestSupportViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *m_table;
@property (nonatomic,strong) UIView *menuList;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,copy) NSString *taskStatus;
@property (nonatomic,strong) UIView *siftList;//筛选条件
@end

@implementation RequestSupportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downloadDataWithKeywords:nil];
}
- (void)downloadDataWithKeywords:(NSString *)words
{
    [self.dataArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[URL_TYPE] = AddRequestListUrl;
    params[@"taskNo"] = words;
    params[@"taskStatus"] = self.taskStatus;
    httpGET2(params, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *array = result[@"list"];
            self.dataArray = [RequestSupportModel arrayOfModelsFromDictionaries:array error:nil];
            [self.m_table reloadData];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
        [self.m_table reloadData];
    });
    
    
}
#pragma mark - UITextField 代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //搜索
    NSLog(@"搜索");
    [self downloadDataWithKeywords:textField.text];
    [textField resignFirstResponder];
    return YES;
}
- (void)searchBtn
{
    //搜索按钮
    UITextField *field = (UITextField *)[self.searchView viewWithTag:500];
    [self downloadDataWithKeywords:field.text];
    [field resignFirstResponder];
    NSLog(@"搜索按钮被点击");
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)createUI
{
    self.view.backgroundColor =COLOR(247, 247, 247);
    self.navigationItem.title = @"请求支撑清单";
    
    //搜索条
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.searchView = [self SetsSearchBarWithPlachTitle:@" "];
    
    [self.view addSubview:self.searchView];
    [self createLeftListView];
    //创建TableView
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(10,(self.searchView.size.height+self.searchView.origin.y+5), APP_W-20, APP_H-NAV_H-64-5 )style:UITableViewStylePlain];
    self.m_table.delegate = self;
    self.m_table.dataSource = self;
    [self.view addSubview:self.m_table];
    //导航栏右边按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"button_main_zoomin_disable@3x"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(menuList:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *addRequestItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem = addRequestItem;
    
    //手机端请求支撑列表增加任务状态筛选条件
    UIButton *menuList = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuList setBackgroundImage:[UIImage imageNamed:@"信息1.png"] forState:UIControlStateNormal];//信息1.png
    [menuList addTarget:self action:@selector(sift:) forControlEvents:UIControlEventTouchUpInside];
    menuList.frame = CGRectMake(0, 0, 20, 20);
    UIBarButtonItem *menuListItem = [[UIBarButtonItem alloc] initWithCustomView:menuList];
    
    self.navigationItem.rightBarButtonItems = @[addRequestItem,menuListItem];
    [self createRightListView];
    [self createLeftListView];
}
// 筛选
- (void)sift:(UIButton *)btn
{
    if (self.siftList.frame.origin.x == APP_W) {
        [UIView animateWithDuration:0.5 animations:^{
            self.siftList.frame = CGRectMake(APP_W-120, STATUS_H+NAV_H, 120, 120);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.menuList.frame = CGRectMake(APP_W, STATUS_H+NAV_H, 120, 30);
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.siftList.frame = CGRectMake(APP_W, STATUS_H+NAV_H, 120, 120);
        }];
    }
    
}
- (void)createLeftListView
{
    self.siftList = [[UIView alloc] initWithFrame:CGRectMake(APP_W, STATUS_H+NAV_H, 120, 120)];
    self.siftList.backgroundColor = COLOR(239, 239, 239);
    self.siftList.layer.borderWidth = 1;
    self.siftList.layer.borderColor = COLOR(239, 239, 239).CGColor;
    [self.view addSubview:self.siftList];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"待执行" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 120, 30);
    [btn1 addTarget:self action:@selector(chooseSift:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 201;
    [self.siftList addSubview:btn1];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 120, 1)];
    lineView1.backgroundColor = [UIColor grayColor];
    lineView1.alpha = 0.5;
    [self.siftList addSubview:lineView1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"执行中" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(0, 30, 120, 30);
    [btn2 addTarget:self action:@selector(chooseSift:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 202;
    [self.siftList addSubview:btn2];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 120, 1)];
    lineView2.backgroundColor = [UIColor grayColor];
    lineView2.alpha = 0.5;
    [self.siftList addSubview:lineView2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn3 setTitle:@"已执行待点评" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.frame = CGRectMake(0, 60, 120, 30);
    [btn3 addTarget:self action:@selector(chooseSift:) forControlEvents:UIControlEventTouchUpInside];
    btn3.tag = 203;
    [self.siftList addSubview:btn3];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 89, 120, 1)];
    lineView3.backgroundColor = [UIColor grayColor];
    lineView3.alpha = 0.5;
    [self.siftList addSubview:lineView3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn4 setTitle:@"已点评" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn4.frame = CGRectMake(0, 90, 120, 30);
    [btn4 addTarget:self action:@selector(chooseSift:) forControlEvents:UIControlEventTouchUpInside];
    btn4.tag = 204;
    [self.siftList addSubview:btn4];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 119, 120, 1)];
    lineView4.backgroundColor = [UIColor grayColor];
    lineView4.alpha = 0.5;
    [self.siftList addSubview:lineView4];
    
    [self.view bringSubviewToFront:self.siftList];
}
#pragma mark - 选择筛选条件
- (void)chooseSift:(UIButton *)btn
{
    self.taskStatus = [NSString stringWithFormat:@"%d",(btn.tag - 201)];
    [UIView animateWithDuration:0.5 animations:^{
        self.siftList.frame = CGRectMake(APP_W, STATUS_H+NAV_H, 120, 120);
    }];
    [self downloadDataWithKeywords:nil];
}

- (void)createRightListView
{
    self.menuList = [[UIView alloc] initWithFrame:CGRectMake(APP_W, STATUS_H+NAV_H, 120, 30)];
    self.menuList.backgroundColor = COLOR(239, 239, 239);
    self.menuList.layer.borderWidth = 1;
    self.menuList.layer.borderColor = COLOR(239, 239, 239).CGColor;
    [self.view addSubview:self.menuList];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"新增请求支撑" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 120, 30);
    [btn1 addTarget:self action:@selector(addRequestBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 101;
    [self.menuList addSubview:btn1];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 120, 1)];
    lineView1.backgroundColor = [UIColor grayColor];
    lineView1.alpha = 0.5;
    [self.menuList addSubview:lineView1];
}
- (void)addRequestBtn:(UIButton *)btn
{
    //新增请求支撑
    AddRequestSupportController *ctrl = [[AddRequestSupportController alloc] init];
    ctrl.source = self.source;
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (void)menuList:(UIButton *)btn
{
    //展开导航菜单栏
    if (self.menuList.frame.origin.x == APP_W) {
        [UIView animateWithDuration:0.5 animations:^{
            self.menuList.frame = CGRectMake(APP_W-120, STATUS_H+NAV_H, 120, 30);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.siftList.frame = CGRectMake(APP_W, STATUS_H+NAV_H, 120, 120);
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.menuList.frame = CGRectMake(APP_W, STATUS_H+NAV_H, 120, 30);
        }];
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark - UITableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"RequestSupportCell";
    RequestSupportCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RequestSupportCell" owner:self options:nil]lastObject];
    }
    RequestSupportModel *model = self.dataArray[indexPath.row];
    [cell configModel:model];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RequestSupportDetailController *ctrl = [[RequestSupportDetailController alloc] init];
    RequestSupportModel *model = self.dataArray[indexPath.row];
    ctrl.taskId = model.taskId;
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end
