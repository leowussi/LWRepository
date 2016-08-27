//
//  MyBookingEdit.m
//  telecom
//
//  Created by ZhongYun on 14-6-15.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyBookingEdit.h"
#import "MyBookingEditDetail.h"
#import "CompAlertBox.h"
#import "NSThread+Blocks.h"

#define TAG_BTN_MODIFY      2001
#define TAG_BTN_CANCEL      2002
#define TAG_BTN_APPROVE     2003
#define TAG_BTN_REFUSED     2004

#define ROW_H   55
#define ROW_E   15
@interface MyBookingEdit ()
{
    NSMutableDictionary* m_data;
    NSInteger m_status;
}
@end

@implementation MyBookingEdit

- (void)dealloc
{
    [m_data release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"预约详细";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addBanner1];
    [self addBanner2];
    [self addBanner3];
    
    CGFloat y = tagView(self.view, 300).ey + ROW_E;
    UIButton* btn1 = [[UIButton alloc] initWithFrame:RECT(10, y, APP_W/2-20, 40)];
    [btn1 setBackgroundImage:color2Image(COLOR(74, 130, 198)) forState:0];
    [btn1 addTarget:self action:@selector(onEditBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    btn1.layer.cornerRadius = 5;
    btn1.clipsToBounds = YES;
    btn1.tag = TAG_BTN_MODIFY;
    [btn1 setTitle:@"编辑" forState:0];
    [btn1 setTitleColor:[UIColor whiteColor] forState:0];
    btn1.titleLabel.font = FontB(Font0);
    [self.view addSubview:btn1];
    [btn1 release];
    
    UIButton* btn2 = [[UIButton alloc] initWithFrame:RECT(APP_W/2+10, y, APP_W/2-20, 40)];
    [btn2 setBackgroundImage:color2Image(COLOR(0, 165, 78)) forState:0];
    [btn2 addTarget:self action:@selector(onCancleBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    btn2.layer.cornerRadius = 5;
    btn2.clipsToBounds = YES;
    btn2.tag = TAG_BTN_CANCEL;
    [btn2 setTitle:@"取消预约" forState:0];
    [btn2 setTitleColor:[UIColor whiteColor] forState:0];
    btn2.titleLabel.font = FontB(Font0);
    [self.view addSubview:btn2];
    [btn2 release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (m_data == nil) {
        [self loadData];
    }
}

- (void)loadData
{
    httpGET1(@{URL_TYPE:NW_OpenDoorInfo,
               @"appointmentId":self.appointmentId},
             ^(id result) {
                 [m_data release];
                 m_data = [[NSMutableDictionary alloc] initWithDictionary:result[@"detail"]];
                 tagViewEx(self.view, 112, UILabel).text = NoNullStr(m_data[@"taskTime"]);
                 tagViewEx(self.view, 212, UILabel).text = NoNullStr(m_data[@"roomName"]);
                 tagViewEx(self.view, 222, UILabel).text = NoNullStr(m_data[@"reason"]);
                 tagViewEx(self.view, 232, UILabel).text = format(@"%@(%@)",
                                                                  NoNullStr(m_data[@"constructor"]),
                                                                  NoNullStr(m_data[@"mobile"]));
                 
                 m_status = [m_data[@"appointmentStatus"] intValue];
                 NSArray* statusDesc = @[@"未定位",
                                         @"已定位，未扫码",
                                         @"已进门，未出门，门状态正常，离进门时间超过10分钟",
                                         @"已进门，未出门，门状态正常，离进门时间未超过10分钟",
                                         @"已进门，未出门，门状态不正常",
                                         @"已出门、当前预约已过期"];
                 tagViewEx(self.view, 312, UILabel).text = statusDesc[m_status];
                 
                 
                 tagViewEx(self.view, TAG_BTN_MODIFY, UIButton).enabled = (m_status<2);
                 tagViewEx(self.view, TAG_BTN_CANCEL, UIButton).enabled = (m_status<2);
                 if (m_status==5 && [m_data[@"accreditStatus"] intValue]==0) {
                     [self addBanner0];
                 }
             });
}

- (void)delOpenDoor
{
    httpGET1(@{URL_TYPE:NW_OpenDoorDel,
               @"appointmentId":self.appointmentId},
             ^(id result) {
                 if (self.respBlock){
                     self.respBlock(self.appointmentId);
                 }
                 [self.navigationController popViewControllerAnimated:YES];
             });
}

- (void)onEditBtnTouched:(id)sender
{
    MyBookingEditDetail* vc = [[MyBookingEditDetail alloc] init];
    vc.data = m_data;
    vc.respBlock = ^(id resp) {
        mainThread(loadData, nil);
    };
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onCancleBtnTouched:(id)sender
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定要取消预约？"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是", nil];
    [alertView showWithBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            mainThread(delOpenDoor, nil);
        }
    }];
    [alertView release];
}

- (void)onApproveBtnTouched:(id)sender
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定要授权该人员再次进出门？"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是", nil];
    [alertView showWithBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            httpGET1(@{URL_TYPE:NW_OpenDoorAccredit,
                       @"appointmentId":self.appointmentId},
                     ^(id result) {
                         if (self.respBlock){
                             self.respBlock(self.appointmentId);
                         }
                         [self.navigationController popViewControllerAnimated:YES];
                     });
        }
    }];
    [alertView release];
}

