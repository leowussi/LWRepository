//
//  MyTaskCallBackController.m
//  telecom
//
//  Created by liuyong on 15/5/12.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyTaskCallBackController.h"
#import "AddFaultOrderController.h"
#import "AddShareInfoController.h"
#import "AddTroubleViewController.h"
#import "RectifyResourceController.h"

@interface MyTaskCallBackController ()<UITextViewDelegate>
{
    BOOL _isAddtionalOperationViewHiden;
}
@property(nonatomic,strong)UIButton *rightAddtionalBtn;
@property(nonatomic,strong)UIView *addtionalView;
@end

@implementation MyTaskCallBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isSecondaryTask) {
        self.title = @"二级召回重做";
    }else{
        self.title = @"一级召回重做";
    }
    _isAddtionalOperationViewHiden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.taskContent.layer.borderWidth = 0.5;
    self.taskContent.delegate = self;
    self.taskContent.layer.borderColor = COLOR(210, 210, 210).CGColor;
    
    self.finishedCount.layer.borderWidth = 0.5;
    self.finishedCount.delegate = self;
    self.finishedCount.layer.borderColor = COLOR(210, 210, 210).CGColor;
    
    self.findOutQuestion.layer.borderWidth = 0.5;
    self.findOutQuestion.delegate = self;
    self.findOutQuestion.layer.borderColor = COLOR(210, 210, 210).CGColor;
    
    self.handleQuestion.layer.borderWidth = 0.5;
    self.handleQuestion.delegate = self;
    self.handleQuestion.layer.borderColor = COLOR(210, 210, 210).CGColor;
    
    [self setUpRightBarButton];
    
    [self setUpRightAddtionalBarButton];
    
    [self loadDataWithURLString:NW_GetTaskInfo];
}

#pragma mark - 右侧按钮
- (void)setUpRightBarButton
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightBtn.frame = CGRectMake(APP_W-40, 7, 30, 30);
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_check@2x"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(callBackAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:self.rightBtn];
}

#pragma mark - 右侧第二个按钮
- (void)setUpRightAddtionalBarButton
{
    self.rightAddtionalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightAddtionalBtn.frame = CGRectMake(APP_W-80, 7, 30, 30);
    [self.rightAddtionalBtn setBackgroundImage:[UIImage imageNamed:@"nav_add@2x"] forState:UIControlStateNormal];
    [self.rightAddtionalBtn addTarget:self action:@selector(addtionalAction) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:self.rightAddtionalBtn];
}

#pragma mark - 添加故障单等操作
- (void)addtionalAction
{
    if (_isAddtionalOperationViewHiden) {
        self.addtionalView = [[UIView alloc] initWithFrame:RECT(APP_W-120, 64, 80, 90)];
        self.addtionalView.backgroundColor = COLOR(239, 239, 239);
        self.addtionalView.layer.borderWidth = 0.5;
        self.addtionalView.layer.borderColor = COLOR(215, 215, 215).CGColor;
        [self.view addSubview:self.addtionalView];
        
        NSArray *titleArray = @[@"添加故障单",@"添加隐患",@"矫正资源"];
        for (int i=0; i<titleArray.count; i++) {
            UIButton *addtionalBtn = [MyUtil createBtnFrame:RECT(0, 30*i, 80, 30) bgImage:nil image:nil title:titleArray[i] target:self action:@selector(addtionalOperation:)];
            [addtionalBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            addtionalBtn.tag = 28888 + i;
            addtionalBtn.layer.borderColor = COLOR(215, 215, 215).CGColor;
            addtionalBtn.layer.borderWidth = 0.5;
            [self.addtionalView addSubview:addtionalBtn];
        }
        
        _isAddtionalOperationViewHiden = NO;
    }else{
        self.addtionalView.hidden = YES;
        _isAddtionalOperationViewHiden = YES;
    }
}

- (void)addtionalOperation:(UIButton *)btn
{
    NSInteger index = btn.tag - 28888;
    if (index == 0) {
        AddFaultOrderController *addOrderCtrl = [[AddFaultOrderController alloc] init];
        addOrderCtrl.callBackInfoDict = self.callBackInfoDict;
        [self.navigationController pushViewController:addOrderCtrl animated:YES];
    }else if (index == 1){
        AddTroubleViewController *addTroubleCtrl = [[AddTroubleViewController alloc] init];
        addTroubleCtrl.callBackInfoDict = self.callBackInfoDict;
        [self.navigationController pushViewController:addTroubleCtrl animated:YES];
    }else{
        RectifyResourceController *rectifyCtrl = [[RectifyResourceController alloc] init];
        rectifyCtrl.callBackInfoDict = self.callBackInfoDict;
        [self.navigationController pushViewController:rectifyCtrl animated:YES];
    }
}


- (void)loadDataWithURLString:(NSString *)urlString
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE]  = urlString;
    paraDict[@"taskId"] = self.callBackInfoDict[@"taskId"];
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result" ] isEqualToString:@"0000000"]) {
//            NSLog(@"detail-------%@",result[@"detail"]);
            NSDictionary *tempDict = result[@"detail"];
            self.taskContent.text = tempDict[@"workContent"];
            self.finishedCount.text = tempDict[@"amount"];
            self.findOutQuestion.text = tempDict[@"question"];
            self.handleQuestion.text = tempDict[@"answer"];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (void)callBackAction
{
    
    if (self.taskContent.text == nil) {
        showAlert(@"工作内容不能为空!");
        return;
    }
    
    if (self.finishedCount.text == nil) {
        showAlert(@"完成数量不能为空!");
        return;
    }
    
    NSInteger finishedCount = [self.finishedCount.text integerValue];
    NSInteger undoCount = [self.callBackInfoDict[@"undoUnitAmount"] integerValue];
    if (finishedCount < undoCount) {
        showAlert(@"完成数量不能大于未完成数量。");
        return;
    }
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = self.isSecondaryTask ? NW_CallBackTaskLevelTwo : NW_CallBackTaskLevelOne;
    paraDict[@"taskId"] = self.callBackInfoDict[@"taskId"];
    paraDict[@"workContent"] = [self.taskContent.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    paraDict[@"finishedAmount"] = self.finishedCount.text;
    paraDict[@"foundProblem"] = [self.findOutQuestion.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    paraDict[@"handledProblem"] = [self.handleQuestion.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            showAlert(@"任务已召回重做");
        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
