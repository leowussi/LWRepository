//
//  DifferentPanelsView.h
//  TestScrollPanel
//
//  Created by liuyong on 15/6/16.
//  Copyright (c) 2015年 liuyong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DifferentPanelsViewDelegate <NSObject>

- (void)switchPanelFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface DifferentPanelsView : UIScrollView
@property(nonatomic,weak)id <DifferentPanelsViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSMutableArray *)dataArray;
@end
