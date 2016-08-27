//
//  OptionView.h
//  telecom
//
//  Created by liuyong on 15/8/3.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OptionViewDelegate <NSObject>
- (void)deliverFixReason:(NSString *)fixReasonString;
@end


@interface OptionView : UIView
@property(nonatomic,weak)id <OptionViewDelegate> delegate;
@property (nonatomic, strong) UILabel *titleLabel;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;
- (void)loadFixReasonsDataWithURL:(NSString *)url parameter:(NSString *)para functionId:(NSString *)functionId;

@end
