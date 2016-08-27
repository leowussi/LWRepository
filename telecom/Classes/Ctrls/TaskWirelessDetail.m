//
//  TaskWirelessDetail.m
//  telecom
//
//  Created by ZhongYun on 15-3-23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "TaskWirelessDetail.h"
#import "WirelessNetManage.h"
#import "TaskTypeBar.h"
#import "TaskWirelessView.h"
#import "TaskFaultRisk.h"
#import "UploadData.h"
#import "AddTroubleViewController.h"
#import "TopTypeBarView.h"

#define TVIEW_H         40
#define TAG_BASIC       18000

@interface TaskWirelessDetail ()<TopTypeBarDelegate>
{
    NSMutableArray* m_typeList;
    TopTypeBarView* m_typeView;
    
    NSMutableArray* m_commitArray;
    
    NSMutableData* recv_data;
    long long total_size;
    
    NSString* m_net_keyword;
    
    
}
@end

@implementation TaskWirelessDetail

- (void)dealloc
{
    [m_commitArray release];
    [m_typeView release];
    [m_typeList release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"二级任务";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addNavBtns];
    
    m_typeView = [[TopTypeBarView alloc] initWithFrame:RECT(0, 64, APP_W, TVIEW_H)];
    m_typeView.backgroundColor = [UIColor whiteColor];
    m_typeView.delegate = self;
    m_typeView.isWireless = YES;
    [self.view addSubview:m_typeView];
    
    m_commitArray = [[NSMutableArray alloc] init];
    m_typeList = [[NSMutableArray alloc] init];
    [self loadData];
}

- (void)loadData
{
    httpGET2(@{URL_TYPE:NW_GetWXSecondaryTaskList, @"taskId":self.task[@"taskId"]}, ^(id result) {
        mainThread(buildCommitArray:, result);
        mainThread(updateTypeListBar:, result);
    }, ^(id result) {
        mainThread(updateTypeListBar:, nil);
    });
}

- (void)buildCommitArray:(id)result
{
    [m_commitArray removeAllObjects];
    NSArray* groups = result[@"list"];
    for (id group in groups) {
        for (id item in group[@"groupContent"]) {
            if ([item[@"writeType"] rangeOfString:@"/"].location != NSNotFound
                && [item[@"result"] isEqualToString:@""]) {
                item[@"result"] = @"无";
            }
            
            if ([item[@"writeType"] rangeOfString:@"精确到天"].location != NSNotFound
                && [item[@"result"] isEqualToString:@""]) {
                item[@"result"] = date2str([NSDate date], DATE_FORMAT);
            }
            
            if ([item[@"writeType"] rangeOfString:@"精确到分"].location != NSNotFound
                && [item[@"result"] isEqualToString:@""]) {
                item[@"result"] = date2str([NSDate date], @"yyyy-MM-dd HH:mm");
            }
            
            if ([item[@"writeType"] rangeOfString:@"场强"].location != NSNotFound
                && [item[@"result"] isEqualToString:@""]) {
                int dBm = device_SignalLevel();
                int PCI = dBm - 5;
                item[@"result"] = format(@"%d;%d", dBm, PCI);;
            }
            
            if ([item[@"writeType"] rangeOfString:@"PCI"].location != NSNotFound
                && [item[@"result"] isEqualToString:@""]) {
                int dBm = device_SignalLevel();
                int PCI = dBm - 5;
                item[@"result"] = format(@"%d", PCI);;
            }
            
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:item[@"subTaskId"],STK_ID,item[@"subTaskName"],STK_NM,item[@"remark"],STK_RM,item[@"result"],STK_CT, nil];
            [m_commitArray addObject:mutDict];
//            [m_commitArray addObject:[@{STK_ID:item[@"subTaskId"],
//                                        STK_NM:item[@"subTaskName"],
//                                        STK_RM:item[@"remark"],
//                                        STK_CT:item[@"result"],
//                                        } mutableCopy]];
            
            if ([item[@"subTaskName"] rangeOfString:@"站号"].location != NSNotFound) {
                m_net_keyword = item[@"result"];
            }
        }
    }
}

- (void)addNavBtns
{
    
    UIImage* moreIcon = [UIImage imageNamed:@"nav_more.png"];
    UIButton* moreBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-moreIcon.size.width), (NAV_H-moreIcon.size.height)/2,
                                                             moreIcon.size.width, moreIcon.size.height)];
    [moreBtn setBackgroundImage:moreIcon forState:0];
    [moreBtn addTarget:self action:@selector(onMoreBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navBarView addSubview:moreBtn];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    [moreBtn release];
    
    UIImage* execIcon = [UIImage imageNamed:@"nav_exec.png"];
    UIButton* execBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-moreIcon.size.width), (NAV_H-moreIcon.size.height)/2,
                                                             moreIcon.size.width, moreIcon.size.height)];
    execBtn.fx = execBtn.fx - 10 - execIcon.size.width;
    [execBtn setBackgroundImage:execIcon forState:0];
    [execBtn addTarget:self action:@selector(onExecBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navBarView addSubview:execBtn];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:execBtn];
    [execBtn release];
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* m_checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-moreIcon.size.width), (NAV_H-moreIcon.size.height)/2,
                                                                moreIcon.size.width, moreIcon.size.height)];
    m_checkBtn.hidden = (self.op == OP_VIEW);
    m_checkBtn.fx = m_checkBtn.fx - 10 - checkIcon.size.width;
    [m_checkBtn setBackgroundImage:checkIcon forState:0];
    [m_checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navBarView addSubview:m_checkBtn];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:m_checkBtn];
    [m_checkBtn release];
    
    
    
    self.navigationItem.rightBarButtonItems = @[item1,item2,item3];
    [item3 release];
    [item1 release];
    [item2 release];
}

