//
//  CheckLevelButton.m
//  telecom
//
//  Created by liuyong on 15/8/25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "CheckLevelButton.h"

@implementation CheckLevelButton

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action
{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitle:title forState:UIControlStateNormal];
        
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
        
        [self addTarget:target action:action forControlEvents:UIControlEventTouchDown];
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        self.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return RECT(0, 2, contentRect.size.width, contentRect.size.height*0.6-2);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return RECT(0,contentRect.size.height*0.6, contentRect.size.width, contentRect.size.height*0.4);
}

- (void)setHighlighted:(BOOL)highlighted
{}

@end
