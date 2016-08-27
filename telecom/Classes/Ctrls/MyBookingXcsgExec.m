

//
//  MyBookingXcsgExec.m
//  telecom
//
//  Created by ZhongYun on 15-1-3.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

//
//  MyBookingXcsgExec.m
//  telecom
//
//  Created by ZhongYun on 15-1-3.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyBookingXcsgExec.h"
#import "CompAlertBox.h"
#import "NSThread+Blocks.h"
#import "ZYQAssetPickerController.h"
#import "MyBookingEvaluateController.h"
#import "MyBookingEvaluateController.h"

#define ROW_H           55
#define ROW_E           26
#define LINE_E          7
#define TITLE_H         48

#define TAG_BTN_EXEC    2310
#define TAG_BTN_CANCEL  2320

#define TAG_BGN_DATE_VLU    2201
#define TAG_BGN_DATE_BTN    2202
#define TAG_BGN_TIME_VLU    2203
#define TAG_BGN_TIME_BTN    2204
#define TAG_END_DATE_VLU    2205
#define TAG_END_DATE_BTN    2206
#define TAG_END_TIME_VLU    2207
#define TAG_END_TIME_BTN    2208
#define TAG_TEXT_USER       2214
#define TAG_SWITCH_FLAG     2215
#define TAG_TEXT_DESC       2216

#define kImageCol 4
#define kImageWH  65

@interface MyBookingXcsgExec ()<UITextFieldDelegate, UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate,UIAlertViewDelegate>
{
        AlertBox* m_datePicker1;
        AlertBox* m_datePicker2;
        AlertBox* m_timePicker1;
        AlertBox* m_timePicker2;
    
    UIView* m_banInfo;
    UIView* m_banList;
    UIView *_attachmentBan;
    UIScrollView* m_scroll;
    
    NSString *_endFlag;
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    NSMutableArray *imageNameArr;
    
    UIView *_bottomView;
    NSString *strTel;
    
    UIView *_showMoreInfoView;
}
@end

@implementation MyBookingXcsgExec

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect rect = m_scroll.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:7];
    rect.size.height -= 297;
    m_scroll.frame = rect;
    [m_scroll scrollRectToVisible:CGRectMake(textField.frame.origin.x + _showMoreInfoView.frame.origin.x + m_banInfo.frame.origin.x, textField.frame.origin.y + _showMoreInfoView.frame.origin.y + m_banInfo.frame.origin.y, textField.frame.size.width, textField.frame.size.height) animated:YES];
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    CGRect rect = m_scroll.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
    [UIView setAnimationCurve:7];
    rect.size.height += 297;
    m_scroll.frame = rect;
    
    [UIView commitAnimations];
    
    
}

- (void)leftAction
{
    
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageNameArr = [[NSMutableArray alloc]initWithCapacity:10];
    imageDataUrlArr = [[NSMutableArray alloc]initWithCapacity:10];
    imgArr = [[NSMutableArray alloc]initWithCapacity:10];
    

    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width),
                                                              (NAV_H-checkIcon.size.height)/2,
                                                              checkIcon.size.width, checkIcon.size.height)];
    [checkBtn setBackgroundImage:checkIcon forState:0];
    [checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    //    [self initDatePickers];
    
    self.title = (self.opType == 1 ? @"随工任务执行" : @"随工任务取消");
        if ([self.title isEqualToString:@"随工任务执行"]) {
            checkBtn.hidden=YES;
        }
    
    m_scroll = [[UIScrollView alloc] initWithFrame:RECT(0, self.navBarView.ey, APP_W, SCREEN_H-self.navBarView.ey)];
    m_scroll.contentSize = m_scroll.bounds.size;
    m_scroll.userInteractionEnabled = YES;
    m_scroll.showsVerticalScrollIndicator = NO;
    m_scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:m_scroll];
    
    m_banInfo = [self newBannerView:15 :640 :@"任务详情"];
    [self addBanInfoObjs];
    
    if (self.opType == 1) {
        m_banList = [self newBanner:2100 PosY:m_banInfo.ey+15 RowCount:2];
        [self addBanEditObjs1];
        //上传附件
        _attachmentBan = [self newBannerView:m_banList.ey + 15 :48+5+kImageWH+5 :@"附件上传"];
        [self addAttachmentWithImageArray:nil];
        //开始执行\结束执行按钮
        [self addBtn];
        NSLog(@"%@",_task);
        //添加显示更多按钮
        if ([[_task objectForKey:@"status"] isEqualToString:@"开始执行"]) {
            [self addShowMoreButton];
        }
        
    } else {
        m_banList = [self newBannerView:m_banInfo.ey+15 :200 :@"取消原因"];
        [self addBanEditObjs2];
    }
    
    [self updateLabels:self.task];
    
    if (self.opType == 1) {
        
    }else{
        m_scroll.contentSize = CGSizeMake(APP_W, m_banList.ey+15);
    }
    
    NSString *isBegin = UGET(@"isBegin");
    if ([isBegin isEqualToString:@"YES"]) {
        UIButton *beginBtn = (UIButton *)[m_scroll viewWithTag:TAG_BTN_EXEC];
        [beginBtn setTitle:date2str([NSDate date], @"yyyy-MM-dd HH") forState:UIControlStateNormal];
        beginBtn.titleLabel.font  = [UIFont systemFontOfSize:15.0f];
        beginBtn.enabled = NO;
    }else{
        UIButton *endBtn = (UIButton *)[m_scroll viewWithTag:TAG_BTN_CANCEL];
        [endBtn setTitle:date2str([NSDate date], @"yyyy-MM-dd HH") forState:UIControlStateNormal];
        endBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        endBtn.enabled = NO;
    }
    
}

