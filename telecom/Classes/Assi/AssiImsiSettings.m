//
//  AssiImsiSettings.m
//  telecom
//
//  Created by ZhongYun on 14-7-9.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "AssiImsiSettings.h"
#import "AssiSuporvisorList.h"

extern void doDeviceToken(int opType);


#define RowHeight       40

@interface AssiImsiSettings ()<UITextFieldDelegate>
{
      NSMutableDictionary* m_selInfo;
}
@end

@implementation AssiImsiSettings

- (void)dealloc
{
    [m_selInfo release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"施工人员注册";
    tagView(self.view, TAG_NAV_LEFT).hidden = YES;
    m_selInfo = [[NSMutableDictionary alloc] init];
    UIView* card = [self addBarObjs];
    
    UIButton* commitBtn = [[UIButton alloc] initWithFrame:RECT(15, card.ey+20, APP_W-30, 40)];
    [commitBtn addTarget:self action:@selector(onCommitBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [commitBtn setBackgroundImage:color2Image(COLOR(0, 165, 78)) forState:0];
    [commitBtn setTitle:@"提交" forState:0];
    commitBtn.layer.cornerRadius = 5;
    commitBtn.clipsToBounds = YES;
    [commitBtn setTitleColor:[UIColor whiteColor] forState:0];
    commitBtn.titleLabel.font = FontB(Font0);
    [self.view addSubview:commitBtn];
    [commitBtn release];
}

- (void)onCommitBtnTouched:(id)sender
{
    NSString* constructionId = m_selInfo[@"constructionId"];
    NSString* constructor = tagViewEx(self.view, 53, UITextField).text;
    NSString* mobile = tagViewEx(self.view, 55, UITextField).text;
    
    if (constructionId == nil || constructionId.length==0) {
        showAlert(@"请选择施工队!");
        return;
    }
    
    if (constructor.length==0) {
        showAlert(@"请填写施工人员姓名!");
        return;
    }
    
    if (mobile.length==0) {
        showAlert(@"请填写施工人员手机号码!");
        return;
    }
    
    httpGET1(@{URL_TYPE:NW_OpenDoorRegister,
               @"constructionId":constructionId,
               @"constructor":constructor,
               @"mobile":mobile,
               @"imsi":UGET(ASSI_IMSI)}, ^(id result) {
                   USET(ASSI_CONSTRUCTION_ID, constructionId);
                   USET(ASSI_CONSTRUCTOR, constructor);
                   USET(ASSI_MOBILE, mobile);
                   mainThread(registSucess, nil);
               });
    
}

- (void)registSucess
{
    doDeviceToken(1);
    NOTIF_POST(ASSI_REGIST_SUCCESS, nil);
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIView*)addBarObjs
{
    int rowNum = 3;
    UIView* bar1 = [[UIView alloc] initWithFrame:RECT(10, self.navBarView.ey+15, APP_W-20, RowHeight*rowNum)];
    bar1.backgroundColor = [UIColor whiteColor];
    bar1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bar1.layer.borderWidth = 0.5;
    bar1.layer.cornerRadius = 4;
    bar1.tag = 40;
    [self.view addSubview:bar1];
    
    for (int i=1; i < rowNum; i++) {
        UIView* line = [[UIView alloc] initWithFrame:RECT(0, i*RowHeight, bar1.fw, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [bar1 addSubview:line];
        [line release];
    }
    
    UILabel* title1 = newLabel(bar1, @[@50, RECT_OBJ(10, RowHeight*0 + (RowHeight-Font3)/2, 60, Font3),
                     [UIColor blackColor], FontB(Font3), @"施工队："]);
    //[self.view viewWithTag:50].layer.borderWidth = 0.5;
    newTextField(bar1, @[@51, RECT_OBJ(title1.ex, RowHeight*0, bar1.fw-title1.ex-10, RowHeight), [UIColor darkGrayColor], FontB(Font3), @"请选择施工队", @""]);
    
    UILabel* title2 = newLabel(bar1, @[@52, RECT_OBJ(10, RowHeight*1 + (RowHeight-Font3)/2, 100, Font3),
                                      [UIColor blackColor], FontB(Font3), @"施工人员姓名："]);
    //[self.view viewWithTag:52].layer.borderWidth = 0.5;
    newTextField(bar1, @[@53, RECT_OBJ(title2.ex, RowHeight*1, bar1.fw-title2.ex-10, RowHeight), [UIColor darkGrayColor], FontB(Font3), @"请输入施工人员姓名", @""]);
    
    UILabel* title3 = newLabel(bar1, @[@54, RECT_OBJ(10, RowHeight*2 + (RowHeight-Font3)/2, 100, Font3),
                                       [UIColor blackColor], FontB(Font3), @"施工人员手机："]);
    //[self.view viewWithTag:54].layer.borderWidth = 0.5;
    UITextField* mobile = newTextField(bar1, @[@55, RECT_OBJ(title3.ex, RowHeight*2, bar1.fw-title3.ex-10, RowHeight), [UIColor darkGrayColor], FontB(Font3), @"请输入施工人员手机", @""]);
    mobile.keyboardType = UIKeyboardTypeNumberPad;
    
    return [self.view viewWithTag:40];
}

- (void)constructionIdSelected
{
    tagViewEx(self.view, 51, UITextField).text = m_selInfo[@"constructionName"];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == 51) {
        AssiSuporvisorList* vc = [[AssiSuporvisorList alloc] init];
        vc.selectedId = m_selInfo[@"constructionId"];
        vc.respBlock = ^(NSDictionary* resp) {
            [m_selInfo removeAllObjects];
            [m_selInfo addEntriesFromDictionary:resp];
            mainThread(constructionIdSelected, nil);
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

@end

