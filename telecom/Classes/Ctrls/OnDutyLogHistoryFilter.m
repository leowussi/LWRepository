//
//  OnDutyLogHistoryFilter.m
//  telecom
//
//  Created by ZhongYun on 14-8-27.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "OnDutyLogHistoryFilter.h"
#import "CompAlertBox.h"
#import "NSThread+Blocks.h"
#import "FilterCompSelect.h"

#define ROW_H   50
@interface OnDutyLogHistoryFilter ()
{
    UIButton* m_checkBtn;
    NSInteger* m_selectedIndex;
    AlertBox* m_datePicker1;
    AlertBox* m_datePicker2;
    NSMutableArray* m_bodys;
    NSMutableArray* m_selected;
}
@end

@implementation OnDutyLogHistoryFilter

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"值班日志历史记录";
    self.view.backgroundColor = [UIColor whiteColor];
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    m_checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
                                                      (NAV_H-checkIcon.size.height)/2,
                                                      checkIcon.size.width, checkIcon.size.height)];
    [m_checkBtn setBackgroundImage:checkIcon forState:0];
    [m_checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:m_checkBtn];
//    [self.navBarView addSubview:m_checkBtn];
    
    
    m_selectedIndex = 0;
    
    CGFloat pos_y = 64 + 10;
    UIButton* btn1 = [[UIButton alloc] initWithFrame:RECT(10, pos_y, APP_W-20, ROW_H)];
    btn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn1.layer.borderWidth = 0.5;
    [btn1 addTarget:self action:@selector(onBtn1Touched:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundImage:color2Image([UIColor whiteColor]) forState:UIControlStateNormal];
    [btn1 setBackgroundImage:color2Image(RGB(0xF0F0F0)) forState:UIControlStateHighlighted];
    btn1.tag = 50;
    [self.view addSubview:btn1];
    
    newImageView(btn1, @[@(51), @"rb_checked.png", RECT_OBJ(15, (ROW_H-18)/2, 18, 18)]);
    newLabel(btn1, @[@52, RECT_OBJ(50, (ROW_H-Font2)/2, 100, Font2), [UIColor blackColor], Font(Font2), @"全部日期"]);
    
    pos_y += (ROW_H-0.5);
    UIButton* btn2 = [[UIButton alloc] initWithFrame:RECT(10, pos_y, APP_W-20, ROW_H)];
    btn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn2.layer.borderWidth = 0.5;
    [btn2 addTarget:self action:@selector(onBtn2Touched:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setBackgroundImage:color2Image([UIColor whiteColor]) forState:UIControlStateNormal];
    [btn2 setBackgroundImage:color2Image(RGB(0xF0F0F0)) forState:UIControlStateHighlighted];
    btn2.tag = 60;
    [self.view addSubview:btn2];
    
    newImageView(btn2, @[@(61), @"rb_normal.png", RECT_OBJ(15, (ROW_H-18)/2, 18, 18)]);
    newLabel(btn2, @[@62, RECT_OBJ(50, (ROW_H-Font2)/2, 100, Font2), [UIColor blackColor], Font(Font2), @"选择日期范围"]);

    
    pos_y += (ROW_H-0.5);
    UIButton* btn3 = [[UIButton alloc] initWithFrame:RECT(10, pos_y, APP_W-20, ROW_H)];
    btn3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn3.layer.borderWidth = 0.5;
    btn3.backgroundColor = [UIColor whiteColor];
    btn3.tag = 70;
    btn3.hidden = YES;
    [btn3 addTarget:self action:@selector(onNextBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [btn3 setBackgroundImage:color2Image([UIColor whiteColor]) forState:UIControlStateNormal];
    [btn3 setBackgroundImage:color2Image(RGB(0xF0F0F0)) forState:UIControlStateHighlighted];
    [self.view addSubview:btn3];
    
    newLabel(btn3, @[@71, RECT_OBJ(50, (ROW_H-Font2)/2, 75, Font2), [UIColor blackColor], Font(Font2), @"开始日期"]);
    newImageView(btn3, @[@(72), @"arrow_right.png", RECT_OBJ(btn3.fw-18, (btn3.fh-14)/2, 8, 14)]);
    newTextField(btn3, @[@73, RECT_OBJ(125, 1, APP_W-125-45, ROW_H-2), [UIColor blackColor], Font(Font3), @"请选择开始日期", @""]).enabled = NO;
    tagViewEx(btn3, 73, UITextField).text = date2str([NSDate date], DATE_FORMAT);
    
    
    pos_y += (ROW_H-0.5);
    UIButton* btn4 = [[UIButton alloc] initWithFrame:RECT(10, pos_y, APP_W-20, ROW_H)];
    btn4.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn4.layer.borderWidth = 0.5;
    btn4.backgroundColor = [UIColor whiteColor];
    btn4.tag = 80;
    btn4.hidden = YES;
    [btn4 addTarget:self action:@selector(onNextBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [btn4 setBackgroundImage:color2Image([UIColor whiteColor]) forState:UIControlStateNormal];
    [btn4 setBackgroundImage:color2Image(RGB(0xF0F0F0)) forState:UIControlStateHighlighted];
    [self.view addSubview:btn4];
    
    newLabel(btn4, @[@81, RECT_OBJ(50, (ROW_H-Font2)/2, 75, Font2), [UIColor blackColor], Font(Font2), @"结束日期"]);
    newImageView(btn4, @[@(82), @"arrow_right.png", RECT_OBJ(btn4.fw-18, (btn4.fh-14)/2, 8, 14)]);
    newTextField(btn4, @[@83, RECT_OBJ(125, 1, APP_W-125-45, ROW_H-2), [UIColor blackColor], Font(Font3), @"请选择结束日期", @""]).enabled = NO;
    tagViewEx(btn4, 83, UITextField).text = date2str([NSDate date], DATE_FORMAT);
    
    
    pos_y = (btn2.ey + 10);
    UIButton* btn5 = [[UIButton alloc] initWithFrame:RECT(10, pos_y, APP_W-20, ROW_H)];
    btn5.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn5.layer.borderWidth = 0.5;
    btn5.backgroundColor = [UIColor whiteColor];
    btn5.tag = 90;
    [btn5 addTarget:self action:@selector(onNextBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [btn5 setBackgroundImage:color2Image([UIColor whiteColor]) forState:UIControlStateNormal];
    [btn5 setBackgroundImage:color2Image(RGB(0xF0F0F0)) forState:UIControlStateHighlighted];
    [self.view addSubview:btn5];
    
    newLabel(btn5, @[@91, RECT_OBJ(15, (ROW_H-Font2)/2, 75, Font2), [UIColor blackColor], Font(Font2), @"值班人员"]);
    newImageView(btn5, @[@(92), @"arrow_right.png", RECT_OBJ(btn5.fw-18, (btn5.fh-14)/2, 8, 14)]);
    newTextField(btn5, @[@93, RECT_OBJ(90, 1, APP_W-90-45, ROW_H-2), [UIColor blackColor], Font(Font3), @"请选择值班人员", @""]).enabled = NO;
    
    [btn1 release];
    [btn2 release];
    [btn3 release];
    [btn4 release];
    [btn5 release];
    
    [self initDatePickers];
}

- (void)setBodys:(NSArray *)bodys
{
    _bodys = [bodys retain];
    if (m_bodys == nil) {
        m_bodys = [bodys mutableCopy];
        m_selected = [[NSMutableArray alloc] init];
    }
}

- (void)onCheckBtnTouched:(id)sender
{
    NSMutableDictionary* info = [NSMutableDictionary dictionary];
    info[@"dateType"] = (tagView(self.view, 70).hidden ? @1 : @2);
    if (!tagView(self.view, 70).hidden) {
        info[@"dateBegin"] = tagViewEx(self.view, 73, UITextField).text;
        info[@"dateEnd"] = tagViewEx(self.view, 83, UITextField).text;
    }
    if (tagViewEx(self.view, 93, UITextField).text.length > 0) {
        info[@"body"] = tagViewEx(self.view, 93, UITextField).text;
    }
    NOTIF_POST(LOG_FILTER_OVER, info);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onBtn1Touched:(id)sender
{
    tagViewEx(self.view, 51, UIImageView).image = [UIImage imageNamed:@"rb_checked.png"];
    tagViewEx(self.view, 61, UIImageView).image = [UIImage imageNamed:@"rb_normal.png"];
    
    tagView(self.view, 70).hidden = YES;
    tagView(self.view, 80).hidden = YES;
    
    tagView(self.view, 90).fy = tagView(self.view, 60).ey + 10;
}

- (void)onBtn2Touched:(id)sender
{
    tagViewEx(self.view, 51, UIImageView).image = [UIImage imageNamed:@"rb_normal.png"];
    tagViewEx(self.view, 61, UIImageView).image = [UIImage imageNamed:@"rb_checked.png"];
    
    tagView(self.view, 70).hidden = NO;
    tagView(self.view, 80).hidden = NO;
    
    tagView(self.view, 90).fy = tagView(self.view, 80).ey + 10;
}

- (void)onNextBtnTouched:(UIButton*)sender
{
    if (sender.tag == 70)
        [m_datePicker1 show];

    if (sender.tag == 80)
        [m_datePicker2 show];
    
    if (sender.tag == 90) {
        FilterCompSelect* vc = [[FilterCompSelect alloc] init];
        vc.multiModule = YES;
        vc.multiSelected = m_selected;
        vc.data = m_bodys;
        vc.idKey = @"ID";
        vc.nameKey = @"NAME";
        vc.respMultiBlock = ^(id selected){
            m_selected = [selected mutableCopy];
            
            NSMutableArray* tmplist = [NSMutableArray array];
            for (id index in m_selected) {
                [tmplist addObject:m_bodys[[index intValue]][@"NAME"]];
            }
            tagViewEx(self.view, 93, UITextField).text = [tmplist componentsJoinedByString:@","];
        };
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}


- (void)initDatePickers
{
    [NSThread performBlockOnMainThread:^{
        if (!m_datePicker1) {
            m_datePicker1 = newDatePickerBox();
            ((UIDatePicker*)m_datePicker1.contentView).minimumDate = nil;
            ((UIDatePicker*)m_datePicker1.contentView).maximumDate = [NSDate date];
            [self.view addSubview:m_datePicker1];
            m_datePicker1.respBlock = ^(int index) {
                if (index == BTN_OK) {
                    NSString* strDate = date2str(((UIDatePicker*)m_datePicker1.contentView).date, DATE_FORMAT);
                    tagViewEx(self.view, 73, UITextField).text = strDate;
                }
            };
        }
        
        if (!m_datePicker2) {
            m_datePicker2 = newDatePickerBox();
            //((UIDatePicker*)m_datePicker2.contentView).minimumDate = nil;
            //((UIDatePicker*)m_datePicker2.contentView).maximumDate = [NSDate date];
            [self.view addSubview:m_datePicker2];
            m_datePicker2.respBlock = ^(int index) {
                if (index == BTN_OK) {
                    NSString* strDate = date2str(((UIDatePicker*)m_datePicker2.contentView).date, DATE_FORMAT);
                    tagViewEx(self.view, 83, UITextField).text = strDate;
                }
            };
        }
    }];
}

@end
