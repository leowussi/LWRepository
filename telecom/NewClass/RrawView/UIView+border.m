//
//  UIView+border.m
//  Hiking
//
//  Created by benny on 13-11-26.
//  Copyright (c) 2013年 augmentum. All rights reserved.
//

#import "UIView+border.h"
#import "QuartzCore/QuartzCore.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]

@implementation UIView (border)
- (void)border
{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColorFromRGB(0xcccccc) CGColor];
}

- (void)circularBead
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
}

- (void)border:(float)width
{
    self.layer.borderWidth = width;
    self.layer.borderColor = [UIColorFromRGB(0xcccccc) CGColor];
}

- (void)circularBead:(float)width
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = width;
}

- (void)rightBorder:(float)width
{
    CALayer *rightBorder = [CALayer layer];
    rightBorder.frame = CGRectMake(self.frame.size.width, 0.0f, width, self.frame.size.height);
    rightBorder.backgroundColor = [UIColorFromRGB(0xcccccc) CGColor];
    [self.layer addSublayer:rightBorder];
}

- (void)leftBorder:(float)width
{
    CALayer *leftBorder = [CALayer layer];
    leftBorder.frame = CGRectMake(0.0f, 0.0f, width, self.frame.size.height);
    leftBorder.backgroundColor = [UIColorFromRGB(0xcccccc) CGColor];
    [self.layer addSublayer:leftBorder];
}

- (void)bottomBorder:(float)width
{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height, self.frame.size.width, width);
    bottomBorder.backgroundColor = [UIColorFromRGB(0xcccccc) CGColor];
    [self.layer addSublayer:bottomBorder];
}

- (void)circular
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width/2;
}

- (void)circularBeadColor:(UIColor *)color
{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1.5;
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = [color CGColor];
}
@end
