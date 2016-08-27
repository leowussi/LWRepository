//
//  PullDownViewInAddRequest.m
//  telecom
//
//  Created by SD0025A on 16/5/30.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "PullDownViewInAddRequest.h"

@implementation PullDownViewInAddRequest
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.scroll = [[UIScrollView alloc] init];
        
        self.scroll.frame = CGRectMake(0, 0, self.frame.size.width,self.frame.size.height);
        self.scroll.bounces = NO;
        [self addSubview:self.scroll];
        
    }
    return self;
}
- (void)setLabelTitle
{
    
    
    for (int i = 0; i<self.titleArray.count; i++) {
        if (i == 0) {
            self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            self.leftImageView.image = [UIImage imageNamed:@"勾选"];
            [self.scroll addSubview:self.leftImageView];
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20*i, self.bounds.size.width-20, 20)];
        label.tag = 100+i;
        label.text = self.titleArray[i];
        label.font = [UIFont systemFontOfSize:11];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:tap];
        self.scroll.contentSize = CGSizeMake(self.frame.size.width, 20*self.titleArray.count+5);
        [self.scroll addSubview:label];
    }
    
}

- (void)tapLabel:(UITapGestureRecognizer*)ges
{
    int index = ges.view.tag - 100;
    self.currentIndex = index;
    UILabel *label = (UILabel *)ges.view;
    self.leftImageView.frame = CGRectMake(0, label.frame.origin.y, 20, 20);
    [self.titleBtn setTitle:self.titleArray[index] forState:UIControlStateNormal];
    self.hidden = YES;
}
@end
