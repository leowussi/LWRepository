//
//  SubRegionRefList.m
//  telecom
//
//  Created by ZhongYun on 14-7-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "SubRegionRefList.h"

#define ROW_H   40

@interface SubRegionRefList ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* m_table;
    NSMutableArray* m_data;
}
@end

@implementation SubRegionRefList

- (void)dealloc
{
    [m_data release];
    [m_table release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择分局";

    m_table = [[UITableView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, SCREEN_H-self.navBarView.ey)
                                           style:UITableViewStylePlain];
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
}

- (void)setSubRegionRefData:(NSArray *)subRegionRefData
{
    _subRegionRefData = [subRegionRefData retain];
    
    if (!m_data) {
        m_data = [[NSMutableArray alloc] init];
    }
    [m_data removeAllObjects];
    [m_data addObjectsFromArray:self.subRegionRefData];
    [m_table reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    [m_table cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    if (self.respBlock) {
        self.respBlock(indexPath.row);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"subRegoinId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = FontB(Font3);
    }
    
    cell.textLabel.text = dataRow[@"subRegoinName"];
    
    return cell;
}


@end
