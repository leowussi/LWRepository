//
//  MyBookingSgyyRefused.m
//  telecom
//
//  Created by ZhongYun on 15-1-6.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyBookingSgyyRefused.h"
#import "YZChooseView.h"
#import "IQKeyboardManager.h"

#define ROW_H   55
#define ROW_E   15

//#define TITLES  @[@"工程名称", @"施工时间", @"施工内容", @"施工区局", @"施工状态", @"施工地点", @"施工人员"]
//#define VALUES  @[@"projectName", @"taskTime", @"reason", @"regionName", @"status", @"taskAddress", @"constructor"]

#define TITLES  @[@"工程名称",@"工程编号", @"施工时间", @"施工内容",@"工程数量",@"特殊要求",@"施工单位",@"工程联系人",@"施工人联系电话",@"施工监护人",@"施工审核人",@"客保工单编号", @"施工区局", @"施工状态", @"施工地点"]

#define VALUES      @[@"projectName",@"projectNo",@"taskTime",@"reason",@"projectNum",@"taskInfo",@"taskCompany",@"constructor",@"contactNumber",@"supervisePeople",@"examinedPeople",@"kbNo",@"regionName",@"status",@"taskAddress"]


#define TAG_BTN_APPROVE     2310
#define TAG_BTN_REFUSED     2320
#define TAG_POP_VIEW        2400
#define TAG_TEXT_DESC       2216

@interface MyBookingSgyyRefused ()<UITextViewDelegate>
{
    NSMutableDictionary* m_data;
    UIScrollView* m_scroll;
    NSString *strTel;
    
    NSMutableDictionary *_chooseDict;
    YZChooseView *_chooseView;
    
    UIView* _banner;
    
    NSMutableDictionary *_dataDict;
    
    NSMutableArray *_nuTypeIdArray;
}
@end

@implementation MyBookingSgyyRefused

- (void)dealloc
{
    if (_nuTypeIdArray != nil) {
        [_nuTypeIdArray release];
    }
    if (_chooseView != nil) {
        [_chooseView release];
    }
    
    [_dataDict release];
    [_chooseDict release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_isConfirm) {
        self.navigationItem.title = @"施工预约确认";
        _dataDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"7",@"1", nil];
    }else{
        self.title = @"施工预约拒绝";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
                                                              (NAV_H-checkIcon.size.height)/2,
                                                              checkIcon.size.width, checkIcon.size.height)];
    [checkBtn setBackgroundImage:checkIcon forState:0];
    [checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
//    [self.navBarView addSubview:checkBtn];
    
    m_scroll = [[UIScrollView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, SCREEN_H-self.navBarView.ey)];
    m_scroll.contentSize = m_scroll.bounds.size;
    m_scroll.showsVerticalScrollIndicator = NO;
    m_scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_scroll];
    
    
    _banner = [[UIView alloc] initWithFrame:RECT(10, ROW_E, APP_W-20, 320)];
    _banner.tag = 100;
    _banner.backgroundColor = [UIColor whiteColor];
    _banner.layer.borderColor = COLOR(190, 190, 190).CGColor;
    _banner.layer.borderWidth = 0.5;
    _banner.layer.cornerRadius = 3;
    [m_scroll addSubview:_banner];
    
    UIView* line = [[UIView alloc] init];
    line.frame = RECT(2, ROW_H, _banner.fw-4, 0.5);
    line.backgroundColor = COLOR(221, 221, 221);
    [_banner addSubview:line];
    [line release];
    
    int btag = 150, vtag = 1100;
    CGFloat pos_y = (ROW_H - Font1)/2;
    UILabel* tlb = newLabel(_banner, @[@(btag++), RECT_OBJ(10, pos_y, 80, Font1), RGB(0xff5e36), FontB(Font1), @"任务详情"]);
    
    pos_y = ROW_H + 10;
