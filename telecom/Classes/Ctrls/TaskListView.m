//
//  TaskListView.m
//  telecom
//
//  Created by ZhongYun on 14-6-14.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "TaskListView.h"
#import "MyTaskListViewController.h"
#import "TaskDetail.h"
#import "TaskJiaohunList.h"
#import "SignFailedReasonView.h"
#import "TaskWirelessDetail.h"
#import "CycleTaskTrackController.h"
#import "YZResourcesChangeViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#define SPID_JH 1   //交换
#define SPID_CS 2   //传输
#define SPID_XL 4   //线路
#define SPID_DL 6   //动力
#define SPID_WX 10  //无线

#define TASK_OPEN 0
#define TASK_DONE 1
#define TASK_DOING 3
#define TASK_REDO 4

#define ROW1_H      55
#define ROW2_H      55
#define HEAD_H      40

extern id g_waitingGpsObj;
@interface TaskListView ()<UITableViewDelegate, UITableViewDataSource, BMKLocationServiceDelegate,BMKGeneralDelegate,BMKMapViewDelegate,UIAlertViewDelegate>
{
    BMKMapView* _mapView;
    UITableView* m_table;
    NSMutableArray* m_data;
    
    MyTaskListViewController* m_parentVC;
    BMKLocationService* m_locService;
    
    CLLocationCoordinate2D m_coordinate;
    CLLocationManager *locationManager;
    
    NSString *strLongitude;
    NSString *strLatitude;
    
    NSIndexPath *_indexPath;
    BOOL m_isCeliang;
    BOOL m_isJiaohuan;
    BOOL m_isDongli;
    BOOL m_isXianlu;
    BOOL m_isWuxian;
    BOOL m_isChuanshu;
    BOOL m_isZonghe;
    
    id m_tempDataRow;
    BOOL m_isBack;
}
@property(nonatomic,strong)NSDictionary *infoDict;
@property(nonatomic,strong)NSDictionary *taskInfoDetail;
@end

@implementation YZIndexPathButton

@end

@implementation TaskListView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        m_isDongli = NO;
        m_isJiaohuan = NO;
        
        
        _mapView.delegate = self;
        
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
            //由于IOS8中定位的授权机制改变 需要进行手动授权
            locationManager = [[CLLocationManager alloc] init];
            //获取授权认证
            [locationManager requestAlwaysAuthorization];
            [locationManager requestWhenInUseAuthorization];
        }
        
        m_locService = [[BMKLocationService alloc]init];
        m_locService.delegate = self;
//        [m_locService startUserLocationService];

        m_data = [[NSMutableArray alloc] init];
        m_table = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        m_table.backgroundColor = [UIColor clearColor];
        m_table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        m_table.bounces = YES;
        m_table.rowHeight = ROW1_H;
        m_table.delegate = self;
        m_table.dataSource = self;
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
        m_table.tableFooterView = footerView;
        [footerView release];
        [self addSubview:m_table];
    }
    return self;
}

- (void)dealloc
{
    _mapView.delegate = nil;
    m_locService = nil;
    [m_locService stopUserLocationService];
    [m_locService release];
    [m_data release];
    [m_table release];
    [super dealloc];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    m_parentVC = (MyTaskListViewController*)getViewController(self);
}

- (void)setTypeInfo:(NSDictionary *)typeInfo
{
    _typeInfo = [typeInfo retain];
    
    NSString* speciltyName = self.typeInfo[@"speciltyName"];
    m_isCeliang = ([speciltyName rangeOfString:@"测量"].location != NSNotFound);
    m_isJiaohuan = ([speciltyName rangeOfString:@"交换"].location != NSNotFound);
    m_isDongli = ([speciltyName rangeOfString:@"动力"].location != NSNotFound);
    m_isXianlu = ([speciltyName rangeOfString:@"线路"].location != NSNotFound);
    m_isWuxian = ([speciltyName rangeOfString:@"无线"].location != NSNotFound);
    m_isChuanshu = ([speciltyName rangeOfString:@"传输"].location != NSNotFound);
    m_isZonghe = ([speciltyName rangeOfString:@"综合化维护"].location != NSNotFound);
    
    [self loadData];
}

- (void)onSubTaskCommit:(NSNotification*)notification
{
    if (m_isWuxian) {
        [self loadData];
    }
}

