//
//  MyBookingSgyyDetail.m
//  telecom
//
//  Created by ZhongYun on 15-1-6.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyBookingSgyyDetail.h"
#import "MyBookingSgyyRefused.h"
#import "MySendSMS.h"
#import "AuditViewController.h"
#define ROW_H   55
#define ROW_E   15

//#define TITLES  @[@"工程名称", @"施工时间", @"施工内容", @"施工区局", @"施工状态", @"施工地点", @"施工人员"]
//#define VALUES  @[@"projectName", @"taskTime", @"reason", @"regionName", @"status", @"taskAddress", @"constructor"]
#define TITLES  @[@"工程名称",@"工程编号", @"施工时间", @"施工内容",@"工程数量",@"特殊要求",@"施工单位",@"工程联系人",@"施工人联系电话",@"施工监护人",@"施工审核人",@"客保工单编号", @"施工区局", @"施工状态", @"施工地点",@"专业"]

#define VALUES      @[@"projectName",@"projectNo",@"taskTime",@"reason",@"projectNum",@"taskInfo",@"taskCompany",@"constructor",@"contactNumber",@"supervisePeople",@"examinedPeople",@"kbNo",@"regionName",@"status",@"taskAddress",@"specName"]



#define TAG_BTN_APPROVE     2310
#define TAG_BTN_REFUSED     2320
#define TAG_POP_VIEW        2400

@interface MyBookingSgyyDetail ()
{
    NSMutableDictionary* m_data;
    UIScrollView* m_scroll;
    NSString *strTel;
}
@end

@implementation MyBookingSgyyDetail

- (void)dealloc
{
    [m_data release];
    [m_scroll release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"施工预约详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    m_scroll = [[UIScrollView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, SCREEN_H-self.navBarView.ey)];
    m_scroll.contentSize = m_scroll.bounds.size;
    m_scroll.showsVerticalScrollIndicator = NO;
    m_scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_scroll];
    
    
    UIView* banner = [[UIView alloc] initWithFrame:RECT(10, ROW_E, APP_W-20, 320)];
    banner.tag = 100;
    banner.backgroundColor = [UIColor whiteColor];
    banner.layer.borderColor = COLOR(190, 190, 190).CGColor;
    banner.layer.borderWidth = 0.5;
    banner.layer.cornerRadius = 3;
    [m_scroll addSubview:banner];
    
    UIView* line = [[UIView alloc] init];
    line.frame = RECT(2, ROW_H, banner.fw-4, 0.5);
    line.backgroundColor = COLOR(221, 221, 221);
    [banner addSubview:line];
    [line release];
    
    int btag = 150, vtag = 1100;
    CGFloat pos_y = (ROW_H - Font1)/2;
    UILabel* tlb = newLabel(banner, @[@(btag++), RECT_OBJ(10, pos_y, 80, Font1), RGB(0xff5e36), FontB(Font1), @"任务详情"]);
    
    pos_y = ROW_H + 10;
//    for (NSString* title in TITLES) {
//        tlb = newLabel(banner, @[@(btag++), RECT_OBJ(10, pos_y, 75, Font3), RGB(0x313131), Font(Font3), format(@"%@：", title)]);
//        newLabel(banner, @[@(vtag++), RECT_OBJ(tlb.ex, pos_y, banner.fw-tlb.ex - 10, Font3*3), RGB(0x313131), Font(Font3), @""]);
//        pos_y = tlb.ey + 20;
//    }
//    banner.fh = pos_y;
    
    NSArray *leftArr = @[@"工程名称",@"工程编号", @"施工时间", @"施工内容",@"工程数量",@"特殊要求",@"施工单位",@"工程联系人",@"施工人联系电话",@"施工监护人",@"施工审核人",@"客保工单编号", @"施工区局", @"施工状态", @"施工地点",@"专       业"];
    
    for (int i = 0; i < leftArr.count; i++) {
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 70+32*i, 75, Font3)];
        leftLable.font = [UIFont systemFontOfSize:Font3];
        leftLable.tag = btag++;
        leftLable.text = [NSString stringWithFormat:@"%@:",[leftArr objectAtIndex:i]];
        [banner addSubview:leftLable];
        [leftLable release];
        
        if (i == 8) {
            leftLable.frame = CGRectMake(10, 70+32*i, 105, Font3);
        }
        
        if (i == 11) {
            leftLable.frame = CGRectMake(10, 70+32*i, 100, Font3);
        }
        
        UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(leftLable.ex, 68+32*i, 200, Font3*3)];
        rightLable.font = [UIFont systemFontOfSize:Font3];
        rightLable.text = @"";
        rightLable.tag = vtag++;
        [banner addSubview:rightLable];
        [rightLable release];
        
        if (i == 8){
            rightLable.hidden = YES;
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(leftLable.ex, 60+32*i, 200, Font3*3)];
            textView.tag = 888;
            textView.font = [UIFont systemFontOfSize:Font3];
            textView.dataDetectorTypes = UIDataDetectorTypeAll;
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0){
                
                textView.selectable = YES;//用法：决定UITextView 中文本是否可以相应用户的触摸，主要指：1、文本中URL是否可以被点击；2、UIMenuItem是否可以响应
                
            }
            textView.editable = NO;
            [banner addSubview:textView];
            
            
        }
        
    }
    
    
    banner.fh = 582;
    pos_y = [self addButtons:banner.ey];
    [banner release];
    
    m_scroll.contentSize = CGSizeMake(m_scroll.fw, pos_y+10);
    
    [self loadData];
}

