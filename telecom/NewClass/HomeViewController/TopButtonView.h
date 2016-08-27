//
//  TopButtonView.h
//  JingRong360
//
//  Created by 锋 on 14-5-7.
//  Copyright (c) 2014年 qian.sundear. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol topBudelegate <NSObject>

- (void)topBtn:(NSInteger)index;

@end

@interface TopButtonView : UIView

@property(assign,nonatomic)id<topBudelegate>delegate;
@property(strong,nonatomic)UILabel *label;
- (id)initWithFrame:(CGRect)frame withImageArr:(NSArray*)imageArr withTitleArr:(NSArray*)titleArr;

@end