- (void)commitCheck
{
    if (m_isDongli) {
//        NSLog(@"%@",self.siteInfo);
//        NSLog(@"%@",self.typeInfo);
        NSString* siteName = (self.siteInfo[@"siteName"] != nil ? self.siteInfo[@"siteName"] : self.siteInfo[@"taskName"]);
        NSString* strUrl = format(@"iPower://iPowerTask?accessToken=%@&siteId=%@&siteName=%@",
                                  UGET(U_POWER_TOKEN), self.typeInfo[@"siteId"], siteName);
        NSString *unicodeURL = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:unicodeURL]];
        return;
    }
    
    NSMutableArray* commitList = [NSMutableArray array];
    NSMutableArray* taskIds = [NSMutableArray array];
    
    
    for (int section=0; section<m_data.count; section++) {
        NSArray* sectionList = m_data[section][@"cycleList"];
        for (int row=0; row<sectionList.count; row++) {
            NSDictionary* item = sectionList[row];
            
            if ([item[@"selected"] intValue] == 1) {
                [taskIds addObject:item[@"taskId"]];
                [commitList addObject:[NSIndexPath indexPathForRow:row inSection:section]];
            }
        }
    }
    
    if (taskIds.count > 0) {
        NSString* taskIdsStr = [taskIds componentsJoinedByString:@","];
        httpGET1(@{URL_TYPE:NW_BatchFinishTasks, @"taskIdList":taskIdsStr}, ^(id result) {
            mainThread(onCommitAfter:, commitList);
        });
    }
}

- (void)onCommitAfter:(NSArray*)commitList
{
    NSMutableDictionary* section = [NSMutableDictionary dictionary];
    for (NSIndexPath* indexPath in commitList) {
        NSMutableDictionary* dataRow = m_data[indexPath.section][@"cycleList"][indexPath.row];
        NSInteger undo_num = [dataRow[@"undoUnitAmount"] integerValue];
        NSInteger did_num = 0;
        
        if (dataRow[@"finishedAmount"] != nil) {
            did_num = [dataRow[@"finishedAmount"] intValue];
            [dataRow removeObjectForKey:@"finishedAmount"];
            
        } else {
            did_num = [dataRow[@"undoUnitAmount"] intValue];
        }
        
        NSInteger all_num = [m_data[indexPath.section][@"undoAmount"] intValue];
        
        _todoNum -= did_num;
        m_data[indexPath.section][@"undoAmount"] = @(all_num - did_num);
        dataRow[@"undoUnitAmount"] = @(undo_num - did_num);
        dataRow[@"selected"] = @0;
        if ([dataRow[@"undoUnitAmount"] intValue] == 0) {
            dataRow[@"taskStatus"] = @(TASK_DONE);
        }
        
        section[format(@"%d",indexPath.section)] = @(indexPath.section);
    }
    
    NSArray* secList = [section allKeys];
    for (NSString* item in secList) {
        [m_table reloadSections:[NSIndexSet indexSetWithIndex:[item intValue]] withRowAnimation:0];
    }
    
    MyTaskListViewController* parentVC = (MyTaskListViewController*)getViewController(self);
    [parentVC updatePointStatus:(self.tag-1000) Count:self.todoNum];
    NOTIF_POST(UP_TASK_LIST, nil);
}

