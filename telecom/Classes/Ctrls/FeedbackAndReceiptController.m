//
//  FeedbackAndReceiptController.m
//  telecom
//
//  Created by SD0025A on 16/4/6.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//反馈/回单  控制器

#import "FeedbackAndReceiptController.h"
#import "FileModel.h"
#import "SelfImgeView.h"
#import "ImageAndVideoPicker.h"

#define FeedBackAndReceiptUrl @"Medium/orderXFH"
#define SelledAcceptUrl @"Trouble/orderAccept"
#define TestListFeedbackUrl @"Medium/testOrderReturn"
#define GetTestNoUrl  @"Medium/GettestNo"//获取测试单编号
@interface FeedbackAndReceiptController ()<ImageAndVideoPickerDelegate,DeleteBtnInImageViewDelegate,UITextViewDelegate>

@property (nonatomic,strong) NSMutableArray *fileArray;
@property (nonatomic,strong) ImageAndVideoPicker *picker;
@end

@implementation FeedbackAndReceiptController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(APP_W, 600);
    self.view.backgroundColor = [UIColor whiteColor];
    self.orderNumber.text = self.orderNo;
    self.handlePerson.text = UGET(U_NAME);
    if ([self.type isEqualToString:@"testList"]) {
        self.testListNum.text = @"测试单编号:";
        [self GetTestNumber];
    }
    
    [self createUI];
    
}
- (void)GetTestNumber
{
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[URL_TYPE] = GetTestNoUrl;
    param[@"workNo"] = self.workNo;
    httpGET2(param, ^(id result) {
        NSLog(@"%@",result);
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.orderNumber.text = result[@"return_data"];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(APP_W, 600);
}
//禁用IQKeyboard
- (void)viewDidAppear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

}
- (void)viewDidDisappear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
   
    
}
- (void)createUI
{
    if ([self.actionType isEqualToString:@"feedback"]) {
        self.navigationItem.title = @"反馈";
    }else if ([self.actionType isEqualToString:@"receipt"]) {
        self.navigationItem.title = @"回单";
    }else if ([self.actionType isEqualToString:@"accept"]) {
        self.navigationItem.title = @"响应";
    }
   
    //创建导航栏右边的btn
    UIButton *checkBtn = [[UIButton alloc] init];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"checkBtn"] forState:UIControlStateNormal];
    checkBtn.frame = CGRectMake(0, 0, 30, 30);
    [checkBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = checkItem;
    //textView  边框
    self.descriptionInfo.delegate = self;
    self.descriptionInfo.layer.borderWidth = 1;
    self.descriptionInfo.layer.borderColor = [UIColor grayColor].CGColor;
    self.descriptionInfo.alpha = 0.5;
    
    //给每个label赋值
    if ([self.actionType isEqualToString:@"receipt"]) {
        self.baseInfo.text = @"回单基本信息";
        self.replyInfo.text = @"回单回复信息";
    }
    if ([self.actionType isEqualToString:@"accept"]) {
        self.baseInfo.text = @"响应基本信息";
        self.replyInfo.text = @"响应回复信息";
    }
    //监听键盘的弹进弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    

}
#pragma mark - 键盘
//键盘的弹出
- (void)keyboardShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5 animations:^{
         self.view.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    }];
    if ([self.descriptionInfo.text isEqualToString:@"请输入描述信息"]) {
        self.descriptionInfo.text = nil;
        self.descriptionInfo.textColor = [UIColor blackColor];
    }
}
//弹进
- (void)keyboardHide:(NSNotification *)notification
{
  
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y+100);
    }];
    
}
#pragma mark - 发起提交
- (void)commit:(UIButton *)btn
{
    if (self.descriptionInfo.text == nil || [self.descriptionInfo.text isEqualToString:@"请输入描述信息"]) {
        showAlert(@"请输入操作描述！");
        return;
    }
    CGFloat fileLength = 0;
    for (FileModel *model in self.fileArray) {
        if (model.movieData) {
            fileLength  = fileLength + model.movieData.length;
            
        }else{
            NSData *data ;
            data = UIImageJPEGRepresentation(model.image, 1);
            if (data == nil) {
                data = UIImagePNGRepresentation(model.image);
            }
            fileLength = fileLength + data.length;
        }
    }
    CGFloat fileSize = fileLength/1024.00/1024.00;
    //NSLog(@"文件大小为%fM",fileLength/1024.00/1024.00);
    
    if (fileSize < 10) {
        NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"accessToken"] = accessToken;
        param[@"workNo"] = self.workNo;
        param[@"action"] = self.actionType;
        if ([self.descriptionInfo.text isEqualToString:@"请输入描述信息"]) {
            param[@"description"] = nil;
            self.descriptionInfo.text = nil;
        }else{
             param[@"description"] = self.descriptionInfo.text;
        }
        NSString *urlType ;
        if ([self.type isEqualToString:@"testList"]) {
            urlType = TestListFeedbackUrl;
        }else{
            if ([self.actionType isEqualToString:@"accept"]) {
                urlType = SelledAcceptUrl;
            }else{
                urlType = FeedBackAndReceiptUrl;
            }
 
        }
                AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, urlType] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (FileModel *model in self.fileArray) {
                if (model.movieData) {
                    [formData appendPartWithFileData:model.movieData name:@"attachment" fileName:[NSString stringWithFormat:@"%@.mp4",operationTime] mimeType:@"video/mp4"];
                    
                }else{
                    NSData *data ;
                    UIImage *originalImage = model.image;
                    if (nil == UIImagePNGRepresentation(originalImage)) {
                        data = UIImageJPEGRepresentation(originalImage, 1);
                    }else{
                        data = UIImagePNGRepresentation(originalImage);
                    }
                    [formData appendPartWithFileData:data name:@"attachment" fileName:[NSString stringWithFormat:@"%@.jpg",operationTime] mimeType:@"image/jpeg"];
                }
                
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            showAlert(responseObject[@"error"]);
            for (int i =0; i<self.fileArray.count; i++) {
                [[self.view viewWithTag:500+i] removeFromSuperview];
            }
            [self.navigationController  popViewControllerAnimated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            showAlert(error);
        }];
    }else{
        showAlert(@"上传文件不能超过10M，请重新选择！");
    }
   
}
#pragma mark -UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder]; return NO;
    }  return YES;
}

