//
//  ResourceInfoViewController.m
//  telecom
//
//  Created by SD0025A on 16/4/8.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//售后故障单  资源信息页面

#import "ResourceInfoViewController.h"
#define ResourceInfoUrl     @"Select/afterSaleSelect"
@interface ResourceInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UITableView *m_table;
@end

@implementation ResourceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self downloadData];
}
- (void)downloadData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"workNo"] = self.workNo;
    params[URL_TYPE] = ResourceInfoUrl;
    httpGET2(params, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dictionary = (NSDictionary *)result;
            self.dataArray = dictionary[@"return_data"];
        }
        [self.m_table reloadData];
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
    self.view.backgroundColor = COLOR(248, 248, 248);
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"资源信息";
    self.m_table = [[UITableView alloc] initWithFrame:CGRectMake(10, 84, APP_W-20, APP_H-104) style:UITableViewStylePlain];
    self.m_table.delegate = self;
    self.m_table.dataSource = self;
    self.m_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.m_table];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 80, 20)];
    leftLabel.backgroundColor = COLOR(248, 248, 248);
    NSString *text = [NSString stringWithFormat:@"%@:",self.dataArray[indexPath.row][@"title"]];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    //计算文字大小，参数一定要符合相应的字体和大小
    CGSize attributeSize = [attributeString.string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    //计算字符间隔
    CGSize frame = leftLabel.frame.size;
    NSNumber *wordSpace = [NSNumber numberWithInt:(frame.width-attributeSize.width)/(attributeString.length-1)];
    //添加属性
    [attributeString addAttribute:NSKernAttributeName value:wordSpace range:NSMakeRange(0, attributeString.length)];
    leftLabel.attributedText = attributeString;
    leftLabel.lineBreakMode = NSLineBreakByCharWrapping;
    leftLabel.font = [UIFont systemFontOfSize:10];
    [cell.contentView addSubview:leftLabel];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftLabel.ex, 5, cell.frame.size.width-leftLabel.ex-10, 20)];
    rightLabel.backgroundColor = COLOR(248, 248, 248);
    rightLabel.text = self.dataArray[indexPath.row][@"content"];
    rightLabel.font = [UIFont systemFontOfSize:10];
    rightLabel.textAlignment =  NSTextAlignmentJustified;
    [cell.contentView addSubview:rightLabel];
    return cell;
}
@end
