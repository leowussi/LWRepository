//
//  MapBackView.h
//  telecom
//
//  Created by 郝威斌 on 15/5/25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol mapBtndelegate <NSObject>

- (void)mapBtn:(NSInteger)index;

@end

@interface MapBackView : UIView

@property(assign,nonatomic)id<mapBtndelegate>delegate;

@property(strong,nonatomic)UILabel *numLabel;
@property(strong,nonatomic)UILabel *label;

- (id)initWithFrame:(CGRect)frame withImageArr:(NSArray*)imageArr withTitleArr:(NSArray*)titleArr;

@end
