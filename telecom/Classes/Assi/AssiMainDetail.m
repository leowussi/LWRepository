//
//  AssiMainDetail.m
//  telecom
//
//  Created by ZhongYun on 14-7-10.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "AssiMainDetail.h"
#import "DownTimer.h"
#import "QrReadView.h"
#import "AlertBox.h"

#define RowHeight       40
#define BRD_COLOR       COLOR(197, 197, 197)
#define LINE_COLOR      COLOR(243, 243, 243)

#define Id_BaseInfo         5800
#define Id_NoticeInfo       5801
#define Id_Timer            5802
#define Id_OpBtn            5803

@interface AssiMainDetail ()<UITextFieldDelegate>
{
    NSMutableDictionary* m_state;
    DownTimer* m_timer;
    
    UIScrollView* m_table;
    UIView* v_BaseInfo;
    UIView* v_NoticeInfo;
    UIView* v_Timer;
    UIView* v_OpBtn;
    
    UILabel* m_lbTime;
    UILabel* m_lbNotice;
    UIButton* m_opBtn;
    
    NSString* m_qrCode;
    
    NSString* m_verifyCode;
    UITextField* m_verifyCodeTxtField;
    AlertBox* m_verifyCodeBox;
}
@end

@implementation AssiMainDetail

- (void)dealloc
{
    NOTIF_REMV();
    [m_state release];
    [m_timer release];
    [m_table release];
    [m_verifyCodeTxtField release];
    [m_verifyCodeBox release];
    [super dealloc];
}

- (void)onNavBackTouched:(id)sender
{
    [m_timer stop];
    m_timer.overBlock = nil;
    m_timer.secondBlock = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"预约详情";

    NOTIF_ADD(GPS_LOCATION_OVER, onGpsLocationOver:);
    
    m_state = [[NSMutableDictionary alloc] init];
    m_timer = [[DownTimer alloc] init];
    m_timer.secondBlock = ^(){ m_lbTime.text = m_timer.secondStr; };
    m_timer.overBlock = ^(){
        if ([m_state[@"state"] intValue] == 1) {
            m_lbTime.text = @"";
            m_state[@"state"] = @0;
            mainThread(execState:, nil);
        }
    };
    
    m_table = [[UIScrollView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, APP_H-NAV_H)];
    [self.view addSubview:m_table];
    
    [self buildCellList];
    [self getVerifyCodeTextField];
    
}

- (void)setData:(NSDictionary *)data
{
    _data = [data retain];
    [self apiQueryState];
}

- (void)onOpBtnTouched:(id)sender
{
    mainThread(execState:, @1);
}

- (void)onGpsLocationOver:(NSNotification*)notification
{
    CLLocation* location = (CLLocation*)notification.object;
    [self apiOpenDoorLocation:location];
}

- (void)apiQueryState
{
    if (NoNullStr(m_verifyCode).length == 0) {
        [self performSelector:@selector(showVerifyCodeTextField) withObject:nil afterDelay:0.5];
        return;
    }
    
    NSDictionary* params = @{URL_TYPE:NW_QueryState,
                             @"appointmentId":self.data[@"appointmentId"],
                             @"verificationCode":m_verifyCode};
    httpGET2(params, ^(id result) {
        [m_state removeAllObjects];
        [m_state addEntriesFromDictionary:result[@"detail"]];
        mainThread(execState:, nil);
    }, ^(id result) {
        //if ([result[@"result"] isEqualToString:@"2011602"])
        if ([result[@"error"] rangeOfString:@"验证码"].location != NSNotFound)
        {
            m_verifyCode = @"";
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"验证码错误，请重新输入。"
                                                               delegate:self
                                                      cancelButtonTitle:@"否"
                                                      otherButtonTitles:@"是", nil];
            [alertView showWithBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    mainThread(showVerifyCodeTextField, nil);
                }
            }];
            [alertView release];
        } else {
            showAlert(result[@"error"]);
        };
    });
}

- (void)apiOpenDoorLocation:(CLLocation*)location
{
#if !TARGET_IPHONE_SIMULATOR
    NSDictionary* params = @{URL_TYPE:NW_OpenDoorLocation, @"appointmentId":self.data[@"appointmentId"],
                             @"longitude":@(location.coordinate.longitude),
                             @"latitude":@(location.coordinate.latitude)};
#else
    NSDictionary* params = @{URL_TYPE:NW_OpenDoorLocation, @"appointmentId":self.data[@"appointmentId"],
                             @"longitude":@"121.585851", @"latitude":@"31.244668"};
#endif
    httpGET2(params, ^(id result) {
        mainThread(apiQueryState, nil);
    }, ^(id result) {
        if ([result[@"result"] isEqualToString:@"2010801"]) {
            showAlert(@"格式不正确");
        } else {
            showAlert(result[@"error"]);
        };
    });
    
}

