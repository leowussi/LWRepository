//
//  TaskWirelessInputText.m
//  telecom
//
//  Created by ZhongYun on 15-3-24.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "TaskWirelessInputText.h"
#import "CompAlertBox.h"
#import "NSThread+Blocks.h"
#import "TaskWirelessDetail.h"

#define TAG_DATE_VLU 1203
#define TAG_TIME_VLU 1204

@interface TaskWirelessInputText ()<UITextFieldDelegate>
{
    AlertBox* m_datePicker1;
    AlertBox* m_timePicker1;
}
@property (nonatomic, assign)int type;
@property (nonatomic, copy)NSString* value;
@property (nonatomic, retain)UILabel* targetLabel;
@property (nonatomic, retain)id dataRow;
@property (nonatomic, retain)TaskWirelessDetail* parentVC;
@end

@implementation TaskWirelessInputText

- (void)dealloc
{
    [m_datePicker1 release];
    [m_timePicker1 release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
                                                      (NAV_H-checkIcon.size.height)/2,
                                                      checkIcon.size.width, checkIcon.size.height)];
    [checkBtn setBackgroundImage:checkIcon forState:0];
    [checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:checkBtn];
    
    NSString* strDesc = [self.title copy];
    self.title = (INPUT_MEMO ? @"备注" : @"设置");
    UILabel* lbtitle = newLabel(self.view, @[@100, RECT_OBJ(15, self.navBarView.ey+15, APP_W-30, 500), RGB(0x666666), FontB(Font2), strDesc]);
    lbtitle.attributedText = getLineSpaceStr(lbtitle.text, 7);
    [lbtitle sizeToFit];
    
    if ((self.type == INPUT_TEXT) || (self.type == INPUT_NUMBER)) {
        UITextField* textField = newTextField(self.view, @[@50, RECT_OBJ(15, lbtitle.ey+15, APP_W-30, 30), RGB(0x000000), Font(Font3), format(@"请输入%@", self.title), self.value]);
        textField.backgroundColor = RGB(0xffffff);
        textField.layer.borderWidth = 0.5;
        textField.layer.borderColor = RGB(0x999999).CGColor;
        textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textField.fh)];
        textField.leftViewMode = UITextFieldViewModeAlways;
        if (self.type == INPUT_NUMBER) {
            textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            textField.textAlignment = NSTextAlignmentCenter;
        }
        
    } else if (self.type == INPUT_DATE_TIME) {
        newLabel(self.view, @[@40, RECT_OBJ(15, lbtitle.ey+15, APP_W-30, 30), RGB(0x000000), FontB(Font2), @"日期"]);
        NSString* dateStr = (isNullStr(self.value) ? @"" : [self.value componentsSeparatedByString:@" "][0]);
        UITextField* textDate = newTextField(self.view, @[@(TAG_DATE_VLU), RECT_OBJ(60, lbtitle.ey+15, APP_W-75, 30), RGB(0x000000), Font(Font3), format(@"请输入%@", self.title), dateStr]);
        textDate.backgroundColor = RGB(0xffffff);
        textDate.layer.borderWidth = 0.5;
        textDate.layer.borderColor = RGB(0x999999).CGColor;
        textDate.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textDate.fh)];
        textDate.leftViewMode = UITextFieldViewModeAlways;
        
        newLabel(self.view, @[@41, RECT_OBJ(15, textDate.ey+15, APP_W-30, 30), RGB(0x000000), FontB(Font2), @"时间"]);
        NSString* timeStr = (isNullStr(self.value) ? @"" : [self.value componentsSeparatedByString:@" "][1]);
        UITextField* textTime = newTextField(self.view, @[@(TAG_TIME_VLU), RECT_OBJ(60, textDate.ey+15, APP_W-75, 30), RGB(0x000000), Font(Font3), format(@"请输入%@", self.title), timeStr]);
        textTime.backgroundColor = RGB(0xffffff);
        textTime.layer.borderWidth = 0.5;
        textTime.layer.borderColor = RGB(0x999999).CGColor;
        textTime.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, textTime.fh)];
        textTime.leftViewMode = UITextFieldViewModeAlways;
        
        [self initDatePickers];
    } else if (self.type == INPUT_MEMO) {
        UITextView* textView = newTextView(self.view, @[@50, RECT_OBJ(15, lbtitle.ey+15, APP_W-30, 100), RGB(0x000000), Font(Font3), self.value]);
        textView.backgroundColor = RGB(0xffffff);
        textView.layer.borderWidth = 0.5;
        textView.layer.borderColor = RGB(0x999999).CGColor;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(initTimePickers) withObject:nil afterDelay:2];
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
                    tagViewEx(self.view, TAG_DATE_VLU, UITextField).text = strDate;
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
                    NSString* strDate = date2str(((UIDatePicker*)m_timePicker1.contentView).date, @"HH:mm");
                    tagViewEx(self.view, TAG_TIME_VLU, UITextField).text = strDate;
                }
            };
        }
    }];
}

- (void)onCheckBtnTouched:(id)sender
{
    if ((self.type == INPUT_TEXT) || (self.type == INPUT_NUMBER)) {
        self.targetLabel.text = tagViewEx(self.view, 50, UITextField).text;
        [self.parentVC changeSubTask:self.dataRow[@"subTaskId"] Key:STK_CT Value:self.targetLabel.text];
    } else if (self.type == INPUT_DATE_TIME) {
        self.targetLabel.text = format(@"%@ %@", tagViewEx(self.view, TAG_DATE_VLU, UITextField).text,
                                       tagViewEx(self.view, TAG_TIME_VLU, UITextField).text);
        [self.parentVC changeSubTask:self.dataRow[@"subTaskId"] Key:STK_CT Value:self.targetLabel.text];
    } else if (self.type == INPUT_MEMO) {
        self.dataRow[@"remark"] = tagViewEx(self.view, 50, UITextView).text;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (self.type == INPUT_DATE_TIME) {
        if (textField.tag == TAG_DATE_VLU) {
            [m_datePicker1 show];
        } else if (textField.tag == TAG_TIME_VLU) {
            [m_timePicker1 show];
        }
        return NO;
    }
    return YES;
}

//view, title, value, blocker;
+(void)show:(NSArray*)params
{
    TaskWirelessDetail* parentVC = (TaskWirelessDetail*)getViewController( params[0]);
    
    TaskWirelessInputText* vc = [[TaskWirelessInputText alloc] init];
    [parentVC.navigationController pushViewController:vc animated:YES];
    vc.parentVC = parentVC;
    vc.dataRow = params[1];
    vc.targetLabel = params[2];
    vc.type = [params[3] intValue];
    
    vc.title = vc.dataRow[@"subTaskName"];
    vc.value = (vc.type == INPUT_MEMO ? vc.dataRow[@"remark"] : vc.dataRow[@"result"]);

    [vc release];
}

@end
