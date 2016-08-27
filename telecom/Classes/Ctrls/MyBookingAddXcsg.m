//
//  MyBookingAddXcsg.m
//  telecom
//
//  Created by ZhongYun on 15-1-2.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyBookingAddXcsg.h"
#import "CompAlertBox.h"
#import "NSThread+Blocks.h"
#import "FilterCompSelect.h"
#import "SelectRoom.h"
#import "MySendSMS.h"

#define ROW_H   55
#define ROW_E   15

#define TAG_BGN_DATE_VLU    2201
#define TAG_BGN_DATE_BTN    2202
#define TAG_BGN_TIME_VLU    2203
#define TAG_BGN_TIME_BTN    2204
#define TAG_END_DATE_VLU    2205
#define TAG_END_DATE_BTN    2206
#define TAG_END_TIME_VLU    2207
#define TAG_END_TIME_BTN    2208
#define TAG_ROOM_VLU        2209
#define TAG_ROOM_BTN        2210
#define TAG_REASON_VLU      2211
#define TAG_REASON_BTN      2212
#define TAG_TEXT_NAME       2213
#define TAG_TEXT_USER       2214


@interface MyBookingAddXcsg ()<UITextFieldDelegate>
{
    AlertBox* m_datePicker1;
    AlertBox* m_datePicker2;
    AlertBox* m_timePicker1;
    AlertBox* m_timePicker2;
    
    NSMutableDictionary* m_reason;
    NSMutableDictionary* m_person;
    
    NSDictionary* m_room;
    
    UIScrollView* m_scroll;
}
@end

@implementation MyBookingAddXcsg

