//
//  MyRepairFaultList.m
//  telecom
//
//  Created by ZhongYun on 14-8-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyRepairFaultList.h"
#import "MyRepairFaultDetail.h"
#import "MJRefresh.h"

@interface MyRepairFaultList ()<UITableViewDelegate, UITableViewDataSource, MJRefreshBaseViewDelegate>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    MJRefreshHeaderView* m_refreshHeader;
}
@end

@implementation MyRepairFaultList

- (void)dealloc
{
    [m_data release];
    [m_table release];
    [m_refreshHeader release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的报修";
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, (SCREEN_H-self.navBarView.ey))
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = 78;
    m_table.delegate = self;
    m_table.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    m_table.tableFooterView = footerView;
    [footerView release];
    [self.view addSubview:m_table];
    
    m_refreshHeader = [[MJRefreshHeaderView alloc] init];
    m_refreshHeader.delegate = self;
    m_refreshHeader.scrollView = m_table;
    
    [self loadData];
}

- (void)loadData
{
    httpGET2(@{URL_TYPE:NW_GetRepairFaultList}, ^(id result) {
        [m_data removeAllObjects];
        [m_data addObjectsFromArray:result[@"list"]];
        [m_table reloadData];
        [m_refreshHeader endRefreshing];
    }, ^(id result) {
        [m_refreshHeader endRefreshing];
    });
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    
    MyRepairFaultDetail* vc = [[MyRepairFaultDetail alloc] init];
    vc.faultId = m_data[indexPath.row][@"faultId"];
    vc.faultNo = m_data[indexPath.row][@"faultNo"];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"siteId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        newLabel(cell, @[@50, RECT_OBJ(10, 10, APP_W-30, Font1), RGB(0xec8027), FontB(Font1), @""]);
        newLabel(cell, @[@51, RECT_OBJ(APP_W-30-60, 10, 60, Font1), [UIColor blackColor], FontB(Font1), @""]).textAlignment = NSTextAlignmentRight;
        newLabel(cell, @[@52, RECT_OBJ(10, 10+Font1+7, APP_W-30, Font4), [UIColor darkGrayColor], Font(Font4), @""]);
        newLabel(cell, @[@53, RECT_OBJ(APP_W-30-120, 10+Font1+7, 120, Font4), [UIColor darkGrayColor], Font(Font4), @""]).textAlignment = NSTextAlignmentRight;
        newLabel(cell, @[@54, RECT_OBJ(10, 10+Font1+7+Font4+7, APP_W-30, Font4), [UIColor blackColor], Font(Font4), @""]);
    }
    
    tagViewEx(cell, 50, UILabel).text = dataRow[@"faultNo"];
    tagViewEx(cell, 51, UILabel).text = dataRow[@"faultLevel"];
    tagViewEx(cell, 52, UILabel).text = dataRow[@"faultStat"];
    tagViewEx(cell, 53, UILabel).text = dataRow[@"takeTime"];
    tagViewEx(cell, 54, UILabel).text = dataRow[@"faultName"];
    
    return cell;
}

@end
