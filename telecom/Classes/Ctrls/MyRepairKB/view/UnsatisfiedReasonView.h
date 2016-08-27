//
//  UnsatisfiedReasonView.h
//  telecom
//
//  Created by liuyong on 15/8/25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  UnsatisfiedReasonViewDelegate<NSObject>
- (void)deliverUnsatisfiedReasonChooseString:(NSString *)chooseString;
@end

@interface UnsatisfiedReasonView : UIView
@property(nonatomic,weak)id <UnsatisfiedReasonViewDelegate> delegate;
- (void)loadDataWithURL:(NSString *)urlString;
@end
