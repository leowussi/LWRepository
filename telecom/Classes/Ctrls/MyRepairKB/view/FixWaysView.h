//
//  FixWaysView.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FixWaysViewDelegate <NSObject>

- (void)deliverFixWay:(NSString *)fixWay;

@end

@interface FixWaysView : UIView
@property(nonatomic,assign)id <FixWaysViewDelegate> delegate;
- (void)loadDataWithURL:(NSString *)urlString;

@end
