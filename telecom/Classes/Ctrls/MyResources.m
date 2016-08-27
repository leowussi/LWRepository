//
//  MyResources.m
//  telecom
//
//  Created by 郝威斌 on 15/4/22.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyResources.h"
#import "WirelessNetManage.h"
#import "MyResourceQuery.h"
#define ROW_H   50
@interface MyResources ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *myTableView;
    NSArray *dataArray;
}
@end

@implementation MyResources

//- (void)dealloc
//{
//    [myTableView release];
//    [dataArray release];
//    [super dealloc];
//}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"资源查询";
    self.automaticallyAdjustsScrollViewInsets = NO;
    dataArray = [[NSArray alloc]initWithObjects:@"A类路由器查询",@"BBU设备查询",@"RRU设备查询",@"天线管理查询",@"室分系统查询", nil];
    myTableView = [[UITableView alloc] initWithFrame:RECT(0, 64, APP_W, SCREEN_H)
                                           style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor whiteColor];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.bounces = YES;
    myTableView.rowHeight = ROW_H;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];

    [self setExtraCellLineHidden:myTableView];//去掉UITableView底部多余的分割线
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MyResourceQuery *vc = [[MyResourceQuery alloc]init];
    vc.vcTag = indexPath.row+1;
    [self.navigationController pushViewController:vc animated:YES];
//    [vc release];

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;//cell的右边有一个小箭头，距离右边有十几像素；

        cell.textLabel.font = FontB(Font2);
    }
    
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    return cell;
}



- (void)onBtnPowerTouched:(id)sender
{
    NSString* strUrl = format(@"iPower://iPowerDK?accessToken=%@", UGET(U_POWER_TOKEN));
    NSString *unicodeURL = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:unicodeURL]];
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
