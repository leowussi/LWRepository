//
//  OnDutyLogHistoryView.m
//  telecom
//
//  Created by ZhongYun on 14-8-21.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "OnDutyLogHistoryView.h"
#import "OnDutyLogHistory.h"
#import "OnDutyLog.h"
#import "MJRefresh.h"

#define CELL_BAS_H      34
#define CELL_EXT_H      92

@interface OnDutyLogHistoryView ()<UITableViewDelegate, UITableViewDataSource, MJRefreshBaseViewDelegate>
{
    NSMutableArray* m_data;
    UITableView* m_table;
    MJRefreshFooterView* m_refreshFooter;
    BOOL m_isMore;
    NSMutableDictionary* m_filter;
    NSDictionary* m_filterInfo;
}
@end

@implementation OnDutyLogHistoryView

//- (void)dealloc
//{
//    [m_filter release];
//    [m_data release];
//    [m_table release];
//    [m_refreshFooter release];
//    [super dealloc];
//}

- (void)dealloc
{
    [m_refreshFooter free];
}

- (void)buildView
{
    if (m_data != nil) return;
    m_filterInfo = ((OnDutyLogHistory*)getViewController(self)).filterInfo;
    
    m_filter = [[NSMutableDictionary alloc] init];
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_table.bounces = YES;
    m_table.rowHeight = CELL_BAS_H;
    m_table.delegate = self;
    m_table.dataSource = self;
    m_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:m_table];
    
    newLabel(self, @[@101, RECT_OBJ(0, 100, APP_W, Font1), [UIColor darkGrayColor], FontB(Font1), @"没有符合条件的数据"]).textAlignment = NSTextAlignmentCenter;
    
    m_refreshFooter = [[MJRefreshFooterView alloc] init];
    m_refreshFooter.delegate = self;
    m_refreshFooter.scrollView = m_table;
    
    m_isMore = YES;
    [self loadData];
}

- (void)loadData
{
    if (m_filterInfo[@"dateBegin"] != nil) {
        m_filter[@"startDate"] = [m_filterInfo[@"dateBegin"] copy];
        m_filter[@"endDate"] = [m_filterInfo[@"dateEnd"] copy];
    }
    
    if (m_filterInfo[@"body"] != nil) {
        m_filter[@"dutyContentBody"] = [m_filterInfo[@"body"] copy];
    }
    
    NSDictionary* temp = @{URL_TYPE:NW_ZbLogList,
                           @"dutyContentStaus":self.typeInfo[@"typeId"],
                           @"limit":@MAX_ROW_NUM,
                           @"skip":@(m_data.count)};
    NSMutableDictionary* params = [temp mutableCopy];
    [params addEntriesFromDictionary:m_filter];
    
    httpGET2(params, ^(id result) {
        for (NSMutableDictionary* item in result[@"detail"][@"list"]) {
            item[@"extended"] = @0;
            [m_data addObject:item];
        }
        [m_table reloadData];
        [m_refreshFooter endRefreshing];

        tagViewEx(self, 101, UILabel).hidden = (m_data.count>0);
        m_isMore = ![result[@"isMore"] isEqualToString:@"false"];
    }, ^(id result) {
        [m_data removeAllObjects];
        [m_table reloadData];
        tagViewEx(self, 101, UILabel).hidden = (m_data.count>0);
        
        [m_refreshFooter endRefreshing];
    });
}