#pragma mark -- 显示更多
- (void)addShowMoreButton
{
    UIButton *showMoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
    showMoreButton.frame = CGRectMake(30, 610, kScreenWidth - 80, 28);
    [showMoreButton setTitle:@"点击显示更多" forState:UIControlStateNormal];
    [showMoreButton setTitle:@"点击收起" forState:UIControlStateSelected];
    [showMoreButton addTarget:self action:@selector(showMoreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [m_banInfo addSubview:showMoreButton];
}

- (void)showMoreButtonClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    CGRect rect_banInfo = m_banInfo.frame;
    CGRect rect_banList = m_banList.frame;
    CGSize size_scrollView = m_scroll.contentSize;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.25];
    if (sender.selected) {
        rect_banInfo.size.height += 154;
        rect_banList.origin.y += 154;
        size_scrollView.height += 154;
        for (int i = 1; i < m_scroll.subviews.count; i++) {
            CGRect rect = m_scroll.subviews[i].frame;
            rect.origin.y += 154;
            m_scroll.subviews[i].frame = rect;
        }
        if (_showMoreInfoView == nil) {
            [self addShowMoreInfoView];
        }
        
        [m_banInfo addSubview:_showMoreInfoView
         ];
    }else{
        for (int i = 1; i < m_scroll.subviews.count; i++) {
            CGRect rect = m_scroll.subviews[i].frame;
            rect.origin.y -= 154;
            m_scroll.subviews[i].frame = rect;
        }

        rect_banInfo.size.height -= 154;
        rect_banList.origin.y -= 154;
        size_scrollView.height -= 154;
        [_showMoreInfoView removeFromSuperview];
    }
    m_banInfo.frame = rect_banInfo;
    m_banList.frame = rect_banList;
    m_scroll.contentSize = size_scrollView;
    [UIView commitAnimations];
}


