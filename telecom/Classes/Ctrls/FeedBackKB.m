//
//  FeedBackKB.m
//  telecom
//
//  Created by ZhongYun on 14-11-18.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "FeedBackKB.h"

@interface FeedBackKB ()<UITextFieldDelegate>
{
    NSDictionary* user;
}
@end

@implementation FeedBackKB

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"故障反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
                                                              (NAV_H-checkIcon.size.height)/2,
                                                              checkIcon.size.width, checkIcon.size.height)];
    [checkBtn setBackgroundImage:checkIcon forState:0];
    [checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    
    user = [self getUserDep];
    
    UIView* obj = nil;
    obj = newLabel(self.view, @[@20, RECT_OBJ(10, NAV_H+STATUS_H+10, 300, Font3), [UIColor darkGrayColor], Font(Font3), format(@"工单流水号：%@", self.orderNo)]);
    obj = newLabel(self.view, @[@21, RECT_OBJ(10, obj.ey+10, 300, Font3), [UIColor darkGrayColor], Font(Font3), format(@"处理部门：%@", NoNullStr(user[@"orgName"]))]);
    obj = newLabel(self.view, @[@22, RECT_OBJ(10, obj.ey+10, 300, Font3), [UIColor darkGrayColor], Font(Font3), format(@"处理人：%@", UGET(U_NAME))]);
    obj = newLabel(self.view, @[@23, RECT_OBJ(10, obj.ey+10, 300, Font3), [UIColor darkGrayColor], Font(Font3), @"反馈内容"]);
    obj = newTextView(self.view, @[@24, RECT_OBJ(10, obj.ey+5, 300, 80), [UIColor blackColor], Font(Font3), @""]);
}

- (NSDictionary*)getUserDep
{
    NSDictionary* config = UGET(U_CONFIG);
    NSArray* list4 = config[@"list4"];
    if (list4.count == 0)return nil;
    NSDictionary* item0 = list4[0];
    return item0;
}


- (void)onCheckBtnTouched:(id)sender
{
//    if (tagViewEx(self.view, 24, UITextView).text.length == 0) {
//        showAlert(@"反馈内容必须填写。");
//        return;
//    }
//    
//    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:@{URL_TYPE:NW_FaultFeedback,
//                                                                                  @"workNo":self.workNo,
//                                                                                  @"action":@"feedBack",
//                                                                                  @"dealUser":UGET(U_ACCOUNT),
//                                                                                  @"description":tagViewEx(self.view, 24, UITextView).text}];
//    if (user[@"orgName"] != nil) {
//        params[@"dealDept"] = user[@"orgName"];
//    }
//    
//    httpGET1(params, ^(id result) {
//        showAlert(@"反馈内容提交成功");
//        [self.navigationController popViewControllerAnimated:YES];
//    });
    
    
    if (tagViewEx(self.view, 24, UITextView).text.length == 0) {
        showAlert(@"反馈内容必须填写。");
        return;
    }
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = NW_FaultFeedback;
    paraDict[@"workNo"] = self.workNo;
    paraDict[@"action"] = @"feedBack";
    paraDict[@"description"] = tagViewEx(self.view, 24, UITextView).text;
    
//    httpGET2(paraDict, ^(id result) {
//        showAlert(result[@"error"]);
//    }, ^(id result) {
//        showAlert(result[@"error"]);
//    });
    
    httpPOST(paraDict, ^(id result) {
        showAlert(result[@"error"]);
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


@end
