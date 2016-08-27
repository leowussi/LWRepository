//
//  YZMenuView.h
//  Test
//
//  Created by 锋 on 16/7/22.
//  Copyright © 2016年 holden. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YZMenuViewDelegate;

@interface YZMenuView : UIView

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, weak) id<YZMenuViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)array;

@end

@protocol YZMenuViewDelegate <NSObject>

- (void)menuView:(YZMenuView *)menuView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end