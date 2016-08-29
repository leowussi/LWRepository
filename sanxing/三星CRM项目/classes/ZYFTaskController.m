//
//  ZYFTaskController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/20.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "ZYFTaskController.h"
#import "CRMHelper.h"

@interface ZYFTaskController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ZYFTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.view setBackgroundColor:rgb(235, 235, 241)];
    
//    self.textView.textContainerInset = UIEdgeInsetsMake(10, 10, 0, 10);
    self.textView.contentInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    self.textView.text = self.text;
}



@end
