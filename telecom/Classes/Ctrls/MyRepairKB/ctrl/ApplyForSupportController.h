//
//  ApplyForSupportController.h
//  telecom
//
//  Created by liuyong on 15/8/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyForSupportController : UIViewController
@property (nonatomic,copy)NSString *workNum;//workNum
@property (nonatomic,copy)NSString *orderNo;//orderNo
@property (strong, nonatomic) IBOutlet UILabel *workNumLabel;
@property (strong, nonatomic) IBOutlet UITextView *descTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *attachmentScrollView;
@end
