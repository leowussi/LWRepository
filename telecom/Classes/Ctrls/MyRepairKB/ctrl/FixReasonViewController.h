//
//  FixReasonViewController.h
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@protocol FixReasonViewControllerDelegate <NSObject>

- (void)deliverFixReason:(NSString *)fixReasonString;

@end

@interface FixReasonViewController : BaseViewController
@property(nonatomic,assign) id <FixReasonViewControllerDelegate>delegate;

@property (nonatomic,copy)NSString *functionId;
@property (nonatomic,copy)NSString *voiceContent;
@property(nonatomic,copy)NSString *spec;
@end
