//
//  ReasonController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/23.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReasonController;
@protocol ReasonControllerDelegate <NSObject>

-(void)reasonController:(ReasonController*) ctrl reasonString :(NSString *)reasonString;

@end

@interface ReasonController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic,copy) NSString *reasonString ;

@property (nonatomic,assign) id<ReasonControllerDelegate> delegate;

@end
