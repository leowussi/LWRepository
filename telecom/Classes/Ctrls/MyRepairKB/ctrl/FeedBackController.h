//
//  FeedBackViewController.h
//  telecom
//
//  Created by liuyong on 15/7/31.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@interface FeedBackController : SXABaseViewController

@property (nonatomic,copy)NSString *workNum;
@property (nonatomic,copy)NSString *orderNum;

@property (strong, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *candlePersonLabel;
@property (strong, nonatomic) IBOutlet UITextView *descInfoText;
@end
