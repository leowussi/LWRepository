//
//  AssiSuporvisorList.m
//  telecom
//
//  Created by ZhongYun on 14-7-23.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "AssiSuporvisorList.h"

#define ROW_H   40

@interface AssiSuporvisorList ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    NSInteger m_selIndex;
}
@end

@implementation AssiSuporvisorList

- (void)dealloc
{
    [m_data release];
    [m_table release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择施工队";
    m_selIndex = -1;
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, APP_H-NAV_H) style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = ROW_H;
    m_table.delegate = self;
    m_table.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    m_table.tableFooterView = footerView;
    [footerView release];
    [self.view addSubview:m_table];
    
    [self loadData];
}

- (void)loadData
{
    httpGET1(@{URL_TYPE:NW_GetSuporvisorList}, ^(id result) {
        [m_data removeAllObjects];
        [m_data addObjectsFromArray:result[@"list"]];
        [m_table reloadData];
    });
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    [m_table cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    if (m_selIndex >= 0) {
        [m_table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:m_selIndex inSection:0]].accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (self.respBlock) {
        self.respBlock(m_data[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    BOOL bSelected = [dataRow[@"constructionId"] isEqualToString:self.selectedId];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"constructionId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = FontB(Font1);
        if (bSelected) {
            m_selIndex = indexPath.row;
        }
    }
    cell.accessoryType = (bSelected ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone);
    cell.textLabel.text = NoNullStr(dataRow[@"constructionName"]);
    return cell;
}


@end