#pragma mark - 上传功能
- (IBAction)upLoadBtn:(UIButton *)sender {
   
    self.picker = [[ImageAndVideoPicker alloc ]init];
    self.picker.delegate  = self;
    self.picker.ctrl = self;
    [self.picker pickImageFromPhotos];
    
}

- (NSMutableArray *)fileArray
{
    if (nil == _fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}

#pragma mark - DeleteBtnInImageViewDelegate
- (void)deleteBtnInImageView:(SelfImgeView *)imgeView
{
    for (int i =0; i<self.fileArray.count; i++) {
        [[self.view viewWithTag:500+i] removeFromSuperview];
    }
    NSInteger index = imgeView.tag - 500;
    FileModel *model = self.fileArray[index];
    [self.fileArray removeObject:model];
    [self showImage];
}

#pragma mark - ImageAndVideoPickerDelegate
- (void)addImageFromTZI:(NSArray *)array
{
    for (UIImage *image in array) {
        FileModel *model = [[FileModel alloc] init];
        model.image = image;
        [self.fileArray addObject:model];

    }
    [self showImage];
    
}
- (void)addVedioFromTZI:(NSData *)movieData coverImage:(UIImage *)coverImage
{
     FileModel *model = [[FileModel alloc] init];
     model.image = coverImage;
     model.movieData = movieData;
    [self.fileArray addObject:model];
    [self showImage];
}
- (void)showImage
{
    for (int i=0; i<self.fileArray.count; i++) {
        int row  = i/3;
        int sec  = i%3;
        SelfImgeView *imageView = [[SelfImgeView alloc] initWithFrame:CGRectMake(self.upLoadBtn.frame.origin.x+70+sec*(60+10), self.upLoadBtn.frame.origin.y+row*(60+10), 60, 60)];
        FileModel *model = self.fileArray[i];
        UIImage *image = model.image;
        imageView.delegate = self;
        imageView.image = image;
        imageView.tag = 500+i;
        [self.scrollView addSubview:imageView];
    }

}
@end
