//
//  FixWayView.h
//  telecom
//
//  Created by liuyong on 15/8/18.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FixWayViewDelegate <NSObject>
- (void)deliverFixWay:(NSString *)fixWayString;
@end

@interface FixWayView : UIView
@property(nonatomic,weak)id <FixWayViewDelegate> delegate;
- (void)loadFixWaysDataWithURL:(NSString *)urlString;
@end
