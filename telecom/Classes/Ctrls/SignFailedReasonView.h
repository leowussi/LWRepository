//
//  SignFailedReasonView.h
//  telecom
//
//  Created by ZhongYun on 15-3-21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignFailedReasonView : UIView
@property (nonatomic,copy)void(^respBlock)(NSDictionary* reason, NSString* desc);
@end

@interface SignFailedReason : NSObject
@property (nonatomic,copy)NSString* regionId;
@property (nonatomic,copy)void(^signOverBlock)(BOOL isSuccess);
- (void)showDialog:(UIViewController*)viewCtrl;
@end