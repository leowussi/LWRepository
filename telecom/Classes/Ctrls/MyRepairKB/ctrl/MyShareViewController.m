//
//  MyShareViewController.m
//  telecom
//
//  Created by liuyong on 15/4/28.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyShareViewController.h"
#import "AddShareInfoController.h"
#import "ShareInfoModel.h"
#import "ShareInfoCell.h"
#import "AttachmentDetailController.h"
@interface MyShareViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *shareInfoArray;
@property(nonatomic,strong)UITableView *myShareInfoTbView;
@end

@implementation MyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的共享信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.shareInfoArray = [NSMutableArray array];
    
    [self setUpRightBarButton];
    [self setUpMyShareInfoTbView];
    [self loadShareInfoDataWithURL:kGetFaultShareInfo];
}

#pragma mark - 右侧按钮
- (void)setUpRightBarButton
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightBtn.frame = CGRectMake(APP_W-40, 7, 30, 30);
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"log_audit@2x"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(addShareInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

- (void)setUpMyShareInfoTbView
{
    self.myShareInfoTbView = [[UITableView alloc] initWithFrame:RECT(0, 64, APP_W, APP_H-44) style:UITableViewStylePlain];
    self.myShareInfoTbView.backgroundColor = [UIColor whiteColor];
    self.myShareInfoTbView.dataSource = self;
    self.myShareInfoTbView.delegate = self;
    [self.view addSubview:self.myShareInfoTbView];
}

- (void)loadShareInfoDataWithURL:(NSString *)urlString
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = urlString;
    paraDict[@"faultId"] = self.faultId;
    
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            
            for (NSDictionary *dict in result[@"list"]) {
                ShareInfoModel *model = [[ShareInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.shareInfoArray addObject:model];
            }
        }
        [self.myShareInfoTbView reloadData];
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shareInfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"reuseCell";
    ShareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShareInfoCell" owner:self options:nil] lastObject];
    }
    ShareInfoModel *model = self.shareInfoArray[indexPath.row];
    [cell config:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareInfoModel *model = self.shareInfoArray[indexPath.row];
    if (![model.fileCount isEqualToString:@"0"]) {
        AttachmentDetailController *attachVc = [[AttachmentDetailController alloc] init];
        attachVc.commentId = model.commentId;
        [self.navigationController pushViewController:attachVc animated:YES];
    }
}


- (void)addShareInfo
{
    AddShareInfoController *addShareVc = [[AddShareInfoController alloc] init];
    addShareVc.faultId = self.uploadNo;
    [self.navigationController pushViewController:addShareVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    [_myShareInfoTbView release];
//    [super dealloc];
//}

@end