- (void)loadData
{
//    NSLog(@"siteInfo == %@",self.siteInfo);
    NSLog(@"typeInfo == %@",self.typeInfo);
    
    if (self.vcTag == 100) {
        
        NSDictionary* params = @{URL_TYPE:NW_GetSpecTaskList,
                                 @"siteId":self.typeInfo[@"regionId"],
                                 @"specId":self.typeInfo[@"speciltyId"]};
        if (self.planDate != nil) {
            params = @{URL_TYPE:NW_GetSpecTaskList,
                       @"siteId":self.typeInfo[@"regionId"],
                       @"specId":self.typeInfo[@"speciltyId"],
                       @"planDate":self.planDate};
        }
        httpGET2(params,
                 ^(id result) {
                     mainThread(updateViewData:, result);
                 }, ^(id result) {
                     mainThread(updateViewData:, nil);
                 });
        
    }else if (self.vcTag == 200) {
        
        NSDictionary* params = @{URL_TYPE:NW_GetSpecTaskList,
                                 @"siteId":self.typeInfo[@"siteId"],
                                 @"specId":self.typeInfo[@"speciltyId"]};
        if (self.planDate != nil) {
            params = @{URL_TYPE:NW_GetSpecTaskList,
                       @"siteId":self.typeInfo[@"siteId"],
                       @"specId":self.typeInfo[@"speciltyId"],
                       @"planDate":self.planDate};
        }
        httpGET2(params,
                 ^(id result) {
                     mainThread(updateViewData:, result);
                 }, ^(id result) {
                     mainThread(updateViewData:, nil);
                 });
        
    }
    else{
        
        NSDictionary* params = @{URL_TYPE:NW_GetSpecTaskList,
                                 @"siteId":self.typeInfo[@"siteId"],
                                 @"specId":self.typeInfo[@"speciltyId"]};
        if (self.planDate != nil) {
            params = @{URL_TYPE:NW_GetSpecTaskList,
                       @"siteId":self.typeInfo[@"siteId"],
                       @"specId":self.typeInfo[@"speciltyId"],
                       @"planDate":self.planDate};
        }
        
        httpGET2(params,
                 ^(id result) {
                     NSLog(@"result == %@",result);
                     mainThread(updateViewData:, result);
                 }, ^(id result) {
                     mainThread(updateViewData:, nil);
                 });
        
    }
    
}


-(void)zhhwhData
{
    NSDictionary* params = @{URL_TYPE:@"MyTask/GetCycleTotalizationList",
                             @"siteId":self.typeInfo[@"siteId"],
                             @"specId":self.typeInfo[@"speciltyId"]};
    
    httpGET2(params,
             ^(id result) {
                 NSLog(@"result == %@",result);
//                 mainThread(updateViewData:, result);
             }, ^(id result) {
//                 mainThread(updateViewData:, nil);
             });
}

- (void)updateViewData:(id)result
{
    [m_data removeAllObjects];
    [m_data addObjectsFromArray:result[@"list"]];
    
    NSString* today = date2str([NSDate date], DATE_FORMAT);
    for (NSMutableDictionary* group in m_data) {
        _todoNum += ([group[@"undoAmount"] intValue]);
        group[@"extended"] = @0;
        
        BOOL bisExist = NO;
        for (NSMutableDictionary* task in group[@"cycleList"]) {
            task[@"rowHeight"] = @(0);
            task[@"selected"] = @(0);
            
            if ([task[@"date"] isEqualToString:today] && [task[@"undoUnitAmount"] integerValue]>0) {
                bisExist = YES;
            }
        }
        
        group[@"today"] = @0;
        if (bisExist) {
            group[@"today"] = @1;
        }
    }
    
    //[m_parentVC performSelector:NSSelectorFromString(@"updateNavBtnStatus:") withObject:self];
    [m_table reloadData];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = ROW1_H;
    if ([m_data[indexPath.section][@"extended"] intValue] != 1) {
        rowHeight = 0;
    }
    return rowHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray*)m_data[section][@"cycleList"]).count;
}