- (void)dealloc
{
    [m_reason release];
    [m_person release];
    [m_datePicker1 release];
    [m_datePicker2 release];
    [m_timePicker1 release];
    [m_timePicker2 release];
    [m_scroll release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新增随工任务";
    self.view.backgroundColor = [UIColor whiteColor];
    m_scroll = [[UIScrollView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, SCREEN_H-self.navBarView.ey)];
    m_scroll.contentSize = m_scroll.bounds.size;
    m_scroll.showsVerticalScrollIndicator = NO;
    m_scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_scroll];
    
    CGFloat top_y = ROW_E;
    top_y = [self addBanner1:top_y];
    top_y = [self addBanner2:top_y];
    top_y = [self addBanner3:top_y];
    
    CGFloat y = tagView(m_scroll, 300).ey + ROW_E;
    UIButton* commitBtn = [[UIButton alloc] initWithFrame:RECT(10, y, APP_W-20, 40)];
    [commitBtn setBackgroundImage:color2Image(COLOR(74, 130, 198)) forState:0];
    [commitBtn addTarget:self action:@selector(onCommitBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.layer.cornerRadius = 5;
    commitBtn.clipsToBounds = YES;
    [commitBtn setTitle:@"添 加" forState:0];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:0];
    commitBtn.titleLabel.font = FontB(Font0);
    [m_scroll addSubview:commitBtn];
    m_scroll.contentSize = CGSizeMake(APP_W, commitBtn.ey+ROW_E);
    [commitBtn release];
    
    
    [self initDatePickers];
    [self loadAssiData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
    [self performSelector:@selector(initTimePickers) withObject:nil afterDelay:2];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)initDatePickers
{
    [NSThread performBlockOnMainThread:^{
        if (!m_datePicker1) {
            m_datePicker1 = newDatePickerBox();
            [self.view addSubview:m_datePicker1];
            m_datePicker1.respBlock = ^(int index) {
                if (index == BTN_OK) {
                    NSString* strDate = date2str(((UIDatePicker*)m_datePicker1.contentView).date, DATE_FORMAT);
                    tagViewEx(self.view, TAG_BGN_DATE_VLU, UILabel).text = strDate;
                }
            };
        }
        
        if (!m_datePicker2) {
            m_datePicker2 = newDatePickerBox();
            [self.view addSubview:m_datePicker2];
            m_datePicker2.respBlock = ^(int index) {
                if (index == BTN_OK) {
                    NSString* strDate = date2str(((UIDatePicker*)m_datePicker2.contentView).date, DATE_FORMAT);
                    tagViewEx(self.view, TAG_END_DATE_VLU, UILabel).text = strDate;
                }
            };
        }
    }];
}

- (void)initTimePickers
{
    [NSThread performBlockOnMainThread:^{
        if (!m_timePicker1) {
            m_timePicker1 = newTimePickerBox();
            [self.view addSubview:m_timePicker1];
            m_timePicker1.respBlock = ^(int index) {
                if (index == BTN_OK) {
                    NSString* strDate = date2str(((UIDatePicker*)m_timePicker1.contentView).date, @"HH:00");
                    tagViewEx(self.view, TAG_BGN_TIME_VLU, UILabel).text = strDate;
                }
            };
        }
        
        if (!m_timePicker2) {
            m_timePicker2 = newTimePickerBox();
            [self.view addSubview:m_timePicker2];
            m_timePicker2.respBlock = ^(int index) {
                if (index == BTN_OK) {
                    NSString* strDate = date2str(((UIDatePicker*)m_timePicker2.contentView).date, @"HH:00");
                    tagViewEx(self.view, TAG_END_TIME_VLU, UILabel).text = strDate;
                }
            };
        }
    }];
}

- (BOOL)checkInputParams
{
    BOOL v1 = [tagViewEx(self.view, TAG_BGN_DATE_VLU, UILabel).text isEqualToString:@"请选择开始日期"];
    BOOL v2 = [tagViewEx(self.view, TAG_BGN_TIME_VLU, UILabel).text isEqualToString:@"请选择开始时间"];
    BOOL v3 = [tagViewEx(self.view, TAG_END_DATE_VLU, UILabel).text isEqualToString:@"请选择结束日期"];
    BOOL v4 = [tagViewEx(self.view, TAG_END_TIME_VLU, UILabel).text isEqualToString:@"请选择结束时间"];
    
    BOOL v5 = [tagViewEx(self.view, TAG_ROOM_VLU, UILabel).text isEqualToString:@"请选择机房"];
    BOOL v6 = [tagViewEx(self.view, TAG_REASON_VLU, UILabel).text isEqualToString:@"请选择进入原因"];
    
    BOOL v7 = [tagViewEx(self.view, TAG_TEXT_NAME, UILabel).text isEqualToString:@"请填写工程名称"];
    BOOL v8 = [tagViewEx(self.view, TAG_TEXT_USER, UILabel).text isEqualToString:@"请填写进入人员"];
    
    if (v1 || v2 || v3 || v4 || v5 || v6 || v7 || v8) {
        showAlert(@"预约内容填写不完整！");
        return NO;
    }
    
    return YES;
}

- (void)sendSmsSuccess
{
    if (self.respBlock) {
        self.respBlock(nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCommitSuccess:(id)result
{
    NSString* verifyCode = result[@"detail"][@"verificationCode"];
    if (NoNullStr(verifyCode).length > 0) {
        NSInteger persionSelected = [m_person[@"selected"] integerValue];
        NSString* mobile = m_person[@"list"][persionSelected][@"mobile"];
        
        NSDictionary* param = @{@"mobile":mobile,
                                @"message":format(@"校验码:%@", verifyCode),
                                @"parent":self};
        [MySendSMS sendSMS:param];
    } else {
        showAlert(@"未生成校验码!");
    }
}

- (void)onCommitBtnTouched:(id)sender
{
    if (![self checkInputParams]) {
        return;
    }
    NSString* strDate1 = date2str(((UIDatePicker*)m_timePicker1.contentView).date, @"HH");
    NSString* strDate2 = date2str(((UIDatePicker*)m_timePicker2.contentView).date, @"HH");
    NSInteger reasonSelected = [m_reason[@"selected"] integerValue];
    NSDictionary* param = @{URL_TYPE:NW_AddTask,
                            @"startDate":tagViewEx(self.view, TAG_BGN_DATE_VLU, UILabel).text,
                            @"startTime":strDate1,
                            @"endDate":tagViewEx(self.view, TAG_END_DATE_VLU, UILabel).text,
                            @"endTime":strDate2,
                            @"roomId":m_room[@"roomId"],
                            @"reasonId":m_reason[@"list"][reasonSelected][@"reasonId"],
                            @"projectName":tagViewEx(self.view, TAG_TEXT_NAME, UILabel).text,
                            @"constructor":tagViewEx(self.view, TAG_TEXT_USER, UILabel).text,};
    httpGET1(param, ^(id result) {
        showAlert(@"随工任务添加成功");
        if (self.respBlock) {
            self.respBlock(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)onSelectBtnTouched:(UIButton*)sender
{
    if (sender.tag == TAG_BGN_DATE_BTN) {
        [m_datePicker1 show];
    } else if (sender.tag == TAG_BGN_TIME_BTN) {
        if ([tagViewEx(self.view, TAG_BGN_DATE_VLU, UILabel).text isEqualToString:@"请选择开始日期"]) {
            showAlert(@"先选择开始日期！");
            return;
        }
        
        NSString* strDate = tagViewEx(self.view, TAG_BGN_DATE_VLU, UILabel).text;
        NSString* currDate = date2str([NSDate date], DATE_FORMAT);
        NSString* currTime = date2str([NSDate date], TIME_FORMAT);
        BOOL isToday = [strDate isEqualToString:currDate];
        if (isToday) {
            ((UIDatePicker*)m_timePicker1.contentView).minimumDate = [NSDate date];
            ((UIDatePicker*)m_timePicker1.contentView).date = [NSDate date];
        } else {
            ((UIDatePicker*)m_timePicker1.contentView).minimumDate = str2date(format(@"%@ 00:00:00", strDate), DATE_TIME_FORMAT);
            ((UIDatePicker*)m_timePicker1.contentView).date = str2date(format(@"%@ %@", strDate, currTime), DATE_TIME_FORMAT);
        }
        [m_timePicker1 show];
    } else if (sender.tag == TAG_END_DATE_BTN) {
        if ([tagViewEx(self.view, TAG_BGN_DATE_VLU, UILabel).text isEqualToString:@"请选择开始日期"]) {
            showAlert(@"先选择开始日期！");
            return;
        }
        
        NSString* strDate = tagViewEx(self.view, TAG_BGN_DATE_VLU, UILabel).text;
        ((UIDatePicker*)m_datePicker2.contentView).minimumDate = str2date(strDate, DATE_FORMAT);
        [m_datePicker2 show];
    } else if (sender.tag == TAG_END_TIME_BTN) {
        if ([tagViewEx(self.view, TAG_BGN_TIME_VLU, UILabel).text isEqualToString:@"请选择开始时间"]) {
            showAlert(@"先选择开始时间！");
            return;
        }
        if ([tagViewEx(self.view, TAG_END_DATE_VLU, UILabel).text isEqualToString:@"请选择结束日期"]) {
            showAlert(@"先选择结束日期！");
            return;
        };
        
        BOOL isSameDate = [tagViewEx(self.view, TAG_BGN_DATE_VLU, UILabel).text
                           isEqualToString:tagViewEx(self.view, TAG_END_DATE_VLU, UILabel).text];
        
        NSDate* starteDate = ((UIDatePicker*)m_timePicker1.contentView).date;
        if (isSameDate) {
            NSDate* endDate = [starteDate dateByAddingTimeInterval:3600];
            ((UIDatePicker*)m_timePicker2.contentView).minimumDate = endDate;
        } else {
            ((UIDatePicker*)m_timePicker2.contentView).minimumDate = starteDate;
        }
        [m_timePicker2 show];
    } else if (sender.tag == TAG_ROOM_BTN) {
        SelectRoom* vc = [[SelectRoom alloc] init];
        vc.respBlock = ^(id result){
            [m_room release];
            m_room = [result copy];
            tagViewEx(self.view, TAG_ROOM_VLU, UILabel).text = m_room[@"roomName"];
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    } else if (sender.tag == TAG_REASON_BTN) {
        FilterCompSelect* vc = [[FilterCompSelect alloc] init];
        vc.selected = (m_reason[@"selected"]==nil ? -1 : [m_reason[@"selected"] intValue]);
        vc.data = m_reason[@"list"];
        vc.idKey = @"reasonId";
        vc.nameKey = @"reason";
        vc.respBlock = ^(NSInteger selected){
            m_reason[@"selected"] = @(selected);
            tagViewEx(self.view, TAG_REASON_VLU, UILabel).text = m_reason[@"list"][selected][@"reason"];
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)loadAssiData
{
    httpGET1(@{URL_TYPE:NW_GetAppointmentReason}, ^(id result) {
        if (!m_reason) {
            m_reason = [[NSMutableDictionary alloc] initWithDictionary:result];
        }
    });
    
    httpGET1(@{URL_TYPE:NW_GetConstructorList}, ^(id result) {
        if (!m_person) {
            m_person = [[NSMutableDictionary alloc] initWithDictionary:result];
            for (NSMutableDictionary* item in m_person[@"list"]) {
                item[@"showText"] = format(@"%@(%@)", item[@"constructor"], item[@"mobile"]);
            }
        }
    });
}

- (CGFloat)addBanner1:(CGFloat)top_y
{
    CGFloat btag = 100;
    UIView* ban = [self newBanner:btag++ PosY:top_y RowCount:3];
    
    CGFloat pos_y = ROW_H*0;
    UILabel* lbt = newLabel(ban, @[@(btag++), RECT_OBJ(10, pos_y+(ROW_H-Font2)/2, ban.fw/2, Font2), [UIColor blackColor], FontB(Font2), @"工程名称"]);
    newTextField(ban, @[@(TAG_TEXT_NAME), RECT_OBJ(80, pos_y+2, ban.fw-88, ROW_H-4), COLOR(69, 69, 69), FontB(Font3), @"请填写工程名称", @""]);
    
    pos_y = ROW_H*1;
    lbt = newLabel(ban, @[@(btag++), RECT_OBJ(10, pos_y+10, ban.fw/2, Font2), [UIColor blackColor], FontB(Font2), @"开始日期"]);
    newLabel(ban, @[@(TAG_BGN_DATE_VLU), RECT_OBJ(10, lbt.ey+5, ban.fw/2, Font3), COLOR(69, 69, 69), FontB(Font3), @"请选择开始日期"]);
    newImageView(ban, @[@(btag++), @"arrow_right.png", RECT_OBJ(ban.fw/2-18, pos_y+(ROW_H-14)/2, 8, 14)]);
    [self newSelectBtn:ban Tag:TAG_BGN_DATE_BTN Frame:RECT(1, pos_y+1, ban.fw/2-2, ROW_H-2)];

    lbt = newLabel(ban, @[@(btag++), RECT_OBJ(ban.fw/2+10, pos_y+10, ban.fw/2, Font2), [UIColor blackColor], FontB(Font2), @"开始时间"]);
    newLabel(ban, @[@(TAG_BGN_TIME_VLU), RECT_OBJ(ban.fw/2+10, lbt.ey+5, ban.fw/2, Font3), COLOR(69, 69, 69), FontB(Font3), @"请选择开始时间"]);
    newImageView(ban, @[@(btag++), @"arrow_right.png", RECT_OBJ(ban.fw-18, pos_y+(ROW_H-14)/2, 8, 14)]);
    [self newSelectBtn:ban Tag:TAG_BGN_TIME_BTN Frame:RECT(ban.fw/2+1, pos_y+1, ban.fw/2-2, ROW_H-2)];
    
    
    pos_y = ROW_H*2;
    lbt = newLabel(ban, @[@(btag++), RECT_OBJ(10, pos_y+10, ban.fw/2, Font2), [UIColor blackColor], FontB(Font2), @"结束日期"]);
    newLabel(ban, @[@(TAG_END_DATE_VLU), RECT_OBJ(10, lbt.ey+5, ban.fw/2, Font3), COLOR(69, 69, 69), FontB(Font3), @"请选择结束日期"]);
    newImageView(ban, @[@(btag++), @"arrow_right.png", RECT_OBJ(ban.fw/2-18, pos_y+(ROW_H-14)/2, 8, 14)]);
    [self newSelectBtn:ban Tag:TAG_END_DATE_BTN Frame:RECT(1, pos_y+1, ban.fw/2-2, ROW_H-2)];
    
    lbt = newLabel(ban, @[@(btag++), RECT_OBJ(ban.fw/2+10, pos_y+10, ban.fw/2, Font2), [UIColor blackColor], FontB(Font2), @"结束时间"]);
    newLabel(ban, @[@(TAG_END_TIME_VLU), RECT_OBJ(ban.fw/2+10, lbt.ey+5, ban.fw/2, Font3), COLOR(69, 69, 69), FontB(Font3), @"请选择结束时间"]);
    newImageView(ban, @[@(btag++), @"arrow_right.png", RECT_OBJ(ban.fw-18, pos_y+(ROW_H-14)/2, 8, 14)]);
    [self newSelectBtn:ban Tag:TAG_END_TIME_BTN Frame:RECT(ban.fw/2+1, pos_y+1, ban.fw/2-2, ROW_H-2)];
    
    return ban.ey + ROW_E;
}

- (CGFloat)addBanner2:(CGFloat)top_y
{
    CGFloat btag = 200;
    UIView* ban = [self newBanner:btag++ PosY:top_y RowCount:2];
    
    CGFloat pos_y = ROW_H*0;
    UILabel* lbt = newLabel(ban, @[@(btag++), RECT_OBJ(10, pos_y+10, ban.fw, Font2), [UIColor blackColor], FontB(Font2), @"机房"]);
    newLabel(ban, @[@(TAG_ROOM_VLU), RECT_OBJ(10, lbt.ey+5, ban.fw, Font3), COLOR(69, 69, 69), FontB(Font3), @"请选择机房"]);
    newImageView(ban, @[@(btag++), @"arrow_right.png", RECT_OBJ(ban.fw-18, pos_y+(ROW_H-14)/2, 8, 14)]);
    [self newSelectBtn:ban Tag:TAG_ROOM_BTN Frame:RECT(1, pos_y+1, ban.fw-2, ROW_H-2)];

    pos_y = ROW_H*1;
    lbt = newLabel(ban, @[@(btag++), RECT_OBJ(10, pos_y+10, ban.fw, Font2), [UIColor blackColor], FontB(Font2), @"进入原因"]);
    newLabel(ban, @[@(TAG_REASON_VLU), RECT_OBJ(10, lbt.ey+5, ban.fw, Font3), COLOR(69, 69, 69), FontB(Font3), @"请选择进入原因"]);
    newImageView(ban, @[@(btag++), @"arrow_right.png", RECT_OBJ(ban.fw-18, pos_y+(ROW_H-14)/2, 8, 14)]);
    [self newSelectBtn:ban Tag:TAG_REASON_BTN Frame:RECT(1, pos_y+1, ban.fw-2, ROW_H-2)];
    
    return ban.ey + ROW_E;
}

- (CGFloat)addBanner3:(CGFloat)top_y
{
    CGFloat btag = 300;
    UIView* ban = [self newBanner:300 PosY:top_y RowCount:1];
    CGFloat pos_y = ROW_H*0;
    newLabel(ban, @[@(btag++), RECT_OBJ(10, pos_y+(ROW_H-Font2)/2, ban.fw/2, Font2), [UIColor blackColor], FontB(Font2), @"进入人员"]);
    newTextField(ban, @[@(TAG_TEXT_USER), RECT_OBJ(80, pos_y+2, ban.fw-88, ROW_H-4), COLOR(69, 69, 69), FontB(Font3), @"请填写进入人员", @""]);
    
    return ban.ey + ROW_E;
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
    [m_scroll addSubview:banner];
    
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

- (UIButton*)newSelectBtn:(UIView*)view Tag:(NSInteger)tag Frame:(CGRect)frame
{
    UIButton* btn = [[UIButton alloc] initWithFrame:frame];
    btn.tag = tag;
    [btn addTarget:self action:@selector(onSelectBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    //btn.layer.borderWidth = 0.5;
    [btn release];
    return (UIButton*)[view  viewWithTag:tag];
}

@end
