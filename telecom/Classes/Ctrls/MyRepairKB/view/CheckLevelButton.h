//
//  CheckLevelButton.h
//  telecom
//
//  Created by liuyong on 15/8/25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckLevelButton : UIButton
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName target:(id)target action:(SEL)action;
@end
