//
//  FeedBackViewController.m
//  telecom
//
//  Created by liuyong on 15/7/31.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "FeedBackController.h"

@interface FeedBackController ()<UITextViewDelegate>

@end

@implementation FeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"反馈";
    _baseScrollView.hidden = YES;
    
    self.descInfoText.layer.borderWidth = 0.5;
    self.descInfoText.delegate = self;
    self.descInfoText.layer.borderColor = COLOR(210, 210, 210).CGColor;
    
    self.orderNumLabel.text = self.orderNum;
    self.candlePersonLabel.text = UGET(U_NAME);
    
    [self setUpRightNavButton];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - setUpRightNavButton
- (void)setUpRightNavButton
{
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"checkBtn.png"];
    checkBtn.frame = RECT(APP_W-40, 7, image.size.width/2, image.size.height/2);
    [checkBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - checkAction
- (void)checkAction
{
    if (self.descInfoText.text.length == 0) {
        showAlert(@"反馈内容必须填写。");
        return;
    }
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = NW_FaultFeedback;
    paraDict[@"workNo"] = self.workNum;
    paraDict[@"action"] = @"feedBack";
    paraDict[@"description"] = self.descInfoText.text;
    
    //    httpGET2(paraDict, ^(id result) {
    //        showAlert(@"反馈成功!");
    //    }, ^(id result) {
    //        showAlert(result[@"error"]);
    //    });
    
    httpPOST(paraDict, ^(id result) {
        showAlert(@"反馈成功!");
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.descInfoText.text = @"";
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    //    NSDictionary *userInfo = [aNotification userInfo];
    //    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [aValue CGRectValue];
    //    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= 100;
        frame.size.height += 100;
        self.view.frame = frame;
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //获取键盘的高度
    //    NSDictionary *userInfo = [aNotification userInfo];
    //    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    //    CGRect keyboardRect = [aValue CGRectValue];
    //    int height = keyboardRect.size.height;
    
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y += 100;
        frame.size.height -= 100;
        self.view.frame = frame;
    }];
}
@end
