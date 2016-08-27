//
//  YZLiuShuiViewController.m
//  telecom
//
//  Created by 锋 on 16/5/10.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZLiuShuiViewController.h"
#import "YZLiuShuiTableViewCell.h"

@interface YZLiuShuiViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YZLiuShuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _liuShuiArray = [[NSMutableArray alloc] initWithCapacity:0];
    _heightArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self loadData];
    [self createTableView];

}

- (void)loadData
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"adjustRes/QueryTransById";
    paraDict[@"id"] = _infoId;
    httpPOST(paraDict, ^(id result) {
        NSArray *listArray = [result objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
            NSLog(@"%@",result);
            YZLiuShuiInfo *info = [[YZLiuShuiInfo alloc] initWithParserDictionary:dict];
            [_liuShuiArray addObject:info];
            
            CGFloat height = [self calculateTextHeight:info.string_desc width:kScreenWidth - 60];
            [_heightArray addObject:@(height)];
            
        }
        [_tableView reloadData];
    }, ^(id result) {
        NSLog(@"%@",result);
    });
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 117) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 100;
    [self.view addSubview:_tableView];
}

#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _liuShuiArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZLiuShuiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liuShui"];
    if (!cell) {
        cell = [[YZLiuShuiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"liuShui"];
    }
    YZLiuShuiInfo *info = _liuShuiArray[indexPath.row];
    cell.label_department.text = info.string_department;
    cell.label_desc.text = info.string_desc;
    cell.label_status.text = info.string_status;
    cell.label_time.text = info.string_time;
    cell.label_desc.frame = CGRectMake(16, 30, kScreenWidth - 60, [_heightArray[indexPath.row] floatValue]);
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_heightArray[indexPath.row] floatValue] + 60;
}
#pragma mark -- 计算文字的高度
- (CGFloat)calculateTextHeight:(NSString *)text width:(CGFloat)width
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return ceilf(rect.size.height);
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