- (void)addShowMoreInfoView
{
    
    _showMoreInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 640, kScreenWidth, 154)];
    [m_banInfo addSubview:_showMoreInfoView];
    
    UILabel *label_projectComplexityLevel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 75, 20)];
    label_projectComplexityLevel.font = FontB(Font3);
    label_projectComplexityLevel.textColor = RGB(0x2f2f2f);
    label_projectComplexityLevel.text = @"难度等级：";
    [_showMoreInfoView addSubview:label_projectComplexityLevel];
    
    UITextField *textField_projectComplexityLevel = [[UITextField alloc] initWithFrame:CGRectMake(80, 9, kScreenWidth - 110, 26)];
    textField_projectComplexityLevel.borderStyle = UITextBorderStyleRoundedRect;
    textField_projectComplexityLevel.delegate = self;
    textField_projectComplexityLevel.font = [UIFont systemFontOfSize:14];
    textField_projectComplexityLevel.tag = 501;
    textField_projectComplexityLevel.text = [_task objectForKey:@"level"];
    [_showMoreInfoView addSubview:textField_projectComplexityLevel];
    
    UILabel *label_costTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 48, kScreenWidth - 40, 20)];
    label_costTime.font = FontB(Font3);
    label_costTime.textColor = RGB(0x2f2f2f);
    label_costTime.text = @"经验耗时：";
    [_showMoreInfoView addSubview:label_costTime];
    
    
    UITextField *textField_costTime = [[UITextField alloc] initWithFrame:CGRectMake(80, 47, kScreenWidth - 110, 26)];
    textField_costTime.borderStyle = UITextBorderStyleRoundedRect;
    textField_costTime.font = [UIFont systemFontOfSize:14];
    textField_costTime.tag = 502;
    textField_costTime.delegate = self;
    textField_costTime.text = [_task objectForKey:@"costTime"];
    [_showMoreInfoView addSubview:textField_costTime];
    
    
    UILabel *label_score = [[UILabel alloc] initWithFrame:CGRectMake(10, 86, kScreenWidth - 100, 20)];
    label_score.font = FontB(Font3);
    label_score.textColor = RGB(0x2f2f2f);
    label_score.text = @"积      分：";
    [_showMoreInfoView addSubview:label_score];
    
    UITextField *textField_score = [[UITextField alloc] initWithFrame:CGRectMake(80, 85, kScreenWidth - 110, 26)];
    textField_score.borderStyle = UITextBorderStyleRoundedRect;
    textField_score.font = [UIFont systemFontOfSize:14];
    textField_score.tag = 503;
    textField_score.delegate = self;
    textField_score.text = [_task objectForKey:@"score"];
    [_showMoreInfoView addSubview:textField_score];
    
    
    
    UILabel *label_skillRequire = [[UILabel alloc] initWithFrame:CGRectMake(10, 124, kScreenWidth - 40, 20)];
    label_skillRequire.font = FontB(Font3);
    label_skillRequire.textColor = RGB(0x2f2f2f);
    label_skillRequire.text = @"技能要求：";
    [_showMoreInfoView addSubview:label_skillRequire];
    
    
    UITextField *textField_skillRequire = [[UITextField alloc] initWithFrame:CGRectMake(80, 123, kScreenWidth - 110, 26)];
    textField_skillRequire.borderStyle = UITextBorderStyleRoundedRect;
    textField_skillRequire.font = [UIFont systemFontOfSize:14];
    textField_skillRequire.tag = 504;
    textField_skillRequire.delegate = self;
    textField_skillRequire.text = [_task objectForKey:@"skill"];
    [_showMoreInfoView addSubview:textField_skillRequire];
}

//加附件
- (void)addAttachmentWithImageArray:(NSArray *)imageArray
{
    for (UIView *view in _bottomView.subviews) {
        [view removeFromSuperview];
    }
    
    [_bottomView removeFromSuperview];
    _bottomView = nil;
    
    _bottomView = [[UIView alloc] initWithFrame:RECT(0, 48, _attachmentBan.fw, kImageWH+5)];
    _bottomView.backgroundColor = [UIColor clearColor];
    _bottomView.userInteractionEnabled = YES;
    [_attachmentBan addSubview:_bottomView];
    
    
    if (imageArray) {
        NSInteger count = imageArray.count;
        int space = (_bottomView.fw - kImageCol*kImageWH) / (kImageCol+1);
        for (int i=0; i<count+1; i++) {
            int row = i / kImageCol;
            int col = i % kImageCol;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT(space+(kImageWH+space)*col, space+(kImageWH+space)*row, kImageWH, kImageWH)];
            imageView.userInteractionEnabled = YES;
            [_bottomView addSubview:imageView];
            
            if (i<count) {
                UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:RECT(-8, -8, 16, 16)];
                deleteImageView.tag = 90000+i;
                deleteImageView.userInteractionEnabled = YES;
                deleteImageView.image = [UIImage imageNamed:@"delete-circular.png"];
                [imageView addSubview:deleteImageView];
                
                [deleteImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)]];
                imageView.image = imageArray[i];
            }else{
                imageView.image = [UIImage imageNamed:@"add.png"];
                [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)]];
            }
        }
        
        int rowNum = ((imageArray.count+1)%4==0) ? (imageArray.count+1)/4 : (imageArray.count+1)/4+1;
        UIButton *btn2 = (UIButton *)[m_scroll viewWithTag:TAG_BTN_EXEC];
        UIButton *btn3 = (UIButton *)[m_scroll viewWithTag:TAG_BTN_CANCEL];
        
        [UIView animateWithDuration:0.3f animations:^{
            [_bottomView setFh:(kImageWH + space)*rowNum + space];
            [_attachmentBan setFh:48+_bottomView.fh];
            btn2.fy = _attachmentBan.ey+15;
            btn3.fy = _attachmentBan.ey+15;
            m_scroll.contentSize = CGSizeMake(APP_W, btn3.ey+10);
        }];
        
    }else{
        UIImageView *addImageBtn = [[UIImageView alloc] initWithFrame:RECT(5, 5, kImageWH, kImageWH)];
        addImageBtn.image = [UIImage imageNamed:@"add.png"];
        addImageBtn.userInteractionEnabled = YES;
        [_bottomView addSubview:addImageBtn];
        
        [addImageBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)]];
    }
}

