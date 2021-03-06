//
//  PoliticalAndCompanySelledFault.m
//  telecom
//
//  Created by SD0025A on 16/4/20.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "PoliticalAndCompanySelledFaultDetail.h"
#import "SelledFaultListDetailModel.h"
#import "SelledFaultListDetailCell.h"//售后故障 详情cell
#import "FeedbackAndReceiptController.h"
#import "SelledPipelineInfoCell.h"
#import "SelledPinelineInfoModel.h"

#import "AccessoryListController.h"
#import "SelledFaultFeedbackViewController.h"
#import "SelledFaultReceiptController.h"
#import "SegmentView.h"
#import "ResourceInfoViewController.h"
#define DangerUrl   @"Select/NetDangerSelect"
@interface PoliticalAndCompanySelledFaultDetail ()<SegmentViewDelegate,UITableViewDataSource,UITableViewDelegate>
//第一个菜单按钮
@property (nonatomic,strong) UIButton *leftMenu;
//第二个菜单按钮
@property (nonatomic,strong) UIButton *rightMenu;
@property (nonatomic,strong) UIView *leftMenuList;
@property (nonatomic,strong) UIView *rightMenuList;

//
@property (nonatomic,strong) UITableView *m_table;
@property (nonatomic,strong) NSMutableArray *dataArray;//流水数据
@property (nonatomic,strong) NSMutableArray *detailArray;//详情数据
@property (nonatomic,assign) BOOL isPipeLineInfo;

@end

@implementation PoliticalAndCompanySelledFaultDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.type = @"selledDetail";
    _isPipeLineInfo = NO;
    [self createUI];
    //[self downloadData];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self downloadData];
}
- (void)createUI
{
    [self createNavBar];
    [self createSegmentAndTable];
    [self createLeftListView];
    [self createRightListView];
    
}
- (NSMutableArray *)detailArray
{
    if (nil == _detailArray) {
        _detailArray = [NSMutableArray array];
    }
    return _detailArray;
}

- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)createNavBar
{
    self.view.backgroundColor = COLOR(248, 248, 248);
    self.navigationItem.title = @"售后故障单详情";
    //leftMenu
    UIImage* leftMenuImage = [UIImage imageNamed:@"操作1.png"];
    self.leftMenu = [[UIButton alloc] initWithFrame:RECT((APP_W-105), 7,leftMenuImage.size.width/1.3, leftMenuImage.size.height/1.3)];
    [self.leftMenu setImage:[leftMenuImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.leftMenu.titleLabel.font = FontB(Font3);
    [self.leftMenu addTarget:self action:@selector(leftMenuAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftMenuItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftMenu];
    
    
    //rightMenu
    UIImage* rightMenuImage = [UIImage imageNamed:@"信息1.png"];
    self.rightMenu = [[UIButton alloc] initWithFrame:RECT((APP_W-40), 7,rightMenuImage.size.width/1.3, rightMenuImage.size.height/1.3)];
    [self.rightMenu setImage:[rightMenuImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    self.rightMenu.titleLabel.font = FontB(Font3);
    [self.rightMenu addTarget:self action:@selector(rightMenuAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightMenuItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightMenu];
    
    
    self.navigationItem.rightBarButtonItems = @[rightMenuItem,leftMenuItem];
}
- (void)leftMenuAction
{
    if (self.leftMenuList.frame.origin.x == APP_W) {
        [UIView animateWithDuration:0.5 animations:^{
            self.leftMenuList.frame = CGRectMake(APP_W-120, STATUS_H+NAV_H, 120, 120);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.rightMenuList.frame = CGRectMake(APP_W, STATUS_H+NAV_H, 120, 90);
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.leftMenuList.frame = CGRectMake(APP_W, STATUS_H+NAV_H, 120, 120);
        }];
    }
}
- (void)rightMenuAction
{
    if (self.rightMenuList.frame.origin.x == APP_W) {
        [UIView animateWithDuration:0.5 animations:^{
            self.rightMenuList.frame = CGRectMake(APP_W-120, STATUS_H+NAV_H, 120, 60);
        }];
        [UIView animateWithDuration:0.5 animations:^{
            self.leftMenuList.frame = CGRectMake(APP_W, STATUS_H+NAV_H, 120, 120);
        }];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.rightMenuList.frame = CGRectMake(APP_W, STATUS_H+NAV_H, 120, 60);
        }];
    }
    
}
//创建左边菜单lsit
- (void)createLeftListView
{
    self.leftMenuList = [[UIView alloc] initWithFrame:CGRectMake(APP_W, STATUS_H+NAV_H, 120, 120)];
    self.leftMenuList.backgroundColor = COLOR(239, 239, 239);
    self.leftMenuList.layer.borderWidth = 1;
    self.leftMenuList.layer.borderColor = COLOR(239, 239, 239).CGColor;
    [self.view addSubview:self.leftMenuList];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"查看附件" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 120, 30);
    [btn1 addTarget:self action:@selector(chooseLeftListBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 101;
    [self.leftMenuList addSubview:btn1];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 120, 1)];
    lineView1.backgroundColor = [UIColor grayColor];
    lineView1.alpha = 0.5;
    [self.leftMenuList addSubview:lineView1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"反馈" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(0, 60, 120, 30);
    [btn2 addTarget:self action:@selector(chooseLeftListBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 102;
    [self.leftMenuList addSubview:btn2];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 89, 120, 1)];
    lineView2.backgroundColor = [UIColor grayColor];
    lineView2.alpha = 0.5;
    [self.leftMenuList addSubview:lineView2];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn3 setTitle:@"回单" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.frame = CGRectMake(0, 90, 120, 30);
    [btn3 addTarget:self action:@selector(chooseLeftListBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn3.tag = 103;
    [self.leftMenuList addSubview:btn3];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 119, 120, 1)];
    lineView3.backgroundColor = [UIColor grayColor];
    lineView3.alpha = 0.5;
    [self.leftMenuList addSubview:lineView3];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn4 setTitle:@"响应" forState:UIControlStateNormal];
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn4.frame = CGRectMake(0, 30, 120, 30);
    [btn4 addTarget:self action:@selector(chooseLeftListBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn4.tag = 104;
    [self.leftMenuList addSubview:btn4];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 120, 1)];
    lineView4.backgroundColor = [UIColor grayColor];
    lineView4.alpha = 0.5;
    [self.leftMenuList addSubview:lineView4];
    
}
//创建右边菜单lsit
- (void)createRightListView
{
    self.rightMenuList = [[UIView alloc] initWithFrame:CGRectMake(APP_W, STATUS_H+NAV_H, 120, 60)];
    self.rightMenuList.backgroundColor = COLOR(239, 239, 239);
    self.rightMenuList.layer.borderWidth = 1;
    self.rightMenuList.layer.borderColor = COLOR(239, 239, 239).CGColor;
    [self.view addSubview:self.rightMenuList];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setTitle:@"资源" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 120, 30);
    [btn1 addTarget:self action:@selector(chooseRightListBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 201;
    [self.rightMenuList addSubview:btn1];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 29, 120, 1)];
    lineView1.backgroundColor = [UIColor grayColor];
    lineView1.alpha = 0.5;
    [self.rightMenuList addSubview:lineView1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setTitle:@"综合告警" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.frame = CGRectMake(0, 30, 120, 30);
    [btn2 addTarget:self action:@selector(chooseRightListBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn2.tag = 202;
    [self.rightMenuList addSubview:btn2];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 59, 120, 1)];
    lineView2.backgroundColor = [UIColor grayColor];
    lineView2.alpha = 0.5;
    [self.rightMenuList addSubview:lineView2];
   }
- (void)chooseLeftListBtn:(UIButton *)btn
{
    int count = btn.tag- 100;
    switch (count) {
        case 1:{
            //DLog(@"查看附件");
            AccessoryListController *ctrl = [[AccessoryListController alloc] init];
            ctrl.workNo = self.workNo;
            ctrl.type = self.type;
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            break;
        case 2:{
            // DLog(@"反馈");
            SelledFaultFeedbackViewController *ctrl = [[SelledFaultFeedbackViewController alloc] initWithNibName:@"SelledFaultFeedbackViewController" bundle:nil] ;
            ctrl.workNo = self.workNo;
            ctrl.orderNO = self.orderNO;
            ctrl.actionType = @"feedback";
            [self.navigationController pushViewController:ctrl animated:YES];
        }
            
            break;
        case 3:{
            // DLog(@"回单");
            SelledFaultReceiptController *ctrl = [[SelledFaultReceiptController alloc] init] ;
            ctrl.workNo = self.workNo;
            ctrl.orderNO = self.orderNO;
            ctrl.actionType = @"receipt";
            [self.navigationController pushViewController:ctrl animated:YES];
            
        }
            break;
        case 4:{
            // DLog(@"响应");
            FeedbackAndReceiptController *ctrl = [[FeedbackAndReceiptController alloc] init] ;
            ctrl.workNo = self.workNo;
            ctrl.orderNo = self.orderNO;
            ctrl.actionType = @"accept";
            [self.navigationController pushViewController:ctrl animated:YES];
            
        }
            break;

            
        default:
            break;
    }
}
- (void)chooseRightListBtn:(UIButton *)btn
{
    int count = btn.tag - 200;
    switch (count) {
        case 1:{
            //DLog(@"资源");
            ResourceInfoViewController *ctrl = [[ResourceInfoViewController alloc] init];
            ctrl.workNo = self.workNo;
            [self.navigationController pushViewController:ctrl animated:YES];
         }
            break;
        case 2:{
            //DLog(@"综合告警");
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"workNo"] = self.workNo;
            params[URL_TYPE] = DangerUrl;
            httpGET1(params, ^(id result) {
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = (NSDictionary *)result;
                    NSDictionary *subDict = dict[@"return_data"];
                    NSString *alertContent = subDict[@"alertContent"];
                    NSString *revertTime = subDict[@"revertTime"];
                    NSString *text = [NSString stringWithFormat:@"截止［%@］为止，最新消息为［%@］",revertTime,alertContent];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                    [alert addAction:action];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                }
            });
        }
            break;
          default:
            break;
    }
}
- (void)createSegmentAndTable
{
    SegmentView *seg = [[SegmentView alloc] initWithFrame:CGRectMake(0, 64, APP_W, 40)];
    seg.delegate = self;
    [self.view addSubview:seg];
    //创建UITableView
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(10, seg.frame.origin.y+seg.frame.size.height+10, APP_W-20, APP_H-64-seg.frame.size.height-20) style:UITableViewStylePlain];
    self.m_table.delegate = self;
    self.m_table.dataSource= self;
    self.m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.m_table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.m_table];
}
#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isPipeLineInfo == YES) {
        return self.dataArray.count;
    }else{
        return self.detailArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isPipeLineInfo) {
        return 110;
    }else{
        SelledFaultListDetailModel *model = self.detailArray[indexPath.row];
        
        return 410+250+[model configSiteHeight];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isPipeLineInfo) {
        //流水信息
        static NSString *cellId = @"SelledpipelineInfoCell";
        SelledPipelineInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SelledPipelineInfoCell" owner:self options:nil] lastObject];
        }
        SelledPinelineInfoModel *model = self.dataArray[indexPath.row];
        [cell comfigModel:model];
        return cell;
    }else{
        //详细信息
        
        static NSString *cellId = @"selledFaultListDetailCell";
        SelledFaultListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SelledFaultListDetailCell" owner:self options:nil] lastObject];
        }
        SelledFaultListDetailModel *model = self.detailArray[indexPath.row];
        [cell configModel:model];
        return cell;
    }
}
#pragma mark - 自定制SegmentView的代理方法
- (void)clickSegmentView:(UIButton *)btn
{
    //DLog(@"\n====值为%d",btn.tag);
    if (btn.tag == 100) {//详情信息cell
        self.navigationItem.title = @"售后故障单详情";
        _isPipeLineInfo = NO;
        
    }else{
        _isPipeLineInfo = YES;//流水信息cell
         self.navigationItem.title = @"我的售后工单详情";
    }
    [self downloadData];
}
- (void)downloadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (_isPipeLineInfo == YES) {
        param[URL_TYPE] = @"Trouble/SaleTroubleSerial";
        param[@"workNo"] = self.workNo;
        [self.dataArray removeAllObjects];
        httpGET2(param, ^(id result) {
            //政企业务开通 流水信息
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary  *)result;
                NSArray *array = dict[@"return_data"];
                self.dataArray = [SelledPinelineInfoModel arrayOfModelsFromDictionaries:array error:nil];
                [self.m_table reloadData];
            }
        }, ^(id result) {
            showAlert(result[@"error"]);
        });
       
    }
    if (_isPipeLineInfo == NO){
            param[URL_TYPE] = @"Trouble/SaleTroubleBat";
            param[@"workNo"] = self.workNo;
            [self.detailArray removeAllObjects];
            httpGET2(param, ^(id result) {
                ////政企业务开通 详情信息
                if ([result isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = (NSDictionary  *)result;
                    NSArray *array = dict[@"return_data"];
                    self.detailArray = [SelledFaultListDetailModel arrayOfModelsFromDictionaries:array error:nil];
                    [self.m_table reloadData];
                }
            }, ^(id result) {
                showAlert(result[@"error"]);
            });
        
    }
    
}

@end
