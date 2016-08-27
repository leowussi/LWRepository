//
//  AuditViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/8/6.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AuditViewController.h"

#define ROW_H   55
#define ROW_E   15

//#define TITLES  @[@"工程名称", @"施工时间", @"施工内容", @"施工区局", @"施工状态", @"施工地点", @"施工人员"]

#define TITLES  @[@"工程名称",@"工程编号", @"施工时间", @"施工内容",@"工程数量",@"特殊要求",@"施工单位",@"工程联系人",@"施工人联系电话",@"施工监护人",@"施工审核人",@"客保工单编号", @"施工区局", @"施工状态", @"施工地点",@"专业"]

#define VALUES      @[@"projectName",@"projectNo",@"taskTime",@"reason",@"projectNum",@"taskInfo",@"taskCompany",@"constructor",@"contactNumber",@"supervisePeople",@"examinedPeople",@"kbNo",@"regionName",@"status",@"taskAddress",@"specName"]

//#define VALUES  @[@"projectName", @"taskTime", @"reason", @"regionName", @"status", @"taskAddress", @"constructor"]


#define TAG_BTN_APPROVE     2310
#define TAG_BTN_REFUSED     2320
#define TAG_POP_VIEW        2400
#define TAG_TEXT_DESC       2216

@interface AuditViewController ()<UITextViewDelegate>
{
    NSMutableDictionary* m_data;
    UIScrollView* m_scroll;
    NSString *strTel;
}


@end

@implementation AuditViewController


- (void)addNavigationRightButton:(NSString *)str
{
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.frame = CGRectMake(kScreenWidth-[UIImage imageNamed:str].size.width/2, 12,[UIImage imageNamed:str].size.width,[UIImage imageNamed:str].size.height);
    [forwardButton setBackgroundImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"施工预约审核";
    
//    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    [self addNavigationRightButton:@"nav_check.png"];
//    UIButton* checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
//                                                              (NAV_H-checkIcon.size.height)/2,
//                                                              checkIcon.size.width, checkIcon.size.height)];
//    [checkBtn setBackgroundImage:checkIcon forState:0];
//    [checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navBarView addSubview:checkBtn];
    
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
    
    int btag = 150, vtag = 1100;
    CGFloat pos_y = (ROW_H - Font1)/2;
    UILabel* tlb = newLabel(banner, @[@(btag++), RECT_OBJ(10, pos_y, 80, Font1), RGB(0xff5e36), FontB(Font1), @"任务详情"]);
    
    pos_y = ROW_H + 10;
//    for (NSString* title in TITLES) {
//        tlb = newLabel(banner, @[@(btag++), RECT_OBJ(10, pos_y, 75, Font3), RGB(0x313131), Font(Font3), format(@"%@：", title)]);
//        newLabel(banner, @[@(vtag++), RECT_OBJ(tlb.ex, pos_y, banner.fw-tlb.ex - 10, Font3*3), RGB(0x313131), Font(Font3), @""]);
//        pos_y = tlb.ey + 20;
//        
//
//    }
    NSArray *leftArr = @[@"工程名称",@"工程编号", @"施工时间", @"施工内容",@"工程数量",@"特殊要求",@"施工单位",@"工程联系人",@"施工人联系电话",@"施工监护人",@"施工审核人",@"客保工单编号", @"施工区局", @"施工状态", @"施工地点"];
    
    for (int i = 0; i < leftArr.count; i++) {
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 70+30*i, 75, Font3)];
        leftLable.font = [UIFont systemFontOfSize:Font3];
        leftLable.tag = btag++;
        leftLable.text = [NSString stringWithFormat:@"%@:",[leftArr objectAtIndex:i]];
        [banner addSubview:leftLable];
        
        if (i == 8) {
            leftLable.frame = CGRectMake(10, 70+30*i, 105, Font3);
        }
        
        if (i == 11) {
            leftLable.frame = CGRectMake(10, 70+30*i, 100, Font3);
        }
        
        UILabel *rightLable = [[UILabel alloc]initWithFrame:CGRectMake(leftLable.ex, 70+30*i, 200, Font3*3)];
        rightLable.font = [UIFont systemFontOfSize:Font3];
        rightLable.text = @"";
        rightLable.tag = vtag++;
        [banner addSubview:rightLable];
        
        if (i == 8){
            rightLable.hidden = YES;
            UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(leftLable.ex, 60+32*i, 200, Font3*3)];
            textView.tag = 888;
            textView.font = [UIFont systemFontOfSize:Font3];
            textView.text = @"";
            textView.dataDetectorTypes = UIDataDetectorTypeAll;
            if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
                
            {
                
                textView.selectable = YES;//用法：决定UITextView 中文本是否可以相应用户的触摸，主要指：1、文本中URL是否可以被点击；2、UIMenuItem是否可以响应
                
            }
            textView.editable = NO;
            [banner addSubview:textView];
            
            
        }

        
    }
    
    
    
    banner.fh = 550;
    pos_y = [self addTextView:banner.ey];
    
    m_scroll.contentSize = CGSizeMake(m_scroll.fw, pos_y+10);
    
    [self updateLabels];
}

- (void)updateLabels
{
    int vtag = 1100;
    for (NSString* key in VALUES) {
        tagViewEx(self.view, vtag, UILabel).text = self.data[key];
        [tagViewEx(self.view, vtag++, UILabel) sizeToFit];
        if (vtag == 1108) {
            
            tagViewEx(self.view, vtag, UILabel).hidden = YES;
            tagViewEx(self.view, 888, UITextView).text = strTel;
            [tagViewEx(self.view, 888, UITextView) sizeToFit];
        }
    }
}

- (void)onCheckBtnTouched:(id)sender
{
    NSString* desc = tagViewEx(self.view, TAG_TEXT_DESC, UITextView).text;
    if (desc.length == 0) {
        showAlert(@"请填写审核原因！");
        return ;
    }
    
    NSDictionary* param = @{URL_TYPE:NW_TaskAppointmentCommit,
                            @"appointmentId":self.data[@"appointmentId"],
                            @"flag":self.data[@"flag"],
                            @"status":@"3",
                            @"examineRemark":desc};
    httpGET1(param, ^(id result) {
        showAlert(@"提交审核成功");
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        NOTIF_POST(BOOKING_UPDATE_SGYY, nil);
    });
}

- (CGFloat)addTextView:(CGFloat)pos_y
{
    UIView* banner = [[UIView alloc] initWithFrame:RECT(10, pos_y + ROW_E, APP_W-20, 200)];
    banner.tag = 200;
    banner.backgroundColor = [UIColor whiteColor];
    banner.layer.borderColor = COLOR(190, 190, 190).CGColor;
    banner.layer.borderWidth = 0.5;
    banner.layer.cornerRadius = 3;
    [m_scroll addSubview:banner];
    
    UIView* line = [[UIView alloc] init];
    line.frame = RECT(2, ROW_H, banner.fw-4, 0.5);
    line.backgroundColor = COLOR(221, 221, 221);
    [banner addSubview:line];
    
    newLabel(banner, @[@(201), RECT_OBJ(10, (ROW_H - Font1)/2, 80, Font1), RGB(0xff5e36), FontB(Font1), @"审核原因"]);
    
    newTextView(banner, @[@(TAG_TEXT_DESC), RECT_OBJ(10, ROW_H+10, banner.fw-20, banner.fh-ROW_H-20), COLOR(69, 69, 69), FontB(Font3), @"", @""]).backgroundColor = RGB(0xe6ede7);
    
    
    CGFloat ban_ey = banner.ey;
    return ban_ey;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
