//
//  MemoInput.m
//  telecom
//
//  Created by ZhongYun on 15-4-15.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MemoInput.h"

#define BOX_H   150
#define BOX_W   270

@interface MemoInput ()<UITextViewDelegate>
{
    UITextView* m_textView;
}
@end

@implementation MemoInput

- (id)init
{
    if ( self = [super initWithFrame:RECT(0, 0, SCREEN_W, SCREEN_H)] )
    {
        UIView* bg = [[UIView alloc] initWithFrame:self.bounds];
        bg.backgroundColor = [UIColor blackColor];
        bg.alpha = 0.3;
        [self addSubview:bg];
        [bg release];
        
        UIView* box = [[UIView alloc] initWithFrame:RECT((SCREEN_W-BOX_W)/2, (SCREEN_H-BOX_H)/2, BOX_W, BOX_H)];
        box.backgroundColor = [UIColor whiteColor];
        box.layer.cornerRadius = 5;
        box.clipsToBounds = YES;
        [self addSubview:box];
        
        UILabel* title = newLabel(box, @[@20, RECT_OBJ(0, 18, box.fw, 26), RGB(0x000000), FontB(Font1), @"备注信息"]);
        title.textAlignment = NSTextAlignmentCenter;
        
        UIButton* btnNO = [[UIButton alloc] initWithFrame:RECT(0, box.fh-NAV_H, box.fw/2, NAV_H)];
        btnNO.titleLabel.font = Font(Font1);
        [btnNO setTitle:@"取消" forState:0];
        [btnNO setTitleColor:RGB(0x007aff) forState:0];
        [btnNO addTarget:self action:@selector(onBtnNoTouched:) forControlEvents:UIControlEventTouchUpInside];
        [box addSubview:btnNO];
        [btnNO release];
        
        UIButton* btnOK = [[UIButton alloc] initWithFrame:RECT(box.fw/2, box.fh-NAV_H, box.fw/2, NAV_H)];
        btnOK.titleLabel.font = FontB(Font1);
        [btnOK setTitle:@"确定" forState:0];
        [btnOK setTitleColor:RGB(0x007aff) forState:0];
        [btnOK addTarget:self action:@selector(onBtnOKTouched:) forControlEvents:UIControlEventTouchUpInside];
        [box addSubview:btnOK];
        [btnOK release];
        
        UIView* line1 = [[UIView alloc] initWithFrame:RECT(0, box.fh-NAV_H+0.5, box.fw, 0.5)];
        line1.backgroundColor = RGB(0xd7d7db);
        [box addSubview:line1];
        [line1 release];
        
        UIView* line2 = [[UIView alloc] initWithFrame:RECT(box.fw/2, box.fh-NAV_H, 0.5, NAV_H)];
        line2.backgroundColor = RGB(0xd7d7db);
        [box addSubview:line2];
        [line2 release];
        
        
        m_textView = newTextView(box, @[@21, RECT_OBJ(0, title.ey, box.fw, box.fh-title.ey-NAV_H+1), RGB(0x000000), Font(Font3), @"", @""]);
        m_textView.delegate = self;
        
        [box release];
    }
    return self;
}

- (void)onBtnNoTouched:(id)sender
{
    self.hidden = YES;
    self.removeFromSuperview;
}

- (void)onBtnOKTouched:(id)sender
{
    if (self.changeBlock) {
        self.changeBlock(m_textView.text);
    }
    
    self.hidden = YES;
    self.removeFromSuperview;
}

- (void)setCurrValue:(NSString *)currValue
{
    _currValue = [currValue copy];
    m_textView.text = self.currValue;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end