#pragma mark - UITableViewDataSource - section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return m_data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEAD_H;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* header = [[UIView alloc] initWithFrame:RECT(0, 0, APP_W, HEAD_H)];
    header.backgroundColor = COLOR(240, 240, 240);
    
    UIView* line1 = [[UIView alloc] initWithFrame:RECT(0, 0, APP_W, 0.5)];
    line1.backgroundColor = COLOR(200, 199, 204);
    [header addSubview:line1];
    [line1 release];
    
    UIView* line2 = [[UIView alloc] initWithFrame:RECT(0, header.fh, APP_W, 0.5)];
    line2.backgroundColor = COLOR(200, 199, 204);
    [header addSubview:line2];
    [line2 release];
    
    NSString* title = format(@"%@ （%@/%@）",
                             m_data[section][@"cycleName"],
                             m_data[section][@"undoAmount"],
                             m_data[section][@"taskAmount"]);
    UILabel*lbtitle = newLabel(header, @[@50, RECT_OBJ(15, (HEAD_H-Font2)/2, 295, Font2), [UIColor blackColor], Font(Font2), title]);
    [lbtitle sizeToFit];
    
    NSString* imgName = ([m_data[section][@"extended"] intValue] == 1 ? @"arr_up.png" : @"arr_down.png");
    newImageView(header, @[@51,imgName, RECT_OBJ(APP_W-20, (HEAD_H-7.5)/2, 10, 7.5)]);
    
    UIButton* headBtn = [[UIButton alloc] initWithFrame:RECT(1, 1, APP_W-2, HEAD_H-2)];
    [headBtn addTarget:self action:@selector(onHeadBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    headBtn.tag = 1000+section;
    [header addSubview:headBtn];
    [headBtn release];
    
    CGFloat point_w = 10;
    UIView* point = [[UIView alloc] initWithFrame:RECT(lbtitle.ex+10, (HEAD_H-point_w)/2, point_w, point_w)];
    point.hidden = ([m_data[section][@"today"] intValue] != 1);
    point.layer.cornerRadius = point_w/2;
    point.backgroundColor = COLOR(255, 127, 127);
    [header addSubview:point];
    [point release];
    
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [m_table cellForRowAtIndexPath:indexPath].selected = NO;
    NSMutableDictionary* dataRow = m_data[indexPath.section][@"cycleList"][indexPath.row];
    if (m_isDongli) {
        if ([dataRow[@"taskStatus"] intValue] == 0) {
            UIViewController* parentVC = getViewController(self);
            TaskDetail* vc = [[TaskDetail alloc] init];
            vc.detail = dataRow;
            vc.respBlock= ^(id result) {
                mainThread(onCommitAfter:, @[indexPath]);
            };
            [parentVC.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    }
    
    
    if (m_isCeliang || m_isChuanshu) {
        if ([dataRow[@"taskStatus"] intValue] == 0) {
            UIViewController* parentVC = getViewController(self);
            TaskDetail* vc = [[TaskDetail alloc] init];
            vc.detail = dataRow;
            vc.respBlock= ^(id result) {
                mainThread(onCommitAfter:, @[indexPath]);
            };
            [parentVC.navigationController pushViewController:vc animated:YES];
            [vc release];
        }else{
            NSString *str = [[NSUserDefaults standardUserDefaults] stringForKey:@"userMapFlag"];
            if ([str isEqualToString:@"1"]) {
            self.infoDict = m_data[indexPath.section][@"cycleList"][indexPath.row];
            NSLog(@"%@",self.infoDict);
            CycleTaskTrackController *cycleTaskTrackCtrl = [[CycleTaskTrackController alloc] init];
            cycleTaskTrackCtrl.taskDict = self.infoDict;
            UIViewController* parentVC = getViewController(self);
            [parentVC.navigationController pushViewController:cycleTaskTrackCtrl animated:YES];
            [cycleTaskTrackCtrl release];
            }
        }
    } else if (m_isJiaohuan) {
        if ([dataRow[@"taskStatus"] intValue] == 0) {
            UIViewController* parentVC = getViewController(self);
            TaskJiaohunList* vc = [[TaskJiaohunList alloc] init];
            vc.planDate = self.planDate;
            vc.detail = dataRow;
            vc.isSecondaryTask = m_isJiaohuan;
            vc.respBlock= ^(int undoCount) {
                if (undoCount == 0) {
                    mainThread(onCommitAfter:, @[indexPath]);
                }
            };
            [parentVC.navigationController pushViewController:vc animated:YES];
            [vc release];
        }else{
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"userMapFlag"] isEqualToString:@"1"]) {
            self.infoDict = m_data[indexPath.section][@"cycleList"][indexPath.row];
            NSLog(@"%@",self.infoDict);
            CycleTaskTrackController *cycleTaskTrackCtrl = [[CycleTaskTrackController alloc] init];
            cycleTaskTrackCtrl.taskDict = self.infoDict;
            UIViewController* parentVC = getViewController(self);
            [parentVC.navigationController pushViewController:cycleTaskTrackCtrl animated:YES];
            [cycleTaskTrackCtrl release];
            }
        }
    } else if (m_isWuxian) {
        
//        TaskWirelessDetail *vcontrol = [[TaskWirelessDetail alloc] init];
////        cycleTaskTrackCtrl.taskDict = self.infoDict;
//        UIViewController* parentVC = getViewController(self);
//        [parentVC.navigationController pushViewController:vcontrol animated:YES];
//        [vcontrol release];
        
        [self onWuxianCellTouched:dataRow];
        
    }else if (m_isZonghe) {
//        [self onWuxianCellTouched:dataRow];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* dataRow = m_data[indexPath.section][@"cycleList"][indexPath.row];
    //    NSString* str = [NSString stringWithFormat:@"cell_%@", dataRow[@"id"]];
    static NSString *reuseId = @"reuse";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:reuseId] autorelease];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.clipsToBounds = YES;
        cell.textLabel.font = FontB(Font1);
        cell.contentView.userInteractionEnabled = YES;
        
        CGFloat row_h = ROW1_H;
        newLabel(cell, @[@51, RECT_OBJ(15, 10, 295, Font2), [UIColor lightGrayColor], Font(Font2), @""]);
        newLabel(cell, @[@52, RECT_OBJ(15, 32, 215, Font3), [UIColor lightGrayColor], Font(Font3), @""]);
        newLabel(cell, @[@50, RECT_OBJ(130, 32, 70, Font3), [UIColor lightGrayColor], Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
        newLabel(cell, @[@53, RECT_OBJ(204, 32, 50, Font3), [UIColor lightGrayColor], Font(Font3), @""]).textAlignment = NSTextAlignmentRight;
        
        UIButton* checkBtn = [[UIButton alloc] initWithFrame:RECT(APP_W-40, (row_h-40)/2, 40, 40)];
        [checkBtn setBackgroundImage:[UIImage imageNamed:@"check_no.png"] forState:0];
        [checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        checkBtn.tag = 54;
        checkBtn.hidden = (!m_isCeliang); //测量有批量处理;
        [cell addSubview:checkBtn];
        [checkBtn release];
        
        YZIndexPathButton *jiaoZhengButton = [YZIndexPathButton buttonWithType:UIButtonTypeCustom];
        jiaoZhengButton.tag = 132;
        jiaoZhengButton.frame = CGRectMake(269, 30, 21, 21);
        [jiaoZhengButton setBackgroundImage:[UIImage imageNamed:@"资源矫正"] forState:UIControlStateNormal];
        [jiaoZhengButton addTarget:self action:@selector(jiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:jiaoZhengButton];
    }
    
    int taskStatus = [dataRow[@"taskStatus"] intValue];
    BOOL isOver = ([dataRow[@"undoUnitAmount"] intValue] <= 0);
    isOver = (taskStatus == TASK_DONE);
    
    if (isOver) {
        if (!m_isDongli) {
            [cell.contentView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(callBackAction:) ] ];
        }
    }
    
    
    tagViewEx(cell, 51, UILabel).textColor = (isOver ? [UIColor lightGrayColor] : RGB(0x000000));
    tagViewEx(cell, 51, UILabel).text = dataRow[@"taskName"];
    tagViewEx(cell, 51, UILabel).fw = ((m_isDongli||m_isJiaohuan) ? 295 : 275);
    
    NSString* strDate = dataRow[@"date"];
    if (strDate.length > 0)
        strDate = format(@"%@   ", strDate);
        
    tagViewEx(cell, 52, UILabel).textColor = (isOver ? [UIColor lightGrayColor] : RGB(0x000000));
    tagViewEx(cell, 52, UILabel).text = format(@"%@%@%@",
                                               strDate,
                                               dataRow[@"undoUnitAmount"],
                                               dataRow[@"unit"]);
    
    tagViewEx(cell, 50, UILabel).textColor = (isOver ? [UIColor lightGrayColor] : RGB(0x000000));
    tagViewEx(cell, 50, UILabel).text = dataRow[@"userId"];
    
    tagViewEx(cell, 53, UILabel).textColor = (isOver ? [UIColor lightGrayColor] : [UIColor redColor]);
    
    NSString* strStatus = @"";
    if (taskStatus == TASK_OPEN) strStatus = @"未完成";
    if (taskStatus == TASK_DONE) strStatus = @"已完成";
    if (taskStatus == TASK_REDO) strStatus = @"召回重做";
    if (taskStatus == TASK_DOING) strStatus = @"进行中";
    tagViewEx(cell, 53, UILabel).text = strStatus;
    
    tagView(cell, 54).hidden = !(!isOver && (m_isCeliang || m_isChuanshu));
    NSString* imgName = ([dataRow[@"selected"] intValue]==1 ? @"check_ok.png" : @"check_no.png");
    [tagViewEx(cell, 54, UIButton) setBackgroundImage:[UIImage imageNamed:imgName] forState:0];
    
    cell.selectionStyle = (isOver ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray);
    
    NSString* today = date2str([NSDate date], DATE_FORMAT);
    BOOL isToday = ([dataRow[@"date"] isEqualToString:today] && !isOver);
    cell.backgroundColor = (isToday ? COLOR(255, 176, 176) : [UIColor whiteColor]);
    
    YZIndexPathButton *jiaoZhengButton = [cell.contentView viewWithTag:132];
    jiaoZhengButton.ButtonIndexPath = indexPath;
//    if ([dataRow objectForKey:@"nu_id"] == nil || [[dataRow objectForKey:@"nu_id"] isEqualToString:@""]) {
//        jiaoZhengButton.hidden = NO;
//    }else{
//        jiaoZhengButton.hidden = YES;
//    }
    
    
    
    return cell;
}

- (void)jiaoZhengButtonClicked:(YZIndexPathButton *)sender
{
    NSMutableDictionary* dataRow = m_data[sender.ButtonIndexPath.section][@"cycleList"][sender.ButtonIndexPath.row];
    UIViewController* parentVC = getViewController(self);
    
    YZResourcesChangeViewController *resourcesChangeVC = [[YZResourcesChangeViewController alloc] init];
    resourcesChangeVC.resources_id = NoNullStr([dataRow objectForKey:@"nu_id"]);
    if (![resourcesChangeVC.resources_id isEqualToString:@""] && resourcesChangeVC) {
        resourcesChangeVC.resources_type = @"2-1";
        resourcesChangeVC.resources_sceneId = @"3";
    }
    
    [parentVC.navigationController pushViewController:resourcesChangeVC animated:YES];
    [resourcesChangeVC release];
}

//- (void)cycleTaskTrack:(UITapGestureRecognizer *)ges
//{
////    CGPoint point = [ges locationInView:m_table];
////    NSIndexPath *indexPath = [m_table indexPathForRowAtPoint:point];
//    self.infoDict = m_data[indexPath.section][@"cycleList"][indexPath.row];
//    NSLog(@"%@",self.infoDict);
//    CycleTaskTrackController *cycleTaskTrackCtrl = [[CycleTaskTrackController alloc] init];
//    cycleTaskTrackCtrl.taskDict = self.infoDict;
//    UIViewController* parentVC = getViewController(self);
//    [parentVC.navigationController pushViewController:cycleTaskTrackCtrl animated:YES];
//    [cycleTaskTrackCtrl release];
//}

- (void)callBackAction:(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [ges locationInView:m_table];
        NSIndexPath* indexPath = [m_table indexPathForRowAtPoint:point];
        self.infoDict = m_data[indexPath.section][@"cycleList"][indexPath.row];
        NSLog(@"%@",self.infoDict);
        if (indexPath == nil)  return;
        _indexPath = indexPath;
        
        if (m_isJiaohuan) {
            UIAlertView *chooseAlert = [ [UIAlertView alloc] initWithTitle:@"选择召回重做" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"一级召回重做",@"二级召回重做", nil];
            chooseAlert.tag = 12000;
            [chooseAlert show];
            [chooseAlert release];
        }else{
            UIAlertView *chooseAlert = [ [UIAlertView alloc] initWithTitle:@"是否要召回重做?" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
            chooseAlert.tag = 12001;
            [chooseAlert show];
            [chooseAlert release];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12000) {//有二级任务的时候
        if (buttonIndex == 0) {//不召回重做
            
        }else if (buttonIndex == 1){//一级召回重做
            
            NSMutableDictionary *taskInfoDict = [NSMutableDictionary dictionary];
            taskInfoDict[URL_TYPE] = NW_GetTaskInfo;
            taskInfoDict[@"taskId"] = self.infoDict[@"taskId"];
            httpGET2(taskInfoDict, ^(id result) {
                NSLog(@"%@",result);
                self.taskInfoDetail = result[@"detail"];
                //召回重做
                NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
                paraDict[URL_TYPE] = NW_CallBackTaskLevelOne;
                paraDict[@"taskId"] = self.infoDict[@"taskId"];
                paraDict[@"workContent"] = [NSString stringWithFormat:@"%@(%@)",self.infoDict[@"taskName"],self.siteInfo[@"siteName"]];
                paraDict[@"finishedAmount"] = self.taskInfoDetail[@"amount"];
                paraDict[@"foundProblem"] = @"";
                paraDict[@"handledProblem"] = @"";
                httpGET2(paraDict, ^(id result) {
                    showAlert(@"已召回重做");
                }, ^(id result) {
                    showAlert(result[@"error"]);
                });
                
            }, ^(id result) {
                showAlert(result[@"error"]);
            });
        }else if (buttonIndex == 2){//二级召回重做
            UIViewController* parentVC = getViewController(self);
            TaskJiaohunList* vc = [[TaskJiaohunList alloc] init];
            vc.planDate = self.planDate;
            vc.detail = (NSMutableDictionary *)self.infoDict;
            vc.siteName = self.siteInfo[@"siteName"];
            vc.isSecondaryTask = m_isJiaohuan;
            vc.respBlock= ^(int undoCount) {
                if (undoCount == 0) {
                    mainThread(onCommitAfter:, @[_indexPath]);
                }
            };
            [parentVC.navigationController pushViewController:vc animated:YES];
            [vc release];

        }
    }else if (alertView.tag == 12001){//没有二级任务
        if (buttonIndex == 0) {//不召回重做
            NSLog(@"不召回重做");
        }else if (buttonIndex == 1){//召回重做
            NSLog(@"召回重做");
            
            UIViewController* parentVC = getViewController(self);
            TaskDetail* vc = [[TaskDetail alloc] init];
            vc.detail = (NSMutableDictionary *)self.infoDict;
            vc.isCallBackAction = YES;
            vc.respBlock= ^(id result) {
                mainThread(onCommitAfter:, @[_indexPath]);
            };
            [parentVC.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    }
}

- (void)onHeadBtnTouched:(UIButton*)sender
{
    NSInteger section = sender.tag-1000;
    NSInteger status = [m_data[section][@"extended"] intValue];
    status = (status==1 ? 0 : 1);
    m_data[section][@"extended"] = @(status);
    [m_table reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:0];
}


- (void)onCheckBtnTouched:(UIButton*)sender
{
    UITableViewCell* cell = (UITableViewCell*)getParentView(sender.superview, [UITableViewCell class]);
    NSIndexPath* indexPath = [m_table indexPathForCell:cell];
    NSMutableDictionary* dataRow = m_data[indexPath.section][@"cycleList"][indexPath.row];
    
    int status = [dataRow[@"selected"] intValue];
    status = (status==0 ? 1 : 0);
    dataRow[@"selected"] = @(status);
    [m_table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:0];
}
/**
 *  取消弹框提示 直接跳到二级任务页面
 *
 *  @param dataRow <#dataRow description#>
 */
- (void)onWuxianCellTouched:(NSMutableDictionary*)dataRow
{
    m_isBack = NO;
    m_tempDataRow = dataRow;
    if ([dataRow[@"taskStatus"] intValue] == 1) {
//        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"是否召回重做"
//                                                            message:@""
//                                                           delegate:self
//                                                  cancelButtonTitle:@"否"
//                                                  otherButtonTitles:@"是", nil];
//        [alertView showWithBlock:^(NSInteger btnIndex) {
//            if (btnIndex > 0) {
//                m_isBack = YES;
//                dataRow[@"taskStatus"] = @TASK_REDO;
//                [self showSignDialog:dataRow];
//            } else {
//                [self openWuxianDetail:dataRow IsView:YES];
//            }
//        }];
//        [alertView release];
        [self openWuxianDetail:dataRow IsView:YES];
    } else {
        [self showSignDialog:dataRow];
    }
}

- (void)showSignDialog:(NSMutableDictionary*)dataRow
{
    if ([dataRow[@"isSigned"] intValue] == 0){
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"请点击签到"
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"签到", nil];
        [alertView showWithBlock:^(NSInteger btnIndex) {
            if (btnIndex > 0) {
//                #if TARGET_IPHONE_SIMULATOR
//                g_waitingGpsObj = self;
//                [m_locService startUserLocationService];
//                #else
//                [self signForWuxianWithGPS];
//                #endif
                _mapView.delegate = self;
                g_waitingGpsObj = self;
                [m_locService startUserLocationService];
                _mapView.userTrackingMode = BMKUserTrackingModeNone;
                _mapView.showsUserLocation = NO;
                _mapView.userTrackingMode = BMKUserTrackingModeFollow;
                _mapView.showsUserLocation = YES;
                
                
            }
        }];
        [alertView release];
    } else {
        [self openWuxianDetail:dataRow IsView:([dataRow[@"taskStatus"] intValue] == TASK_DONE)];
    }
}

- (void)signForWuxianWithGPS
{
    NSMutableDictionary* dataRow = m_tempDataRow;
    NSString* longitude = [@(m_coordinate.longitude) stringValue];
    NSString* latitude = [@(m_coordinate.latitude) stringValue];
    
//    if ([longitude isEqualToString:@"0"] && [latitude isEqualToString:@"0"]) {
//        
//    }
    
    httpGET2(@{URL_TYPE:NW_SignInAtSite,
               @"regionId":self.siteInfo[@"siteId"],
               @"specialtyId":self.typeInfo[@"speciltyId"],
               @"longitude":longitude,//strLongitude
               @"latitude":latitude}, ^(id result) {//strLatitude
                   [self openWuxianDetail:dataRow IsView:NO];
               }, ^(id result) {
                   UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"签到失败"
                                                                       message:@""
                                                                      delegate:self
                                                             cancelButtonTitle:@"确定"
                                                             otherButtonTitles:nil, nil];
                   [alertView showWithBlock:^(NSInteger btnIndex) {
                       mainThread(signTypeSelectDialog, nil);
                   }];
               });
    
}

- (void)signTypeSelectDialog
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"请选择签到类型"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"图片签到", @"重新签到", nil];
    [alertView showWithBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            httpGET1(@{URL_TYPE:NW_GetSignFailedReasons}, ^(id result) {
                mainThread(signFaildReasonSelectDialog:, result[@"list"]);
            });
        } else if (btnIndex == 2) {
            [self signForWuxianWithGPS];
        }
    }];
    [alertView release];
}