- (void)refreshData
{
    [m_filter removeAllObjects];
    [m_data removeAllObjects];
    [self loadData];
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([m_data[indexPath.row][@"extended"] intValue] == 1) {
        return CELL_BAS_H + CELL_EXT_H;
    }
    return CELL_BAS_H;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    
    NSInteger ext = [m_data[indexPath.row][@"extended"] intValue];
    ext = (ext==1 ? 0 : 1);
    m_data[indexPath.row][@"extended"]= @(ext);
    [m_table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"dutyContentId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        
        CGFloat pos_y = 10;
        newLabel(cell, @[@50, RECT_OBJ(15, pos_y, 150, Font3), [UIColor blackColor], Font(Font3), @""]);
        newLabel(cell, @[@51, RECT_OBJ(167, pos_y, APP_W-30-167, Font3), [UIColor blackColor], Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
        newImageView(cell, @[@52, @"arr_down.png", RECT_OBJ(APP_W-20, (CELL_BAS_H-7.5)/2, 10, 7.5)]);
        
        pos_y = CELL_BAS_H + 10;
        newLabel(cell, @[@53, RECT_OBJ(15, pos_y, APP_W-25, Font3), [UIColor darkGrayColor], Font(Font3), @""]);
        pos_y += Font3+5;
        newLabel(cell, @[@54, RECT_OBJ(15, pos_y, APP_W-25, Font3), [UIColor darkGrayColor], Font(Font3), @""]);
        pos_y += Font3+5;
        newLabel(cell, @[@55, RECT_OBJ(15, pos_y, APP_W-25, Font3), [UIColor darkGrayColor], Font(Font3), @""]);
        pos_y += Font3+5;
        newLabel(cell, @[@56, RECT_OBJ(15, pos_y, APP_W-25, Font3), [UIColor darkGrayColor], Font(Font3), @""]);
        
        UIButton* btn = [[UIButton alloc] initWithFrame:RECT(1, CELL_BAS_H+1, APP_W-2, CELL_EXT_H-2)];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(onMoreBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
//        [btn release];
        
        UIView* line1 = [[UIView alloc] initWithFrame:RECT(0, CELL_BAS_H-0.5, APP_W, 0.5)];
        line1.backgroundColor = RGB(0xc8c7cc);
        line1.tag = 61;
        [cell addSubview:line1];
//        [line1 release];
        
        UIView* line2 = [[UIView alloc] initWithFrame:RECT(0, CELL_BAS_H+CELL_EXT_H-0.5, APP_W, 0.5)];
        line2.backgroundColor = RGB(0xc8c7cc);
        line2.tag = 62;
        [cell addSubview:line2];
//        [line2 release];
    }
    
    tagViewEx(cell, 50, UILabel).text = format(@"值班日期：%@", NoNullStr(dataRow[@"dutyContentDate"]));
    tagViewEx(cell, 51, UILabel).text = format(@"填表人：%@", NoNullStr(dataRow[@"createUserName"]));
    NSString* imgName = ([dataRow[@"extended"] intValue] == 1 ? @"arr_up.png" : @"arr_down.png");
    tagViewEx(cell, 52, UIImageView).image = [UIImage imageNamed:imgName];
    
    tagViewEx(cell, 53, UILabel).text = format(@"组织名称：%@", NoNullStr(dataRow[@"orgName"]));
    tagViewEx(cell, 54, UILabel).text = format(@"站点名称：%@", NoNullStr(dataRow[@"siteName"]));
    tagViewEx(cell, 55, UILabel).text = format(@"值班班次：%@", NoNullStr(dataRow[@"batchName"]));
    tagViewEx(cell, 56, UILabel).text = format(@"保存时间：%@", NoNullStr(dataRow[@"saveTime"]));
    
    return cell;
}

- (void)onMoreBtnTouched:(UIButton*)sender
{
    NSInteger row = parentCellIndexPath(sender).row;
    httpGET1(@{URL_TYPE:NW_ZbLogInfo, @"dutyContentId":m_data[row][@"dutyContentId"]}, ^(id result) {
        UIViewController* parentVC = getViewController(self);
        //if ([result[@"detail"][@"contentStatus"] intValue] != 1) {
            OnDutyLog* vc = [[OnDutyLog alloc] init];
            vc.logId = m_data[row][@"dutyContentId"];
            vc.logData = result[@"detail"];
            [parentVC.navigationController pushViewController:vc animated:YES];
//            [vc release];
//        } else {
//            
//        }
    });
}

@end
