//
//  AlerBox.m
//  telecom
//
//  Created by ZhongYun on 14-6-15.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "AlertBox.h"

#define AB_TITLE_H    44
#define AB_BTN_H      44

@interface AlertBox ()
@end

@implementation AlertBox

//- (void)dealloc
//{
//    [self.contentView release];
//    [super dealloc];
//}

- (id)initWithContentSize:(CGSize)contentSize Btns:(NSArray*)names
{
    CGFloat h = AB_TITLE_H + contentSize.height + AB_TITLE_H;
    self = [super initWithFrame:RECT(0, 0, SCREEN_W, SCREEN_H)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.hidden = YES;
        //self.contentView = view;
        
        UIView* bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [self addSubview:bgView];
        [bgView release];
        
        CGFloat box_y = (SCREEN_H-h)*0.4;
        UIView* boxView = [[UIView alloc] initWithFrame:RECT((APP_W-contentSize.width)/2, box_y, contentSize.width, h)];
        boxView.backgroundColor = COLOR(227, 227, 227);
        boxView.layer.cornerRadius = 5;
        boxView.clipsToBounds = YES;
        boxView.tag = 500;
        [self addSubview:boxView];
        
        newLabel(boxView, @[@(50), RECT_OBJ(0, 20, boxView.fw, Font2), [UIColor blackColor], FontB(Font2), @""]).textAlignment = NSTextAlignmentCenter;
        
        UIView* line = [[UIView alloc] initWithFrame:RECT(0, boxView.fh-AB_BTN_H, boxView.fw, 0.5)];
        line.backgroundColor = COLOR(179, 179, 179);
        [boxView addSubview:line];
        [line release];
        
        CGFloat btnw = boxView.fw/names.count;
        for (int i = 0; i < names.count; i++) {
            if (i > 0) {
                UIView* vl = [[UIView alloc] initWithFrame:RECT(btnw*i, boxView.fh-AB_BTN_H, 0.5, AB_BTN_H)];
                vl.backgroundColor = COLOR(179, 179, 179);
                [boxView addSubview:vl];
                [vl release];
            }
            
            UIButton* btn = [[UIButton alloc] initWithFrame:RECT(btnw*i, boxView.fh-AB_BTN_H, btnw, AB_BTN_H)];
            btn.backgroundColor = [UIColor clearColor];
            btn.tag = 2000 + i;
            [btn setTitle:names[i] forState:0];
            [btn setTitleColor:[UIColor blackColor] forState:0];
            btn.titleLabel.font = Font(Font2);
            [btn addTarget:self action:@selector(onBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [boxView addSubview:btn];
            [btn release];
        }
        
        [boxView release];
    }
    return self;
}

- (void)onBtnTouched:(UIButton*)sender
{
    NSInteger index = sender.tag - 2000;
    if (self.respBlock) {
        self.respBlock(index);
    }
    self.hidden = YES;
}

- (void)show
{
    self.hidden = NO;
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    tagViewEx(self, 50, UILabel).text = self.title;
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = [contentView retain];
    self.contentView.fy = AB_TITLE_H;
    [tagView(self, 500) addSubview:self.contentView];
}

@end
