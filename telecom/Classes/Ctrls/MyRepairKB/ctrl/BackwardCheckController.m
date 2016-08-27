//
//  BackwardCheckController.m
//  telecom
//
//  Created by liuyong on 15/8/24.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#define kCustomButtonWH 60
#define kBasicTag       10086

#import "BackwardCheckController.h"
#import "CheckLevelButton.h"
#import "ChooseCheckObjectView.h"
#import "UnsatisfiedReasonView.h"

@interface BackwardCheckController ()<ChooseCheckObjectViewDelegate,UnsatisfiedReasonViewDelegate,UITextViewDelegate>
{
    CheckLevelButton *_selectedLevelBtn;
    
    BOOL _isLevelOneSelected;
    BOOL _isLevelTwoSelected;
    BOOL _isLevelThreeSelected;
    
    BOOL _isUnsatisfiedHidden;
    
    BOOL _isCheckObjectViewHidden;
    BOOL _isUnsatisfiedReasonViewHidden;
    
    NSString *_checkLevel;//考评等级
    NSString *_targetGroupId;//考评工位ID
    
    ChooseCheckObjectView *_ChooseCheckObjectView;
    UnsatisfiedReasonView *_UnsatisfiedReasonView;
    
    UILabel *_workNumTitleLabel;
    UILabel *_workNumLabel;
    
    UILabel *_checkObjectTitleLabel;
    UILabel *_checkObjectLabel;
    
    UIView *_bigView;
    
    UILabel *_checkSatisfiedLevelTitleLabel;
    UIView *_checkSatisfiedLevelView;
    
    UILabel *_unsatisfiedReasonTitleLabel;
    UILabel *_unsatisfiedReasonLabel;
    
    UIView *_smallView;
    
    UIView *_remarkView;
    
    UILabel *_remarkTextTitleLabel;
    UITextView *_remarkTextView;
    
    UIScrollView *_bottomScrollView;
}
@end

@implementation BackwardCheckController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"逆向考评";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _isLevelOneSelected = NO;
    _isLevelTwoSelected = NO;
    _isLevelThreeSelected = NO;
    _isUnsatisfiedHidden = YES;
    _isCheckObjectViewHidden = YES;
    _isUnsatisfiedReasonViewHidden = YES;
    
    [self addNavigationLeftButton];
    
    [self setUpRightNavButton];
    
    [self setUpUI];
}

