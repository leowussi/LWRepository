//
//  MyBookingList.m
//  telecom
//
//  Created by ZhongYun on 14-6-15.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyBookingList.h"
#import "MyBookingAdd.h"
#import "MyBookingEdit.h"

@interface MyBookingList ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* m_table;
    NSMutableArray* m_data;
}
@end

@implementation MyBookingList

- (void)dealloc
{
    [m_data release];
    [m_table release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的预约";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addNavigationLeftButton];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIImage* addIcon = [UIImage imageNamed:@"nav_add.png"];
    UIButton* addBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-addIcon.size.width), (NAV_H-addIcon.size.height)/2,
                                                             addIcon.size.width, addIcon.size.height)];
    [addBtn setBackgroundImage:addIcon forState:0];
    [addBtn addTarget:self action:@selector(onAddBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:addBtn];
    [addBtn release];
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, APP_H-NAV_H)
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = 80;
    m_table.delegate = self;
    m_table.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    m_table.tableFooterView = footerView;
    [footerView release];
    [self.view addSubview:m_table];
    [self loadData];
    
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadData
{
    NSDictionary* params = @{URL_TYPE:NW_OpenDoorListForAdmin, @"startDate":date2str([NSDate date], DATE_FORMAT)};
    httpGET1(params, ^(id result) {
        [m_data removeAllObjects];
        NSArray* resList = result[@"list"];
        m_table.hidden = (resList.count == 0);
        if (resList.count > 0) {
            [m_data addObjectsFromArray:resList];
        }
        [m_table reloadData];
    });
}

- (void)onAddBtnTouched:(id)sender
{
    MyBookingAdd* vc = [[MyBookingAdd alloc] init];
    vc.respBlock = ^(id resp) {
        mainThread(loadData, nil);
    };
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)toShowDetail:(NSString*)detailId
{
    MyBookingEdit* vc = [[MyBookingEdit alloc] init];
    vc.appointmentId = detailId;
    vc.respBlock = ^(id resp) {
        mainThread(loadData, nil);
    };
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    [self toShowDetail:m_data[indexPath.row][@"appointmentId"]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"appointmentId"]];
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        newLabel(cell, @[@50, RECT_OBJ(10, 10, APP_W-30, Font3), COLOR(236, 132, 41), FontB(Font3), @""]);
        newLabel(cell, @[@51, RECT_OBJ(10, 10+Font3+7, APP_W-30, Font1), [UIColor blackColor], FontB(Font1), @""]);
        newLabel(cell, @[@52, RECT_OBJ(10, 10+Font3+7+Font1+7, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]);//.textAlignment = NSTextAlignmentRight;
    }
    
    ((UILabel*)[cell viewWithTag:50]).text = dataRow[@"taskTime"];
    ((UILabel*)[cell viewWithTag:51]).text = dataRow[@"roomName"];
    ((UILabel*)[cell viewWithTag:52]).text = dataRow[@"reason"];
    
    return cell;
}


//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)apsToList
{
    [self popToRootViewController];
    [self loadData];
}

- (void)apsToDetail:(NSString*)detailId
{
    [self popToRootViewController];
    [self performSelector:@selector(toShowDetail:) withObject:detailId afterDelay:1];
}



@end
