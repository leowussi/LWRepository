//
//  YZImageAccessoryViewController.m
//  telecom
//
//  Created by 锋 on 16/6/27.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZImageAccessoryViewController.h"
#import "YZImageAccessoryTableViewCell.h"
#import "YZResourcesInfoDetailTableViewCell.h"
#import "YZCheckImageViewController.h"

@interface YZImageAccessoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    
}
@end

@implementation YZImageAccessoryList

- (instancetype)initWithParserWithDictionary:(NSDictionary *)dict textColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        _time = [NSString stringWithFormat:@"上传时间:%@",[dict objectForKey:@"uploadTime"]];
        _name = [NSString stringWithFormat:@"上  传  人:%@",[dict objectForKey:@"uploadUserName"]];
        _accessoryName = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"    %@",[dict objectForKey:@"attachmentName"]] attributes:@{NSForegroundColorAttributeName:color,NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)}];
        _attachmentId = [dict objectForKey:@"attachmentId"];
    }
    
    return self;
}

@end

@implementation YZImageAccessoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"附件列表";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -33, kScreenWidth, kScreenHeight + 33) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 104;
    [self.view addSubview:_tableView];
    
    [self loadData];
    [self addNavigationLeftButton];
}
#pragma mark - 返回按钮
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(0, 7,navImg.size.width/1,navImg.size.height/1)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,44,44);
    //    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"riskOperation/QueryAttachmentList";
    paraDict[@"workNo"] = _workNo;
    NSLog(@"%@",paraDict);
    
    httpPOST(paraDict, ^(id result) {
        NSArray *listArray = [result objectForKey:@"list"];
        if (listArray.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有符合条件的数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else {
            UIColor *color = [UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1];

            for (NSDictionary *dict in listArray) {
                YZImageAccessoryList *list = [[YZImageAccessoryList alloc] initWithParserWithDictionary:dict textColor:color];
                [_dataArray addObject:list];
            }
        }
        [_tableView reloadData];
    }, ^(id result) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    });
    
}

#pragma mark -- tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZImageAccessoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (self) {
        cell = [[YZImageAccessoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    YZImageAccessoryList *list = _dataArray[indexPath.row];
    [cell.label_accessoryName setAttributedText:list.accessoryName];
    cell.label_time.text = list.time;
    cell.label_name.text = list.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZCheckImageViewController *imageVC = [[YZCheckImageViewController alloc] init];
    YZImageAccessoryList *list = _dataArray[indexPath.row];
    imageVC.workNo = _workNo;
    imageVC.attachmentId = list.attachmentId;
    [self.navigationController pushViewController:imageVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
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
