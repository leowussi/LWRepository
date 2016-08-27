//
//  LinkClientInfoController.m
//  telecom
//
//  Created by SD0025A on 16/3/31.
//  Copyright © 2016年 ZhongYun. All rights reserved.


#import "LinkClientInfoController.h"
#import "LinkClientInfoCell.h"
#import "LinkClientInfoModel.h"
#define LinkClientUrl  @"Medium/LinkCustomerInfo"
@interface LinkClientInfoController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *m_table;
@end

@implementation LinkClientInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.urlType = LinkClientUrl;
    [self createUI];
    [self downloadData];
    
}
- (void)downloadData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"workNo"] = self.workNo;
    param[URL_TYPE] = self.urlType;
    httpGET2(param, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)result;
            if ([dict[@"return_code"]  isEqualToString:@"0"]) {
                NSArray *array = dict[@"return_data"];
                for (NSDictionary *subDic in array) {
                    LinkClientInfoModel *model = [[LinkClientInfoModel alloc] init];
                    [model setValuesForKeysWithDictionary:subDic];
                    [self.dataArray addObject:model];
                }
                [self.m_table reloadData];
            }
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"链路客户信息";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(10, 64+10, APP_W-20, APP_H-74) style:UITableViewStylePlain];
    self.m_table.delegate = self;
    self.m_table.dataSource = self;
    self.m_table.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.m_table];
   
}
#pragma mark - UITableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LinkClientInfoModel *model = self.dataArray[indexPath.row];
    return [model configHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"linkClientInfo";
    LinkClientInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LinkClientInfoCell" owner:self options:nil]lastObject];
    }
    LinkClientInfoModel *model = self.dataArray[indexPath.row];
    [cell configModel:model];
   
    return cell;
    
}
@end
