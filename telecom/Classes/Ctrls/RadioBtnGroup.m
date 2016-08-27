//
//  RadioBtnGroup.m
//  telecom
//
//  Created by ZhongYun on 15-4-14.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "RadioBtnGroup.h"

#define RB_W   16

@interface RadioBtnGroup ()
{
    UIButtonEx* btn1;
    UIImageView* btn1Img;
    UIButtonEx* btn2;
    UIImageView* btn2Img;
    UIButtonEx* btn3;
    UIImageView* btn3Img;
}
@end

@implementation RadioBtnGroup

- (void)dealloc
{
    [btn1Img release];
    [btn2Img release];
    [btn3Img release];
    [btn1 release];
    [btn2 release];
    [btn3 release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        btn1 = [[UIButtonEx alloc] initWithFrame:RECT(0, 0, RB_W+Font3+6, self.fh)];
        btn1.clipsToBounds = YES;
        //btn1.layer.borderColor = RGB(0x666666).CGColor;
        //btn1.layer.borderWidth = 0.5;
        btn1.titleLabel.font = Font(Font3);
        [btn1 setTitle:@"无" forState:0];
        [btn1 setTitleColor:RGB(0x000000) forState:0];
        btn1.contentEdgeInsets = UIEdgeInsetsMake(0, RB_W, 0, 0);
        btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn1 addTarget:self action:@selector(onBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn1];
        
        btn1Img = [[UIImageView alloc] initWithFrame:RECT(0, (self.fh-RB_W)/2, RB_W, RB_W)];
        btn1Img.image = [UIImage imageNamed:@"rb_normal.png"];
        [btn1 addSubview:btn1Img];
        btn1.info = btn1Img;
        
        btn2 = [[UIButtonEx alloc] initWithFrame:RECT(btn1.ex, 0, RB_W+Font3*2+6, self.fh)];
        btn2.clipsToBounds = YES;
        //btn2.layer.borderColor = RGB(0x666666).CGColor;
        //btn2.layer.borderWidth = 0.5;
        btn2.titleLabel.font = Font(Font3);
        [btn2 setTitle:@"1" forState:0];
        [btn2 setTitleColor:RGB(0x000000) forState:0];
        btn2.contentEdgeInsets = UIEdgeInsetsMake(0, RB_W, 0, 0);
        btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn2 addTarget:self action:@selector(onBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn2];
        
        btn2Img = [[UIImageView alloc] initWithFrame:btn1Img.frame];
        btn2Img.image = [UIImage imageNamed:@"rb_normal.png"];
        [btn2 addSubview:btn2Img];
        btn2.info = btn2Img;
        
        btn3 = [[UIButtonEx alloc] initWithFrame:RECT(btn2.ex, 0, RB_W+Font3*3+6, self.fh)];
        btn3.clipsToBounds = YES;
        //btn3.layer.borderColor = RGB(0x666666).CGColor;
        //btn3.layer.borderWidth = 0.5;
        btn3.titleLabel.font = Font(Font3);
        [btn3 setTitle:@"2" forState:0];
        [btn3 setTitleColor:RGB(0x000000) forState:0];
        btn3.contentEdgeInsets = UIEdgeInsetsMake(0, RB_W, 0, 0);
        btn3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn3 addTarget:self action:@selector(onBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn3];
        
        btn3Img = [[UIImageView alloc] initWithFrame:btn1Img.frame];
        btn3Img.image = [UIImage imageNamed:@"rb_normal.png"];
        [btn3 addSubview:btn3Img];
        btn3.info = btn3Img;
        
        
        self.fw = btn3.ex+2;
    }
    return self;
}

- (void)setWriteType:(NSString *)writeType
{
    _writeType = [writeType copy];
    NSArray* txtList = [writeType componentsSeparatedByString:@"/"];
    [btn2 setTitle:txtList[0] forState:0];
    [btn3 setTitle:txtList[1] forState:0];
}

- (void)setCurrValue:(NSString *)currValue
{
    _currValue = [currValue copy];
    if ([currValue isEqualToString:btn1.titleLabel.text]) {
        [self onBtnTouched:btn1];
    } else if ([currValue isEqualToString:btn2.titleLabel.text]) {
        [self onBtnTouched:btn2];
    } else if ([currValue isEqualToString:btn3.titleLabel.text]) {
        [self onBtnTouched:btn3];
    }
    
    
}

- (void)onBtnTouched:(UIButtonEx*)sender
{
    ((UIImageView*)sender.info).image = [UIImage imageNamed:@"rb_checked.png"];
    if (sender != btn1) {
        ((UIImageView*)btn1.info).image = [UIImage imageNamed:@"rb_normal.png"];
    }
    if (sender != btn2) {
        ((UIImageView*)btn2.info).image = [UIImage imageNamed:@"rb_normal.png"];
    }
    if (sender != btn3) {
        ((UIImageView*)btn3.info).image = [UIImage imageNamed:@"rb_normal.png"];
    }
    
    if (self.changeBlock) {
        self.changeBlock(sender.titleLabel.text);
    }
}

@end
