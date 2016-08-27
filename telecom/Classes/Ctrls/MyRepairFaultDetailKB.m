//
//  MyRepairFaultDetailKB.m
//  telecom
//
//  Created by ZhongYun on 14-11-17.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyRepairFaultDetailKB.h"
#import "TaskTypeBarDiff.h"

#import "RepairFaultDetailKBView.h"
#import "FeedbackController.h"
#import "RespondViewController.h"
#import "FixsViewController.h"
#import "ApplyForSupportController.h"
#import "ShareInfoViewController.h"
#import "AddShareInfoController.h"
#import "MyShareViewController.h"
#import "AddSGYY.h"

#import "FaultTrackViewController.h"
#import "MyResourceQuery.h"
#import "WirelessNetManage.h"
#import "AlarmInfoViewController.h"
#import "ResourcesViewController.h"
#import "StandardizeViewController.h"

#define TVIEW_H         40
#define TAG_BASIC       18000
@interface MyRepairFaultDetailKB ()<TaskTypeBarDiffDelegate>
{
    NSMutableArray* m_typeList;
    TaskTypeBarDiff* m_typeView;
    BOOL m_tabExitsFlg;
    
    UIView *_entrancesView;
    UIView *_trackReourceAlertEntrancesView;
    BOOL _entrancesIsHiding;
    BOOL _trackReourceAlertEntrancesIsHiding;
}
@end

