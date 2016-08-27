//
//  AssiMainListView.m
//  telecom
//
//  Created by ZhongYun on 15-1-5.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AssiMainListView.h"
#import "MJRefresh.h"
#import "AssiMainDetail.h"
#import "AssiDetailSGYY.h"

#define CARD_H      80
@interface AssiMainListView ()<UITableViewDelegate, UITableViewDataSource, MJRefreshBaseViewDelegate>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    MJRefreshHeaderView* m_refreshHeader;
    NSInteger m_typeId;
}
@end

@implementation AssiMainListView

- (void)dealloc
{
    [m_data release];
    [m_table release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)viewDidLoad
{
    m_typeId = [self.typeInfo[@"typeId"] intValue];
    if (m_typeId == YY_SGYY) NOTIF_ADD(ASSI_ADD_SGYY, onAddSuccess:);
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_table.bounces = YES;
    m_table.rowHeight = 10+CARD_H;
    m_table.delegate = self;
    m_table.dataSource = self;
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    m_table.tableFooterView = footerView;
    [footerView release];
    [self addSubview:m_table];
    
    m_refreshHeader = [[MJRefreshHeaderView alloc] init];
    m_refreshHeader.delegate = self;
    m_refreshHeader.scrollView = m_table;
    
    if (UGET(ASSI_IMSI) != nil) {
        [self loadData];
    }
}

- (void)loadData
{
    NSString* date = date2str([NSDate date], DATE_FORMAT);
    NSString* strUrl = NW_OpenDoorListForMember;
    if (m_typeId == YY_SGYY) strUrl = NW_TaskAppointmentList;
    httpGET2(@{URL_TYPE:strUrl, @"startDate":date, @"imsi":UGET(ASSI_IMSI)}, ^(id result) {
        [m_refreshHeader endRefreshing];
        [m_data removeAllObjects];
        [m_data addObjectsFromArray:result[@"list"]];
        [m_table reloadData];
    }, ^(id result) {
        [m_refreshHeader endRefreshing];
        if ([result isKindOfClass:[NSDictionary class]]) {
            if ([result[@"result"] isEqualToString:@"2010602"]) {
                NOTIF_POST(ASSI_IMSI_UNKNOWN, nil);
            } else {
                showAlert(result[@"error"]);
            }
        }        
    });
}

- (void)onAddSuccess:(NSNotification*)notification
{
    [self loadData];
}

- (void)openAssiDetailById:(NSString*)appointmentId
{
    for (NSDictionary* item in m_data) {
        if ([item[@"appointmentId"] isEqualToString:appointmentId]) {
            [self openAssiDetailByInfo:item];
            return;
        }
    }
}

- (void)openAssiDetailByInfo:(NSDictionary*)data
{
    AssiMainDetail* vc = [[AssiMainDetail alloc] init];
    vc.data = data;
    [getViewController(self).navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - MJRefreshBaseViewDelegate
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    [self loadData];
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
    if (m_typeId == YY_SGRW)
        [self openAssiDetailByInfo:m_data[indexPath.row]];
    if (m_typeId == YY_SGYY) {
        AssiDetailSGYY* vc = [[AssiDetailSGYY alloc] init];
        vc.appointmentId = m_data[indexPath.row][@"appointmentId"];
        [getViewController(self).navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = nil;
    if (m_typeId == YY_SGRW) {
        cell = [self getCellForSGRW:indexPath];
    } else if (m_typeId == YY_SGYY) {
        cell = [self getCellForSGYY:indexPath];
    }
    return cell;
}

- (UITableViewCell *)getCellForSGRW:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"appointmentId"]];
    UITableViewCell* cell=[m_table dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = FontB(Font1);
        
        UIView* card = [[UIView alloc] initWithFrame:RECT(10, 10, APP_W-20, CARD_H)];
        card.layer.borderColor = [UIColor lightGrayColor].CGColor;
        card.layer.borderWidth = 0.5;
        card.layer.cornerRadius = 3;
        card.backgroundColor = [UIColor whiteColor];
        card.tag = 50;
        [cell addSubview:card];
        [card release];
        
        newImageView(card, @[@(80), @"arrow_right.png", RECT_OBJ(card.fw-18, (card.fh-14)/2, 8, 14)]);
        
        CGFloat pos_y = 10;
        newLabel(card, @[@51, RECT_OBJ(10, pos_y, card.fw-20, Font4), RGB(0xed8226), Font(Font4), NoNullStr(dataRow[@"taskTime"])]);
        pos_y += (Font4+10);
        
        newLabel(card, @[@52, RECT_OBJ(10, pos_y, card.fw-20, Font2), [UIColor blackColor], FontB(Font2), NoNullStr(dataRow[@"roomName"])]);
        pos_y += (Font2+10);
        
        newLabel(card, @[@53, RECT_OBJ(10, pos_y, (card.fw-20)/2, Font4), RGB(0x4f4f4f), Font(Font4), NoNullStr(dataRow[@"reason"])]);
        newLabel(card, @[@54, RECT_OBJ(10+(card.fw-20)/2, pos_y, (card.fw-20)/2, Font4), [UIColor blackColor], Font(Font4),
                         format(@"%@(%@)", NoNullStr(dataRow[@"constructor"]), NoNullStr(dataRow[@"mobile"]))]);
    }
    
    tagViewEx(cell, 51, UILabel).text = NoNullStr(dataRow[@"taskTime"]);
    tagViewEx(cell, 52, UILabel).text = NoNullStr(dataRow[@"roomName"]);
    tagViewEx(cell, 53, UILabel).text = NoNullStr(dataRow[@"reason"]);
    tagViewEx(cell, 54, UILabel).text = format(@"%@(%@)", NoNullStr(dataRow[@"constructor"]), NoNullStr(dataRow[@"mobile"]));
    
    return cell;
}

- (UITableViewCell *)getCellForSGYY:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"appointmentId"]];
    UITableViewCell* cell=[m_table dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = FontB(Font1);
        
        UIView* card = [[UIView alloc] initWithFrame:RECT(10, 10, APP_W-20, CARD_H)];
        card.layer.borderColor = [UIColor lightGrayColor].CGColor;
        card.layer.borderWidth = 0.5;
        card.layer.cornerRadius = 3;
        card.backgroundColor = [UIColor whiteColor];
        card.tag = 50;
        [cell addSubview:card];
        [card release];
        
        newImageView(card, @[@(80), @"arrow_right.png", RECT_OBJ(card.fw-18, (card.fh-14)/2, 8, 14)]);
        
        CGFloat pos_y = 10;
        newLabel(card, @[@51, RECT_OBJ(10, pos_y, card.fw-20, Font2), RGB(0x000000), FontB(Font2), @""]);
        pos_y += (Font2+10);
        
        newLabel(card, @[@52, RECT_OBJ(10, pos_y, card.fw-20, Font4), RGB(0x4f4f4f), Font(Font4), @""]);
        pos_y += (Font4+10);
        
        newLabel(card, @[@53, RECT_OBJ(10, pos_y, (card.fw-20)/2, Font4), RGB(0x4f4f4f), Font(Font4), @""]);
    }
    
    tagViewEx(cell, 51, UILabel).text = NoNullStr(dataRow[@"projectName"]);
    
    CGRect rect = tagViewEx(cell, 52, UILabel).frame;
    rect.size = CGSizeMake((APP_W-20)-20, 80);
    tagViewEx(cell, 52, UILabel).text = format(@"%@  %@", NoNullStr(dataRow[@"taskTime"]), NoNullStr(dataRow[@"regionName"]));
    [tagViewEx(cell, 52, UILabel) sizeToFit];
    
    tagViewEx(cell, 53, UILabel).text = NoNullStr(dataRow[@"taskAddress"]);
    
    return cell;
}

@end
