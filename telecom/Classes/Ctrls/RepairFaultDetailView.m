//
//  RepairFaultDetailView.m
//  telecom
//
//  Created by ZhongYun on 14-8-8.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "RepairFaultDetailView.h"
#import "MJRefresh.h"

#define CellId      @"CellId"
#define RowHeight   @"RowHeight"
#define TITLE_W     ((APP_W-20)*0.45)

@interface RepairFaultDetailView ()<UITableViewDelegate, UITableViewDataSource, MJRefreshBaseViewDelegate>
{
    NSMutableArray* m_data;
    UITableView* m_table;
    NSInteger m_typeId;
    MJRefreshHeaderView* m_refreshHeader;
}
@end

@implementation RepairFaultDetailView

- (void)dealloc
{
    [m_data release];
    [m_table release];
    [m_refreshHeader release];
    [super dealloc];
}

- (void)buildView
{
    if (m_data != nil) return;
    m_typeId = [self.typeInfo[@"typeId"] intValue];
    if (m_typeId<=0) return;
    
    int tmplist[] = {34, 58, 34, 34};
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = tmplist[m_typeId-1];
    m_table.delegate = self;
    m_table.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    m_table.tableFooterView = footerView;
    [footerView release];
    [self addSubview:m_table];
    
    if (m_typeId != TI_DETAIL) {
        m_refreshHeader = [[MJRefreshHeaderView alloc] init];
        m_refreshHeader.delegate = self;
        m_refreshHeader.scrollView = m_table;
    }
    
    [self loadData];
}

- (void)loadData
{
    NSArray* urlList = @[NW_GetRepairFaultDetail,NW_GetRepairFaultTransInfo,NW_GetFaultAlarmList,NW_GetFaultDeviceList];
    httpGET2(@{URL_TYPE:urlList[m_typeId-1],@"faultId":self.faultId,@"faultNo":self.faultNo}, ^(id result) {
        [m_data removeAllObjects];
        for (NSMutableDictionary* item in result[@"list"]) {
            item[CellId] = @(arc4random());
            item[RowHeight] = [self getRowHeight:item];
            [m_data addObject:item];
        }
        [m_table reloadData];
        [m_refreshHeader endRefreshing];
    }, ^(id result) {
        [m_refreshHeader endRefreshing];
    });
}

- (id)getRowHeight:(NSDictionary*)row
{
    if (m_typeId==TI_DETAIL) {
        CGSize txtSize = getTextSize(row[@"content"], Font(Font3), APP_W-20-TITLE_W);
        CGFloat txt_h = MAX(txtSize.height, Font3);
        return @(txt_h+20);
    }
    if (m_typeId==TI_RECORD) {
        CGSize txtSize = getTextSize(row[@"dealDesc"], Font(Font3), APP_W-20);
        return @(m_table.rowHeight + 10 + txtSize.height);
    }
    if (m_typeId==TI_WARNING){
        CGSize txtSize = getTextSize(row[@"content"], Font(Font3), APP_W-20-TITLE_W);
        CGFloat txt_h = MAX(txtSize.height, Font3);
        return @(txt_h+20);
    }
    if (m_typeId==TI_MACHINE){
        CGSize txtSize = getTextSize(row[@"content"], Font(Font3), APP_W-20-TITLE_W);
        CGFloat txt_h = MAX(txtSize.height, Font3);
        return @(txt_h+20);
    }
    return @(m_table.rowHeight);
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [m_data[indexPath.row][RowHeight] floatValue];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[CellId]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = (m_typeId==TI_DETAIL ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray);
    }
    if (m_typeId==TI_DETAIL) [self buildCell_FaultDetail:cell IndexPath:indexPath];
    if (m_typeId==TI_RECORD) [self buildCell_FaultTransInfo:cell IndexPath:indexPath];
    if (m_typeId==TI_WARNING) [self buildCell_FaultAlarmList:cell IndexPath:indexPath];
    if (m_typeId==TI_MACHINE) [self buildCell_FaultDeviceList:cell IndexPath:indexPath];
    return cell;
}

