//
//  VehicleReservationRecordFilter.m
//  telecom
//
//  Created by SD0025A on 16/7/20.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//筛选

#import "VehicleReservationRecordFilter.h"
#import "Masonry.h"

@interface VehicleReservationRecordFilter ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *statusArray;
@end

@implementation VehicleReservationRecordFilter

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *array = @[@"预约未审核",@"预约审核通过",@"预约审核不通过",@"记录未审核",@"记录审核不通过",@"已归档（记录审核通过）",@"已取消"];
    NSArray *status = @[@"0",@"0",@"0",@"0",@"0",@"0",@"0"];
    [self.statusArray addObjectsFromArray:status];
    [self.dataArray addObjectsFromArray:array];
    [self createUI];
    
}
- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)statusArray
{
    if (nil == _statusArray) {
        _statusArray = [NSMutableArray array];
    }
    return _statusArray;
}

- (void)createUI
{
    self.navigationItem.title = @"筛选";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //右边item
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"checkBtn"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    //创建tableview
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APP_W, APP_H- 64) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, APP_W, 30)];
    header.backgroundColor = COLOR(221, 221, 221);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
    titleLabel.text = @"车辆预约状态";
    titleLabel.font = [UIFont systemFontOfSize:16];
    [header addSubview:titleLabel];
    self.table.tableHeaderView = header;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *staus = self.statusArray[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([staus isEqualToString:@"0"]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 200;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(30));
            make.height.equalTo(@(30));
            make.top.equalTo(cell.contentView.mas_top).offset(0);
            make.right.equalTo(cell.contentView.mas_right).offset(-10);
        }];
        imageView.image = [UIImage imageNamed:@"check_ok@2x"];
        [self.statusArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }else{
        UIImageView *imageView = (id)[cell.contentView viewWithTag:200];
        [imageView removeFromSuperview];
        [self.statusArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
   
}
@end