- (void)updateTypeListBar:(id)result
{
    [m_typeList removeAllObjects];
    NSArray* groups = result[@"list"];
    for (int i = 0; i < groups.count; i++) {
        [m_typeList addObject:@{@"groupId":@(i),@"speciltyName":groups[i][@"groupName"], @"taskAmount":@"0"}];
    }
    
    NSInteger selected = 0;
    if (m_typeList.count > 0) {
        CGRect frame = RECT(0, m_typeView.ey, APP_W, SCREEN_H-m_typeView.ey);
        for (int i=0; i<m_typeList.count; i++) {
            TaskWirelessView* view = [[TaskWirelessView alloc] initWithFrame:frame];
            view.typeInfo = m_typeList[i];
            view.task = self.task;
            view.group = groups[i];
            view.backgroundColor = [UIColor whiteColor];
            view.tag = i + TAG_BASIC;
            view.hidden = YES;
            view.commitArray = m_commitArray;
            [self.view addSubview:view];
            [view release];
        }
        m_typeView.typeList = m_typeList;
        m_typeView.selected = selected;
    }
}

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count
{
    [m_typeView updatePointStatus:index Count:count];
}

- (void)updateNavBtnStatus:(TaskWirelessView*)view
{
    if (view.tag-TAG_BASIC == m_typeView.selected) {
        
    }
}

- (void)changeBefore:(TaskTypeBar*)sender
{
    [self.view endEditing:YES];
    [self.view viewWithTag:m_typeView.selected+TAG_BASIC].hidden = YES;
}

- (void)changeAfter:(TaskTypeBar*)sender
{
    NSInteger viewTag = sender.selected+TAG_BASIC;
    TaskWirelessView* view = tagViewEx(self.view, viewTag, TaskWirelessView);
    view.hidden = NO;
    [self updateNavBtns:view];
}

- (void)updateNavBtns:(TaskWirelessView*)currView
{

}



- (void)onMoreBtnTouched:(id)sender
{
    [self.view endEditing:YES];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"选择操作方式"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"我的资源", @"网管", nil];
    [alertView showWithBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            #warning TODO: 打开我的资源;
            showAlert(@"无该类型数据查询");
        } else if (btnIndex == 2) {
            WirelessNetManage* vc = [[WirelessNetManage alloc] init];
            vc.keyword = m_net_keyword;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
    }];
    [alertView release];
}

- (void)onExecBtnTouched:(id)sender
{
    [self.view endEditing:YES];
    
//    TaskFaultRisk* vc = [[TaskFaultRisk alloc] init];
//    vc.task = self.task;
//    [self.navigationController pushViewController:vc animated:YES];
//    [vc release];
    
    AddTroubleViewController* vc = [[AddTroubleViewController alloc] init];
    vc.callBackInfoDict = self.task;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];

    
}

- (void)onCheckBtnTouched:(id)sender
{
//    w_dxwl_zxp
    [self.view endEditing:YES];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"选择操作方式"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"提交", nil];
    [alertView showWithBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            mainThread(CommitData, nil);
        } else if (btnIndex == 2) {
            mainThread(SaveData, nil);
        }
    }];
    [alertView release];
}

- (void)CommitData
{
    
    for (id item in m_commitArray) {
       
        if ( [[item[STK_CT] description] isEqualToString:@""] ) {
            showAlert(format(@"%@ 信息未填写", item[STK_NM]));
            return;
        }
    }
    
    UploadData* updata = [[UploadData alloc] init];
    updata.respBlocker = ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            mainThread(onCommitSuccess, nil);
        } else {
            showAlert(result[@"error"]);
        }
    };
    [updata send:@{URL_TYPE:NW_FinishWXTask, @"isBack":(self.isBack?@1:@0), @"tasks":m_commitArray}];
    [updata release];
}

- (void)onCommitSuccess
{
    if (self.superList != nil) {
        if ([self.superList respondsToSelector:NSSelectorFromString(@"onSubTaskCommit:")]) {
            [self.superList performSelector:NSSelectorFromString(@"onSubTaskCommit:") withObject:nil];
        }
    }
    
    showAlert(@"数据提交成功");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeSubTask:(NSString*)sid Key:(NSString*)key Value:(NSString*)value
{
    for (id item in m_commitArray) {
        if ([item[STK_ID] isEqualToString:sid]) {
            item[key] = value;
            break;
        }
    }
}


- (void)SaveData
{
    UploadData* updata = [[UploadData alloc] init];
    updata.respBlocker = ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            showAlert(@"数据暂存成功");
            [self.navigationController popViewControllerAnimated:YES];
        }
    };
    [updata send:@{URL_TYPE:NW_FinishWXTaskForTemp, @"isBack":(self.isBack?@1:@0), @"tasks":m_commitArray}];
    [updata release];
}


@end
