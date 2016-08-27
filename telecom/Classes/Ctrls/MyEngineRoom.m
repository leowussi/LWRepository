//
//  MyEngineRoom.m
//  telecom
//
//  Created by ZhongYun on 14-8-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyEngineRoom.h"
#import "MyEngineRoomDetail.h"
#import "QrReadView.h"

@interface MyEngineRoom ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    UISearchBar* m_searchBar;
    UITableView* m_table;
    NSMutableArray* m_data;
    NSString* m_qrCode;
}
@end

@implementation MyEngineRoom

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的机房";
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImage* moreIcon = [UIImage imageNamed:@"jf1.png"];
    UIButton* moreBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-moreIcon.size.width), (NAV_H-moreIcon.size.height)/2,
                                                             moreIcon.size.width/2, moreIcon.size.height/2)];
    [moreBtn setBackgroundImage:moreIcon forState:0];
    [moreBtn addTarget:self action:@selector(onMoreBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    
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
}

- (void)loadData:(NSString*)keyword
{
    httpGET2(@{URL_TYPE:NW_GetRoomListData, @"roomName":keyword}, ^(id result) {
        NSArray* resList = result[@"list"];
        if (resList.count > 0) {
            [m_data addObjectsFromArray:resList];
            [m_table reloadData];
        }
        //[m_refreshfooter endRefreshing];
    }, ^(id result) {
        //[m_refreshfooter endRefreshing];
    });
}

- (void)onMoreBtnTouched:(id)sender
{
    [self.view endEditing:YES];
    
    if ([QrReadView checkCamera]) {
        QrReadView* vc = [[QrReadView alloc] init];
        vc.respBlock = ^(NSString* v) {
            m_qrCode = [v copy];
            mainThread(openRoomDetailInfo:, m_qrCode);
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)openRoomDetailInfo:(NSString*)qrCode
{
    httpGET2(@{URL_TYPE:NW_GetRoomDetailData, @"roomID":qrCode}, ^(id result) {
        NSArray* list = result[@"list"];
        if (list && list.count>0) {
            NSString* roomName = @"";
            for (NSDictionary* item in list) {
                if ([item[@"title"] isEqualToString:@"机房名称"]) {
                    roomName = item[@"content"];
                    break;
                }
            }
            
            NSDictionary* info = @{@"roomId":qrCode, @"roomName":roomName};
            mainThread(openRoomDetailVC:, info);
        } else {
            showAlert(format(@"无此机房信息(%@)", qrCode));
        }
    }, ^(id result) {
        showAlert(format(@"无此机房信息(%@)", qrCode));
    });
}

- (void)openRoomDetailVC:(NSMutableDictionary*)info
{
    MyEngineRoomDetail* vc = [[MyEngineRoomDetail alloc] init];
    vc.roomInfo = info;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
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
    if (m_data[indexPath.row][@"roomId"] == nil) return;
    [self openRoomDetailVC:m_data[indexPath.row]];
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
        
        newLabel(cell, @[@50, RECT_OBJ(15, 10, APP_W-40, Font2), [UIColor blackColor], Font(Font2), @""]);
    }
    tagViewEx(cell, 50, UILabel).text = dataRow[@"roomName"];
    
    return cell;
}


@end