- (void)setUpUI
{
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:RECT(0, 64, APP_W, APP_H-44)];
    _bottomScrollView.backgroundColor = RGBCOLOR(249, 249, 249);
    _bottomScrollView.contentSize = CGSizeMake(APP_W, APP_H-44);
    [self.view addSubview:_bottomScrollView];
    
    _workNumTitleLabel = [MyUtil createLabel:RECT(8, 20, 72, 25) text:@"流水单号:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:15.0f];
    [_bottomScrollView addSubview:_workNumTitleLabel];
    
    _workNumLabel = [MyUtil createLabel:RECT(_workNumTitleLabel.ex+8, 20, APP_W-24-_workNumTitleLabel.fw, 25) text:self.orderNo alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:14.0f];
    [_bottomScrollView addSubview:_workNumLabel];
    
    _checkObjectTitleLabel = [MyUtil createLabel:RECT(8, _workNumTitleLabel.ey+8, _workNumTitleLabel.fw, 25) text:@"考评对象:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:15.0f];
    [_bottomScrollView addSubview:_checkObjectTitleLabel];
    
    _checkObjectLabel = [MyUtil createLabel:RECT(_checkObjectTitleLabel.ex+8, _workNumTitleLabel.ey+8, APP_W-24-_workNumTitleLabel.fw, 25) text:@"选择考评对象" alignment:NSTextAlignmentLeft textColor:RGBCOLOR(191, 191, 191) font:14.0f];
    _checkObjectLabel.userInteractionEnabled = YES;
    _checkObjectLabel.layer.borderWidth = 0.5;
    _checkObjectLabel.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    [_checkObjectLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseCheckObjectAction:)]];
    [_bottomScrollView addSubview:_checkObjectLabel];
    
    _checkSatisfiedLevelTitleLabel = [MyUtil createLabel:RECT(8, _checkObjectTitleLabel.ey+8, 90, 25) text:@"考评满意度:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:15.0f];
    [_bottomScrollView addSubview:_checkSatisfiedLevelTitleLabel];
    
    _checkSatisfiedLevelView = [[UIView alloc] initWithFrame:RECT(_checkSatisfiedLevelTitleLabel.ex+8, _checkSatisfiedLevelTitleLabel.fy, APP_W-24-_checkSatisfiedLevelTitleLabel.fw, 70)];
    _checkSatisfiedLevelView.backgroundColor = [UIColor clearColor];
    [_bottomScrollView addSubview:_checkSatisfiedLevelView];
    
    NSArray *imageNameArr = @[@"非常满意1",@"满意1",@"不满意1"];
    NSArray *selectedImageNameArr = @[@"非常满意2",@"满意2",@"不满意2"];
    NSArray *titleArr = @[@"非常满意",@"满意",@"不满意"];
    
    
    NSInteger space = (_checkSatisfiedLevelView.frame.size.width - kCustomButtonWH*3) / 4;
    for (int i=0; i<titleArr.count; i++) {
        CheckLevelButton *checkLevelButton = [[CheckLevelButton alloc] initWithFrame:RECT(space+(kCustomButtonWH+space)*i,(_checkSatisfiedLevelView.fh-kCustomButtonWH)/2, kCustomButtonWH, kCustomButtonWH) title:titleArr[i] imageName:imageNameArr[i] selectedImageName:selectedImageNameArr[i] target:self action:@selector(changeSatisfiedLevelAction:)];
        checkLevelButton.tag = kBasicTag+i;
        checkLevelButton.layer.cornerRadius = 5;
        [_checkSatisfiedLevelView addSubview:checkLevelButton];
    }
    
    _remarkView = [[UIView alloc] initWithFrame:RECT(0, _checkSatisfiedLevelView.ey+8, APP_W, 60)];
    _remarkView.backgroundColor = [UIColor clearColor];
    _remarkView.userInteractionEnabled = YES;
    [_bottomScrollView addSubview:_remarkView];
    
    _remarkTextTitleLabel = [MyUtil createLabel:RECT(8, 0, 50, 25) text:@"备注:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:15.0f];
    [_remarkView addSubview:_remarkTextTitleLabel];
    
    _remarkTextView = [[UITextView alloc] initWithFrame:RECT(_remarkTextTitleLabel.ex+8, _remarkTextTitleLabel.fy, APP_W-24-_remarkTextTitleLabel.fw, 60)];
    _remarkTextView.delegate = self;
    _remarkTextView.layer.borderWidth = 0.5;
    _remarkTextView.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    _remarkTextView.text = @"请输入备注...";
    _remarkTextView.font = [UIFont systemFontOfSize:14.0f];
    [_remarkView addSubview:_remarkTextView];
}

- (void)chooseCheckObjectAction:(UITapGestureRecognizer *)ges
{
    if (_isCheckObjectViewHidden == YES) {
        [UIView animateWithDuration:0.3f animations:^{
            [_checkSatisfiedLevelTitleLabel setFy:_checkSatisfiedLevelTitleLabel.fy+80];
            [_checkSatisfiedLevelView setFy:_checkSatisfiedLevelView.fy+80];
//            [_remarkTextTitleLabel setFy:_remarkTextTitleLabel.fy+80];
//            [_remarkTextView setFy:_remarkTextView.fy+80];
            [_remarkView setFy:_remarkView.fy+80];
            
            if (_unsatisfiedReasonLabel != nil || _UnsatisfiedReasonView != nil) {
                [_unsatisfiedReasonTitleLabel setFy:_unsatisfiedReasonTitleLabel.fy+80];
                [_unsatisfiedReasonLabel setFy:_unsatisfiedReasonLabel.fy+80];
                [_UnsatisfiedReasonView setFy:_UnsatisfiedReasonView.fy+80];
            }
        }];
        
        _ChooseCheckObjectView = [[ChooseCheckObjectView alloc] initWithFrame:RECT(_checkObjectLabel.fx,_checkObjectLabel.ey+5,_checkObjectLabel.fw, 72)];
        _ChooseCheckObjectView.delegate = self;
        [_bottomScrollView addSubview:_ChooseCheckObjectView];
        
        _bottomScrollView.contentSize = CGSizeMake(APP_W, _bottomScrollView.contentSize.height+80);
        
        [_ChooseCheckObjectView loadDataWithURL:kGetCheckTarget workNo:self.workNum];
        
        _isCheckObjectViewHidden = NO;
        ges.enabled = NO;
    }else{
        
        _isCheckObjectViewHidden = YES;
    }
}

- (void)chooseUnsatisfiedReasonAction:(UITapGestureRecognizer *)ges
{
    if (_isUnsatisfiedReasonViewHidden == YES) {
        
        [UIView animateWithDuration:0.3f animations:^{
//            [_remarkTextTitleLabel setFy:_remarkTextTitleLabel.fy+150+8];
//            [_remarkTextView setFy:_remarkTextView.fy+150+8];
            [_remarkView setFy:_remarkView.fy+150+8];
        }];
        
        _UnsatisfiedReasonView = [[UnsatisfiedReasonView alloc] initWithFrame:RECT(_unsatisfiedReasonLabel.fx, _unsatisfiedReasonLabel.ey+5, _unsatisfiedReasonLabel.fw, 150)];
        _UnsatisfiedReasonView.delegate = self;
        [_bottomScrollView addSubview:_UnsatisfiedReasonView];
        
        _bottomScrollView.contentSize = CGSizeMake(APP_W, _bottomScrollView.contentSize.height+150+8);
        
        [_UnsatisfiedReasonView loadDataWithURL:kGetDissatisfyReason];
        
        _isUnsatisfiedReasonViewHidden = NO;
        ges.enabled = NO;
    }else{
        
        _isUnsatisfiedReasonViewHidden = YES;
    }
}

- (void)deliverCheckObjectChooseString:(NSString *)chooseString targetGroupId:(NSString *)targetGroupId
{
    _checkObjectLabel.text = chooseString;
    _targetGroupId = targetGroupId;
    _checkObjectLabel.textColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.3f animations:^{
        [_checkSatisfiedLevelTitleLabel setFy:_checkSatisfiedLevelTitleLabel.fy-80];
        [_checkSatisfiedLevelView setFy:_checkSatisfiedLevelView.fy-80];
//        [_remarkTextTitleLabel setFy:_remarkTextTitleLabel.fy-80];
//        [_remarkTextView setFy:_remarkTextView.fy-80];
        [_remarkView setFy:_remarkView.fy-80];
        if (_unsatisfiedReasonLabel != nil || _UnsatisfiedReasonView != nil) {
            [_unsatisfiedReasonTitleLabel setFy:_unsatisfiedReasonTitleLabel.fy-80];
            [_unsatisfiedReasonLabel setFy:_unsatisfiedReasonLabel.fy-80];
            [_UnsatisfiedReasonView setFy:_UnsatisfiedReasonView.fy-80];
        }
        [_ChooseCheckObjectView removeFromSuperview];
    }];
    
    _bottomScrollView.contentSize = CGSizeMake(APP_W, _bottomScrollView.contentSize.height-80);
    
    UITapGestureRecognizer *ges = (UITapGestureRecognizer *)[_checkObjectLabel.gestureRecognizers objectAtIndex:0];
    ges.enabled = YES;
    _ChooseCheckObjectView = nil;
    _isCheckObjectViewHidden = YES;
}