//    for (NSString* title in TITLES) {
//        tlb = newLabel(banner, @[@(btag++), RECT_OBJ(10, pos_y, 75, Font3), RGB(0x313131), Font(Font3), format(@"%@：", title)]);
//        newLabel(banner, @[@(vtag++), RECT_OBJ(tlb.ex, pos_y, banner.fw-tlb.ex - 10, Font3*3), RGB(0x313131), Font(Font3), @""]);
//        pos_y = tlb.ey + 20;
//    }
//    banner.fh = pos_y;
//    pos_y = [self addTextView:banner.ey];
    NSArray *leftArr = @[@"工程名称",@"工程编号", @"施工时间", @"施工内容",@"工程数量",@"特殊要求",@"施工单位",@"工程联系人",@"施工人联系电话",@"施工监护人",@"施工审核人",@"客保工单编号", @"施工区局", @"施工状态", @"施工地点"];
   
    _chooseDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@[@"施工证明审查",@"设备开箱验货",@"施工规范监督",@"工程余料清理",@"安全管理",@"设备线缆标示",@"现场管理"],@"1", nil];
    
    for (int i = 0; i < leftArr.count; i++) {
        UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 70+32*i, 75, Font3)];
        leftLable.font = [UIFont systemFontOfSize:Font3];
        leftLable.tag = btag++;
        leftLable.text = [NSString stringWithFormat:@"%@:",[leftArr objectAtIndex:i]];
        [_banner addSubview:leftLable];
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
        [_banner addSubview:rightLable];
        [rightLable release];
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
            [_banner addSubview:textView];
            [textView release];
        }
        
    }
    NSArray *newAddArray = nil;
    if (_isConfirm) {
        if ([[_data objectForKey:@"specName"] isEqualToString:@"动力"]) {
            [self GetNuTypeList];
            newAddArray = @[@"网元类型",@"适用场景",@"配合任务"];
            _banner.fh = 550 + 96;
            for (int i = 0; i < newAddArray.count; i++) {
                UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 550+32*i, 175, Font3)];
                leftLable.font = [UIFont systemFontOfSize:Font3];
                if (i == 1) {
                    leftLable.text = [NSString stringWithFormat:@"%@:工程现场配合",[newAddArray objectAtIndex:i]];
                }else if (i == 0){
                    [self addChooseButtonWithButtonTag:50 frame:CGRectMake(75, 548+32*i, kScreenWidth - 106, 24)];
                    leftLable.text = [NSString stringWithFormat:@"%@:",[newAddArray objectAtIndex:i]];
                }else{
                    [self addChooseButtonWithButtonTag:51 frame:CGRectMake(75, 548+32*i, kScreenWidth - 106, 24)];
                    leftLable.text = [NSString stringWithFormat:@"%@:",[newAddArray objectAtIndex:i]];
                }
                
                [_banner addSubview:leftLable];
                [leftLable release];
            }
        }else{
            newAddArray = @[@"适用场景",@"配合任务"];
            _banner.fh = 550 + 64;
            for (int i = 0; i < newAddArray.count; i++) {
                UILabel *leftLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 550+32*i, 175, Font3)];
                leftLable.font = [UIFont systemFontOfSize:Font3];
                if (i == 0) {
                    leftLable.text = [NSString stringWithFormat:@"%@:工程现场配合",[newAddArray objectAtIndex:i]];
                }else{
                     leftLable.text = [NSString stringWithFormat:@"%@:",[newAddArray objectAtIndex:i]];
                    [self addChooseButtonWithButtonTag:51 frame:CGRectMake(75, 548+32*i, kScreenWidth - 106, 24)];
                }
                
                [_banner addSubview:leftLable];
                [leftLable release];
            }

        }
    }else{
        _banner.fh = 550;
    }
    
    
    pos_y = [self addTextView:_banner.ey];
    [_banner release];
    
    m_scroll.contentSize = CGSizeMake(m_scroll.fw, pos_y+10);
    
    NSString *str = [NSString stringWithFormat:@"%@",self.data[@"contactNumber"]];
    strTel = [str
              stringByReplacingOccurrencesOfString:@"," withString:@" "];
    
    [self updateLabels];
}

