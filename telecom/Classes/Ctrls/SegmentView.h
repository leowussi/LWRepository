//
//  SegmentView.h
//  telecom
//
//  Created by SD0025A on 16/3/31.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentViewDelegate <NSObject>

- (void)clickSegmentView:(UIButton *)btn;

@end
@interface SegmentView : UIView
@property (nonatomic,weak)id<SegmentViewDelegate>delegate;
@end
