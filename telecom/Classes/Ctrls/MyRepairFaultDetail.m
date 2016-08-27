//
//  MyRepairFaultDetail.m
//  telecom
//
//  Created by ZhongYun on 14-8-7.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyRepairFaultDetail.h"
#import "TaskTypeBar.h"
#import "RepairFaultDetailView.h"

#define TVIEW_H         40
#define TAG_BASIC       18000
@interface MyRepairFaultDetail ()<TaskTypeBarDelegate>
{
    NSMutableArray* m_typeList;
    TaskTypeBar* m_typeView;
    BOOL m_tabExitsFlg;
}
@end

@implementation MyRepairFaultDetail

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的报修";
    m_tabExitsFlg = NO;
}

- (void)setFaultId:(NSString *)faultId
{
    _faultId = [faultId copy];
    
    httpGET1(@{URL_TYPE:NW_GetRepairFaultTab,@"faultId":self.faultId}, ^(id result) {
        m_tabExitsFlg = ([result[@"detail"][@"tabExitsFlg"] intValue]==1);
        mainThread(loadTypeList, nil);
    });
}

- (void)loadTypeList
{
    if (!m_typeList) {
        m_typeList = [[NSMutableArray alloc] init];
        m_typeView = [[TaskTypeBar alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, TVIEW_H)];
        m_typeView.backgroundColor = [UIColor whiteColor];
        m_typeView.buttonWidth = 100;
        m_typeView.delegate = self;
        [self.view addSubview:m_typeView];
    }
    [m_typeList removeAllObjects];
    [m_typeList addObjectsFromArray:@[@{@"typeId":@(TI_DETAIL), @"speciltyName":@"故障单详细", @"taskAmount":@0},
                                      @{@"typeId":@(TI_RECORD), @"speciltyName":@"故障流水信息", @"taskAmount":@0}] ];
    if (m_tabExitsFlg) {
        [m_typeList addObjectsFromArray:@[@{@"typeId":@(TI_WARNING), @"speciltyName":@"故障告警信息", @"taskAmount":@0},
                                          @{@"typeId":@(TI_MACHINE), @"speciltyName":@"故障设备信息", @"taskAmount":@0}] ];
    }
    NSInteger selected = 0;
    if (m_typeList.count > 0) {
        CGRect frame = RECT(0, m_typeView.ey, APP_W, SCREEN_H-m_typeView.ey);
        for (int i=0; i<m_typeList.count; i++) {
            RepairFaultDetailView* view = [[RepairFaultDetailView alloc] initWithFrame:frame];
            view.typeInfo = m_typeList[i];
            view.faultId = self.faultId;
            view.faultNo = self.faultNo;
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

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count
{
    [m_typeView updatePointStatus:index Count:count];
}

- (void)updateNavBtnStatus:(RepairFaultDetailView*)view
{
    if (view.tag-TAG_BASIC == m_typeView.selected) {
        
    }
}

- (void)changeBefore:(TaskTypeBar*)sender
{
    [self.view viewWithTag:m_typeView.selected+TAG_BASIC].hidden = YES;
}

- (void)changeAfter:(TaskTypeBar*)sender
{
    NSInteger viewTag = sender.selected+TAG_BASIC;
    RepairFaultDetailView* view = tagViewEx(self.view, viewTag, RepairFaultDetailView);
    view.hidden = NO;
    [view buildView];
    [self updateNavBtns:view];
}

- (void)updateNavBtns:(RepairFaultDetailView*)currView
{

}

@end