#pragma mark -- 请求网元类型
- (void)GetNuTypeList
{
    NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
    para1[URL_TYPE] = @"MyTask/WithWork/GetNuTypeList";
    httpPOST(para1, ^(id result) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
        _nuTypeIdArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *listArray = [result objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
            [mutArray addObject:[dict objectForKey:@"nuTypeName"]];
            [_nuTypeIdArray addObject:[dict objectForKey:@"nuTypeId"]];
        }
        [_chooseDict setObject:mutArray forKey:@"0"];
    }, ^(id result) {
        
    });

}

#pragma mark -- 选择文本
- (void)addChooseButtonWithButtonTag:(NSInteger)tag frame:(CGRect)frame
{
    UIButton *chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (tag == 51) {
        [chooseButton setTitle:@"现场管理" forState:UIControlStateNormal];
    }
    [chooseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    chooseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    chooseButton.tag = tag;
    chooseButton.frame = frame;
    chooseButton.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
    chooseButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    chooseButton.contentEdgeInsets = UIEdgeInsetsMake(0,8, 0, 0);
    chooseButton.layer.cornerRadius = 4;
    chooseButton.layer.borderColor = [UIColor grayColor].CGColor;
    chooseButton.layer.borderWidth = .5;
    [chooseButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_banner addSubview:chooseButton];
    
    CALayer *accessoryLayer = [CALayer layer];
    accessoryLayer.frame = CGRectMake(frame.size.width - 23, 2, 23, 21);
    accessoryLayer.contents = (id)[UIImage imageNamed:@"week_right"].CGImage;
    accessoryLayer.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
    [chooseButton.layer addSublayer:accessoryLayer];
   

}

- (void)chooseButtonClicked:(UIButton *)sender
{
    if (!_chooseView) {
        _chooseView = [[YZChooseView alloc] initWithFrame:CGRectZero tableViewHeight:0];
        
    }
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    NSArray *array = [_chooseDict objectForKey:[NSString stringWithFormat:@"%d",sender.tag - 50]];
    
    __block NSInteger selectedIndex = -1;
    NSMutableArray *heightArray = [NSMutableArray arrayWithCapacity:0];
    __block CGFloat totalheight = 0.0f;
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:sender.titleLabel.text]) {
            selectedIndex = idx;
        }
        CGFloat height = [YZChooseView calculateTextheight:obj withTextWidth:sender.frame.size.width] + 4;
        height = height > 22 ? height : 22;
        totalheight = totalheight + height;
        [heightArray addObject:[NSNumber numberWithFloat:height]];
    }];
    if (sender.tag == 50) {
         _chooseView.frame = CGRectMake(sender.frame.origin.x + _banner.frame.origin.x , sender.frame.origin.y + _banner.frame.origin.y - 100, sender.frame.size.width, 300);
        _chooseView.tableView.frame = CGRectMake(0, 0, _chooseView.frame.size.width, 300);
        _chooseView.tableView.showsVerticalScrollIndicator = YES;
    }else{
         _chooseView.frame = CGRectMake(sender.frame.origin.x + _banner.frame.origin.x , sender.frame.origin.y + _banner.frame.origin.y, sender.frame.size.width, totalheight);
        _chooseView.tableView.frame = CGRectMake(0, 0, _chooseView.frame.size.width, totalheight);
    }
   
    
    
    
    _chooseView.heightArray = heightArray;
    _chooseView.selectedIndex = selectedIndex;
    _chooseView.dataArray = array;
    [m_scroll addSubview:_chooseView];
    
    _chooseView.selectedCompletionBlock = ^(NSInteger selectedIndex){
        [sender setTitle:array[selectedIndex] forState:UIControlStateNormal];
        if (sender.tag - 50 == 1) {
             [_dataDict setObject:[NSString stringWithFormat:@"%d",selectedIndex + 1] forKey:[NSString stringWithFormat:@"%d",sender.tag - 50]];
        }else{
            [_dataDict setObject:_nuTypeIdArray[selectedIndex] forKey:@"0"];
        }
       
    };
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