- (void)apiOpenDoorIn:(NSString*)qrCode
{
    NSDictionary* param = @{URL_TYPE:NW_OpenDoorIn, @"imsi":UGET(ASSI_IMSI), @"mobileCode":qrCode,
                            @"appointmentId":self.data[@"appointmentId"] };
    httpGET2(param, ^(id result) {
        mainThread(apiQueryState, nil);
    }, ^(id result) {
        showAlert(result[@"error"]);
        if ([result[@"result"] isEqualToString:@"2010904"]) {
            m_lbTime.text = @"05:00";
            [m_timer stop];
        }
    });
}

- (void)apiOpenDoorOut
{
    NSDictionary* param = @{URL_TYPE:NW_OpenDoorOut, @"imsi":UGET(ASSI_IMSI),
                            @"appointmentId":self.data[@"appointmentId"] };
    httpGET1(param, ^(id result) {
        mainThread(apiQueryState, nil);
    });
}

- (void)apiOpenDoorApply
{
    NSDictionary* param = @{URL_TYPE:NW_OpenDoorApply, @"imsi":UGET(ASSI_IMSI),
                            @"appointmentId":self.data[@"appointmentId"] };
    httpGET1(param, ^(id result) {
        mainThread(apiQueryState, nil);
    });
}


- (void)execState:(id)opType
{
    NSString* noticeDesc = @"";
    NSArray* showList = nil;

    int state = [m_state[@"state"] intValue];
    if (state == 0) { //未定位
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (opType == nil) {
            showList = @[@(Id_BaseInfo), @(Id_NoticeInfo), @(Id_OpBtn)];
            
            noticeDesc= @"1、请至待开门局站附近定位。\n"
                        @"2、若定位失败，请确认是否开启GPS定位功能，\n"
                        @"      或至局站附近空旷处再次定位。";
            
            [m_opBtn setBackgroundImage:color2Image(COLOR(0, 165, 78)) forState:0];
            [m_opBtn setTitle:@"定位" forState:0];
        } else {
            //[m_locService startUserLocationService];
            NOTIF_POST(GPS_LOCATION_START, nil);
        }
        
    } else if (state == 1) { //已定位未扫码
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (opType == nil) {
            showList = @[@(Id_BaseInfo), @(Id_NoticeInfo), @(Id_Timer), @(Id_OpBtn)];
            
            if (m_timer.isRunning) [m_timer stop];
            m_timer.totalSeconds = 5*60;
            [m_timer startWithOldDate:str2date(m_state[@"time"], @"yyyyMMddHHmmss")];
            
            noticeDesc= @"1、扫码必须在定位后5分钟时效内完成。\n"
                        @"2、扫码时，请将二维码完全至于方形块内。\n"
                        @"3、若光线昏暗，请打开手电后扫码。";
            
            [m_opBtn setBackgroundImage:color2Image(COLOR(74, 130, 198)) forState:0];
            [m_opBtn setTitle:@"扫码进门" forState:0];
        } else {
#if !TARGET_IPHONE_SIMULATOR
            if ([QrReadView checkCamera]) {
                QrReadView* vc = [[QrReadView alloc] init];
                vc.respBlock = ^(NSString* v) {
                    m_qrCode = [v copy];
                    mainThread(apiOpenDoorIn:, v);
                };
                [self.navigationController pushViewController:vc animated:YES];
                [vc release];
            }
#else
            m_qrCode = [@"3139" copy];
            mainThread(apiOpenDoorIn:, @"3139");
#endif
        }
        
    } else if (state == 2) { //已进门未出门，已超10分钟
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (opType == nil) {
            showList = @[@(Id_BaseInfo), @(Id_NoticeInfo), @(Id_OpBtn)];
            
            noticeDesc= @"1、出门按钮只能使用一次，请仅在出门时操作。\n"
                        @"2、出门时，请点击出门按钮。\n"
                        @"3、若出门时门未打开，请联系xxx。";
            
            [m_opBtn setBackgroundImage:color2Image(COLOR(255, 77, 60)) forState:0];
            [m_opBtn setTitle:@"出门" forState:0];
        } else {
            mainThread(apiOpenDoorOut, nil);
        }
        
    } else if (state == 3) { //已进门未出门，未超10分钟
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (opType == nil) {
            showList = @[@(Id_BaseInfo), @(Id_NoticeInfo), @(Id_Timer), @(Id_OpBtn)];
            
            if (m_timer.isRunning) [m_timer stop];
            m_timer.totalSeconds = 10*60;
            [m_timer startWithOldDate:str2date(m_state[@"time"], @"yyyyMMddHHmmss")];
            
            noticeDesc= @"1、门未正常关闭，请尽快关门。\n"
                        @"2、门未关闭状态10分钟后，您将不能使用出门操作。";
            
            [m_opBtn setBackgroundImage:color2Image(COLOR(255, 77, 60)) forState:0];
            [m_opBtn setTitle:@"出门" forState:0];
        } else {
            mainThread(apiOpenDoorOut, nil);
        }
        
    } else if (state == 4) { //已进门未出门，门状态异常
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (opType == nil) {
            showList = @[@(Id_BaseInfo), @(Id_NoticeInfo)];
            noticeDesc= @"你未在10分钟内关门，不能使用开门操作。";
        } else {
            
        }
    } else if (state == 5) { //已出门、预约已过期;
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////
        if (opType == nil) {
            showList = @[@(Id_BaseInfo), @(Id_NoticeInfo), @(Id_OpBtn)];
            
            noticeDesc= @"1、您的预约可能已使用。\n"
                        @"2、您的预约可能不在有效时间范围内。\n"
                        @"3、您的预约可能已被取消。";
            
            [m_opBtn setBackgroundImage:color2Image(COLOR(0, 165, 78)) forState:0];
            if ([m_state[@"stateApply"] intValue] == 1) {
                
            } else {
                
            }
            if ([m_state[@"stateApply"] intValue] == 0) {
                [m_opBtn setTitle:@"已申请, 正在等待授权" forState:0];
            } else if ([m_state[@"stateApply"] intValue] == 1) {
                [m_opBtn setTitle:@"申请再次进出门" forState:0];
            } else if ([m_state[@"stateApply"] intValue] == 2) {
                [m_opBtn setTitle:@"已拒绝, 不能再次申请" forState:0];
            }
        } else {
            if ([m_state[@"stateApply"] intValue] == 0) {
                mainThread(apiQueryState, nil);
            } else if ([m_state[@"stateApply"] intValue] == 1) {
                mainThread(apiOpenDoorApply, nil);
            } else if ([m_state[@"stateApply"] intValue] == 2) {
                mainThread(apiQueryState, nil);
            }
        }
    }
    if (!showList) return;

    // notice info
    m_lbNotice.attributedText = getLineSpaceStr(noticeDesc, 5);
    m_lbNotice.fw = m_lbNotice.superview.fw-15;
    [m_lbNotice sizeToFit];
    m_lbNotice.superview.fh = m_lbNotice.ey+10;
    v_NoticeInfo.fh = m_lbNotice.superview.fh + 10;

    [self refreshCellListShowState:showList];
}

