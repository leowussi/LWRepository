//
//  YZMenuView.m
//  Test
//
//  Created by 锋 on 16/7/22.
//  Copyright © 2016年 holden. All rights reserved.
//

#import "YZMenuView.h"

@implementation YZMenuView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)array
{
    frame.size.height = array.count * 40;
    self = [super initWithFrame:frame];
    if (self) {
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 40 * idx, self.frame.size.width, 40);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitle:obj forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = idx + 1;
            button.backgroundColor = [UIColor colorWithRed:231 green:231 blue:231 alpha:1];
            [self addSubview:button];
            
            
        }];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.layer.shadowOpacity = .3f;
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender
{
    [_delegate menuView:self clickedButtonAtIndex:sender.tag];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
