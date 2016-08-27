//
//  BaseScrollView.h
//  ShanXiApple
//
//  Created by chenliang on 14-1-8.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseScrollView : UIScrollView{
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
    CGSize          _originalContentSize;
    CGFloat         _currentPointY;
}
- (void)adjustOffsetToIdealIfNeeded;
@end
