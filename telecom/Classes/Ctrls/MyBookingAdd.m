//
//  MyBookingAdd.m
//  telecom
//
//  Created by ZhongYun on 14-6-16.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "MyBookingAdd.h"
#import "CompAlertBox.h"
#import "NSThread+Blocks.h"
#import "FilterCompSelect.h"
#import "SelectRoom.h"
#import "MySendSMS.h"

#define ROW_H   55
#define ROW_E   15
@interface MyBookingAdd ()
{
    AlertBox* m_datePicker;
    AlertBox* m_timePicker1;
    AlertBox* m_timePicker2;
    
    NSMutableDictionary* m_reason;
    NSMutableDictionary* m_person;
    
    NSDictionary* m_room;
}
@end

@implementation MyBookingAdd

- (void)dealloc
{
    [m_reason release];
    [m_person release];
    [m_datePicker release];
    [m_timePicker1 release];
    [m_timePicker2 release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新增施工预约";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addBanner1];
    [self addBanner2];
    [self addBanner3];
    
    CGFloat y = tagView(self.view, 300).ey + ROW_E;
    UIButton* commitBtn = [[UIButton alloc] initWithFrame:RECT(10, y, APP_W-20, 40)];
    [commitBtn setBackgroundImage:color2Image(COLOR(74, 130, 198)) forState:0];
    [commitBtn addTarget:self action:@selector(onCommitBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    commitBtn.layer.cornerRadius = 5;
    commitBtn.clipsToBounds = YES;
    [commitBtn setTitle:@"添 加" forState:0];
    [commitBtn setTitleColor:[UIColor whiteColor] forState:0];
    commitBtn.titleLabel.font = FontB(Font0);
    [self.view addSubview:commitBtn];
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

- (BOOL)checkInputParams
{
    BOOL v1 = [tagViewEx(self.view, 112, UILabel).text isEqualToString:@"请选择日期"];
    BOOL v2 = [tagViewEx(self.view, 122, UILabel).text isEqualToString:@"请选择开始时间"];
    BOOL v3 = [tagViewEx(self.view, 132, UILabel).text isEqualToString:@"请选择结束时间"];

    BOOL v4 = [tagViewEx(self.view, 212, UILabel).text isEqualToString:@"请选择机房"];
    BOOL v5 = [tagViewEx(self.view, 222, UILabel).text isEqualToString:@"请选择进入原因"];
    
    BOOL v6 = [tagViewEx(self.view, 312, UILabel).text isEqualToString:@"请选择进入人员"];
    
    if (v1 || v2 || v3 || v4 || v5 || v6) {
        showAlert(@"预约内容填写不完整！");
        return NO;
    }
    
    return YES;
}

- (void)onCommitBtnTouched:(id)sender
{
    if (![self checkInputParams]) {
        return;
    }
    NSString* strDate1 = date2str(((UIDatePicker*)m_timePicker1.contentView).date, @"HH");
    NSString* strDate2 = date2str(((UIDatePicker*)m_timePicker2.contentView).date, @"HH");
    NSInteger reasonSelected = [m_reason[@"selected"] integerValue];
    NSInteger persionSelected = [m_person[@"selected"] integerValue];
    NSDictionary* param = @{URL_TYPE:NW_OpenDoorAdd,
                            @"appointmentDate":tagViewEx(self.view, 112, UILabel).text,
                            @"startTime":strDate1,
                            @"endTime":strDate2,
                            @"roomId":m_room[@"roomId"],
                            @"reasonId":m_reason[@"list"][reasonSelected][@"reasonId"],
                            @"constructorId":m_person[@"list"][persionSelected][@"constructorId"] };
    httpGET1(param, ^(id result) {
        mainThread(onCommitSuccess:, result);
    });
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

- (void)sendSmsSuccess
{
    if (self.respBlock) {
        self.respBlock(nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onSelectBtnTouched:(UIButton*)sender
{
    if (sender.tag == 113) {
        [m_datePicker show];
    } else if (sender.tag == 123) {
        if ([tagViewEx(self.view, 112, UILabel).text isEqualToString:@"请选择日期"]) {
            showAlert(@"先选择日期！");
            return;
        }
        
        NSString* strDate = tagViewEx(self.view, 112, UILabel).text;
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
    } else if (sender.tag == 133) {
        if ([tagViewEx(self.view, 112, UILabel).text isEqualToString:@"请选择日期"]) {
            showAlert(@"先选择日期！");
            return;
        }
        if ([tagViewEx(self.view, 122, UILabel).text isEqualToString:@"请选择开始时间"]) {
            showAlert(@"先选择开始时间！");
            return;
        };
        
        NSDate* starteDate = ((UIDatePicker*)m_timePicker1.contentView).date;
        NSDate* endDate = [starteDate dateByAddingTimeInterval:3600];
        ((UIDatePicker*)m_timePicker2.contentView).minimumDate = endDate;
        [m_timePicker2 show];
    } else if (sender.tag == 213) {
        SelectRoom* vc = [[SelectRoom alloc] init];
        vc.respBlock = ^(id result){
            [m_room release];
            m_room = [result copy];
            tagViewEx(self.view, 212, UILabel).text = m_room[@"roomName"];
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    } else if (sender.tag == 223) {
        FilterCompSelect* vc = [[FilterCompSelect alloc] init];
        vc.selected = (m_reason[@"selected"]==nil ? -1 : [m_reason[@"selected"] intValue]);
        vc.data = m_reason[@"list"];
        vc.idKey = @"reasonId";
        vc.nameKey = @"reason";
        vc.respBlock = ^(NSInteger selected){
            m_reason[@"selected"] = @(selected);
            tagViewEx(self.view, 222, UILabel).text = m_reason[@"list"][selected][@"reason"];
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    } else if (sender.tag == 313) {
        FilterCompSelect* vc = [[FilterCompSelect alloc] init];
        vc.selected = (m_person[@"selected"]==nil ? -1 : [m_person[@"selected"] intValue]);
        vc.data = m_person[@"list"];
        vc.idKey = @"constructorId";
        vc.nameKey = @"showText";
        vc.respBlock = ^(NSInteger selected){
            m_person[@"selected"] = @(selected);
            tagViewEx(self.view, 312, UILabel).text = m_person[@"list"][selected][@"showText"];
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)addBanner1
{
    UIView* ban = [self newBanner:100 PosY:75 RowCount:2];
    newImageView(ban, @[@(110), @"arrow_right.png", RECT_OBJ(ban.fw-18, (ban.fh/2-14)/2, 8, 14)]);
    newLabel(ban, @[@(111), RECT_OBJ(10, 10, ban.fw-40, Font2), [UIColor blackColor], FontB(Font2), @"预约日期"]);
    newLabel(ban, @[@(112), RECT_OBJ(10, 10+Font2+5, ban.fw-40, Font3), COLOR(69, 69, 69), Font(Font3), @"请选择日期"]);
    [self newSelectBtn:ban Tag:113 Frame:RECT(1, 1, ban.fw-2, ban.fh/2-2)];
    
    newImageView(ban, @[@(120), @"arrow_right.png", RECT_OBJ(ban.fw/2-18, ban.fh/2+(ban.fh/2-14)/2, 8, 14)]);
    newLabel(ban, @[@(121), RECT_OBJ(10, ban.fh/2+10, (ban.fw-40)/2, Font2), [UIColor blackColor], FontB(Font2), @"开始时间"]);
    newLabel(ban, @[@(122), RECT_OBJ(10, ban.fh/2+10+Font2+5, (ban.fw-40)/2, Font3), COLOR(69, 69, 69), Font(Font3), @"请选择开始时间"]);
    [self newSelectBtn:ban Tag:123 Frame:RECT(1, ban.fh/2+1, ban.fw/2-2, ban.fh/2-2)];
    
    newImageView(ban, @[@(130), @"arrow_right.png", RECT_OBJ(ban.fw-18, ban.fh/2+(ban.fh/2-14)/2, 8, 14)]);
    newLabel(ban, @[@(131), RECT_OBJ(ban.fw/2, ban.fh/2+10, (ban.fw-40)/2, Font2), [UIColor blackColor], FontB(Font2), @"结束时间"]);
    newLabel(ban, @[@(132), RECT_OBJ(ban.fw/2, ban.fh/2+10+Font2+5, (ban.fw-40)/2, Font3), COLOR(69, 69, 69), Font(Font3), @"请选择结束时间"]);
    [self newSelectBtn:ban Tag:133 Frame:RECT(ban.fw/2+1, ban.fh/2+1, ban.fw/2-2, ban.fh/2-2)];
}

- (void)addBanner2
{
    UIView* ban = [self newBanner:200 PosY:[self.view viewWithTag:100].ey+ROW_E RowCount:2];
    newImageView(ban, @[@(210), @"arrow_right.png", RECT_OBJ(ban.fw-18, (ban.fh/2-14)/2, 8, 14)]);
    newLabel(ban, @[@(211), RECT_OBJ(10, 10, ban.fw-40, Font2), [UIColor blackColor], FontB(Font2), @"机房"]);
    newLabel(ban, @[@(212), RECT_OBJ(10, 10+Font2+5, ban.fw-40, Font3), COLOR(69, 69, 69), Font(Font3), @"请选择机房"]);
    [self newSelectBtn:ban Tag:213 Frame:RECT(1, 1, ban.fw-2, ban.fh/2-2)];
    
    newImageView(ban, @[@(210), @"arrow_right.png", RECT_OBJ(ban.fw-18, ban.fh/2+(ban.fh/2-14)/2, 8, 14)]);
    newLabel(ban, @[@(221), RECT_OBJ(10, ban.fh/2+10, ban.fw-40, Font2), [UIColor blackColor], FontB(Font2), @"进入原因"]);
    newLabel(ban, @[@(222), RECT_OBJ(10, ban.fh/2+10+Font2+5, ban.fw-40, Font3), COLOR(69, 69, 69), Font(Font3), @"请选择进入原因"]);
    [self newSelectBtn:ban Tag:223 Frame:RECT(1, ban.fh/2+1, ban.fw-2, ban.fh/2-2)];
}

- (void)addBanner3
{
    UIView* ban = [self newBanner:300 PosY:[self.view viewWithTag:200].ey+ROW_E RowCount:1];
    newImageView(ban, @[@(310), @"arrow_right.png", RECT_OBJ(ban.fw-18, (ban.fh-14)/2, 8, 14)]);
    newLabel(ban, @[@(311), RECT_OBJ(10, 10, ban.fw-40, Font2), [UIColor blackColor], FontB(Font2), @"进入人员"]);
    newLabel(ban, @[@(312), RECT_OBJ(10, 10+Font2+5, ban.fw-40, Font3), COLOR(69, 69, 69), Font(Font3), @"请选择进入人员"]);
    [self newSelectBtn:ban Tag:313 Frame:RECT(1, 1, ban.fw-2, ban.fh-2)];
    
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

- (void)initDatePickers
{
    [NSThread performBlockOnMainThread:^{
        if (!m_datePicker) {
            m_datePicker = newDatePickerBox();
            [self.view addSubview:m_datePicker];
            m_datePicker.respBlock = ^(int index) {
                if (index == BTN_OK) {
                    NSString* strDate = date2str(((UIDatePicker*)m_datePicker.contentView).date, DATE_FORMAT);
                    tagViewEx(self.view, 112, UILabel).text = strDate;
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
                    tagViewEx(self.view, 122, UILabel).text = strDate;
                }
            };
        }
        
        if (!m_timePicker2) {
            m_timePicker2 = newTimePickerBox();
            [self.view addSubview:m_timePicker2];
            m_timePicker2.respBlock = ^(int index) {
                if (index == BTN_OK) {
                    NSString* strDate = date2str(((UIDatePicker*)m_timePicker2.contentView).date, @"HH:00");
                    tagViewEx(self.view, 132, UILabel).text = strDate;
                }
            };
        }
    }];
}

@end