- (void)refreshCellListShowState:(NSArray*)showList
{
    NSMutableDictionary* tmplist = [NSMutableDictionary dictionary];
    for (id showId in showList) {
        tmplist[showId] = showId;
    }
    
    v_BaseInfo.hidden = (tmplist[@(Id_BaseInfo)] == nil);
    v_NoticeInfo.hidden = (tmplist[@(Id_NoticeInfo)] == nil);
    v_Timer.hidden = (tmplist[@(Id_Timer)] == nil);
    v_OpBtn.hidden = (tmplist[@(Id_OpBtn)] == nil);
    
    CGFloat top_y = v_BaseInfo.ey;
    if (!v_NoticeInfo.hidden) {
        v_NoticeInfo.fy = top_y;
        top_y += v_NoticeInfo.fh;
    }
    if (!v_Timer.hidden) {
        v_Timer.fy = top_y;
        top_y += v_Timer.fh;
    }
    if (!v_OpBtn.hidden) {
        v_OpBtn.fy = top_y;
        top_y += v_OpBtn.fh;
    }
    
    m_table.contentSize = CGSizeMake(APP_W, top_y);
}


/////////////////////////////////////////////////////////////////////////////////////
- (void)buildCellList
{
    [self addCell_BaseInfo];
    [self addCell_noticeInfo];
    [self addCell_TimerCard];
    [self addCell_OpBtn];
}

