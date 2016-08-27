//
//  UILabel+caculateSize.h
//  tubu
//
//  Created by benny on 14-7-7.
//  Copyright (c) 2014年 augmentum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (caculateSize)
- (CGSize)caculateSizeWithString;
- (double)getTextHeight;
- (double)getTextWidth;
@end