- (void)deleteImage:(UITapGestureRecognizer *)ges
{
    UIView *view = ges.view;
    NSInteger index = view.tag - 90000;
    [imgArr removeObjectAtIndex:index];
    
    for (UIView *view in _bottomView.subviews) {
        [view removeFromSuperview];
    }
    
    [self addAttachmentWithImageArray:imgArr];
}

- (void)addImage
{
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [chooseImageSheet showInView:self.view];
}

#pragma mark -照片功能
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://拍照
        {
            [self takePhoto];
            break;
        }
            
        case 1://本地相册
        {
            [self LocalPhoto];
            break;
        }
        default:
            break;
    }
}

//从相册选择
-(void)LocalPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    //    picker.maximumNumberOfSelection = 4-imgArr.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 4-imgArr.count;
        } else {
            return YES;
        }
        
    }];
    
    [self presentViewController:picker animated:NO completion:NULL];
}

//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        //        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:NO];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

#pragma mark - ZYQAssetPickerControllerDelegate
- (void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (ALAsset *asset in assets) {
        UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        NSString *imageName = asset.defaultRepresentation.filename;
        
        [self saveImage:image WithName:imageName];
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)assetPickerControllerDidCancel:(ZYQAssetPickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd-hh:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *imageName = [NSString stringWithFormat:@"%@.png",dateString];
    [self saveImage:originalImage WithName:imageName];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -保存图片的路径
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSURL *url = [NSURL fileURLWithPath:fullPathToFile];
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    [imgArr addObject:tempImage];
    [imageDataUrlArr addObject:url];
    
    [self addAttachmentWithImageArray:imgArr];
}

//开始执行和结束执行
- (void)addBtn
{
    UIButton* btn2 = [[UIButton alloc] initWithFrame:RECT(10, _attachmentBan.ey + 15, (APP_W-40)/2, 40)];
    [btn2 setBackgroundImage:color2Image(COLOR(74, 130, 198)) forState:0];
    [btn2 addTarget:self action:@selector(onBeginExceuteBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    btn2.layer.cornerRadius = 5;
    btn2.clipsToBounds = YES;
    btn2.tag = TAG_BTN_EXEC;
    [btn2 setTitle:@"开始执行" forState:0];
    [btn2 setTitleColor:[UIColor whiteColor] forState:0];
    btn2.titleLabel.font = FontB(Font0);
    [m_scroll addSubview:btn2];
    
    UIButton* btn3 = [[UIButton alloc] initWithFrame:RECT(btn2.ex+20, _attachmentBan.ey + 15, (APP_W-40)/2, 40)];
    [btn3 setBackgroundImage:color2Image(COLOR(0, 165, 78)) forState:0];
    [btn3 addTarget:self action:@selector(onEndExceuteBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    btn3.layer.cornerRadius = 5;
    btn3.clipsToBounds = YES;
    btn3.tag = TAG_BTN_CANCEL;
    [btn3 setTitle:@"结束执行" forState:0];
    [btn3 setTitleColor:[UIColor whiteColor] forState:0];
    btn3.titleLabel.font = FontB(Font0);
    [m_scroll addSubview:btn3];
    
    m_scroll.contentSize = CGSizeMake(APP_W, btn3.ey+10);
}



- (void)onBeginExceuteBtnTouched:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你是否要开始执行此任务?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 4444;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 4444) {
        if (buttonIndex == 1) {
            [self beginTask];
        }
    }
    
    if (alertView.tag == 5555) {
        if (buttonIndex == 1) {
            [self endTask];
        }
    }
    
    if (alertView.tag == 6666) {
        if (buttonIndex == 1) {
            [self dianping];
        }
    }
}

- (void)beginTask
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"MyTask/WithWork/TaskCommit";
    
    NSString* strDate1 = date2str([NSDate date], @"HH");
    paraDict[@"startTime"] = strDate1;
    paraDict[@"startDate"] = date2str([NSDate date], @"yyyy-MM-dd");
    
    paraDict[@"appointmentId"] = self.task[@"appointmentId"];
    NSString *constuctor = tagViewEx(self.view, TAG_TEXT_USER, UITextField).text;
    
    if (constuctor == nil || [constuctor isEqualToString:@""]) {
        showAlert(@"请输入随工人员");
        
    }else{
        paraDict[@"constructor"] = constuctor;
        paraDict[@"executeMark"] = @"0";
        paraDict[@"flag"] = @"0";
        
        
        httpPOST2(paraDict, ^(id result) {
            USET(@"isBegin", @"YES");
            USET(@"executeId", result[@"executeId"]);
            showAlert(@"任务开始执行");
            if (!_showMoreInfoView) {
                [self addShowMoreButton];
            }
            
            UILabel *label = [m_banInfo viewWithTag:211];
            label.text = @"开始执行";
            CGRect rect = label.frame;
            rect.size.width += 20;
            label.frame = rect;
            
            UIButton *beginBtn = (UIButton *)[m_scroll viewWithTag:TAG_BTN_EXEC];
            [beginBtn setTitle:date2str([NSDate date], @"yyyy-MM-dd HH") forState:UIControlStateNormal];
            beginBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            beginBtn.enabled = NO;
            
            UIButton *endBtn = (UIButton *)[m_scroll viewWithTag:TAG_BTN_CANCEL];
            [endBtn setTitle:@"结束执行" forState:UIControlStateNormal];
            endBtn.enabled = YES;
        }, ^(id result) {
            NSLog(@"%@",result);
            showAlert(@"开始执行任务失败");
        });
    }
    
}

- (void)onEndExceuteBtnTouched:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你是否要结束执行此任务?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 5555;
    [alertView show];
}

- (void)endTask
{
    NSString* strDate2 = date2str([NSDate date], @"HH");
    
    NSString *endDate = date2str([NSDate date], @"yyyy-MM-dd");
    
    NSString* flag = (tagViewEx(self.view, TAG_SWITCH_FLAG, UISwitch).on ? @"1" : @"0");
    
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    
    NSString *constuctor = tagViewEx(self.view, TAG_TEXT_USER, UITextField).text;
    
    if (constuctor == nil || [constuctor isEqualToString:@""]) {
        showAlert(@"请输入随工人员");
    }else{
       /* NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/MyTask/WithWork/TaskCommit.json?operationTime=%@&accessToken=%@&appCode=%@&appointmentId=%@&endDate=%@&endTime=%@&executeMark=%@&flag=%@&executeId=%@&constructor=%@",ADDR_IP,ADDR_DIR,operationTime,accessToken,@"10000",self.task[@"appointmentId"],endDate,strDate2,@"1",flag,UGET(@"executeId"),constuctor];*/
         NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/MyTask/WithWork/TaskCommit.json?",ADDR_IP,ADDR_DIR];
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[@"operationTime"] = operationTime;
        paraDict[@"accessToken"] = accessToken;
        paraDict[@"appCode"] = @"10000";
        paraDict[@"appointmentId"] = self.task[@"appointmentId"];
        paraDict[@"endDate"] = endDate;
        
        paraDict[@"endTime"] = strDate2;
        paraDict[@"executeMark"] = @"1";
        paraDict[@"flag"] = flag;
        paraDict[@"executeId"] = UGET(@"executeId");
        paraDict[@"constructor"] = constuctor;
        
        UITextField *textField = (UITextField *)[m_scroll viewWithTag:501];
        paraDict[@"level"] = textField.text;
        
        textField = (UITextField *)[m_scroll viewWithTag:502];
        paraDict[@"costTime"] = textField.text;
        
        textField = (UITextField *)[m_scroll viewWithTag:503];
        paraDict[@"score"] = textField.text;
        
        textField = (UITextField *)[m_scroll viewWithTag:504];
        paraDict[@"skill"] = textField.text;
        
        NSLog(@"%@",paraDict);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager POST:requestUrl parameters:paraDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (int i = 0; i < imageDataUrlArr.count; i++) {
                if (imageDataUrlArr.count == 0) {
                }else{
                    NSURL *imgUrl = [imageDataUrlArr objectAtIndex:i];
                    [formData appendPartWithFileURL:imgUrl name:[NSString stringWithFormat:@"image%d",i] error:nil];
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject[@"result"] isEqualToString:@"0000000"]) {
                
                USET(@"isBegin", nil);
                
                UIButton *beginBtn = (UIButton *)[m_scroll viewWithTag:TAG_BTN_EXEC];
                [beginBtn setTitle:@"开始执行" forState:UIControlStateNormal];
                beginBtn.enabled = YES;
                
                UIButton *endBtn = (UIButton *)[m_scroll viewWithTag:TAG_BTN_CANCEL];
                [endBtn setTitle:date2str([NSDate date], @"yyyy-MM-dd HH") forState:UIControlStateNormal];
                endBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                endBtn.enabled = NO;
                
                if ([_endFlag isEqualToString:@"1"]) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeWorkOrder" object:self];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此条任务已执行完成,是否要点评?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    alertView.tag = 6666;
                    [alertView show];
                }else{
                    showAlert(@"任务结束执行");
                    UILabel *label = [m_banInfo viewWithTag:211];
                    label.text = @"执行中";
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            showAlert([error localizedDescription]);
        }];
    }
    //    tagViewEx(ban,TAG_TEXT_USER);
    
    
    
}

