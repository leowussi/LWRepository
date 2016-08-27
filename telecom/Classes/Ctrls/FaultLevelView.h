//
//  FaultLevelView.h
//  telecom
//
//  Created by liuyong on 15/12/3.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FaultLevelViewDelegate <NSObject>
- (void)deliverFaultLevel:(NSString *)faultLevel faultLevelId:(NSString *)faultLevelId;
@end

@interface FaultLevelView : UIView
@property(nonatomic,weak)id <FaultLevelViewDelegate> delegate;
- (void)loadDataWithURL:(NSString *)urlStr;
@end
