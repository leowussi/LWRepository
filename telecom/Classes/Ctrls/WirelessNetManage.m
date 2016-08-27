//
//  WirelessNetManage.m
//  telecom
//
//  Created by ZhongYun on 14-8-22.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "WirelessNetManage.h"
#import "QrReadView.h"

@interface WirelessNetManage ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UISearchBar* m_searchBar;
    UITableView* m_table;
    NSMutableArray* m_data;
    NSString* m_qrCode;
}
@end

@implementation WirelessNetManage

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"无线网管";
    
    UIImage* moreIcon = [UIImage imageNamed:@"jf1.png"];
    UIButton* moreBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-moreIcon.size.width), (NAV_H-moreIcon.size.height)/2,
                                                             moreIcon.size.width/2, moreIcon.size.height/2)];
    [moreBtn setBackgroundImage:moreIcon forState:0];
    [moreBtn addTarget:self action:@selector(onMoreBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
//    [self.navBarView addSubview:moreBtn];
    
    m_searchBar = [[UISearchBar alloc] initWithFrame:RECT(0, 64, APP_W, NAV_H)];
    m_searchBar.delegate = self;
    m_searchBar.placeholder = @"请输入局站名称";
    m_searchBar.translucent = YES;
    m_searchBar.keyboardType = UIKeyboardTypeDefault;
    m_searchBar.backgroundColor = [UIColor lightGrayColor];
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
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:RECT(0, m_searchBar.ey, APP_W, (SCREEN_H-m_searchBar.ey))
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = Font2+20;
    m_table.delegate = self;
    m_table.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    m_table.tableFooterView = footerView;
    [footerView release];
    [self.view addSubview:m_table];
    
    
    if (self.keyword != nil) {
        m_searchBar.text = self.keyword;
        [self loadData:m_searchBar.text];
    }
}

- (void)loadData:(NSString*)keyword
{
    httpGET1(@{URL_TYPE:NW_GetDeviceAlarm, @"equipCode":keyword}, ^(id result) {
        [m_data removeAllObjects];
        
        NSMutableDictionary* item = [result[@"detail"] mutableCopy];
        item[@"id"] = @(arc4random());
        [m_data addObject:item];
        [item release];
        [m_table reloadData];
    });
}

- (void)onMoreBtnTouched:(id)sender
{
    if ([QrReadView checkCamera]) {
        QrReadView* vc = [[QrReadView alloc] init];
        vc.respBlock = ^(NSString* v) {
            m_qrCode = [v copy];
            mainThread(getDetailInfo:, m_qrCode);
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)getDetailInfo:(NSString*)qrCode
{
    [self loadData:qrCode];
}

#pragma mark - UISearchBarDelegate
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
    [m_table reloadData];
    mainThread(loadData:, searchBar.text);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = YES;
    m_searchBar.text = @"";
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
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
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"roomId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        newLabel(cell, @[@50, RECT_OBJ(15, (m_table.rowHeight-Font2)/2, APP_W-40, Font2), [UIColor blackColor], Font(Font2), @""]);
    }
    tagViewEx(cell, 50, UILabel).text = dataRow[@"returnValue"];
    
    return cell;
}


@end