#pragma mark - 点评
- (void)dianping
{
    MyBookingEvaluateController *evaluateCtrl = [[MyBookingEvaluateController alloc] init];
    evaluateCtrl.taskDict = self.task;
    [self.navigationController pushViewController:evaluateCtrl animated:YES];
    
}

- (void)onCheckBtnTouched:(id)sender
{
//    [self dianping];
    
    if (self.opType == 1) {
//            if (![self checkInputParams]) {
//                return;
//            }
            NSString* strDate1 = date2str(((UIDatePicker*)m_timePicker1.contentView).date, @"HH");
            NSString* strDate2 = date2str(((UIDatePicker*)m_timePicker2.contentView).date, @"HH");
            NSString* flag = (tagViewEx(self.view, TAG_SWITCH_FLAG, UISwitch).on ? @"1" : @"0");

            NSDictionary* param = @{URL_TYPE:NW_TaskCommit,
                                    @"appointmentId":self.task[@"appointmentId"],
                                    @"startDate":tagViewEx(self.view, TAG_BGN_DATE_VLU, UILabel).text,
                                    @"startTime":strDate1,
                                    @"endDate":tagViewEx(self.view, TAG_END_DATE_VLU, UILabel).text,
                                    @"endTime":strDate2,
                                    @"constructor":tagViewEx(self.view, TAG_TEXT_USER, UILabel).text,
                                    @"flag":flag};
            httpGET1(param, ^(id result) {
                showAlert(@"任务执行记录添加成功");
                [self.navigationController popToViewController:self.listVC animated:YES];
            });
    } else if (self.opType == 2) {
        NSString* desc = tagViewEx(self.view, TAG_TEXT_DESC, UITextView).text;
        if (desc.length == 0) {
            showAlert(@"请填写取消原因！");
            return ;
        }
        
        NSDictionary* param = @{URL_TYPE:NW_TaskCancel,
                                @"appointmentId":self.task[@"appointmentId"],
                                @"cancelReason":desc};
        
        
        httpPOST(param, ^(id result) {
            if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
                showAlert(@"任务取消成功");
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
                
            }
        }, ^(id result) {
            NSLog(@"%@",result);
            
        });
    }
}

