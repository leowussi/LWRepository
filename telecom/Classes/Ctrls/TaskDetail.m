//
//  TaskDetail.m
//  telecom
//
//  Created by ZhongYun on 14-6-20.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "TaskDetail.h"
#import "AddFaultOrderController.h"
#import "AddShareInfoController.h"
#import "AddTroubleViewController.h"
#import "RectifyResourceController.h"

@interface TaskDetail ()<UITextFieldDelegate, UITextViewDelegate>
{
    BOOL _isAddtionalOperationViewHiden;
}
@property(nonatomic,strong)UIButton *rightAddtionalBtn;
@property(nonatomic,strong)UIView *addtionalView;
@end

@implementation TaskDetail

- (void)addNavigationRightButton:(NSString *)str
{
    UIButton *forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forwardButton.frame = CGRectMake(kScreenWidth-[UIImage imageNamed:str].size.width/2, 12,[UIImage imageNamed:str].size.width,[UIImage imageNamed:str].size.height);
    [forwardButton setBackgroundImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    [forwardButton addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:forwardButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"处理任务";
    self.view.backgroundColor = [UIColor whiteColor];
    _isAddtionalOperationViewHiden = YES;
    
    UIImage* checkIcon = [UIImage imageNamed:@"图标.png"];
    UIButton* checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-80),
                                                              (NAV_H-checkIcon.size.height)/2,
                                                              checkIcon.size.width/1.5, checkIcon.size.height/1.5)];
    [checkBtn setBackgroundImage:checkIcon forState:0];
    [checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = item1;
    
    self.rightAddtionalBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightAddtionalBtn.frame = CGRectMake(APP_W-40, 7, 30, 30);
    [self.rightAddtionalBtn setBackgroundImage:[UIImage imageNamed:@"3_1.png"] forState:UIControlStateNormal];
    [self.rightAddtionalBtn addTarget:self action:@selector(addtionalAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:self.rightAddtionalBtn];
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    [item2 release];
    [item1 release];
    
    UIView* obj = nil;
    obj = newLabel(self.view, @[@20, RECT_OBJ(10, 68, 300, Font3), [UIColor darkGrayColor], Font(Font3), @"具体工作内容"]);
    obj = newTextView(self.view, @[@21, RECT_OBJ(10, obj.ey+5, 300, 80), [UIColor blackColor], Font(Font3), @""]);
    obj = newLabel(self.view, @[@22, RECT_OBJ(10, obj.ey+10, 300, Font3), [UIColor darkGrayColor], Font(Font3), @"完成数量"]);
    obj = newTextField(self.view, @[@23, RECT_OBJ(10, obj.ey+5, 300, 30), [UIColor blackColor], Font(Font3), @"", @""]);
    obj = newLabel(self.view, @[@24, RECT_OBJ(10, obj.ey+10, 300, Font3), [UIColor darkGrayColor], Font(Font3), @"发现问题"]);
    obj = newTextView(self.view, @[@25, RECT_OBJ(10, obj.ey+5, 300, 80), [UIColor blackColor], Font(Font3), @""]);
    obj = newLabel(self.view, @[@26, RECT_OBJ(10, obj.ey+10, 300, Font3), [UIColor darkGrayColor], Font(Font3), @"处理问题"]);
    obj = newTextView(self.view, @[@27, RECT_OBJ(10, obj.ey+5, 300, 80), [UIColor blackColor], Font(Font3), @""]);
}

#pragma mark - 添加故障单等操作
- (void)addtionalAction
{
    if (_isAddtionalOperationViewHiden) {
        _addtionalView = [[UIView alloc] initWithFrame:RECT(APP_W-80, 64, 80, 90)];
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
        addOrderCtrl.callBackInfoDict = self.detail;
        [self.navigationController pushViewController:addOrderCtrl animated:YES];
        [addOrderCtrl release];
    }else if (index == 1){
//        AddTroubleViewController *addTroubleCtrl = [[AddTroubleViewController alloc] init];
//        addTroubleCtrl.callBackInfoDict = self.detail;
//        [self.navigationController pushViewController:addTroubleCtrl animated:YES];
        [self getData];
    }else{
//        RectifyResourceController *rectifyCtrl = [[RectifyResourceController alloc] init];
//        rectifyCtrl.callBackInfoDict = self.detail;
//        [self.navigationController pushViewController:rectifyCtrl animated:YES];
        [self getData];
    }
}
-(void)getData{
        AddTroubleViewController *addTroubleCtrl = [[AddTroubleViewController alloc] init];
        NSMutableDictionary *par =[NSMutableDictionary dictionary];
        [par setObject:@"MyTask/GetRiskBasicInfo" forKey:URL_TYPE];
        [par setObject:self.detail[@"taskId"] forKey:@"taskId"];
        httpGET2(par, ^(id result) {
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                addTroubleCtrl.callBackInfoDict = result[@"detail"];
                addTroubleCtrl.subTaskId =self.detail[@"taskId"];
                
                [self.navigationController pushViewController:addTroubleCtrl animated:YES];
            }
        }, ^(id result) {
            
        });
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.strVCTag == 888) {
        tagViewEx(self.view, 21, UITextView).text = self.detail[@"taskContent"];
        tagViewEx(self.view, 23, UITextField).text = format(@"%@", self.detail[@"undoUnitAmount"]);
        tagViewEx(self.view, 23, UITextField).layer.borderWidth = 0.5;
        tagViewEx(self.view, 23, UITextField).layer.borderColor = COLOR(210, 210, 210).CGColor;
    }else{
        tagViewEx(self.view, 21, UITextView).text = self.detail[@"taskName"];
        tagViewEx(self.view, 23, UITextField).text = format(@"%@", self.detail[@"undoUnitAmount"]);
        tagViewEx(self.view, 23, UITextField).layer.borderWidth = 0.5;
        tagViewEx(self.view, 23, UITextField).layer.borderColor = COLOR(210, 210, 210).CGColor;
    }
    
    NSLog(@"%@",self.detail);
}

