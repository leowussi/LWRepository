//
//  RequestSupportDetailController.m
//  telecom
//
//  Created by SD0025A on 16/5/24.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "RequestSupportDetailController.h"
#import "RequestSupportDetailCell.h"
#import "RequestSupportDetailModel.h"
#import "AddRequestCommentController.h"
#import "UIImageView+WebCache.h"
#import "TaskDetailInRequestSupportDetail.h"
#import "TaskDetailInRequestSupportDetailCell.h"
#import "WebViewController.h"
#define RequestSupportDetail  @"task/SearchSupportTaskInfo"
#define LookTaskDetail       @"task/SearchSupportTaskImplInfo"
@interface RequestSupportDetailController ()<UITableViewDataSource,UITableViewDelegate,RequestSupportDetailCellDelegate>
@property (nonatomic,strong) UITableView *m_table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *taskArray;
@property (nonatomic,strong) UIButton *commentBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) NSMutableArray *photoArray;
@end

@implementation RequestSupportDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadData];
    [self createUI];
    
}
- (void)downloadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[URL_TYPE] = RequestSupportDetail;
    params[@"taskId"] = self.taskId;
    httpGET2(params, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = result[@"detail"];
            RequestSupportDetailModel *model = [[RequestSupportDetailModel alloc] initWithDictionary:dict error:nil];
            [self.dataArray addObject:model];
            [self.m_table reloadData];
            if ([model.status isEqualToString:@"2"]) {
                //点评
                self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.commentBtn setTitle:@"点评" forState:UIControlStateNormal];
                [self.commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.commentBtn.frame = CGRectMake(30, self.m_table.origin.y+self.m_table.size.height+25, 60, 30);
                self.commentBtn.backgroundColor = COLOR(66, 123, 196);
                [self.commentBtn addTarget:self action:@selector(comment:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.commentBtn];
                
                //取消
                self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.cancelBtn.frame = CGRectMake(APP_W-30-60, self.m_table.origin.y+self.m_table.size.height+25, 60, 30);
                self.cancelBtn.backgroundColor = COLOR(0, 183, 70);
                [self.cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.cancelBtn];
            }else{
                //取消
                self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.cancelBtn.frame = CGRectMake(0, APP_H-10, APP_W, 30);
                self.cancelBtn.backgroundColor = COLOR(0, 183, 70);
                [self.cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.cancelBtn];
            }
            
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
        
    });
    
}

- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"请求支撑详单";
    //创建Tableview
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(10, 69, APP_W-20, APP_H-69-80) style:UITableViewStylePlain];
    self.m_table.delegate = self;
    self.m_table.dataSource = self;
    [self.view addSubview:self.m_table];
    
    
}
- (void)comment:(UIButton *)btn
{
    //点评
    AddRequestCommentController *ctrl = [[AddRequestCommentController alloc] init];
    ctrl.taskId = self.taskId;
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (void)cancel:(UIButton *)btn
{
    //取消
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)taskArray
{
    if (nil == _taskArray) {
        _taskArray = [NSMutableArray array];
    }
    return _taskArray;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 325;
    }else{
        return 80;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellId = @"RequestSupportDetailCell";
        RequestSupportDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"RequestSupportDetailCell" owner:nil options:nil]lastObject];
        }
        RequestSupportDetailModel *model = self.dataArray[indexPath.row];
        cell.delegate = self;
        [cell configModel:model];
        return cell;
    }else{
        
        static NSString *cellId = @"taskDetailInRequestSupportDetailCell";
        TaskDetailInRequestSupportDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"TaskDetailInRequestSupportDetailCell" owner:nil options:nil]lastObject];
        }
        TaskDetailInRequestSupportDetail *model = self.dataArray[indexPath.row];
        [cell configModel:model];
        
        return cell;
    }
    
    
}
#pragma mark - RequestSupportDetailCellDelegate
- (void)taskDetailAction:(RequestSupportDetailCell *)cell
{
    [self.dataArray removeObjectsInArray:self.taskArray];
    [self.taskArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[URL_TYPE] = LookTaskDetail;
    params[@"taskId"] = self.taskId;
    httpGET2(params, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray *array = result[@"list"];
            [self.taskArray addObjectsFromArray:[TaskDetailInRequestSupportDetail arrayOfModelsFromDictionaries:array error:nil]];
            [self.dataArray addObjectsFromArray:self.taskArray];
            [self.m_table reloadData];
            [self getPhoto];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (void)getPhoto
{
    RequestSupportDetailModel *model = self.dataArray[0];
    CGFloat photoWidth = (self.m_table.width- 50)/4;
    CGFloat photoHeight = photoWidth;
    CGFloat space = 10;
    NSArray *array = model.attachmentList;
    NSInteger row = array.count %4 == 0 ?array.count/4 : array.count/4 +1;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.m_table.width, APP_W, space +(space + photoHeight)*row)];
    
    for (int i = 0; i<array.count; i++) {
        CGFloat row = i/4; //行
        CGFloat col = i%4; //列
        NSString *idStr = array[i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(space + (space +photoWidth)*col, space +(space + photoHeight)*row, photoWidth, photoHeight)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/ywglapp/attachment/ywglSupportTask/%@/origin",ADDR_IP,idStr]]];
        imageView.tag = idStr.integerValue;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        [footerView addSubview:imageView];
    }
    self.m_table.tableFooterView = footerView;
    
}
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    NSString *idStr = [NSString stringWithFormat:@"%d",tap.view.tag];
    WebViewController *web = [[WebViewController alloc] init];
    web.url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/ywglapp/attachment/ywglSupportTask/%@/origin",ADDR_IP,idStr]];
    [self.navigationController pushViewController:web animated:YES];
}
@end
