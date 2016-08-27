//
//  RepairFaultDetailKBView.m
//  telecom
//
//  Created by ZhongYun on 14-11-17.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "RepairFaultDetailKBView.h"
#import "MJRefresh.h"

#define CellId      @"CellId"
#define RowHeight   @"RowHeight"
#define TITLE_W     ((APP_W-20)*0.45)

@interface RepairFaultDetailKBView ()<UITableViewDelegate, UITableViewDataSource, MJRefreshBaseViewDelegate>
{
    NSMutableArray* m_data;
    UITableView* m_table;
    NSInteger m_typeId;
}
@end

@implementation RepairFaultDetailKBView

- (void)dealloc
{
    [m_data release];
    [m_table release];
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
    
    [self loadData];
}

- (void)loadData
{
    [m_data removeAllObjects];
    
    if (m_typeId == TI_DETAIL_KB) {
        NSArray* kvlist = @[@[@"orderNo", @"订单号"],//@"workNo", @"工单流水号"
                            @[@"businessNo", @"业务号"],//
                            @[@"region", @"区域"],
                            @[@"faultLevel",@"等级"],
                            @[@"spec",@"专业"],
                            @[@"site", @"站点"],
                            @[@"acceptTime", @"工单受理时间"],
                            @[@"workType", @"工单类别"],
                            @[@"workStatus", @"工单状态"],
                            @[@"workContent", @"工单内容"],
                            @[@"expectTime", @"工单预计时间"],
                            @[@"dealTimeLimit", @"工单历时"],//总时限
                            @[@"faultTimeLimit", @"工单时限"],//已经处理时限
                            @[@"handupTime", @"挂起时长"],//挂起时长
                            @[@"finishTimeLimit", @"剩余时间"],//剩余时限
                            @[@"contactWay", @"联系人和联系方式"],
                            @[@"faultPartDesc1",@"故障部位1"],
                            @[@"faultPartDesc2",@"故障部位2"],
                            @[@"faultPartDesc3",@"故障部位3"],
                            @[@"faultPartDesc4",@"故障部位4"],
                            @[@"faultPartDesc5",@"故障部位5"],
                            @[@"faultPartDesc6",@"故障部位6"],
                            @[@"faultPartDesc7",@"故障部位7"],
                            @[@"faultPartDesc9",@"故障部位8"],];
        for (NSArray* kvitem in kvlist) {
            NSMutableDictionary* item = [NSMutableDictionary dictionary];
            NSString *title = [kvitem[1] mutableCopy];
            item[@"title"] = title;
            [title release];
            if ([kvitem[0] rangeOfString:@"Limit"].location == NSNotFound) {
                item[@"content"] = NoNullStr(self.workInfo[kvitem[0]]);
            } else {
                id value = self.workInfo[kvitem[0]];
                if (value != nil) {
                    int num = [value intValue];
                    item[@"content"] = format(@"%d分钟", num);
                    if (num > 60 ) {
                        item[@"content"] = format(@"%d小时%d分钟", num/60, num%60);
                    }
                } else {
                    item[@"content"] = @"";
                }
            }
            
            item[CellId] = @(arc4random());
            item[RowHeight] = [self getRowHeight:item];
            [m_data addObject:item];
        }
    } else if (m_typeId == TI_RECORD_KB) {
        for (NSDictionary* tempItem in self.workInfo[@"transList"]) {
            NSMutableDictionary* item = [tempItem mutableCopy];
            item[CellId] = @(arc4random());
            item[RowHeight] = [self getRowHeight:item];
            [m_data addObject:item];
            [item release];
        }
    }
    [m_table reloadData];
}

- (id)getRowHeight:(NSDictionary*)row
{
    if (m_typeId==TI_DETAIL_KB) {
        CGSize txtSize = getTextSize(row[@"content"], Font(Font3), APP_W-20-TITLE_W);
        CGFloat txt_h = MAX(txtSize.height, Font3);
        return @(txt_h+20);
    }
    if (m_typeId==TI_RECORD_KB) {
        NSString *rowDesc = row[@"description"];
        CGSize txtSize = getTextSize(rowDesc ? rowDesc : row[@"Description"], Font(Font3), APP_W-20);
        return @(m_table.rowHeight + 10 + txtSize.height);
    }
    return @(m_table.rowHeight);
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
        cell.selectionStyle = (m_typeId==TI_DETAIL_KB ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray);
    }
    if (m_typeId==TI_DETAIL_KB) [self buildCell_FaultDetail:cell IndexPath:indexPath];
    if (m_typeId==TI_RECORD_KB) [self buildCell_FaultTransInfo:cell IndexPath:indexPath];
    return cell;
}

- (void)buildCell_FaultDetail:(UITableViewCell*)cell IndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    BOOL isCreate = ([cell viewWithTag:50] == nil);
    if (isCreate) {
        CGFloat title_w = TITLE_W;
        newLabel(cell, @[@50, RECT_OBJ(10, 10, title_w, Font3), RGBCOLOR(99, 164, 225), FontB(Font3), @""]);
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
        
        CGFloat dealUserInfo_w = (APP_W-20)*0.6;
        newLabel(cell, @[@54,RECT_OBJ(10, tagView(cell, 51).ey+10, dealUserInfo_w, Font3),[UIColor blackColor],Font(Font3),@""]).textAlignment = NSTextAlignmentLeft;
        
        CGFloat type_w = (APP_W-20)*0.4;
        newLabel(cell, @[@52, RECT_OBJ(APP_W-10-type_w, tagView(cell, 51).ey+10, type_w, Font3), [UIColor blackColor], Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
        
        newLabel(cell, @[@53, RECT_OBJ(10, tagView(cell, 52).ey+10, APP_W-20, Font3), [UIColor blackColor], Font(Font3), @""]);
    }
    tagViewEx(cell, 50, UILabel).text = format(@"%@ %@", dataRow[@"dealDept"], dataRow[@"dealUser"]);
    tagViewEx(cell, 51, UILabel).text = dataRow[@"actionTime"];
    tagViewEx(cell, 52, UILabel).text = dataRow[@"action"];
    
    NSString *rowDesc = dataRow[@"description"];
    tagViewEx(cell, 53, UILabel).text = rowDesc? rowDesc : dataRow[@"Description"];
    tagViewEx(cell, 53, UILabel).fw = APP_W-20;
    [tagViewEx(cell, 53, UILabel) sizeToFit];
    tagViewEx(cell, 54, UILabel).text = dataRow[@"dealUser"];
}



@end