- (void)onRefusedBtnTouched:(id)sender
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"确定要拒绝该人员再次进出门？"
                                                       delegate:self
                                              cancelButtonTitle:@"否"
                                              otherButtonTitles:@"是", nil];
    [alertView showWithBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            httpGET1(@{URL_TYPE:NW_OpenDoorReject,
                       @"appointmentId":self.appointmentId},
                     ^(id result) {
                         if (self.respBlock){
                             self.respBlock(self.appointmentId);
                         }
                         [self.navigationController popViewControllerAnimated:YES];
                     });
        }
    }];
    [alertView release];
}


- (void)addBanner0
{
    UIView* ban = [self newBanner:500 PosY:self.navBarView.ey+ROW_E RowCount:1];
    newLabel(ban, @[@(511), RECT_OBJ(10, 10, ban.fw-40, Font2), [UIColor blackColor], FontB(Font2), @"该施工人员申请再次进出门"]);

    CGFloat y = 10 + Font2 + ROW_E;
    UIButton* btn1 = [[UIButton alloc] initWithFrame:RECT(10, y, ban.fw/2-20, 40)];
    [btn1 setBackgroundImage:color2Image(COLOR(255, 77, 60)) forState:0];
    [btn1 addTarget:self action:@selector(onApproveBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    btn1.layer.cornerRadius = 5;
    btn1.clipsToBounds = YES;
    btn1.tag = TAG_BTN_APPROVE;
    [btn1 setTitle:@"接受" forState:0];
    [btn1 setTitleColor:[UIColor whiteColor] forState:0];
    btn1.titleLabel.font = FontB(Font0);
    [ban addSubview:btn1];
    [btn1 release];
    
    UIButton* btn2 = [[UIButton alloc] initWithFrame:RECT(ban.fw/2+10, y, ban.fw/2-20, 40)];
    [btn2 setBackgroundImage:color2Image(COLOR(0, 165, 78)) forState:0];
    [btn2 addTarget:self action:@selector(onRefusedBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    btn2.layer.cornerRadius = 5;
    btn2.clipsToBounds = YES;
    btn2.tag = TAG_BTN_REFUSED;
    [btn2 setTitle:@"拒绝" forState:0];
    [btn2 setTitleColor:[UIColor whiteColor] forState:0];
    btn2.titleLabel.font = FontB(Font0);
    [ban addSubview:btn2];
    [btn2 release];
    
    ban.fh = tagView(self.view, TAG_BTN_REFUSED).ey + ROW_E;
    
    tagView(self.view, 100).fy += ban.fh+ROW_E;
    tagView(self.view, 200).fy += ban.fh+ROW_E;
    tagView(self.view, 300).fy += ban.fh+ROW_E;
    tagViewEx(self.view, TAG_BTN_MODIFY, UIButton).fy += ban.fh+ROW_E;
    tagViewEx(self.view, TAG_BTN_CANCEL, UIButton).fy += ban.fh+ROW_E;
}

- (void)addBanner1
{
    UIView* ban = [self newBanner:100 PosY:64+ROW_E RowCount:1];
    newLabel(ban, @[@(111), RECT_OBJ(10, 10, ban.fw-40, Font2), [UIColor blackColor], FontB(Font2), @"预约时间"]);
    newLabel(ban, @[@(112), RECT_OBJ(10, 10+Font2+5, ban.fw-40, Font3), COLOR(69, 69, 69), Font(Font3), @""]);
}

- (void)addBanner2
{
    int num = 3;
    UIView* ban = [self newBanner:200 PosY:[self.view viewWithTag:100].ey+ROW_E RowCount:num];
    newLabel(ban, @[@(211), RECT_OBJ(10, 10, ban.fw-40, Font2), [UIColor blackColor], FontB(Font2), @"机房"]);
    newLabel(ban, @[@(212), RECT_OBJ(10, 10+Font2+5, ban.fw-40, Font3), COLOR(69, 69, 69), Font(Font3), @""]);
    
    newLabel(ban, @[@(221), RECT_OBJ(10, ban.fh*1/num+10, ban.fw-40, Font2), [UIColor blackColor], FontB(Font2), @"进入原因"]);
    newLabel(ban, @[@(222), RECT_OBJ(10, ban.fh*1/num+10+Font2+5, ban.fw-40, Font3), COLOR(69, 69, 69), Font(Font3), @""]);
    
    newLabel(ban, @[@(231), RECT_OBJ(10, ban.fh*2/num+10, ban.fw-40, Font2), [UIColor blackColor], FontB(Font2), @"进入人员"]);
    newLabel(ban, @[@(232), RECT_OBJ(10, ban.fh*2/num+10+Font2+5, ban.fw-40, Font3), COLOR(69, 69, 69), Font(Font3), @""]);
}

- (void)addBanner3
{
    UIView* ban = [self newBanner:300 PosY:[self.view viewWithTag:200].ey+ROW_E RowCount:1];
    newLabel(ban, @[@(311), RECT_OBJ(10, 10, ban.fw-40, Font2), [UIColor blackColor], FontB(Font2), @"预约单状态"]);
    newLabel(ban, @[@(312), RECT_OBJ(10, 10+Font2+5, ban.fw-40, Font3), COLOR(69, 69, 69), Font(Font3), @""]);
}

- (UIView*)newBanner:(NSInteger)tag PosY:(CGFloat)y RowCount:(NSInteger)count
{
    UIView* banner = [[UIView alloc] initWithFrame:RECT(10, y, APP_W-20, ROW_H*count)];
    banner.tag = tag;
    banner.backgroundColor = [UIColor whiteColor];
    banner.layer.borderColor = COLOR(190, 190, 190).CGColor;
    banner.layer.borderWidth = 0.5;
    banner.layer.cornerRadius = 3;
    //showShadow(banner, CGSizeMake(1, 1));
    [self.view addSubview:banner];
    
    NSInteger lineNum = count - 1;
    for (int i = 0; i < lineNum; i++) {
        UIView* line = [[UIView alloc] init];
        line.frame = RECT(2, ROW_H*(i+1), banner.fw-4, 0.5);
        line.backgroundColor = COLOR(221, 221, 221);
        [banner addSubview:line];
        [line release];
    }
    
    [banner release];
    
    return [self.view viewWithTag:tag];
}

@end