- (UIView*)newBanner:(NSInteger)tag PosY:(CGFloat)y RowCount:(NSInteger)count
{
    UIView* banner = [[UIView alloc] initWithFrame:RECT(10, y, APP_W-20, ROW_H*count)];
    banner.tag = tag;
    banner.backgroundColor = [UIColor whiteColor];
    banner.layer.borderColor = COLOR(190, 190, 190).CGColor;
    banner.layer.borderWidth = 0.5;
    banner.layer.cornerRadius = 3;
    //showShadow(banner, CGSizeMake(1, 1));
    [m_scroll addSubview:banner];
    
    NSInteger lineNum = count - 1;
    for (int i = 0; i < lineNum; i++) {
        UIView* line = [[UIView alloc] init];
        line.frame = RECT(2, ROW_H*(i+1), banner.fw-4, 0.5);
        line.backgroundColor = COLOR(221, 221, 221);
        [banner addSubview:line];
    }
    
    return [self.view viewWithTag:tag];
}

- (UIView*)newBannerView:(CGFloat)pos_y :(CGFloat)height :(NSString*)title
{
    UIView* banner = [[UIView alloc] initWithFrame:RECT(10, pos_y, APP_W-20, height)];
    banner.backgroundColor = [UIColor whiteColor];
    banner.userInteractionEnabled = YES;
    banner.layer.borderColor = COLOR(190, 190, 190).CGColor;
    banner.layer.borderWidth = 0.5;
    banner.layer.cornerRadius = 3;
    [m_scroll addSubview:banner];
    
    if (title != NULL) {
        newLabel(banner, @[@10, RECT_OBJ(10, (TITLE_H-Font1)/2, 120, Font1), RGB(0xff6d45), FontB(Font1), title]);
    }
    
    UIView* line = [[UIView alloc] initWithFrame:RECT(0, TITLE_H, banner.fw, 0.5)];
    line.backgroundColor = COLOR(221, 221, 221);
    [banner addSubview:line];
    
    return banner;
}