- (void)addCell_BaseInfo
{
    v_BaseInfo = [[UIView alloc] initWithFrame:CGRectZero];
    v_BaseInfo.tag = Id_BaseInfo;
    v_BaseInfo.backgroundColor = [UIColor clearColor];
    v_BaseInfo.clipsToBounds = YES;

    UIView* card = [self addCard1WithTitle:@"预约详情" Cell:v_BaseInfo
                                   TxtList:@[@[@"预约时段：", NoNullStr(self.data[@"taskTime"])],
                                             @[@"施工机房：", NoNullStr(self.data[@"roomName"])],
                                             @[@"施工原因：", NoNullStr(self.data[@"reason"])],
                                             @[@"施工人员：", format(@"%@(%@)",
                                                                NoNullStr(self.data[@"constructor"]),
                                                                NoNullStr(self.data[@"mobile"]))],
                                             ] ];
    v_BaseInfo.fh = card.fh+10;
    v_BaseInfo.fw = APP_W;
    v_BaseInfo.hidden = NO;
    [m_table addSubview:v_BaseInfo];
    m_table.contentSize = CGSizeMake(APP_W, v_BaseInfo.fh);
}

- (void)addCell_noticeInfo
{
    v_NoticeInfo = [[UIView alloc] initWithFrame:CGRectZero];
    v_NoticeInfo.tag = Id_NoticeInfo;
    v_NoticeInfo.backgroundColor = [UIColor clearColor];
    v_NoticeInfo.clipsToBounds = YES;
    
    UIView* card = [self addCard2WithTitle:@"注意事项" Cell:v_NoticeInfo];
    v_NoticeInfo.fh = card.fh+10;
    v_NoticeInfo.fw = APP_W;
    v_NoticeInfo.hidden = YES;
    [m_table addSubview:v_NoticeInfo];
}

- (void)addCell_TimerCard
{
    v_Timer = [[UIView alloc] initWithFrame:CGRectZero];
    v_Timer.tag = Id_Timer;
    v_Timer.backgroundColor = [UIColor clearColor];
    v_Timer.clipsToBounds = YES;
    
    UIView* card = [[UIView alloc] initWithFrame:RECT(10, 10, APP_W-20, 115)];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.borderColor = [UIColor lightGrayColor].CGColor;
    card.layer.borderWidth = 0.5;
    card.layer.cornerRadius = 4;
    card.tag = 50;
    [v_Timer addSubview:card];
    
    m_lbTime = newLabel(card, @[@51, RECT_OBJ(10, 10, card.fw-20, card.fh-20), [UIColor blackColor],
                     [UIFont fontWithName:@"Verdana-Bold" size:60], @""]);
    m_lbTime.textAlignment = NSTextAlignmentCenter;
    [card release];
    
    card = [v_Timer viewWithTag:50];
    v_Timer.fh = card.fh+10;
    v_Timer.fw = APP_W;
    v_Timer.hidden = YES;
    [m_table addSubview:v_Timer];
}