- (void)signFaildReasonSelectDialog:(NSArray*)reasons
{
    SignFailedReason* sign = [[[SignFailedReason alloc] init] autorelease];
    sign.regionId = self.siteInfo[@"siteId"];
    sign.signOverBlock = ^(BOOL isSuccess) {
        if (isSuccess) {
            showAlert(@"签到成功");
            [self openWuxianDetail:m_tempDataRow IsView:NO];
        } else {
            showAlert(@"签到失败");
             mainThread(signTypeSelectDialog, nil);
        }
    };
    [sign showDialog:m_parentVC];
}

- (void)openWuxianDetail:(NSMutableDictionary*)dataRow IsView:(BOOL)isview
{
    TaskWirelessDetail* vc = [[TaskWirelessDetail alloc] init];
    vc.superList = self;
    vc.task = dataRow;
    vc.op = (isview ? OP_VIEW : OP_EDIT);
    vc.isBack = m_isBack;
//    vc.view.userInteractionEnabled=NO;
    [m_parentVC.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    m_coordinate = userLocation.location.coordinate;
    
    strLongitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
    strLatitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
    
    [m_locService stopUserLocationService];
    
    g_waitingGpsObj = nil;
    if (ABS(m_coordinate.longitude)>10
        && ABS(m_coordinate.latitude)>10) {
        [self signForWuxianWithGPS];
    }
}


- (void)didFailToLocateUserWithError:(NSError *)error
{
    [m_locService stopUserLocationService];
    g_waitingGpsObj = nil;
    showAlert(@"GPS定位失败!");
}

#pragma mark 在开时定位时调用
- (void)willStartLocatingUser
{
    NSLog(@"开始调用");
}
#pragma mark 在停止定位后，会调用此函数
- (void)didStopLocatingUser
{
    NSLog(@"定位结束");
}

- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.2;
    region.span.longitudeDelta = 0.2;
    NSLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
   
    
    if (ABS(userLocation.location.coordinate.longitude)>10
        && ABS(userLocation.location.coordinate.latitude)>10) {
        
         m_coordinate = userLocation.location.coordinate;
        
        strLongitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
        strLatitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
        
        [m_locService stopUserLocationService];
        g_waitingGpsObj = nil;

        [self signForWuxianWithGPS];
    }
}

@end
