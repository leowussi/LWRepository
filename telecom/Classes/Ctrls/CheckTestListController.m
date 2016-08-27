//
//  CheckTestListController.m
//  telecom
//
//  Created by SD0025A on 16/4/7.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//查看测试单页面

#import "CheckTestListController.h"
#import "CheckTestListModel.h"
#import "CheckTestListCell.h"
#import "FeedbackAndReceiptController.h"
#define CheckTestListUrl  @"Medium/testOrderSee"
@interface CheckTestListController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIView *rightMenuList;
@property (nonatomic,strong) UITableView *m_table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation CheckTestListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downloadData];
}
- (void)downloadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[URL_TYPE] = CheckTestListUrl;
    param[@"type"] = @"open";
    param[@"workNo"] = self.workNo;
    httpGET2(param, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)result;
            if ([dict[@"return_data"] isKindOfClass:[NSArray class]]) {
                NSArray *array = dict[@"return_data"];
                self.dataArray = [CheckTestListModel arrayOfModelsFromDictionaries:array error:nil];
                [self.m_table reloadData];
            }
            
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    

}
- (void)createUI
{
    self.view.backgroundColor = COLOR(248, 248, 248);
    self.navigationItem.title = @"查看测试单";
    //创建菜单视图
    [self createList];
    //创建右边的导航栏item
    //创建导航栏右边的btn
    UIButton *listBtn = [[UIButton alloc] init];
    [listBtn setBackgroundImage:[UIImage imageNamed:@"信息1.png"] forState:UIControlStateNormal];
    listBtn.frame = CGRectMake(0, 0, 20, 20);
    [listBtn addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *listItem = [[UIBarButtonItem alloc] initWithCustomView:listBtn];
    self.navigationItem.rightBarButtonItem = listItem;
    
    //创建TableView
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(10, 74, APP_W-20, APP_H-84) style:UITableViewStylePlain];
    self.m_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.m_table.delegate = self;
    self.m_table.dataSource = self;
    self.m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.m_table];
    
}
- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)createList
{
    self.rightMenuList = [[UIView alloc] initWithFrame:CGRectMake(APP_W, STATUS_H+NAV_H, 120, 30)];
    self.rightMenuList.backgroundColor = COLOR(239, 239, 239);
    self.rightMenuList.layer.borderWidth = 1;
    self.rightMenuList.layer.borderColor = COLOR(239, 239, 239).CGColor;
    [self.view addSubview:self.rightMenuList];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"测试单反馈" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 120, 30);
    [btn1 addTarget:self action:@selector(clickTest:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 101;
    [self.rightMenuList addSubview:btn1];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 120, 1)];
    lineView1.backgroundColor = [UIColor grayColor];
    lineView1.alpha = 0.5;
    [self.rightMenuList addSubview:lineView1];
}
- (void)showList:(UIButton *)btn
{
    if (self.rightMenuList.frame.origin.x == APP_W) {
        [UIView animateWithDuration:0.5 animations:^{
            self.rightMenuList.frame = CGRectMake(APP_W - 120, self.rightMenuList.frame.origin.y, 120, 30);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.rightMenuList.frame = CGRectMake(APP_W, self.rightMenuList.frame.origin.y, 120, 30);
        }];
    }
    [self.view bringSubviewToFront:self.rightMenuList];

}
- (void)clickTest:(UIButton *)btn
{
    FeedbackAndReceiptController *TestFeedback = [[FeedbackAndReceiptController alloc] init];
    TestFeedback.workNo = self.workNo;
    TestFeedback.actionType = @"feedback";
    TestFeedback.type = @"testList";//测试单反馈
    [self.navigationController pushViewController:TestFeedback animated:YES];
    
    

}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"checkTestListCell";
    CheckTestListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CheckTestListCell" owner:self options:nil] lastObject];
    }
    CheckTestListModel *model = self.dataArray[indexPath.row];
    [cell configModel:model];
    return cell;

}
@end
