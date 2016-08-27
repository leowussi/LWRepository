//
//  MidButtonView.h
//  i YunWei
//
//  Created by 郝威斌 on 15/5/6.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol midBtndelegate <NSObject>

- (void)midBtn:(NSInteger)index;

@end

@interface MidButtonView : UIView

@property(assign,nonatomic)id<midBtndelegate>delegate;

@property(strong,nonatomic)UILabel *numLabel;
@property(strong,nonatomic)UILabel *label;

- (id)initWithFrame:(CGRect)frame withImageArr:(NSArray*)imageArr withTitleArr:(NSArray*)titleArr withNumArr:(NSArray*)numArr;




@end