- (void)addBanInfoObjs
{
    int ttag = 100, vtag = 200;
    CGFloat pos_y = (TITLE_H + 14);
    UILabel* title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"工程编号："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"工程名称："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"随工时间："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"随工内容："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"工程数量："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"特殊要求："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"施工单位："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 100, Font3), RGB(0x2f2f2f), FontB(Font3), @"工程联系人："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 120, Font3), RGB(0x2f2f2f), FontB(Font3), @"施工人联系电话："]);
    //    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(title.ex, pos_y-10, m_banInfo.fw-10-title.ex, Font3*3)];
    textView.tag = 888;
    textView.font = [UIFont systemFontOfSize:Font3];
    textView.textColor = RGB(0x2f2f2f);
    textView.text = @"";
    textView.dataDetectorTypes = UIDataDetectorTypeAll;
    if([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        
    {
        
        textView.selectable = YES;//用法：决定UITextView 中文本是否可以相应用户的触摸，主要指：1、文本中URL是否可以被点击；2、UIMenuItem是否可以响应
        
    }
    textView.editable = NO;
    vtag++;
    [m_banInfo addSubview:textView];
    pos_y += ( textView.frame.size.height); //2015.4.25号更换
//    pos_y += (Font3 + textView.frame.size.height);
//    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 100, Font3), RGB(0x2f2f2f), FontB(Font3), @"施工审核人："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 100, Font3), RGB(0x2f2f2f), FontB(Font3), @"客保工单编号："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"随工状态："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"监护人员："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    pos_y += (Font3 + ROW_E);
    title = newLabel(m_banInfo, @[@(ttag++), RECT_OBJ(10, pos_y, 70, Font3), RGB(0x2f2f2f), FontB(Font3), @"随工地点："]);
    newLabel(m_banInfo, @[@(vtag++), RECT_OBJ(title.ex, pos_y, m_banInfo.fw-10-title.ex, Font3*2+LINE_E), RGB(0x2f2f2f), FontB(Font3), @""]);
    
    
}

//- (void)updateLabels:(NSDictionary*)info
//{
//    int vtag = 200;
//    
//    //    工程编号
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"projectNo"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    工程名称
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"projectName"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    随工时间
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskTime"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    随工内容
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"reason"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    工程数量
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"projectNum"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    特殊要求
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskInfo"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    施工单位
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskCompany"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    工程联系人
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"constructor"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    施工人联系电话
//    if (vtag == 208) {
//        
//        NSString *str = [NSString stringWithFormat:@"%@",NoNullStr(info[@"constructorMobile"])];
//        strTel = [str
//                  stringByReplacingOccurrencesOfString:@"," withString:@" "];
//        tagViewEx(m_banInfo, vtag, UILabel).hidden = YES;
//        tagViewEx(m_banInfo, 888, UITextView).text = strTel;
//        [tagViewEx(m_banInfo, 888, UITextView) sizeToFit];
//        vtag++;
//    }
//    
//    //    施工审核人
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"examinedPeople"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    客保工单编号
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"kbNo"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    随工状态
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"status"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    监护人员
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"executeUserName"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    //    随工地点
//    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskAddress"]);
//    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
//    
//    
//}
- (void)updateLabels:(NSDictionary*)info
{
    int vtag = 200;
    //    工程编号
    UILabel *temp =tagViewEx(m_banInfo, vtag, UILabel);
    temp.text = NoNullStr(info[@"projectNo"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    temp.height=Font3;
    
    //    工程名称
    UILabel *tempName =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"projectName"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempName.height=Font3;
    //    随工时间
    UILabel *tempTime =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskTime"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempTime.height=Font3;
    //    随工内容
    UILabel *tempContent =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"reason"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempContent.height=Font3;
    
    //    工程数量
    UILabel *tempNumber =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"projectNum"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempNumber.height = Font3;
    //    特殊要求
    UILabel *tempYaoQiu =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskInfo"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempYaoQiu.height = Font3;
    //    施工单位
    UILabel *tempComp =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskCompany"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempComp.height = Font3;
    //    工程联系人
    UILabel *tempPhone =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"constructor"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempPhone.height = Font3;
    //    施工人联系电话
    //之前注释掉了  2016.4.25号打开
    UILabel *tempPhoneNumber =tagViewEx(m_banInfo, vtag, UILabel);
    //        tagViewEx(m_banInfo, vtag, UITextView).text = NoNullStr(info[@"constructorMobile"]);
    //        [tagViewEx(m_banInfo, vtag++, UITextView) sizeToFit];
    tempPhoneNumber.height = Font3;
    if (vtag == 208) {
        NSString *str = [NSString stringWithFormat:@"%@",NoNullStr(info[@"constructorMobile"])];
        strTel = [str
                  stringByReplacingOccurrencesOfString:@"," withString:@" "];
        tagViewEx(m_banInfo, vtag, UILabel).hidden = YES;
        
        tagViewEx(m_banInfo, 888, UITextView).text = strTel;
        [tagViewEx(m_banInfo, 888, UITextView) sizeToFit];
        vtag++;
    }
    NSLog(@"%@",info);
    
    //    施工审核人[3]	(null)	@"executeUserName" : @"张仕波"	[13]	(null)	@"examinedPeople" : @"张仕波"
    UILabel *tempPerson =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"examinedPeople"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempPerson.height = Font3;
    
    //    客保工单编号
    UILabel *tempGongNumber =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"kbNo"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempGongNumber.height = Font3;
    
    //    随工状态
    UILabel *tempStates =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"status"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempStates.height = Font3;
    
    //    监护人员
    UILabel *tempJianPerson =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"executeUserName"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempJianPerson.height = Font3;
    
    //    随工地点
    UILabel *tempSuiAddress =tagViewEx(m_banInfo, vtag, UILabel);
    tagViewEx(m_banInfo, vtag, UILabel).text = NoNullStr(info[@"taskAddress"]);
    [tagViewEx(m_banInfo, vtag++, UILabel) sizeToFit];
    tempSuiAddress.height = Font3;
}

- (void)addBanEditObjs1
{
    CGFloat btag = 100;
    UIView* ban = m_banList;
    
    CGFloat pos_y = ROW_H*0;
    UILabel* lbt = newLabel(ban, @[@(btag++), RECT_OBJ(10, pos_y+(ROW_H-Font2)/2, ban.fw/2, Font2), [UIColor blackColor], FontB(Font2), @"随工人员"]);
    newTextField(ban, @[@(TAG_TEXT_USER), RECT_OBJ(80, pos_y+2, ban.fw-88, ROW_H-4), COLOR(69, 69, 69), FontB(Font3), @"请填写随工人员", @""]);
    
    pos_y = ROW_H*1;
    
    lbt = newLabel(ban, @[@(btag++), RECT_OBJ(10, pos_y+(ROW_H-Font3)/2, 180, Font3), COLOR(69, 69, 69), FontB(Font3), @"是否最后一次执行任务："]);
    [lbt sizeToFit];
    
    UISwitch* stateSwitch = [[UISwitch alloc] init];
    stateSwitch.tag = TAG_SWITCH_FLAG;
    stateSwitch.frame = RECT(lbt.ex+20, pos_y+(ROW_H-stateSwitch.fh)/2, stateSwitch.fw, stateSwitch.fh);
    [stateSwitch addTarget: self action:@selector(onSwithChanged:) forControlEvents:UIControlEventValueChanged];
    stateSwitch.on = NO;
    _endFlag = @"0";
    [stateSwitch setOnTintColor:RGB(0x0090ff)];
    [ban addSubview:stateSwitch];
}


- (void)addBanEditObjs2
{
    CGFloat pos_y = (TITLE_H);
    newTextView(m_banList, @[@(TAG_TEXT_DESC), RECT_OBJ(10, pos_y+10, m_banList.fw-20, m_banList.fh-pos_y-20), COLOR(69, 69, 69), FontB(Font3), @"", @""]).backgroundColor = RGB(0xe6ede7);
}

- (void)onSwithChanged:(UISwitch*)sender
{
    if (sender.on) {
        _endFlag = @"1";
    }else{
        _endFlag = @"0";
    }
}


@end

