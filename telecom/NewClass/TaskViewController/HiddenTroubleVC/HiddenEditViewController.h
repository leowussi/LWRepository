//
//  HiddenEditViewController.h
//  telecom
//
//  Created by 郝威斌 on 15/8/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@protocol hiddendelegate <NSObject>

- (void)popBtn:(NSInteger)index;

@end


@interface HiddenEditViewController : SXABaseViewController

@property(strong,nonatomic)NSString *strDangerId;
@property(strong,nonatomic)NSDictionary *dic;

@property(assign,nonatomic)id<hiddendelegate>delegate;

@end