- (void)updateLabels
{
    int vtag = 1100;
    for (NSString* key in VALUES) {
        tagViewEx(self.view, vtag, UILabel).text = m_data[key];
        [tagViewEx(self.view, vtag++, UILabel) sizeToFit];
        if (vtag == 1108) {
            
            tagViewEx(self.view, vtag, UILabel).hidden = YES;
            tagViewEx(self.view, 888, UITextView).text = strTel;
            [tagViewEx(self.view, 888, UITextView) sizeToFit];
        }
    }
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:TAG_BTN_APPROVE];
    if ([m_data[@"authorityMark"] isEqualToString:@"0"] ) {
        [btn setTitle:@"审    核" forState:UIControlStateNormal];
    }else{
        [btn setTitle:@"确    认" forState:UIControlStateNormal];
    }
}

- (void)loadData
{
    httpGET1(@{URL_TYPE:NW_TaskAppointmentInfo, @"appointmentId":self.appointmentId}, ^(id result) {
        NSLog(@"%@",result);
        m_data = [result[@"detail"] mutableCopy];
        NSString *str = [NSString stringWithFormat:@"%@",m_data[@"contactNumber"]];
        strTel = [str
                  stringByReplacingOccurrencesOfString:@"," withString:@" "];
        mainThread(updateLabels, nil);
    });
}

- (CGFloat)addButtons:(CGFloat)pos_y
{
    UIButton* btn1 = [[UIButton alloc] initWithFrame:RECT(10, pos_y+20, APP_W/2-20, 40)];
    [btn1 setBackgroundImage:color2Image(COLOR(74, 130, 198)) forState:0];
    [btn1 addTarget:self action:@selector(onBtnApproveTouched:) forControlEvents:UIControlEventTouchUpInside];
    btn1.layer.cornerRadius = 5;
    btn1.clipsToBounds = YES;
    btn1.hidden = ([m_data[@"statusId"] intValue] == 1);
    btn1.tag = TAG_BTN_APPROVE;
    [btn1 setTitle:@"审    核" forState:0];
    [btn1 setTitleColor:[UIColor whiteColor] forState:0];
    btn1.titleLabel.font = FontB(Font0);
    [m_scroll addSubview:btn1];
    CGFloat btn_ey = btn1.ey;
    [btn1 release];
    
    UIButton* btn2 = [[UIButton alloc] initWithFrame:RECT(APP_W/2+10, pos_y+20, APP_W/2-20, 40)];
    [btn2 setBackgroundImage:color2Image(COLOR(0, 165, 78)) forState:0];
    [btn2 addTarget:self action:@selector(onBtnRefusedTouched:) forControlEvents:UIControlEventTouchUpInside];
    btn2.layer.cornerRadius = 5;
    btn2.clipsToBounds = YES;
    btn2.hidden = ([m_data[@"statusId"] intValue] == 1);
    btn2.tag = TAG_BTN_REFUSED;
    [btn2 setTitle:@"拒    绝" forState:0];
    [btn2 setTitleColor:[UIColor whiteColor] forState:0];
    btn2.titleLabel.font = FontB(Font0);
    [m_scroll addSubview:btn2];
    [btn2 release];
    
    return btn_ey + 20;
}

