//
//  NewsView.h
//  gonggao
//
//  Created by liuyong on 16/3/5.
//  Copyright © 2016年 Sundear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsView : UIView
- (instancetype)initWithFrame:(CGRect)frame news:(NSArray *)news;
- (void)showNewsInfo;
@end
