//
//  VehicleReservationRecord.m
//  telecom
//
//  Created by SD0025A on 16/7/19.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//车辆预约记录

#import "VehicleReservationRecord.h"
#import "VehicleReservationRecordCell.h"
#import "VehicleReservationRecordModel.h"
#import "VehicleReservationRecordFilter.h"//筛选
#import "EditorUserDetailController.h"//编辑使用人
#import "AutomobileRecorderController.h"//行车记录
#import "VehicleReservationsDetailController.h"//车辆预约详情
#import "EditDrivingRecordController.h" //编辑行车记录
#import "NewCarsAppointmentController.h"//新增车辆预约


@interface VehicleReservationRecord ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation VehicleReservationRecord

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self downloadData];
    
}
- (void)downloadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[URL_TYPE] = nil;
}
- (void)createUI
{
    self.navigationItem.title = @"车辆预约记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = COLOR(241, 241, 241);
    //导航栏右边item//Filter
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setImage:[UIImage imageNamed:@"nav_filter@2x"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(filterStatus:)  forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    //UItableView
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APP_W, APP_H-64) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.backgroundColor = COLOR(241, 241, 241);
    [self.view addSubview:self.table];
}
- (void)filterStatus:(UIButton *)btn
{
    VehicleReservationRecordFilter *ctrl = [[VehicleReservationRecordFilter alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellId = @"vehicleReservationRecordCell";
    VehicleReservationRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VehicleReservationRecordCell" owner:nil options:nil] lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = COLOR(241, 241, 241);
    return cell;
}
//详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row%5 == 0) {
        EditorUserDetailController *ctrl = [[EditorUserDetailController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if(indexPath.row%5 == 1){
        AutomobileRecorderController *ctrl = [[AutomobileRecorderController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (indexPath.row %5 == 2){
        VehicleReservationsDetailController *ctrl = [[VehicleReservationsDetailController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (indexPath.row %5 == 3){
        EditDrivingRecordController *ctrl = [[EditDrivingRecordController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (indexPath.row %5 == 4){
        NewCarsAppointmentController *ctrl = [[NewCarsAppointmentController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}
@end
