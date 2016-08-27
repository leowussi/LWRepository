//
//  UIView+border.h
//  Hiking
//
//  Created by benny on 13-11-26.
//  Copyright (c) 2013年 augmentum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (border)
- (void)border;
- (void)circularBead;
- (void)circularBead:(float)width;
- (void)border:(float)width;
- (void)rightBorder:(float)width;
- (void)leftBorder:(float)width;
- (void)bottomBorder:(float)width;
- (void)circular;
- (void)circularBeadColor:(UIColor *)color;
@end
