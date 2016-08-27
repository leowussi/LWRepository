//
//  SelledFaultFeedbackViewController.m
//  telecom
//
//  Created by SD0025A on 16/4/8.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//售后故障单  售后反馈 页面

#import "SelledFaultFeedbackViewController.h"
#import "SelfImgeView.h"
#import "ImageAndVideoPicker.h"
#import "FileModel.h"
//售后  反馈
#define selledFeedbackUrl             @"Trouble/SaleTroubleF"
#define GetStationUrl                @"Trouble/getStation"

@interface SelledFaultFeedbackViewController ()<ImageAndVideoPickerDelegate,DeleteBtnInImageViewDelegate,UITextViewDelegate>

@property (nonatomic,strong) NSMutableArray *stationArray;
@property (nonatomic,strong) UIView *chooseView;
@property (nonatomic,copy)  NSString *idSr;
@property (nonatomic,strong) NSString *groupId;

@property (nonatomic,strong) NSMutableArray *fileArray;


@property (nonatomic,strong) ImageAndVideoPicker *picker;
@end

@implementation SelledFaultFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.userInteractionEnabled = YES;
    self.textView.delegate = self;
    self.label1.text = self.orderNO;
    self.label2.text = UGET(U_NAME);
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
    self.chooseLabel.userInteractionEnabled = YES;
    [self.chooseLabel addGestureRecognizer:ges];
    [self createNav];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    self.scrollView.contentSize = CGSizeMake(APP_W, 650);
}
- (void)getStation
{
    [self.stationArray removeAllObjects];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"workNo"] = self.workNo;
    param[URL_TYPE] = GetStationUrl;
    httpGET2(param, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary *)result;
            NSArray * array = (NSArray *)dict[@"return_data"];
            [self.stationArray addObjectsFromArray:array];
        }
        self.chooseView = [[UIView alloc] initWithFrame:CGRectMake(self.chooseLabel.frame.origin.x, self.chooseLabel.frame.origin.y+25, self.chooseLabel.bounds.size.width, self.chooseLabel.bounds.size.height*self.stationArray.count)];
        self.chooseView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:self.chooseView];
        //创建btn
        for (int i = 0; i<self.stationArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, self.chooseLabel.bounds.size.height*i, self.chooseLabel.bounds.size.width, self.chooseLabel.bounds.size.height);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            NSDictionary *dict = self.stationArray[i];
            [btn setTitle:dict[@"groupName"] forState:UIControlStateNormal];
            
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [btn addTarget:self action:@selector(chooseBtn:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = 600+i;
            [btn addTarget:self action:@selector(buttonBackGroundHighlighted:) forControlEvents:UIControlEventTouchDown];
            [self.chooseView addSubview:btn];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });

}
//设置高亮状态的背景颜色
- (void)buttonBackGroundHighlighted:(UIButton *)btn
{
    btn.backgroundColor = [UIColor greenColor];
}
- (void)tapLabel:(UITapGestureRecognizer *)ges
{
   //点击chooseLabel的手势
   [self getStation];
    
}
- (void)chooseBtn:(UIButton *)btn
{
    NSInteger count = btn.tag -600;
   NSDictionary *dict = self.stationArray[count];
    self.chooseLabel.text = dict[@"groupName"];
    self.chooseLabel.textColor = [UIColor blackColor];
    self.groupId = dict[@"groupId"];
    [self.chooseView removeFromSuperview];
    
}

- (NSMutableArray *)stationArray
{
    if (nil == _stationArray) {
        _stationArray = [NSMutableArray array];
    }
    return _stationArray;
}

- (void)createNav
{
    self.view.backgroundColor = COLOR(248, 248, 248);
    if ([self.actionType isEqualToString:@"feedback"]) {
        self.navigationItem.title = @"反馈";
    }else{
        self.navigationItem.title = @"回单";
    }
    
    //创建导航栏右边的btn
    UIButton *checkBtn = [[UIButton alloc] init];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"checkBtn"] forState:UIControlStateNormal];
    checkBtn.frame = CGRectMake(0, 0, 30, 30);
    [checkBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = checkItem;
        //监听键盘的弹进弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
#pragma mark - UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder]; return NO;
    }  return YES;
}

#pragma mark - 键盘
//键盘的弹出
- (void)keyboardShow:(NSNotification *)notification
{
    NSLog(@"%@",notification.userInfo);
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    }];
    if ([self.textView.text isEqualToString:@"请输入描述信息"]) {
        self.textView.text = nil;
        self.textView.textColor = [UIColor blackColor];
    }
}
//弹进
- (void)keyboardHide:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y+100);
    }];
    
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

- (void)commit:(UIButton *)btn
{
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
    if (fileSize <10) {
        NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"operationTime"] = operationTime;
        param[@"workNo"] = self.workNo;
        param[@"action"] = self.actionType;
        param[@"groupId"] = self.groupId;
        if ([self.textView.text isEqualToString:@"请输入描述信息"]) {
            param[@"description"] = @"";
            self.textView.text = nil;
        }else{
            param[@"description"] = self.textView.text;
        }
        while (!self.groupId) {
            showAlert(@"请选择工位！");
            return;
        }
        param[@"accessToken"] = UGET(U_TOKEN);
        NSLog(@"===%@",[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, selledFeedbackUrl]);
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, selledFeedbackUrl] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
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
                [[self.scrollView viewWithTag:500+i] removeFromSuperview];
            }
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            showAlert(error);
        }];
    }else{
        showAlert(@"上传文件不能超过10M，请重新选择！");
    }
    
}

- (IBAction)uploadBtn:(UIButton *)btn {
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
        [[self.scrollView viewWithTag:500+i] removeFromSuperview];
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
        imageView.delegate = self;
        UIImage *image = model.image;
        imageView.image = image;
        imageView.tag = 500+i;
        [self.scrollView addSubview:imageView];
    }
    
}
@end