#pragma mark -  施工审核人点击进行审核\确认操作
- (void)onBtnApproveTouched:(id)sender
{
    int flag = [m_data[@"flag"] intValue];
    
    if ([m_data[@"authorityMark"] isEqualToString:@"0"]) {//审核
        
        if (flag == 1) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"选择生成类型"
                                                                message:@"请选择生成远程开门任务还是现场随工任务！"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"远程开门", @"现场随工", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alertView textFieldAtIndex:0];
            textField.placeholder = @"添加备注信息";
            [alertView showWithBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self approveToSGRWOfStatus:@"3" flag:@"1" remarkInfo:textField.text];
                }else if (btnIndex == 2){
                [self approveToSGRWOfStatus:@"3" flag:@"2" remarkInfo:textField.text];
                }
            }];
            [alertView release];
        } else if (flag == 2) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                message:@"是否确定该条施工预约单将生成现场随工单？"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alertView textFieldAtIndex:0];
            textField.placeholder = @"添加备注信息";
            [alertView showWithBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self approveToSGRWOfStatus:@"3" flag:@"2" remarkInfo:textField.text];
                }
            }];
            [alertView release];
        }

    }else{//确认
        if (flag == 1) {
            
            //---------------
            MyBookingSgyyRefused* vc = [[MyBookingSgyyRefused alloc] init];
            vc.data = m_data;
            vc.isConfirm = YES;
            vc.isShowAlert = YES;
            vc.listVC = self.listVC;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
            return;
            //-------------
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"选择生成类型"
                                                                message:@"请选择生成远程开门任务还是现场随工任务！"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"远程开门", @"现场随工", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alertView textFieldAtIndex:0];
            textField.placeholder = @"添加备注信息";
            [alertView showWithBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self approveToSGRWOfStatus:@"3" flag:@"1" remarkInfo:textField.text];
                }else if (btnIndex == 2){
                    [self approveToSGRWOfStatus:@"3" flag:@"2" remarkInfo:textField.text];
                }
            }];
            [alertView release];
        } else if (flag == 2) {
            /*
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                                message:@"是否确定该条施工预约单将生成现场随工单？"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alertView textFieldAtIndex:0];
            textField.placeholder = @"添加备注信息";
            [alertView showWithBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self approveToSGRWOfStatus:@"1" flag:@"2" remarkInfo:textField.text];
                }
            }];
            [alertView release];
             */
            
            MyBookingSgyyRefused* vc = [[MyBookingSgyyRefused alloc] init];
            vc.data = m_data;
            vc.isConfirm = YES;
            vc.listVC = self.listVC;
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        }
             
    }
    
    
}

- (void)approveToSGRWOfStatus:(NSString *)status flag:(NSString *)flag remarkInfo:(NSString *)remarkInfo
{
    httpGET1(@{URL_TYPE:NW_TaskAppointmentCommit,
               @"appointmentId":self.appointmentId,
               @"flag":flag,//m_data[@"flag"]
               @"status":status,
               @"examineRemark":remarkInfo},
             ^(id result) {
                 int flag = [m_data[@"flag"] intValue];
                 if (flag == 1) {
//                     tagView(self.view, TAG_BTN_APPROVE).hidden = YES;
//                     tagView(self.view, TAG_BTN_REFUSED).hidden = YES;
//                     
//                     NSString* verifyCode = result[@"detail"][@"verificationCode"];
//                     NSString* mobile = result[@"detail"][@"mobile"];
//                     if (NoNullStr(verifyCode).length > 0 && NoNullStr(mobile).length > 0) {
//                         NSString* msg = format(@"时间：%@；机房名称：%@；进入原因：%@；预约验证码：%@；",
//                                                m_data[@"taskTime"],m_data[@"regionName"],
//                                                m_data[@"reason"],verifyCode);
//                         NSDictionary* param = @{@"mobile":mobile,
//                                                 @"message":msg,
//                                                 @"parent":self};
//                         [MySendSMS sendSMS:param];
//                     } else {
//                         showAlert(@"未生成校验码!");
//                     }
                 } else if (flag == 2) {
                     NOTIF_POST(BOOKING_UPDATE_SGRW, nil);
                     NOTIF_POST(BOOKING_UPDATE_SGYY, nil);
                     [self.navigationController popViewControllerAnimated:YES];
                 }
             });
}

- (void)onBtnRefusedTouched:(id)sender
{
    MyBookingSgyyRefused* vc = [[MyBookingSgyyRefused alloc] init];
    vc.data = m_data;
    vc.listVC = self.listVC;
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)sendSmsSuccess
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
