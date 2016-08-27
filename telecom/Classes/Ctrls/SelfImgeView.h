//
//  SelfImgeView.h
//  telecom
//
//  Created by SD0025A on 16/4/21.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SelfImgeView;
@protocol DeleteBtnInImageViewDelegate <NSObject>

- (void)deleteBtnInImageView:(SelfImgeView *)imgeView;

@end
@interface SelfImgeView : UIImageView
@property (nonatomic,weak) id<DeleteBtnInImageViewDelegate> delegate;
@end