- (void)buildCell_FaultDetail:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    BOOL isCreate = ([cell viewWithTag:50] == nil);
    if (isCreate) {
        CGFloat title_w = TITLE_W;
        newLabel(cell, @[@50, RECT_OBJ(10, 10, title_w, Font3), [UIColor blackColor], FontB(Font3), @""]);
        newLabel(cell, @[@51, RECT_OBJ(10+title_w, 10, APP_W-title_w-20, Font3*10), [UIColor darkGrayColor], Font(Font3), @""]);
    }
    tagViewEx(cell, 50, UILabel).text = dataRow[@"title"];
    tagViewEx(cell, 51, UILabel).text = dataRow[@"content"];
    tagViewEx(cell, 51, UILabel).fw = APP_W-20-TITLE_W;
    [tagViewEx(cell, 51, UILabel) sizeToFit];
}

- (void)buildCell_FaultTransInfo:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    BOOL isCreate = ([cell viewWithTag:50] == nil);
    if (isCreate) {
        CGFloat date_w = (APP_W-20)*0.4;
        CGFloat title_w = APP_W-20-date_w;
        newLabel(cell, @[@50, RECT_OBJ(10, 10, title_w, Font2), [UIColor blackColor], FontB(Font2), @""]);
        newLabel(cell, @[@51, RECT_OBJ(10+title_w, 10, date_w, Font3), RGB(0xec8027), Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
        
        CGFloat type_w = (APP_W-20)*0.4;
        newLabel(cell, @[@52, RECT_OBJ(APP_W-10-type_w, tagView(cell, 51).ey+10, type_w, Font3), [UIColor blackColor], Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
        
        newLabel(cell, @[@53, RECT_OBJ(10, tagView(cell, 52).ey+10, APP_W-20, Font3), [UIColor blackColor], Font(Font3), @""]);
    }
    tagViewEx(cell, 50, UILabel).text = format(@"%@ %@", dataRow[@"dealGroup"], dataRow[@"dealMan"]);
    tagViewEx(cell, 51, UILabel).text = dataRow[@"dealTime"];
    tagViewEx(cell, 52, UILabel).text = dataRow[@"dealActionType"];
    
    tagViewEx(cell, 53, UILabel).text = dataRow[@"dealDesc"];
    tagViewEx(cell, 53, UILabel).fw = APP_W-20;
    [tagViewEx(cell, 53, UILabel) sizeToFit];
    
}

- (void)buildCell_FaultAlarmList:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    BOOL isCreate = ([cell viewWithTag:50] == nil);
    if (isCreate) {
        CGFloat title_w = TITLE_W;
        newLabel(cell, @[@50, RECT_OBJ(10, 10, title_w, Font3), [UIColor blackColor], FontB(Font3), @""]);
        newLabel(cell, @[@51, RECT_OBJ(10+title_w, 10, APP_W-title_w-20, Font3*10), [UIColor darkGrayColor], Font(Font3), @""]);
    }
    tagViewEx(cell, 50, UILabel).text = dataRow[@"title"];
    tagViewEx(cell, 51, UILabel).text = dataRow[@"content"];
    tagViewEx(cell, 51, UILabel).fw = APP_W-20-TITLE_W;
    [tagViewEx(cell, 51, UILabel) sizeToFit];
}

- (void)buildCell_FaultDeviceList:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    BOOL isCreate = ([cell viewWithTag:50] == nil);
    if (isCreate) {
        CGFloat title_w = TITLE_W;
        newLabel(cell, @[@50, RECT_OBJ(10, 10, title_w, Font3), [UIColor blackColor], FontB(Font3), @""]);
        newLabel(cell, @[@51, RECT_OBJ(10+title_w, 10, APP_W-title_w-20, Font3*10), [UIColor darkGrayColor], Font(Font3), @""]);
    }
    tagViewEx(cell, 50, UILabel).text = dataRow[@"title"];
    tagViewEx(cell, 51, UILabel).text = dataRow[@"content"];
    tagViewEx(cell, 51, UILabel).fw = APP_W-20-TITLE_W;
    [tagViewEx(cell, 51, UILabel) sizeToFit];
}


@end