- (void)onCheckBtnTouched:(id)sender
{
    if (self.isCallBackAction == YES) {//召回重做
        if (tagViewEx(self.view, 21, UITextView).text.length == 0) {
            showAlert(@"工作内容必须填写。");
            return;
        }
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] =  NW_CallBackTaskLevelOne;
        paraDict[@"taskId"] = self.detail[@"taskId"];
        paraDict[@"workContent"] = tagViewEx(self.view, 21, UITextView).text;
        paraDict[@"finishedAmount"] = tagViewEx(self.view, 23, UITextField).text;
        paraDict[@"foundProblem"] = tagViewEx(self.view, 25, UITextView).text;
        paraDict[@"handledProblem"] = tagViewEx(self.view, 27, UITextView).text;
        httpGET2(paraDict, ^(id result) {
                showAlert(@"任务已召回重做");
            [self.navigationController popViewControllerAnimated:YES];
        }, ^(id result) {
            showAlert(result[@"error"]);
        });
    }else{//任务处理
        if (tagViewEx(self.view, 21, UITextView).text.length == 0) {
            showAlert(@"工作内容必须填写。");
            return;
        }
        
        if (tagViewEx(self.view, 23, UITextField).text.length == 0) {
            showAlert(@"完成数量必须填写。");
            return;
        }
        
        httpGET1(@{URL_TYPE:NW_FinishTask,
                   @"taskId":self.detail[@"taskId"],
                   @"workContent":tagViewEx(self.view, 21, UITextView).text,
                   @"finishedAmount":tagViewEx(self.view, 23, UITextField).text ,
                   @"foundProblem":tagViewEx(self.view, 25, UITextView).text,
                   @"handledProblem":tagViewEx(self.view, 27, UITextView).text},
                 ^(id result) {
                     if (self.strVCTag == 888) {
                         if ([result[@"result"] isEqualToString:@"0000000"]){
                             showAlert(@"操作成功");
                         }else{
                             
                         }
                     }else{
                        mainThread(commitSuccess, nil);
                     }
                     
                 });
    }
}

- (void)commitSuccess
{
    if (self.strVCTag == 888) {
        
    }else{
        NSInteger finishedAmount = [tagViewEx(self.view, 23, UITextField).text intValue];
        self.detail[@"finishedAmount"] = @(finishedAmount);
        self.detail[@"taskName"] = tagViewEx(self.view, 21, UITextView).text;
        if (self.respBlock) {
            self.respBlock(nil);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == 25) {
        
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y -=30;
        frame.size.height +=30;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
        
    }else if (textView.tag == 27) {
        
        NSTimeInterval animationDuration = 0.30f;
        CGRect frame = self.view.frame;
        frame.origin.y -=150;
        frame.size.height +=150;
        self.view.frame = frame;
        [UIView beginAnimations:@"ResizeView" context:nil];
        [UIView setAnimationDuration:animationDuration];
        self.view.frame = frame;
        [UIView commitAnimations];
        
    }else{
        
    }
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

@end