- (void)updataWithFlag:(NSString *)flag status:(NSString *)status
{
    NSString* desc = tagViewEx(self.view, TAG_TEXT_DESC, UITextView).text;
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"URL_TYPE"] = NW_TaskAppointmentCommit;
    param[@"appointmentId"] = self.data[@"appointmentId"];
    param[@"flag"] = flag;
    param[@"status"] = status;
    param[@"rejectReason"] = desc;
    param[@"matchTaskId"] = [_dataDict objectForKey:@"1"];
    param[@"nuTypeId"] = [_dataDict objectForKey:@"0"];
    NSLog(@"%@",param);
    httpGET1(param, ^(id result) {
        int flag = [m_data[@"flag"] intValue];
        if (flag == 2) {
            NOTIF_POST(BOOKING_UPDATE_SGRW, nil);
            NOTIF_POST(BOOKING_UPDATE_SGYY, nil);
        }else{
            NOTIF_POST(BOOKING_UPDATE_SGRW, nil);
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交确认成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [alertView release];
        //        [self.navigationController popToViewController:self.listVC animated:YES];
        
    });
    return;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
- (void)onCheckBtnTouched:(id)sender
{
    NSString* desc = tagViewEx(self.view, TAG_TEXT_DESC, UITextView).text;
    if (desc.length == 0) {
        if (_isConfirm) {
             showAlert(@"请填写备注信息！");
        }else {
             showAlert(@"请填写拒绝原因！");
        }
        return ;
    }
    

    
    if (_isConfirm) {
        if ([[_data objectForKey:@"specName"] isEqualToString:@"动力"]) {
            if ([_dataDict objectForKey:@"0"] == nil ||[[_dataDict objectForKey:@"0"] isEqualToString:@""]) {
                showAlert(@"请选择网元类型！");
                return;
            }
        }
        if (_isShowAlert) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"选择生成类型"
                                                                message:@"请选择生成远程开门任务还是现场随工任务！"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"远程开门", @"现场随工", nil];
            [alertView showWithBlock:^(NSInteger btnIndex) {
                if (btnIndex == 1) {
                    [self updataWithFlag:@"1" status:@"1"];
                }else if (btnIndex == 2){
                    [self updataWithFlag:@"2" status:@"1"];
                }

            }];
        }else{
            [self updataWithFlag:@"2" status:@"1"];
        }
        
        
             
    }else{
        
        
        
        NSDictionary* param = @{URL_TYPE:NW_TaskAppointmentCommit,
                                @"appointmentId":self.data[@"appointmentId"],
                                @"flag":self.data[@"flag"],
                                @"status":@"2",
                                @"rejectReason":desc};
        httpGET1(param, ^(id result) {
            showAlert(@"提交拒绝成功");
            //        [self.navigationController popToViewController:self.listVC animated:YES];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
            NOTIF_POST(BOOKING_UPDATE_SGYY, nil);
        });

       
    }
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
    [line release];
    
    if (_isConfirm) {
        newLabel(banner, @[@(201), RECT_OBJ(10, (ROW_H - Font1)/2, 120, Font1), RGB(0xff5e36), FontB(Font1), @"添加备注信息"]);
    }else {
        newLabel(banner, @[@(201), RECT_OBJ(10, (ROW_H - Font1)/2, 80, Font1), RGB(0xff5e36), FontB(Font1), @"拒绝原因"]);
    }
    newTextView(banner, @[@(TAG_TEXT_DESC), RECT_OBJ(10, ROW_H+10, banner.fw-20, banner.fh-ROW_H-20), COLOR(69, 69, 69), FontB(Font3), @"", @""]).backgroundColor = RGB(0xe6ede7);
    
    
    CGFloat ban_ey = banner.ey;
    [banner release];
    return ban_ey;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_chooseView removeFromSuperview];
    CGRect rect = m_scroll.frame;
    rect.size.height -= 297;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25f];
    [UIView setAnimationCurve:7];
     m_scroll.frame = rect;
    [UIView commitAnimations];

    [m_scroll scrollRectToVisible:CGRectMake(0, m_scroll.contentSize.height - textView.frame.size.height, textView.frame.size.width, 50) animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect rect = m_scroll.frame;
    rect.size.height += 297;
    [UIView animateWithDuration:.25 animations:^{
        m_scroll.frame = rect;
    } completion:^(BOOL finished) {
        
    }];

}
@end