- (void)addCell_OpBtn
{
    v_OpBtn = [[UIView alloc] initWithFrame:CGRectZero];
    v_OpBtn.tag = Id_OpBtn;
    v_OpBtn.backgroundColor = [UIColor clearColor];
    v_OpBtn.clipsToBounds = YES;
    
    m_opBtn = [[UIButton alloc] initWithFrame:RECT(15, 20, APP_W-30, 40)];
    [m_opBtn addTarget:self action:@selector(onOpBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    //[m_opBtn setBackgroundImage:color2Image(COLOR(0, 165, 78)) forState:0];
    m_opBtn.layer.cornerRadius = 5;
    m_opBtn.clipsToBounds = YES;
    [m_opBtn setTitleColor:[UIColor whiteColor] forState:0];
    m_opBtn.titleLabel.font = FontB(Font0);
    m_opBtn.tag = 50;
    [v_OpBtn addSubview:m_opBtn];
    [m_opBtn release];
    
    m_opBtn = (UIButton*)[v_OpBtn viewWithTag:50];
    
    v_OpBtn.fh = m_opBtn.fh+40;
    v_OpBtn.fw = APP_W;
    v_OpBtn.hidden = YES;
    [m_table addSubview:v_OpBtn];
}

- (UIView*)addCard1WithTitle:(NSString*)title Cell:(UIView*)cell TxtList:(NSArray*)txtList
{
    int txtTag = 50;
    UIView* card = [[UIView alloc] initWithFrame:RECT(10, 10, APP_W-20, 0)];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.borderColor = [UIColor lightGrayColor].CGColor;
    card.layer.borderWidth = 0.5;
    card.layer.cornerRadius = 4;
    card.tag = (txtTag++);
    [cell addSubview:card];
    
    CGFloat pos_y = 10;
    newLabel(card, @[@(txtTag++), RECT_OBJ(10, pos_y, card.fw-20, Font2), RGB(0xec8026), FontB(Font2), title]);
    pos_y += (Font2 + 10);
    
    UIView* line = [[UIView alloc] initWithFrame:RECT(10, pos_y, card.fw-20, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [card addSubview:line];
    [line release];
    pos_y += (0.5 + 10);
    
    
    for (NSArray* info in txtList) {
        UILabel* lbtitle = newLabel(card, @[@(txtTag++), RECT_OBJ(10, pos_y, 70, Font3), [UIColor blackColor], FontB(Font3), info[0]]);
        newLabel(card, @[@(txtTag++), RECT_OBJ(lbtitle.ex+2, pos_y, (card.fw-lbtitle.ex-2-10), Font3), [UIColor darkGrayColor], Font(Font3), info[1]]);
        pos_y += (Font3 + 10);
    }
    
    card.fh = pos_y;
    [card release];
    return [cell viewWithTag:50];
}

- (UIView*)addCard2WithTitle:(NSString*)title Cell:(UIView*)cell
{
    int txtTag = 50;
    UIView* card = [[UIView alloc] initWithFrame:RECT(10, 10, APP_W-20, 0)];
    card.backgroundColor = [UIColor whiteColor];
    card.layer.borderColor = [UIColor lightGrayColor].CGColor;
    card.layer.borderWidth = 0.5;
    card.layer.cornerRadius = 4;
    card.tag = (txtTag++);
    [cell addSubview:card];
    
    CGFloat pos_y = 10;
    newLabel(card, @[@(txtTag++), RECT_OBJ(10, pos_y, card.fw-20, Font2), RGB(0xec8026), FontB(Font2), title]);
    pos_y += (Font2 + 10);
    
    UIView* line = [[UIView alloc] initWithFrame:RECT(10, pos_y, card.fw-20, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [card addSubview:line];
    [line release];
    pos_y += (0.5 + 10);

    m_lbNotice = newLabel(card, @[@(txtTag++), RECT_OBJ(10, pos_y, card.fw-20, Font4), [UIColor blackColor], Font(Font4), @""]);
    pos_y += (m_lbNotice.fh );
    
    card.fh = pos_y+10;
    [card release];
    return [cell viewWithTag:50];
}

- (void)getVerifyCodeTextField
{
    CGFloat view_w=APP_W-50, view_h=40;
    m_verifyCodeTxtField = [[UITextField alloc] initWithFrame:RECT(50, 0, view_w-100, view_h-10)];
    m_verifyCodeTxtField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    m_verifyCodeTxtField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    m_verifyCodeTxtField.textAlignment = NSTextAlignmentCenter;
    m_verifyCodeTxtField.borderStyle = UITextBorderStyleNone;
    m_verifyCodeTxtField.font = Font(Font3);
    m_verifyCodeTxtField.placeholder = @"请输入校验码";
    m_verifyCodeTxtField.text = @"";
    m_verifyCodeTxtField.returnKeyType = UIReturnKeyDone;
    m_verifyCodeTxtField.clearButtonMode = UITextFieldViewModeWhileEditing;
    m_verifyCodeTxtField.backgroundColor = [UIColor whiteColor];
    m_verifyCodeTxtField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    m_verifyCodeTxtField.layer.borderWidth = 0.5;
    m_verifyCodeTxtField.layer.borderColor = [UIColor grayColor].CGColor;
    m_verifyCodeTxtField.delegate = self;
    
    m_verifyCodeBox = [[AlertBox alloc] initWithContentSize:CGSizeMake(view_w, view_h) Btns:@[@"取消", @"确定"]];
    m_verifyCodeBox.title = @"提示";
    m_verifyCodeBox.contentView = m_verifyCodeTxtField;
    m_verifyCodeBox.respBlock = ^(int index) {
        if (index == BTN_OK) {
            m_verifyCode = [m_verifyCodeTxtField.text copy];
            m_verifyCodeTxtField.text = @"";
            mainThread(apiQueryState, nil);
        }
        [self.view endEditing:YES];
    };
    [self.view addSubview:m_verifyCodeBox];
}

- (void)showVerifyCodeTextField {
    [m_verifyCodeBox show];
}

@end
