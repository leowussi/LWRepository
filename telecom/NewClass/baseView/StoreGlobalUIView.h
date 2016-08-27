//
//  CouponGlobalUIView.h
//  Coupon
//
//  Created by chenliang Fu on 14/1/8.
//  Copyright (c) 2014. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Store)

- (void)removeAllSubViews;

@end

@interface UINavigationBar (Store)
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
@end


@interface UINavigationController (Store) 


@end