- (void)deliverUnsatisfiedReasonChooseString:(NSString *)chooseString
{
    _unsatisfiedReasonLabel.text = chooseString;
    _unsatisfiedReasonLabel.textColor = [UIColor blackColor];
    
    [UIView animateWithDuration:0.3f animations:^{
//        [_remarkTextTitleLabel setFy:_remarkTextTitleLabel.fy-150-8];
//        [_remarkTextView setFy:_remarkTextView.fy-150-8];
        [_remarkView setFy:_remarkView.fy-150-8];
        [_UnsatisfiedReasonView removeFromSuperview];
    }];
    
    _bottomScrollView.contentSize = CGSizeMake(APP_W, _bottomScrollView.contentSize.height-150-8);
    
    _UnsatisfiedReasonView = nil;
    _isUnsatisfiedReasonViewHidden = YES;
    UITapGestureRecognizer *ges = (UITapGestureRecognizer *)[_unsatisfiedReasonLabel.gestureRecognizers objectAtIndex:0];
    ges.enabled = YES;
}

- (void)changeSatisfiedLevelAction:(CheckLevelButton *)currentLevelBtn
{
    NSInteger index = currentLevelBtn.tag - kBasicTag;
    if (index == 0) {//非常满意
        
        _checkLevel = @"非常满意";
        
        _selectedLevelBtn.selected = NO;
        _selectedLevelBtn.backgroundColor = [UIColor clearColor];
        currentLevelBtn.selected = YES;
        currentLevelBtn.backgroundColor = RGBCOLOR(240, 141, 38);
        _selectedLevelBtn = currentLevelBtn;
        
        if (_unsatisfiedReasonTitleLabel == nil) return;
        
        if (_unsatisfiedReasonTitleLabel != nil && _UnsatisfiedReasonView != nil){
            [UIView animateWithDuration:0.3f animations:^{
                [_unsatisfiedReasonTitleLabel setFx:_unsatisfiedReasonTitleLabel.fx+APP_W];
                [_unsatisfiedReasonTitleLabel removeFromSuperview];
                _unsatisfiedReasonTitleLabel = nil;
                [_unsatisfiedReasonLabel setFx:_unsatisfiedReasonLabel.fx+APP_W];
                [_unsatisfiedReasonLabel removeFromSuperview];
                _unsatisfiedReasonLabel = nil;
                _isUnsatisfiedHidden = YES;
                [_UnsatisfiedReasonView removeFromSuperview];
                _UnsatisfiedReasonView = nil;
                _isUnsatisfiedReasonViewHidden = YES;
                
//                [_remarkTextTitleLabel setFy:_remarkTextTitleLabel.fy-25-150-8-8];
//                [_remarkTextView setFy:_remarkTextView.fy-25-150-8-8];
                [_remarkView setFy:_remarkView.fy-25-150-8-8];
                return;
            }];
        }
        
        if (_unsatisfiedReasonTitleLabel != nil && _UnsatisfiedReasonView == nil) {
            [UIView animateWithDuration:0.3f animations:^{
                [_unsatisfiedReasonTitleLabel setFx:_unsatisfiedReasonTitleLabel.fx+APP_W];
                [_unsatisfiedReasonTitleLabel removeFromSuperview];
                _unsatisfiedReasonTitleLabel = nil;
                [_unsatisfiedReasonLabel setFx:_unsatisfiedReasonLabel.fx+APP_W];
                [_unsatisfiedReasonLabel removeFromSuperview];
                _unsatisfiedReasonLabel = nil;
                _isUnsatisfiedHidden = YES;
                
//                [_remarkTextTitleLabel setFy:_remarkTextTitleLabel.fy-25-8];
//                [_remarkTextView setFy:_remarkTextView.fy-25-8];
                [_remarkView setFy:_remarkView.fy-25-8];
                return;
            }];
        }
        
    }else if (index == 1){//满意
        
        _checkLevel = @"满意";
        
        _selectedLevelBtn.selected = NO;
        _selectedLevelBtn.backgroundColor = [UIColor clearColor];
        currentLevelBtn.selected = YES;
        currentLevelBtn.backgroundColor = RGBCOLOR(254, 227, 46);
        _selectedLevelBtn = currentLevelBtn;
        
        if (_unsatisfiedReasonTitleLabel == nil) return;
        
        if (_unsatisfiedReasonTitleLabel != nil && _UnsatisfiedReasonView != nil){
            [UIView animateWithDuration:0.3f animations:^{
                [_unsatisfiedReasonTitleLabel setFx:_unsatisfiedReasonTitleLabel.fx+APP_W];
                [_unsatisfiedReasonTitleLabel removeFromSuperview];
                _unsatisfiedReasonTitleLabel = nil;
                [_unsatisfiedReasonLabel setFx:_unsatisfiedReasonLabel.fx+APP_W];
                [_unsatisfiedReasonLabel removeFromSuperview];
                _unsatisfiedReasonLabel = nil;
                _isUnsatisfiedHidden = YES;
                [_UnsatisfiedReasonView removeFromSuperview];
                _UnsatisfiedReasonView = nil;
                _isUnsatisfiedReasonViewHidden = YES;
                
//                [_remarkTextTitleLabel setFy:_remarkTextTitleLabel.fy-25-150-8-8];
//                [_remarkTextView setFy:_remarkTextView.fy-25-150-8-8];
                [_remarkView setFy:_remarkView.fy-25-150-8-8];
                return;
            }];
        }
        
        if (_unsatisfiedReasonTitleLabel != nil && _UnsatisfiedReasonView == nil) {
            [UIView animateWithDuration:0.3f animations:^{
                [_unsatisfiedReasonTitleLabel setFx:_unsatisfiedReasonTitleLabel.fx+APP_W];
                [_unsatisfiedReasonTitleLabel removeFromSuperview];
                _unsatisfiedReasonTitleLabel = nil;
                [_unsatisfiedReasonLabel setFx:_unsatisfiedReasonLabel.fx+APP_W];
                [_unsatisfiedReasonLabel removeFromSuperview];
                _unsatisfiedReasonLabel = nil;
                _isUnsatisfiedHidden = YES;
                
//                [_remarkTextTitleLabel setFy:_remarkTextTitleLabel.fy-25-8];
//                [_remarkTextView setFy:_remarkTextView.fy-25-8];
                [_remarkView setFy:_remarkView.fy-25-8];
                return;
            }];
        }
        
    }else{//不满意
        
        _checkLevel = @"不满意";
        
        _selectedLevelBtn.selected = NO;
        _selectedLevelBtn.backgroundColor = [UIColor clearColor];
        currentLevelBtn.selected = YES;
        currentLevelBtn.backgroundColor = RGBCOLOR(193, 193, 193);
        _selectedLevelBtn = currentLevelBtn;
        
        if (_isUnsatisfiedHidden == YES) {
            [UIView animateWithDuration:0.3f animations:^{
//                [_remarkTextTitleLabel setFy:_remarkTextTitleLabel.fy+25+8];
//                [_remarkTextView setFy:_remarkTextView.fy+25+8];
                [_remarkView setFy:_remarkView.fy+25+8];
            }];
            
            _unsatisfiedReasonTitleLabel = [MyUtil createLabel:RECT(APP_W, _checkSatisfiedLevelView.ey+8, 90, 25) text:@"不满意原因:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor] font:15.0f];
            [_bottomScrollView addSubview:_unsatisfiedReasonTitleLabel];
            
            _unsatisfiedReasonLabel = [MyUtil createLabel:RECT(_unsatisfiedReasonTitleLabel.ex+8, _checkSatisfiedLevelView.ey+8, APP_W-24-_unsatisfiedReasonTitleLabel.fw, 25) text:@"选择不满意原因" alignment:NSTextAlignmentLeft textColor:RGBCOLOR(191, 191, 191) font:14.0f];
            _unsatisfiedReasonLabel.userInteractionEnabled = YES;
            _unsatisfiedReasonLabel.layer.borderWidth = 0.5;
            _unsatisfiedReasonLabel.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
            [_unsatisfiedReasonLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseUnsatisfiedReasonAction:)]];
            [_bottomScrollView addSubview:_unsatisfiedReasonLabel];
            
            [UIView animateWithDuration:0.3f animations:^{
                [_unsatisfiedReasonTitleLabel setFx:_unsatisfiedReasonTitleLabel.fx-(APP_W-8)];
                [_unsatisfiedReasonLabel setFx:_unsatisfiedReasonLabel.fx-(APP_W-8)];
            }];
            
            _isUnsatisfiedHidden = NO;
        }else{
            
            if (_unsatisfiedReasonTitleLabel != nil && _UnsatisfiedReasonView != nil){
                [UIView animateWithDuration:0.3f animations:^{
                    [_unsatisfiedReasonTitleLabel setFx:_unsatisfiedReasonTitleLabel.fx+APP_W];
                    [_unsatisfiedReasonTitleLabel removeFromSuperview];
                    _unsatisfiedReasonTitleLabel = nil;
                    [_unsatisfiedReasonLabel setFx:_unsatisfiedReasonLabel.fx+APP_W];
                    [_unsatisfiedReasonLabel removeFromSuperview];
                    _unsatisfiedReasonLabel = nil;
                    _isUnsatisfiedHidden = YES;
                    [_UnsatisfiedReasonView removeFromSuperview];
                    _UnsatisfiedReasonView = nil;
                    _isUnsatisfiedReasonViewHidden = YES;
                    
//                    [_remarkTextTitleLabel setFy:_remarkTextTitleLabel.fy-25-150-8];
//                    [_remarkTextView setFy:_remarkTextView.fy-25-150-8];
                    [_remarkView setFy:_remarkView.fy-25-150-8];
                    return;
                }];
            }
            
            if (_unsatisfiedReasonTitleLabel != nil && _UnsatisfiedReasonView == nil) {
                [UIView animateWithDuration:0.3f animations:^{
                    [_unsatisfiedReasonTitleLabel setFx:_unsatisfiedReasonTitleLabel.fx+APP_W];
                    [_unsatisfiedReasonTitleLabel removeFromSuperview];
                    _unsatisfiedReasonTitleLabel = nil;
                    [_unsatisfiedReasonLabel setFx:_unsatisfiedReasonLabel.fx+APP_W];
                    [_unsatisfiedReasonLabel removeFromSuperview];
                    _unsatisfiedReasonLabel = nil;
                    _isUnsatisfiedHidden = YES;
                    
//                    [_remarkTextTitleLabel setFy:_remarkTextTitleLabel.fy-25-8];
//                    [_remarkTextView setFy:_remarkTextView.fy-25-8];
                    [_remarkView setFy:_remarkView.fy-25-8];
                    return;
                }];
            }
            
            _isUnsatisfiedHidden = YES;
        }
        
    }
}




- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"tuijianpan");
    [textView resignFirstResponder];
    
}

#pragma mark - addNavigationLeftButton
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton setImage:[navImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setUpRightNavButton
- (void)setUpRightNavButton
{
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"checkBtn.png"];
    checkBtn.frame = RECT(APP_W-40, 7, image.size.width/2, image.size.height/2);
    [checkBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(backwardCheckAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - 逆向考评结果提交
- (void)backwardCheckAction
{
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");//yyyy-MM-dd HH:mm:ss
    NSString *accessToken = UGET(U_TOKEN);
    NSString *workNo = self.workNum;
    NSString *targetGroupId = _targetGroupId;
    NSString *checkLevel = _checkLevel;
    NSString *description = _remarkTextView.text;
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[@"operationTime"] = operationTime;
    paraDict[@"accessToken"] = accessToken;
    paraDict[@"workNo"] = workNo;
    paraDict[@"targetGroupId"] = targetGroupId;
    paraDict[@"checkLevel"] = checkLevel;
    if ([checkLevel isEqualToString:@"不满意"]){
        paraDict[@"reason"] = _unsatisfiedReasonLabel.text;
    }
    paraDict[@"description"]  =description;
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/%@.json",ADDR_IP,ADDR_DIR,kSendCheckResult];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager POST:requestUrl parameters:paraDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        showAlert(responseObject[@"error"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        showAlert([error localizedDescription]);
    }];
}

@end
