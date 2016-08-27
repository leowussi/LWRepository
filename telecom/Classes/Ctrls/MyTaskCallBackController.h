//
//  MyTaskCallBackController.h
//  telecom
//
//  Created by liuyong on 15/5/12.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface MyTaskCallBackController : BaseViewController
@property(nonatomic,strong)NSDictionary *callBackInfoDict;
@property(nonatomic,assign)BOOL isSecondaryTask;
@property (retain, nonatomic) IBOutlet UITextView *taskContent;
@property (retain, nonatomic) IBOutlet UITextView *findOutQuestion;
@property (retain, nonatomic) IBOutlet UITextView *finishedCount;
@property (retain, nonatomic) IBOutlet UITextView *handleQuestion;
@end
