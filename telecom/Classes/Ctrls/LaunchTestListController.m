//
//  LaunchTestListController.m
//  telecom
//
//  Created by SD0025A on 16/4/6.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//
// 发起测试单  控制器
#import "LaunchTestListController.h"
#import <AVFoundation/AVFoundation.h>
#import "ImageAndVideoPicker.h"
#import "SelfImgeView.h"
#import "FileModel.h"
#define LaunchTestUrl   @"Medium/testOrderStart"
#define GetStationUrl  @"Medium/getStation"

@interface LaunchTestListController ()<ImageAndVideoPickerDelegate,DeleteBtnInImageViewDelegate,UITextViewDelegate>
@property (nonatomic,strong)  UIImagePickerController *pickPhotoController;


@property (nonatomic,strong) ImageAndVideoPicker *picker;
@property (nonatomic,strong) NSMutableArray *stationArray;
@property (nonatomic,strong) NSMutableArray *fileArray;
@property (nonatomic,strong) NSMutableArray *choosedArray;
@property (nonatomic,copy) NSString *idStr;


@end

@implementation LaunchTestListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    [self getStation];
    
}
- (NSMutableArray *)choosedArray
{
    if (nil == _choosedArray) {
        _choosedArray = [NSMutableArray array];
    }
    return _choosedArray;
}

- (void)getStation
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[URL_TYPE] = GetStationUrl;
    httpGET2(params, ^(id result) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.stationArray = result[@"return_data"];
            //创建工位按钮
            for (int i= 0; i<self.stationArray.count; i++) {
                NSInteger col = i/4;//行
                NSInteger row = i%4;//列
                NSDictionary *dict = self.stationArray[i];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.titleLabel.font = [UIFont systemFontOfSize:9];
                btn.tag = 200+i;
                btn.frame = CGRectMake(self.testStationLabel.x+row*70, self.testStationLabel.ey+10+col*25, 65, 28);
                [btn setTitle:dict[@"groupName"] forState:UIControlStateNormal];
                btn.selected = NO;
                btn.titleLabel.textAlignment = NSTextAlignmentCenter;
                btn.titleLabel.numberOfLines = 0;
                btn.backgroundColor = [UIColor whiteColor];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(chooseStation:) forControlEvents:UIControlEventTouchUpInside];
                [self.scrollView addSubview:btn];
            }
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    
}
- (void)chooseStation:(UIButton *)btn
{
    //NSLog(@"===%@",btn.titleLabel.text);
    btn.selected = !btn.selected;
    if (btn.selected) {
        btn.backgroundColor = [UIColor greenColor];
        [self.choosedArray addObject:btn];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.choosedArray removeObject:btn];
    }
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)createUI
{
    self.navigationItem.title = @"发起测试单";
    //创建导航栏右边的btn
    UIButton *checkBtn = [[UIButton alloc] init];
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"checkBtn"] forState:UIControlStateNormal];
    checkBtn.frame = CGRectMake(0, 0, 30, 30);
    [checkBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *checkItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = checkItem;
    //监听键盘
    //监听键盘的弹进弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
   
    //发起人 设置
    self.launchPerson.text = UGET(U_NAME);
    self.textView.delegate = self;

}
#pragma mark - 键盘
//键盘的弹出
- (void)keyboardWillShow:(NSNotification *)notification
{
        [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y-100);
    }];
    if ([self.textView.text isEqualToString:@"你的反馈内容..."]) {
        self.textView.text = nil;
    }
}
//弹进
- (void)keyboardWillHide:(NSNotification *)notification
{
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y+100);
    }];
    
}
#pragma mark - 发起测试单
- (void)commit:(UIButton *)btn
{
    if (self.textView.text == nil||[self.textView.text isEqualToString:@"你的反馈内容..."]) {
        showAlert(@"请输入测试单描述！");
        return;
    }
    
    for (int i = 0; i<self.choosedArray.count; i++) {
        UIButton *btn = self.choosedArray[i];
        if (i == 0) {
            for (int j= 0; j<self.stationArray.count; j++) {
                NSDictionary *dict = self.stationArray[j];
                if ([btn.titleLabel.text isEqualToString:dict[@"groupName"]]) {
                    self.idStr = dict[@"groupId"];
                }
            }

        }else{
            for (int j= 0; j<self.stationArray.count; j++) {
                NSDictionary *dict = self.stationArray[j];
                if ([btn.titleLabel.text isEqualToString:dict[@"groupName"]]) {
                    self.idStr = [NSString stringWithFormat:@"%@,%@",self.idStr,dict[@"groupId"]];
                }
            }
        }
    }
    if (self.idStr.length ==0) {
        showAlert(@"请选择工位！");
        return;
    }
    NSLog(@"=====%@",self.idStr);
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
        NSString *accessToken = UGET(U_TOKEN);
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"workNo"] = self.workNo;
        param[@"type"] = @"open";
        param[@"operationTime"] = operationTime;
        param[@"dealUser"] = UGET(U_NAME);
        param[@"description"] = self.textView.text;
        param[@"testId"] = self.idStr;
        param[@"accessToken"] = accessToken;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, LaunchTestUrl] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
            for (int i =0; i<self.fileArray.count; i++) {
                [[self.scrollView viewWithTag:500+i] removeFromSuperview];
            }
            [self.fileArray removeAllObjects];
            showAlert(responseObject[@"error"]);
            [self.navigationController  popViewControllerAnimated:YES];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            showAlert(error);
        }];
    }else{
        showAlert(@"上传文件不能超过10M，请重新选择！");
    }
   
    
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

- (IBAction)upLoadBtn:(id)sender {
    
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
    [self showImage];}

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
    NSInteger row = self.fileArray.count%3 == 0 ?self.fileArray.count/3:self.fileArray.count/3+1;
    self.scrollView.contentSize = CGSizeMake(APP_W, self.upLoadBtn.y+70*row);
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
#pragma mark -UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder]; return NO;
    }  return YES;
}

@end
