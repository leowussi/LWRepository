//
//  MyBookingListView.m
//  telecom
//
//  Created by ZhongYun on 14-12-26.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyBookingListView.h"
#import "MyBookingEdit.h"
#import "MyBookingXcsgDetail.h"
#import "MyBookingSgyyDetail.h"
#define CARD_H      105

@interface MyBookingListView ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView* m_table;
    NSMutableArray* m_data;
    
    NSInteger m_typeId;
    BaseViewController* m_parentVC;
}
@end

@implementation MyBookingListView

- (void)viewDidLoad
{
    NOTIF_ADD(BOOKING_UPDATE_SGRW, onXcsgUpdate:);
    NOTIF_ADD(BOOKING_UPDATE_SGYY, onSgyyUpdate:);
    
    
    m_typeId = [self.typeInfo[@"typeId"] intValue];
    m_parentVC = (BaseViewController*)getViewController(self);
    
    m_data = [[NSMutableArray alloc] init];
    m_table = [[UITableView alloc] initWithFrame:self.bounds
                                           style:UITableViewStylePlain];
    m_table.backgroundColor = [UIColor whiteColor];
    m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    m_table.bounces = YES;
    m_table.rowHeight = CARD_H;
    m_table.delegate = self;
    m_table.dataSource = self;
    m_table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:m_table];
    [self loadData];
}

- (void)loadData
{
    NSDictionary* params = nil;
    if (m_typeId==YY_SGRW) {
        params = @{URL_TYPE:NW_OpenDoorListForAdmin, @"startDate":date2str([NSDate date], DATE_FORMAT)};
    } else if (m_typeId==YY_SGYY) {
        params = @{URL_TYPE:NW_TaskAppointmentListForAdmin};
    }
    httpGET2(params, ^(id result) {
        [m_data removeAllObjects];
        NSArray* resList = result[@"list"];
        m_table.hidden = (resList.count == 0);
        if (resList.count > 0) {
            [m_data addObjectsFromArray:resList];
        }
        [m_table reloadData];
    }, ^(id result) {
        if (m_data.count > 0) {
            [m_data removeAllObjects];
            [m_table reloadData];
        }
    });
}

- (void)onXcsgUpdate:(NSNotification*)notification
{
    if (m_typeId==YY_SGRW) {
        [self loadData];
    }
}

- (void)onSgyyUpdate:(NSNotification*)notification
{
    if (m_typeId==YY_SGYY) {
        [self loadData];
    }
}


- (void)toShowKMDetail:(NSString*)detailId
{
    MyBookingEdit* vc = [[MyBookingEdit alloc] init];
    vc.appointmentId = detailId;
    vc.respBlock = ^(id resp) {
        mainThread(loadData, nil);
    };
    [m_parentVC.navigationController pushViewController:vc animated:YES];
}

- (void)toShowSGDetail:(NSString*)detailId
{
    MyBookingXcsgDetail* vc = [[MyBookingXcsgDetail alloc] init];
    vc.taskId = detailId;
    vc.listVC = getViewController(self);
    [getViewController(self).navigationController pushViewController:vc animated:YES];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return m_table.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    NSDictionary* dataRow = m_data[indexPath.row];
    if (m_typeId == YY_SGRW) {
        if ([dataRow[@"typeId"] intValue] == 1) {
            [self toShowKMDetail:dataRow[@"appointmentId"]];
        } else if ([dataRow[@"typeId"] intValue] == 2) {
            [self toShowSGDetail:dataRow[@"appointmentId"]];
        }
    } else if (m_typeId == YY_SGYY) {
        MyBookingSgyyDetail* vc = [[MyBookingSgyyDetail alloc] init];
        vc.appointmentId = dataRow[@"appointmentId"];
        vc.listVC = getViewController(self);
        [getViewController(self).navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return m_data.count;
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
    NSDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"appointmentId"]];
    UITableViewCell* cell=[m_table dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel* lbdate = newLabel(cell, @[@50, RECT_OBJ(10, 10, APP_W-30, Font3), COLOR(236, 132, 41), FontB(Font3), @""]);
        UILabel* lbtype = newLabel(cell, @[@51, RECT_OBJ(10, lbdate.ey+7, APP_W-30, Font1), COLOR(236, 132, 41), FontB(Font1), @""]);
        UILabel* lbtitle = newLabel(cell, @[@52, RECT_OBJ(10, lbtype.ey+7, APP_W-30, Font1), [UIColor blackColor], FontB(Font1), @""]);
        UILabel* lbreason = newLabel(cell, @[@53, RECT_OBJ(10, lbtitle.ey+7, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]);//.textAlignment = NSTextAlignmentRight;
        newLabel(cell, @[@54, RECT_OBJ(10, lbreason.fy, APP_W-30, Font3), COLOR(83, 83, 83), Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
    }
    
    NSArray* typeNames = @[@"", @"远程开门", @"现场随工", @"系统割接", @"故障任务"];
    
    ((UILabel*)[cell viewWithTag:50]).text = dataRow[@"taskTime"];
    NSString* typeName = typeNames[[dataRow[@"typeId"] intValue]];
    ((UILabel*)[cell viewWithTag:51]).text = typeName;
    ((UILabel*)[cell viewWithTag:52]).text = dataRow[@"roomName"];
    ((UILabel*)[cell viewWithTag:53]).text = dataRow[@"reason"];
    
    
    NSString* person = format(@"%@%@", NoNullStr(dataRow[@"constructor"]), NoNullStr(dataRow[@"mobile"]));
    ((UILabel*)[cell viewWithTag:54]).text = person;
    
    return cell;
}

- (UITableViewCell *)getCellForSGYY:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.row];
    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"appointmentId"]];
    UITableViewCell* cell=[m_table dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:str];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UILabel* lbname = newLabel(cell, @[@50, RECT_OBJ(10, 10, APP_W-30, Font1), RGB(0x000000), FontB(Font1), @""]);
        UILabel* lbnum = newLabel(cell, @[@51, RECT_OBJ(10, lbname.ey+7, APP_W-40, Font3), RGB(0x4f4f4f), Font(Font3), @""]);
        newLabel(cell, @[@52, RECT_OBJ(10, lbname.ey+7, APP_W-50, Font3), RGB(0x4f4f4f), Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
        UILabel* lbtime = newLabel(cell, @[@53, RECT_OBJ(10, lbnum.ey+7, APP_W-30, Font3), RGB(0x4f4f4f), Font(Font3), @""]);
        newLabel(cell, @[@54, RECT_OBJ(10, lbtime.ey+7, APP_W-30, Font3), RGB(0x4f4f4f), Font(Font3), @""]);
    }
    
    tagViewEx(cell, 50, UILabel).text = NoNullStr(dataRow[@"projectName"]);
    tagViewEx(cell, 51, UILabel).text = NoNullStr(dataRow[@"appointmentId"]);
    tagViewEx(cell, 52, UILabel).text = NoNullStr(dataRow[@"regionName"]);
    tagViewEx(cell, 53, UILabel).text = NoNullStr(dataRow[@"taskTime"]);
    tagViewEx(cell, 54, UILabel).text = NoNullStr(dataRow[@"taskAddress"]);
    
    return cell;
}

//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)apsToList
{
    [m_parentVC popToRootViewController];
    [self loadData];
}

- (void)apsToDetail:(NSString*)detailId
{
    [m_parentVC popToRootViewController];
    [self performSelector:@selector(toShowKMDetail:) withObject:detailId afterDelay:1];
}



@end
