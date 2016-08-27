//
//  TopTypeBarView.m
//  telecom
//
//  Created by 郝威斌 on 15/9/9.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "TopTypeBarView.h"

#define BTN_W           80
#define COMM_COLOR      COLOR(125, 125, 125)

@interface TopTypeBarView ()<UIScrollViewDelegate>
{
    UIScrollView *myScroll;
    UIView* m_side;
    CGFloat m_btnWidth;
    float scroll_Y;
}
@end


@implementation TopTypeBarView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        myScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        myScroll.pagingEnabled = NO; //自动滚动到subview的边界
//        m_scroll.bounces = NO; //拖动超出范围
        myScroll.showsHorizontalScrollIndicator = NO;
        myScroll.userInteractionEnabled = YES;
        myScroll.delegate = self;
        
        [self addSubview:myScroll];
        
        UIView* border = [[UIView alloc] initWithFrame:RECT(0, self.fh-0.5, self.fw, 0.5)];
        border.backgroundColor = COLOR(207, 207, 207);
        [self addSubview:border];
        
        m_btnWidth = BTN_W;
        m_side = [[UIView alloc] initWithFrame:RECT(0, self.fh-2, m_btnWidth, 2)];
        m_side.backgroundColor = APP_COLOR;
        m_side.hidden = YES;
        [myScroll addSubview:m_side];
        
        
        _selected = -1;
    }
    return self;
}


- (void)setButtonWidth:(NSInteger)buttonWidth
{
    _buttonWidth = buttonWidth;
    m_btnWidth = buttonWidth;
    m_side.fw = buttonWidth;
}

- (void)setTypeList:(NSArray *)typeList
{
    _typeList = (NSMutableArray *)typeList;
    
//    if (typeList.count < 4) {
//        m_btnWidth = APP_W/typeList.count;
//        m_side.fw = m_btnWidth;
//    } else if (typeList.count > 4) {
//        m_btnWidth -= 20;
//    }
    m_btnWidth = APP_W/_typeList.count;
    m_side.fw = m_btnWidth;
    
    myScroll.contentSize = CGSizeMake(self.typeList.count*m_btnWidth+20, 40);
    
    CGFloat btn_x = 0, btn_w = 0;
    for (int i=0; i<self.typeList.count; i++) {
        btn_w = m_btnWidth;
        if (self.isWireless) {
            CGSize txtSize = getTextSize(self.typeList[i][@"speciltyName"], FontB(13), APP_W);
            btn_w = MAX(m_btnWidth, txtSize.width+10);
        }
        
        UIButton* btn = [[UIButton alloc] initWithFrame:RECT(btn_x, 0, btn_w, self.fh)];
        btn.backgroundColor = [UIColor clearColor];
        btn.tag = 100+i;
        [btn setTitle:self.typeList[i][@"speciltyName"] forState:0];
        [btn setTitleColor:COMM_COLOR forState:0];
        btn.titleLabel.font = FontB(13);
        [btn addTarget:self action:@selector(onBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        //btn.layer.borderWidth = 0.5;
        btn.clipsToBounds = YES;
        [myScroll addSubview:btn];
//        [self addCirclePointView:btn Index:i];
        
        btn_x += btn_w;
    }
    
    if (self.isWireless) {
        scroll_Y = btn_x;
        myScroll.contentSize = CGSizeMake(btn_x, 40);
        myScroll.contentOffset = CGPointMake(0, 0);
        
    }
    
    if (self.typeList.count > 0) {
        self.selected = 0;
    }
}

- (void)addCirclePointView:(UIButton*)view Index:(NSInteger)index
{
    CGFloat pw = 14, edge=4;
    CGSize titleSize = getTextSize(view.titleLabel.text, FontB(13), view.fw);
    CGFloat x = (view.fw-titleSize.width)/2 + titleSize.width + 2;
    //CGFloat x = (view.fw - edge - pw);
    UIView* point = [[UIView alloc] initWithFrame:RECT(x, edge, pw, pw)];
    point.hidden = ([self.typeList[index][@"taskAmount"] intValue] == 0);
    point.tag = 10049;
    point.alpha = 0.5;
    point.layer.cornerRadius = point.fh/2;
    point.backgroundColor = [UIColor redColor];
    [view addSubview:point];
    
    NSString* txtv = format(@"%@", self.typeList[index][@"taskAmount"]);
    newLabel(point, @[@10050, RECT_OBJ(0, 0, point.fw, point.fh), [UIColor whiteColor], FontB(8), txtv]).textAlignment = NSTextAlignmentCenter;
}

- (void)onBtnTouched:(UIButton*)sender
{
    self.selected = (sender.tag-100);
}

- (void)setSelected:(NSInteger)selected
{
    if (_selected == selected) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeBefore:)]) {
        [self.delegate changeBefore:self];
    }
    _selected = selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeAfter:)]) {
        [self.delegate changeAfter:self];
    }
    
    if (selected>=0 && selected<self.typeList.count) {
        m_side.hidden = NO;
        for (int i=0; i<self.typeList.count; i++) {
            [((UIButton*)[self viewWithTag:i+100]) setTitleColor:COMM_COLOR forState:0];
        }
        
        [((UIButton*)[self viewWithTag:selected+100]) setTitleColor:APP_COLOR forState:0];
        [UIView animateWithDuration:0.2 animations:^{
            m_side.fx = [self viewWithTag:selected+100].fx;
            m_side.fw = [self viewWithTag:selected+100].fw;
        }];
    } else {
        m_side.hidden = YES;
    }
    
}

- (void)updatePointStatus:(NSInteger)index Count:(NSInteger)count
{
    [self viewWithTag:10049].hidden = (count==0);
    id lbtitile = [self viewWithTag:10050];
    ((UILabel*)lbtitile).text = format(@"%d", count);
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
