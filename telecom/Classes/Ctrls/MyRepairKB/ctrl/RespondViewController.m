//
//  RespondViewController.m
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "RespondViewController.h"

@interface RespondViewController ()

@end

@implementation RespondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"响  应";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpRightNavButton];
    
    self.workNo.text = self.orderNo;
    self.handlePerson.text = UGET(U_NAME);
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
    //    NSArray *tempArr  = UGET(U_CONFIG)[@"list4"];
    //    NSString *tempStr = [tempArr[0] objectForKey:@"orgName"];
    //    NSString *dealDept = [tempStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //    NSString *dealUser = [UGET(U_NAME) stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //
    //    NSDictionary *paraDict = @{URL_TYPE : kRespondAction,@"workNo" : self.workNum,@"action" : @"响应",@"dealDept" : dealDept,@"dealUser" :dealUser ,@"description":@"description"};
    //
    //    httpGET2(paraDict, ^(id result) {
    //        if ([result[@"result"] isEqualToString:@"0000000"]) {
    //            showAlert(@"响应成功!");
    //        }
    //    }, ^(id result) {
    //        showAlert(result[@"error"]);
    //    });
    
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = NW_FaultFeedback;
    paraDict[@"workNo"] = self.workNum;
    paraDict[@"action"] = @"accept";
    paraDict[@"description"] = @"响应";
    
    //    httpGET2(paraDict, ^(id result) {
    //        if ([result[@"result"] isEqualToString:@"0000000"]) {
    //            showAlert(result[@"error"]);
    //        }
    //    }, ^(id result) {
    //        showAlert(result[@"error"]);
    //    });
    
    httpPOST(paraDict, ^(id result) {
        showAlert(result[@"error"]);
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    
}
@end
