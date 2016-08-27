//
//  OnDutyLogTemp.m
//  telecom
//
//  Created by ZhongYun on 14-8-19.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "OnDutyLogTemp.h"
#import "FilterCompSelect.h"

@interface OnDutyLogTemp ()<UITextFieldDelegate,UITextViewDelegate>
{
    NSInteger m_selected;
    UIScrollView *_bottomScrollView;
}
@end

@implementation OnDutyLogTemp


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"值班日志";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    m_selected = -1;
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:RECT(0, 64, APP_W, APP_H-44)];
    [self.view addSubview:_bottomScrollView];
    
    CGFloat top_y = 0, rowHeight = 34;
    newLabel(_bottomScrollView, @[@50, RECT_OBJ(10, top_y+10, 65, Font3), RGB(0x006cc3), FontB(Font3), @"值班模板"]);
    //    newTextF(_bottomScrollView, @[@51, RECT_OBJ(77, top_y+1, APP_W-5-75, rowHeight-2), [UIColor blackColor], Font(Font3), @"请选择值班模板", @""]);
    
    UITextField *filed = [[UITextField alloc] initWithFrame:CGRectMake(77, top_y+1, APP_W-5-75, rowHeight-2)];
    filed.placeholder = @"请选择值班模板";
    filed.font = [UIFont systemFontOfSize:14.0];
    filed.enabled = NO;
    filed.textAlignment = NSTextAlignmentLeft;
    [_bottomScrollView addSubview:filed];
    
    UIButton *tapBtn = [[UIButton alloc]initWithFrame:CGRectMake(77, top_y+1, APP_W-5-75, rowHeight-2)];
    tapBtn.backgroundColor = [UIColor clearColor];
    [tapBtn addTarget:self action:@selector(tapBtn) forControlEvents:UIControlEventTouchUpInside];
    [_bottomScrollView addSubview:tapBtn];
    
    
    newImageView(_bottomScrollView, @[@52, @"arrow_right.png", RECT_OBJ(APP_W-18, top_y+(rowHeight-14)/2, 8, 14)]);
    newTextView(_bottomScrollView, @[@53, RECT_OBJ(10, top_y+rowHeight, APP_W-20, SCREEN_H-top_y-rowHeight-10), [UIColor blackColor], Font(Font3), @""]).returnKeyType = UIReturnKeyDefault;
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* m_checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
                                                                (NAV_H-checkIcon.size.height)/2,
                                                                checkIcon.size.width, checkIcon.size.height)];
    [m_checkBtn setBackgroundImage:checkIcon forState:0];
    [m_checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:m_checkBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:NO];
    [super viewWillDisappear:animated];
}

- (void)onNavBackTouched:(id)sender
{
    [self.view endEditing:NO];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)onCheckBtnTouched:(id)sender
{
    [self.view endEditing:NO];
    if (tagViewEx(_bottomScrollView, 53, UITextView).text.length == 0) {
        showAlert(@"值班内容不能为空");
        return;
    }
    
    NSString* tmpStr = trim(tagViewEx(_bottomScrollView, 53, UITextView).text);
    if (tmpStr.length == 0) {
        showAlert(@"值班内容不能为空");
        return;
    }
    
    
    if (self.respBlock) {
        NSDictionary* resp = @{@"selected":@(m_selected),
                               @"text":tagViewEx(_bottomScrollView, 53, UITextView).text};
        self.respBlock(resp);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateModelText
{
    NSString* modelId = self.data[m_selected][@"ID"];
    httpGET1(@{URL_TYPE:NW_ZbLogContent, @"modelId":modelId}, ^(id result) {
        tagViewEx(_bottomScrollView, 53, UITextView).text = result[@"detail"][@"modelContent"];
    });
}

- (void)setDefIndex:(NSInteger)defIndex
{
    m_selected = defIndex;
    if (m_selected >= 0) {
        tagViewEx(_bottomScrollView, 51, UITextField).text = self.data[m_selected][@"NAME"];
    }
}

- (void)setDefText:(NSString *)defText
{
    tagViewEx(_bottomScrollView, 53, UITextView).text = defText;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.view endEditing:NO];
    FilterCompSelect* vc = [[FilterCompSelect alloc] init];
    vc.selected = m_selected;
    vc.data = self.data;
    vc.idKey = @"ID";
    vc.nameKey = @"NAME";
    vc.respBlock = ^(NSInteger selected){
        m_selected = selected;
        tagViewEx(_bottomScrollView, 51, UITextField).text = self.data[selected][@"NAME"];
        mainThread(updateModelText, nil);
        
    };
    [self.navigationController pushViewController:vc animated:YES];
    
    return NO;
}

-(void)tapBtn
{
    [self.view endEditing:NO];
    FilterCompSelect* vc = [[FilterCompSelect alloc] init];
    vc.selected = m_selected;
    vc.data = self.data;
    vc.idKey = @"ID";
    vc.nameKey = @"NAME";
    vc.respBlock = ^(NSInteger selected){
        m_selected = selected;
        tagViewEx(_bottomScrollView, 51, UITextField).text = self.data[selected][@"NAME"];
        mainThread(updateModelText, nil);
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.contentSize.width, APP_H+300);
    return YES;
}

@end
