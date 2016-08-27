//
//  AssiRoomList.m
//  telecom
//
//  Created by ZhongYun on 15-1-5.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AssiRoomList.h"
#import "MJRefresh.h"

#define ROW_H   40
@interface AssiRoomList ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate, MJRefreshBaseViewDelegate>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    UISearchBar* m_searchBar;
    MJRefreshFooterView* m_refreshFooter;
    
    BOOL m_bIsRegion;
}
@end

@implementation AssiRoomList


- (void)dealloc
{
    [m_searchBar release];
    [m_data release];
    [m_table release];
    [m_refreshFooter release];
    [m_refreshFooter free];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择机房";
    [self addSearchBar];
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:RECT(0, STATUS_H+NAV_H, APP_W, SCREEN_H-m_searchBar.ey)
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
    
    m_refreshFooter = [[MJRefreshFooterView alloc] init];
    m_refreshFooter.delegate = self;
    m_refreshFooter.scrollView = m_table;
    
    [self loadData];
}

- (void)loadData
{
    if ([self.originalVc isEqualToString:@"addSGYY"]) {
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = AssiGetRoomList;
        paraDict[@"limit"] = @(20);
        paraDict[@"skip"] = @(m_data.count);
        if (m_searchBar.text.length > 0) {
            paraDict[@"roomName"] = m_searchBar.text;
        }
        httpGET2(paraDict, ^(id result) {
            //[m_data removeAllObjects];
            [m_data addObjectsFromArray:result[@"list"]];
            [m_table reloadData];
            [m_refreshFooter endRefreshing];
        }, ^(id result) {
            //[m_data removeAllObjects];
            //[m_table reloadData];
            [m_refreshFooter endRefreshing];
        });
    }else{
        NSMutableDictionary* paras = [NSMutableDictionary dictionary];
        m_bIsRegion = !(m_searchBar.text.length > 0 || self.regionId != nil);
        
        if (m_bIsRegion) {
            paras[URL_TYPE] = AssiGetRegionList;
        } else {
            paras[URL_TYPE] = AssiGetRoomList;
            paras[@"limit"] = @(20);
            paras[@"skip"] = @(m_data.count);
            paras[@"regionId"] = self.regionId;
            if (m_searchBar.text.length > 0) {
                paras[@"roomName"] = m_searchBar.text;
            }
        }
        
        httpGET2(paras, ^(id result) {
            //[m_data removeAllObjects];
            [m_data addObjectsFromArray:result[@"list"]];
            [m_table reloadData];
            [m_refreshFooter endRefreshing];
        }, ^(id result) {
            //[m_data removeAllObjects];
            //[m_table reloadData];
            [m_refreshFooter endRefreshing];
        });
    }
    
    
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (!m_bIsRegion) {
        [self loadData];
    } else {
        [m_refreshFooter endRefreshing];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    if (m_bIsRegion) {
        AssiRoomList* vc = [[AssiRoomList alloc] init];
        vc.rootVC = self.rootVC;
        vc.regionId = m_data[indexPath.row][@"regionId"];
        vc.respBlock = self.respBlock;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    } else {
        if (self.respBlock) {
            self.respBlock(m_data[indexPath.row]);
        }
        [self.navigationController popToViewController:self.rootVC animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* rowId = (m_bIsRegion ? dataRow[@"regionId"] : dataRow[@"roomId"]);
    NSString* rowTitle = (m_bIsRegion ? dataRow[@"regionName"] : dataRow[@"roomName"]);
    
    NSString* str = [NSString stringWithFormat:@"cell_%@", rowId];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = FontB(Font3);
    }
    
    cell.textLabel.text = rowTitle;
    return cell;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -----v SearchBar v-----------------------
- (void)addSearchBar
{
    m_searchBar = [[UISearchBar alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, NAV_H)];
    m_searchBar.delegate = self;
    m_searchBar.placeholder = @"请输入机房关键字";
    m_searchBar.translucent = YES;
    m_searchBar.keyboardType = UIKeyboardTypeDefault;
    m_searchBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:m_searchBar];
    
    if (iOSv7) {
        UIView* barView = [m_searchBar.subviews objectAtIndex:0];
        [[barView.subviews objectAtIndex:0] removeFromSuperview];
        UITextField* searchField = [barView.subviews objectAtIndex:0];
        [searchField setReturnKeyType:UIReturnKeySearch];
    } else {
        [[m_searchBar.subviews objectAtIndex:0] removeFromSuperview];
        UITextField* searchField = [m_searchBar.subviews objectAtIndex:0];
        [searchField setReturnKeyType:UIReturnKeySearch];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    m_searchBar.showsCancelButton = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = NO;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = NO;
    [m_data removeAllObjects];
    mainThread(loadData, nil);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = YES;
    m_searchBar.text = @"";
}



@end