@implementation MyRepairFaultDetailKB

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"客保故障单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    m_tabExitsFlg = NO;
    _entrancesIsHiding = YES;
    _trackReourceAlertEntrancesIsHiding = YES;
    self.navBarView.hidden = YES;
    
    if ([self.rightItemKind isEqualToString:@"从故障直查地图页面跳入"]) {
        //最右边btn
        UIImage* commitIcon = [UIImage imageNamed:@"信息1.png"];
        UIButton* commitBtn1 = [[UIButton alloc] initWithFrame:RECT((APP_W-40), 7,commitIcon.size.width/1.3, commitIcon.size.height/1.3)];
        [commitBtn1 setImage:[commitIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        commitBtn1.titleLabel.font = FontB(Font3);
        [commitBtn1 addTarget:self action:@selector(trackReourceAlertEntrances) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:commitBtn1];
        self.navigationItem.rightBarButtonItem = item1;
        [commitBtn1 release];
        [item1 release];
    }else{
        //右二btn
        UIImage* commitIcon = [UIImage imageNamed:@"操作1.png"];
        UIButton* commitBtn2 = [[UIButton alloc] initWithFrame:RECT((APP_W-105), 7,commitIcon.size.width/1.3, commitIcon.size.height/1.3)];
        [commitBtn2 setImage:[commitIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        commitBtn2.titleLabel.font = FontB(Font3);
        [commitBtn2 addTarget:self action:@selector(entrances:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:commitBtn2];
        self.navigationItem.rightBarButtonItem = item2;
        [commitBtn2 release];
        [item2 release];
        
        if ([self.originalVc isEqualToString:NW_GetRepairFault]) {
            UIImage* commitIcon = [UIImage imageNamed:@"信息1.png"];
            UIButton* commitBtn1 = [[UIButton alloc] initWithFrame:RECT((APP_W-40), 7,commitIcon.size.width/1.3, commitIcon.size.height/1.3)];
            [commitBtn1 setImage:[commitIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            commitBtn1.titleLabel.font = FontB(Font3);
            [commitBtn1 addTarget:self action:@selector(trackReourceAlertEntrances) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:commitBtn1];
    // self.navigationItem.rightBarButtonItems = @[item1,item2];增加标准化手册之前未注释
            [commitBtn1 release];
            
            
            //增加标准化手册按钮
            UIImage* Icon = [UIImage imageNamed:@"wenhao.png"];
            UIButton* commitBtn3 = [[UIButton alloc] initWithFrame:RECT((APP_W-170), 7,commitIcon.size.width/1.3, commitIcon.size.height/1.3)];
            [commitBtn3 setImage:[Icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
            commitBtn3.titleLabel.font = FontB(Font3);
            [commitBtn3 addTarget:self action:@selector(standardize:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:commitBtn3];
            self.navigationItem.rightBarButtonItems = @[item1,item2,item3];
            [commitBtn3 release];
            [item1 release];
            [item3 release];

        }
    }
    
    if (self.pushNotice != nil && [self.pushNotice isEqualToString:@"pushNotice"] && self.workNo != nil) {
        [self loadData];
    }else{
        [self loadTypeList];
    }
    
}
//增加标准化手册
- (void)standardize:(UIButton *)btn
{
    StandardizeViewController *ctrl = [[StandardizeViewController alloc] init];
    NSDictionary *dict = self.workInfo;
    NSString *str1 = dict[@"faultPartDesc1"] == nil ? @"":dict[@"faultPartDesc1"];
    NSString *str2 = dict[@"faultPartDesc2"] == nil ? @"":dict[@"faultPartDesc2"];
    NSString *str3 = dict[@"faultPartDesc3"] == nil ? @"":dict[@"faultPartDesc3"];
    NSString *str4 = dict[@"faultPartDesc4"] == nil ? @"":dict[@"faultPartDesc4"];
    NSString *str5 = dict[@"faultPartDesc5"] == nil ? @"":dict[@"faultPartDesc5"];
    NSString *str6 = dict[@"faultPartDesc6"] == nil ? @"":dict[@"faultPartDesc6"];
    NSString *str7 = dict[@"faultPartDesc7"] == nil ? @"":dict[@"faultPartDesc7"];
    NSString *str8 = dict[@"faultPartDesc8"] == nil ? @"":dict[@"faultPartDesc8"];
    NSString *str9 = dict[@"workType"] == nil ? @"":dict[@"workType"];
    NSString *str10 = dict[@"spec"] == nil ? @"":dict[@"spec"];
    NSString *urlStr = [[NSString stringWithFormat:@"http://%@/doc-app/doc/p/search.do?key=%@ %@ %@ %@ %@ %@ %@ %@ %@&and=障碍处理|%@",ADDR_IP,str9,str1,str2,str3,str4,str5,str6,str7,str8,str10]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];   
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    ctrl.request = request;
    [self.navigationController pushViewController:ctrl animated:YES];
    [ctrl release];
}

- (void)loadData
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = kSearchFaultLocal;
    paraDict[@"workNo"] = self.workNo;
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            self.workInfo = (NSDictionary *)[result[@"list"] firstObject];
            [self loadTypeList];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (void)trackReourceAlertEntrances
{
    NSArray *trackReourceAlertArray = @[@"资源",@"网管告警",@"综合告警"];
    if (_trackReourceAlertEntrancesIsHiding == YES) {
        
        if (_entrancesIsHiding != YES) {
            _entrancesView.hidden = YES;
            _entrancesIsHiding = YES;
        }
        
        _trackReourceAlertEntrancesView = [[UIView alloc] initWithFrame:CGRectMake(APP_W-110, NAV_H+STATUS_H, 100, trackReourceAlertArray.count*39)];
        _trackReourceAlertEntrancesView.backgroundColor = COLOR(239, 239, 239);
        _trackReourceAlertEntrancesView.layer.borderWidth = 0.5;
        _trackReourceAlertEntrancesView.layer.borderColor = COLOR(215, 215, 215).CGColor;
        [self.view addSubview:_trackReourceAlertEntrancesView];
        
        for (int i=0; i < trackReourceAlertArray.count; i++) {
            UIButton *entrancesBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            entrancesBtn.frame = CGRectMake(0, 39*i, 100, 39);
            [entrancesBtn setTitle:trackReourceAlertArray[i] forState:UIControlStateNormal];
            [entrancesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [entrancesBtn addTarget:self action:@selector(firstEntryAction:) forControlEvents:UIControlEventTouchUpInside];
            entrancesBtn.tag = 7000+i;
            [_trackReourceAlertEntrancesView addSubview:entrancesBtn];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39+(39*i), 100, 1)];
            lineView.backgroundColor = [UIColor grayColor];
            [_trackReourceAlertEntrancesView addSubview:lineView];
            [lineView release];
        }
        _trackReourceAlertEntrancesIsHiding = NO;
    }else{
        
        _trackReourceAlertEntrancesView.hidden = YES;
        _trackReourceAlertEntrancesIsHiding = YES;
    }
}

- (void)entrances:(UIButton *)sender
{
    if ([self.originalVc isEqualToString:NW_GetRepairFault]) {
        NSArray *entrancesArray = @[@"反馈",@"响应",@"支撑",@"修复",@"共享",@"新增施工预约"];
        if (_entrancesIsHiding == YES) {
            
            if (_trackReourceAlertEntrancesIsHiding != YES) {
                _trackReourceAlertEntrancesView.hidden = YES;
                _trackReourceAlertEntrancesIsHiding = YES;
            }
            
            _entrancesView = [[UIView alloc] initWithFrame:CGRectMake(APP_W-110, NAV_H+STATUS_H, 100, entrancesArray.count*39)];
            _entrancesView.backgroundColor = COLOR(239, 239, 239);
            _entrancesView.layer.borderWidth = 0.5;
            _entrancesView.layer.borderColor = COLOR(215, 215, 215).CGColor;
            [self.view addSubview:_entrancesView];
            
            for (int i=0; i<entrancesArray.count; i++) {
                UIButton *entrancesBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                entrancesBtn.frame = CGRectMake(0, 39*i, 100, 39);
                [entrancesBtn setTitle:entrancesArray[i] forState:UIControlStateNormal];
                [entrancesBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [entrancesBtn addTarget:self action:@selector(secondEntryAction:) forControlEvents:UIControlEventTouchUpInside];
                entrancesBtn.tag = 8000+i;
                [_entrancesView addSubview:entrancesBtn];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39+(39*i), 100, 1)];
                lineView.backgroundColor = [UIColor grayColor];
                [_entrancesView addSubview:lineView];
                [lineView release];
            }
            _entrancesIsHiding = NO;
        }else{
            _entrancesView.hidden = YES;
            _entrancesIsHiding = YES;
        }
    }
    
    if ([self.originalVc isEqualToString:AssiGetSharedFaultList]) {
        MyShareViewController *myShareVc = [[MyShareViewController alloc] init];
        myShareVc.faultId = self.workInfo[@"workNo"];
        myShareVc.uploadNo = self.workInfo[@"faultId"];
        [self.navigationController pushViewController:myShareVc animated:YES];
        [myShareVc release];
    }
    
}

- (void)firstEntryAction:(UIButton *)entranceBtn
{
    NSInteger index = entranceBtn.tag - 7000;
    if (index == 0){//资源
        NSString *workType = self.workInfo[@"workType"];
        if ([workType isEqualToString:@"LTE无线侧"]) {
            MyResourceQuery *reseourceQuery = [[MyResourceQuery alloc] init];
            NSString *condition = self.workInfo[@"faultPartDesc1"];
            if ([condition rangeOfString:@"BBU"].location != NSNotFound) {
                reseourceQuery.vcTag = 2;
            }else if ([condition rangeOfString:@"RRU"].location != NSNotFound){
                reseourceQuery.vcTag = 3;
            }else{
                reseourceQuery.vcTag = 2;
            }
            NSMutableString *mutableStr = [NSMutableString stringWithString:condition];
            NSArray *arr = [mutableStr componentsSeparatedByString:@"//"];
            NSString *searchCondition = arr[1];
            NSString *searchConditionStr = [searchCondition rangeOfString:@"LBBU"].location != NSNotFound ? [searchCondition substringFromIndex:[searchCondition rangeOfString:@"LBBU"].location] : searchCondition;
            [reseourceQuery loadData:searchConditionStr];
            [self.navigationController pushViewController:reseourceQuery animated:YES];
            [reseourceQuery release];
        }else if ([workType isEqualToString:@"WLAN无线侧"] || [workType isEqualToString:@"CDMA无线侧"]){
            showAlert(@"无相关资源信息!");
        }else if ([workType isEqualToString:@"空调"] || [workType isEqualToString:@"电源"]){
            AlarmInfoViewController *alarmInfoCtrl = [[AlarmInfoViewController alloc] init];
            alarmInfoCtrl.type = @"关联资源";
            alarmInfoCtrl.orderNo = self.workInfo[@"orderNo"];
            alarmInfoCtrl.workNo = self.workInfo[@"workNo"];
            [self.navigationController pushViewController:alarmInfoCtrl animated:YES];
            [alarmInfoCtrl release];
        }else if ([workType isEqualToString:@"PON告警"]){//如果workType是PON信息的时候 跳入到PON查询页面 只查ONU类型的
            EponInfoViewController *eponInfoCtrl = [[EponInfoViewController alloc] init];
            NSString *equipCode = self.workInfo[@"faultPartDesc1"];
            [self.navigationController pushViewController:eponInfoCtrl animated:YES];
            
            [eponInfoCtrl searchEponInfoWithEquipCode:equipCode equipKind:@"3" flag:@"2"];
            [eponInfoCtrl release];
        }else if ([workType rangeOfString:@"交换"].location != NSNotFound){//交换
            ResourcesViewController *resourceCtrl = [[ResourcesViewController alloc] init];
            [resourceCtrl loadDataWithSearchCondition:self.workInfo[@"faultPartDesc1"]];
            [self.navigationController pushViewController:resourceCtrl animated:YES];
            [resourceCtrl release];
        }
        
    }else if (index == 1){//网管告警
        NSString *workType = self.workInfo[@"workType"];
        if ([workType isEqualToString:@"LTE无线侧"]) {
            WirelessNetManage *wirelessNetManageCtrl = [[WirelessNetManage alloc] init];
            NSString *condition = self.workInfo[@"faultPartDesc1"];
            NSMutableString *mutableStr = [NSMutableString stringWithString:condition];
            NSArray *arr = [mutableStr componentsSeparatedByString:@"//"];
            NSString *searchCondition = arr[1];
            NSString *searchConditionStr = [searchCondition rangeOfString:@"LBBU"].location != NSNotFound ? [searchCondition substringFromIndex:[searchCondition rangeOfString:@"LBBU"].location] : searchCondition;
            [wirelessNetManageCtrl loadData:searchConditionStr];
            [self.navigationController pushViewController:wirelessNetManageCtrl animated:YES];
            [wirelessNetManageCtrl release];
        }else if ([workType isEqualToString:@"WLAN无线侧"] || [workType isEqualToString:@"CDMA无线侧"]){
            showAlert(@"无相关网管告警!");
        }else if ([workType isEqualToString:@"空调"] || [workType isEqualToString:@"电源"]){
            AlarmInfoViewController *alarmInfoCtrl = [[AlarmInfoViewController alloc] init];
            alarmInfoCtrl.type = @"网管告警";
            alarmInfoCtrl.orderNo = self.workInfo[@"orderNo"];
            alarmInfoCtrl.workNo = self.workInfo[@"workNo"];
            [self.navigationController pushViewController:alarmInfoCtrl animated:YES];
            [alarmInfoCtrl release];
        }
    }else if (index == 2) {
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = @"Select/NetDangerSelect";
        paraDict[@"workNo"] = _workNo;
        httpPOST(paraDict, ^(id result) {
            NSString *message = nil;
            if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
                NSDictionary *return_data = [result objectForKey:@"return_data"];
                message = [NSString stringWithFormat:@"截至[%@]\n最新消息为: [%@]",[return_data objectForKey:@"revertTime"],[return_data objectForKey:@"alertContent"]];
            }else {
                message = [result objectForKey:@"error"];
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        }, ^(id result) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            
        });

    }
}

- (void)secondEntryAction:(UIButton *)entranceBtn
{
    NSInteger index = entranceBtn.tag - 8000;
    if (index == 0) {//反馈
        FeedBackController *feedCtrl = [[FeedBackController alloc] init];
        feedCtrl.workNum = self.workInfo[@"workNo"];
        feedCtrl.orderNum = self.workInfo[@"orderNo"];
        [self.navigationController pushViewController:feedCtrl animated:YES];
        [feedCtrl release];
    }else if (index == 1){//响应
        RespondViewController *respondCtrl = [[RespondViewController alloc] init];
        respondCtrl.workNum = self.workInfo[@"workNo"];
        respondCtrl.orderNo = self.workInfo[@"orderNo"];
        [self.navigationController pushViewController:respondCtrl animated:YES];
        [respondCtrl release];
    }else if (index == 2){//支撑申请
        ApplyForSupportController *applyForSupportCtrl = [[ApplyForSupportController alloc] init];
        applyForSupportCtrl.workNum = self.workInfo[@"workNo"];
        applyForSupportCtrl.orderNo = self.workInfo[@"orderNo"];
        [self.navigationController pushViewController:applyForSupportCtrl animated:YES];
        [applyForSupportCtrl release];
    }else if (index == 3){//修复
        FixsViewController *fixCtrl = [[FixsViewController alloc] init];
        fixCtrl.workNum = self.workInfo[@"workNo"];//workNo 01107569
        fixCtrl.orderNo = self.workInfo[@"orderNo"];//orderNo 20150311660685
        fixCtrl.spec = self.workInfo[@"spec"];
        [self.navigationController pushViewController:fixCtrl animated:YES];
        [fixCtrl release];
    }else if (index == 4){//分享
        ShareInfoViewController *shareInfoCtrl = [[ShareInfoViewController alloc] init];
        shareInfoCtrl.faultId = self.workInfo[@"workNo"];
        shareInfoCtrl.workInfoDict = self.workInfo;
        [self.navigationController pushViewController:shareInfoCtrl animated:YES];
        [shareInfoCtrl release];
    }else if (index == 5){//新增施工预约
        AddSGYY *addSGYYCtrl = [[AddSGYY alloc] init];
        addSGYYCtrl.orderNo = self.workInfo[@"orderNo"];
        addSGYYCtrl.workInfo = self.workInfo;
        [self.navigationController pushViewController:addSGYYCtrl animated:YES];
        [addSGYYCtrl release];
    }
}

- (void)setWorkInfo:(NSDictionary *)workInfo
{
    _workInfo = [workInfo retain];
}

- (void)loadTypeList
{
    if (self.pushNotice != nil && [self.pushNotice isEqualToString:@"pushNotice"]) {
        if (!m_typeList) {
            m_typeList = [[NSMutableArray alloc] init];
            m_typeView = [[TaskTypeBarDiff alloc] initWithFrame:RECT(0, 64, APP_W, TVIEW_H) flag:self.pushNotice];
            m_typeView.backgroundColor = [UIColor whiteColor];
            m_typeView.buttonWidth = 100;
            m_typeView.delegate = self;
            [self.view addSubview:m_typeView];
        }
        [m_typeList removeAllObjects];
        
        if ([self.originalVc isEqualToString:NW_GetRepairFault]) {
            [m_typeList addObjectsFromArray:@[@{@"typeId":@(TI_DETAIL_KB), @"speciltyName":@"故障单详细", @"taskAmount":@0},@{@"typeId":@(TI_RECORD_KB), @"speciltyName":@"故障流水信息", @"taskAmount":@0}] ];
        }
        
        if ([self.originalVc isEqualToString:AssiGetSharedFaultList]) {
            [m_typeList addObjectsFromArray:@[@{@"typeId":@(TI_DETAIL_KB), @"speciltyName":@"故障单详细", @"taskAmount":@0}] ];
        }
        
        NSInteger selected = 0;
        if (m_typeList.count > 0) {
            CGRect frame = RECT(0, m_typeView.ey, APP_W, SCREEN_H-m_typeView.ey);
            for (int i=0; i<m_typeList.count; i++) {
                RepairFaultDetailKBView* view = [[RepairFaultDetailKBView alloc] initWithFrame:frame];
                view.typeInfo = m_typeList[i];
                view.workInfo = self.workInfo;
                view.backgroundColor = [UIColor whiteColor];
                view.tag = i + TAG_BASIC;
                view.hidden = YES;
                [self.view addSubview:view];
                [view release];
            }
            m_typeView.typeList = m_typeList;
            m_typeView.selected = selected;
        }
    }else{
        if (!m_typeList) {
            m_typeList = [[NSMutableArray alloc] init];
            m_typeView = [[TaskTypeBarDiff alloc] initWithFrame:RECT(0, 64, APP_W, TVIEW_H) flag:nil];
            m_typeView.backgroundColor = [UIColor whiteColor];
            m_typeView.buttonWidth = 100;
            m_typeView.delegate = self;
            [self.view addSubview:m_typeView];
        }
        [m_typeList removeAllObjects];
        
        if ([self.originalVc isEqualToString:NW_GetRepairFault]) {
            [m_typeList addObjectsFromArray:@[@{@"typeId":@(TI_DETAIL_KB), @"speciltyName":@"故障单详细", @"taskAmount":@0},@{@"typeId":@(TI_RECORD_KB), @"speciltyName":@"故障流水信息", @"taskAmount":@0}] ];
        }
        
        if ([self.originalVc isEqualToString:AssiGetSharedFaultList]) {
            [m_typeList addObjectsFromArray:@[@{@"typeId":@(TI_DETAIL_KB), @"speciltyName":@"故障单详细", @"taskAmount":@0}] ];
        }
        
        NSInteger selected = 0;
        if (m_typeList.count > 0) {
            CGRect frame = RECT(0, m_typeView.ey, APP_W, SCREEN_H-m_typeView.ey);
            for (int i=0; i<m_typeList.count; i++) {
                RepairFaultDetailKBView* view = [[RepairFaultDetailKBView alloc] initWithFrame:frame];
                view.typeInfo = m_typeList[i];
                view.workInfo = self.workInfo;
                view.backgroundColor = [UIColor whiteColor];
                view.tag = i + TAG_BASIC;
                view.hidden = YES;
                [self.view addSubview:view];
                [view release];
            }
            m_typeView.typeList = m_typeList;
            m_typeView.selected = selected;
        }
    }
}

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count
{
    [m_typeView updatePointStatus:index Count:count];
}

- (void)updateNavBtnStatus:(RepairFaultDetailKBView*)view
{
    if (view.tag-TAG_BASIC == m_typeView.selected) {
        
    }
}

- (void)changeBefore:(TaskTypeBarDiff*)sender
{
    [self.view viewWithTag:m_typeView.selected+TAG_BASIC].hidden = YES;
}

- (void)changeAfter:(TaskTypeBarDiff*)sender
{
    NSInteger viewTag = sender.selected+TAG_BASIC;
    RepairFaultDetailKBView* view = tagViewEx(self.view, viewTag, RepairFaultDetailKBView);
    view.hidden = NO;
    [view buildView];
    [self updateNavBtns:view];
}

- (void)updateNavBtns:(RepairFaultDetailKBView*)currView
{
    
}

@end

