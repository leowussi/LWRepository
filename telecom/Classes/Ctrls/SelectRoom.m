//
//  SelectRoom.m
//  telecom
//
//  Created by ZhongYun on 14-6-16.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "SelectRoom.h"
#import "SubRegionRefList.h"

#define ROW_H   40

@interface SelectRoom ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UITextFieldDelegate>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    UISearchBar* m_searchBar;
    
    UIButton* m_subRegionSelectBtn;
    NSMutableArray* m_subRegionRefData;
    NSInteger m_selected;
}
@end

@implementation SelectRoom

- (void)dealloc
{
    [m_subRegionSelectBtn release];
    [m_searchBar release];
    [m_data release];
    [m_table release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择机房";
    m_selected = -1;
    [self addSearchBar];
    
    m_subRegionSelectBtn = [[UIButton alloc] initWithFrame:RECT(0, m_searchBar.ey, APP_W, ROW_H)];
    m_subRegionSelectBtn.titleLabel.font = Font(Font3);
    [m_subRegionSelectBtn setTitle:@"请选择分局" forState:0];
    [m_subRegionSelectBtn setTitleColor:RGB(0x8e8e8e) forState:0];
    m_subRegionSelectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    m_subRegionSelectBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    m_subRegionSelectBtn.backgroundColor = [UIColor whiteColor];
    m_subRegionSelectBtn.layer.borderColor = RGB(0xe3e3e3).CGColor;
    m_subRegionSelectBtn.layer.borderWidth = 0.5;
    [m_subRegionSelectBtn setBackgroundImage:color2Image(BTN_HIGHLIGHTED) forState:UIControlStateHighlighted];
    [m_subRegionSelectBtn addTarget:self action:@selector(onSubRegionSelectBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_subRegionSelectBtn];
    
    UIImageView* arr = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right.png"]];
    arr.frame = RECT(m_subRegionSelectBtn.fw-arr.fw-10, (m_subRegionSelectBtn.fh-arr.fh)/2, arr.fw, arr.fh);
    [m_subRegionSelectBtn addSubview:arr];
    [arr release];
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:RECT(0, m_subRegionSelectBtn.ey, APP_W, SCREEN_H-m_subRegionSelectBtn.ey)
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



- (void)loadData
{
    NSMutableDictionary* paras = [NSMutableDictionary dictionary];
    paras[URL_TYPE] = NW_GetRoomList;
    if (m_searchBar.text.length > 0) {
        paras[@"roomName"] = m_searchBar.text;
    }
    if (m_selected >= 0) {
        paras[@"subRegionId"] = m_subRegionRefData[m_selected][@"subRegoinId"];
    }
    httpGET1(paras, ^(id result) {
        [m_data removeAllObjects];
        [m_data addObjectsFromArray:result[@"list"]];
        [m_table reloadData];
    });
}

- (void)onSubRegionSelectBtnTouched:(id)sender
{
    if (m_subRegionRefData) {
        SubRegionRefList* vc = [[SubRegionRefList alloc] init];
        vc.subRegionRefData = m_subRegionRefData;
        vc.respBlock = ^(NSInteger selected) {
            m_selected = selected;
            [m_subRegionSelectBtn setTitle:m_subRegionRefData[selected][@"subRegoinName"] forState:0];
            [m_subRegionSelectBtn setTitleColor:[UIColor blackColor] forState:0];
            mainThread(loadData, nil);
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    } else {
        httpGET1(@{URL_TYPE:NW_GetSubRegionList}, ^(id result) {
            m_subRegionRefData = [[NSMutableArray alloc] initWithArray:result[@"list"]];
            mainThread(onSubRegionSelectBtnTouched:, nil);
        });
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
    if (self.respBlock) {
        self.respBlock(m_data[indexPath.row]);
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
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"roomId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.font = FontB(Font3);
    }
    
    cell.textLabel.text = dataRow[@"roomName"];
    return cell;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -----v SearchBar v-----------------------
- (void)addSearchBar
{
    m_searchBar = [[UISearchBar alloc] initWithFrame:RECT(0, 64, APP_W, NAV_H)];
    m_searchBar.delegate = self;
    m_searchBar.placeholder = @"请输入机房关键字";
    m_searchBar.translucent = YES;
    m_searchBar.keyboardType = UIKeyboardTypeDefault;
//    m_searchBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:m_searchBar];
    
//    if (iOSv7) {
//        UIView* barView = [m_searchBar.subviews objectAtIndex:0];
//        [[barView.subviews objectAtIndex:0] removeFromSuperview];
//        UITextField* searchField = [barView.subviews objectAtIndex:0];
//        [searchField setReturnKeyType:UIReturnKeySearch];
//    } else {
//        [[m_searchBar.subviews objectAtIndex:0] removeFromSuperview];
//        UITextField* searchField = [m_searchBar.subviews objectAtIndex:0];
//        [searchField setReturnKeyType:UIReturnKeySearch];
//    }
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
    mainThread(loadData, nil);
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [m_searchBar resignFirstResponder];
    m_searchBar.showsCancelButton = YES;
    m_searchBar.text = @"";
}


@end
