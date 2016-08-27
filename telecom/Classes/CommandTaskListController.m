//
//  CommandTaskListController.m
//  telecom
//
//  Created by SD0025A on 16/5/11.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "CommandTaskListController.h"
#import "CommandTaskListCell.h"
#import "CommandTaskListModel.h"
#import "StandardizeViewController.h"
#import "CommandTaskDetailController.h"
#define CommandTaskListUrl  @"task/SearchSubTaskInfo"
@interface CommandTaskListController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *m_table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIView *searchView;//搜索条
@end

@implementation CommandTaskListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self downloadDataWithKeywords:nil];
}
- (void)downloadDataWithKeywords:(NSString *)words;
{
    [self.dataArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[URL_TYPE] = CommandTaskListUrl;
    params[@"taskNo"] = words;
    httpGET2(params, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *array = result[@"list"];
            self.dataArray = [CommandTaskListModel arrayOfModelsFromDictionaries:array error:nil];
            
            [self.m_table reloadData];
        }

    }, ^(id result) {
        showAlert(result[@"error"]);
        [self.m_table reloadData];
    });
}
- (void)createUI
{
    self.view.backgroundColor =COLOR(247, 247, 247);
    [self addNavTitle:@"指挥任务清单"];

//    //搜索条
    self.automaticallyAdjustsScrollViewInsets = NO;
   self.searchView  = [self SetsSearchBarWithPlachTitle:@" "];
    
    [self.view addSubview:self.searchView];

    //创建TableView
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(10,(self.searchView.size.height+self.searchView.origin.y+5), APP_W-20, APP_H-NAV_H-64-5 )style:UITableViewStylePlain];
    self.m_table.delegate = self;
    self.m_table.dataSource = self;
    [self.view addSubview:self.m_table];
    //增加标准化手册按钮
    UIImage* Icon = [UIImage imageNamed:@"wenhao.png"];
    UIButton* standardizeBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-170), 7,30, 30)];
    [standardizeBtn setImage:[Icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    standardizeBtn.titleLabel.font = FontB(Font3);
    [standardizeBtn addTarget:self action:@selector(standardize:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *standardizeItem = [[UIBarButtonItem alloc] initWithCustomView:standardizeBtn];
    self.navigationItem.rightBarButtonItem = standardizeItem;
    
}
- (void)standardize:(UIButton *)btn
{
    StandardizeViewController *ctrl = [[StandardizeViewController alloc] init];
    NSString *urlStr = [[NSString stringWithFormat:@"http://%@/doc-app/doc/p/search.do?key=&and=指挥任务",ADDR_IP] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    ctrl.request = request;
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - UITextField 代理 
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   //搜索
     NSLog(@"搜索");
    [textField resignFirstResponder];
    [self downloadDataWithKeywords:textField.text];
    
    return YES;
}
- (void)searchBtn
{
    //搜索按钮
    UITextField *field = (UITextField *)[self.searchView viewWithTag:500];
    [field resignFirstResponder];
    [self downloadDataWithKeywords:field.text];
    NSLog(@"搜索按钮被点击");
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
    return 150;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"CommandTaskListCell";
    CommandTaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommandTaskListCell" owner:self options:nil]lastObject];
    }
    CommandTaskListModel *model = self.dataArray[indexPath.row];
    [cell configModel:model];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommandTaskDetailController *ctrl = [[CommandTaskDetailController alloc] init];
    CommandTaskListModel *model = self.dataArray[indexPath.row];
    ctrl.taskId = model.taskId;
    ctrl.upTaskId = model.upTaskId;
    [self.navigationController pushViewController:ctrl animated:YES];
}
@end
