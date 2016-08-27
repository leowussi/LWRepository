//
//  AddRequestCommentController.m
//  telecom
//
//  Created by SD0025A on 16/6/1.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "AddRequestCommentController.h"
#import "RatingBar.h"
#import "ImageAndVideoPicker.h"
#import "FileModel.h"
#import "SelfImgeView.h"
#import "IQKeyboardManager.h"
#import "RequestSupportViewController.h"
#define CommentUrl    @"task/Comment"


@interface AddRequestCommentController ()<RatingBarDelegate,ImageAndVideoPickerDelegate,DeleteBtnInImageViewDelegate,UITextViewDelegate>
@property (nonatomic,strong) RatingBar *ratingBar;
@property (nonatomic,copy) NSString *satisfactionDegree;
@property (nonatomic,strong) NSMutableArray *fileArray;
@property (nonatomic,strong) ImageAndVideoPicker *picker;

@end

@implementation AddRequestCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.textView.delegate = self;
    self.navigationController.title = @"请求支持点评";
    self.ratingBar = [[RatingBar alloc] initWithFrame:CGRectMake(0, self.rateView.bounds.size.height/2-10, self.rateView.bounds.size.width, 50)];
    
    //添加到view中
    [self.rateView addSubview:self.ratingBar];
    //是否是指示器
    self.ratingBar.isIndicator = NO;
    [self.ratingBar setImageDeselected:@"灰.png" halfSelected:@"黄.png" fullSelected:@"黄.png" andDelegate:self];
}
#pragma mark -UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入描述..."]) {
        textView.text = nil;
    }
    self.view.center = CGPointMake(self.view.center.x, self.view.center.y-40);
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]){
        [textView resignFirstResponder];
         self.view.center = CGPointMake(self.view.center.x, self.view.center.y+40);
        return NO;
    }
    return YES;
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

#pragma mark - RatingBar delegate
-(void)ratingBar:(RatingBar *)ratingBar ratingChanged:(float)newRating{
     int rate = ceil(newRating);
    self.satisfactionDegree = [NSString stringWithFormat:@"%d",rate];
    
}

- (IBAction)yesAction:(UIButton *)sender {
    
    if ([self.textView.text isEqualToString:@"请输入描述..."]) {
        showAlert(@"请输入点评描述！");
        return;
    }
    if (self.textView.text.length == 0 ) {
        showAlert(@"请输入点评描述！");
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
    
    if (fileSize < 10) {
        NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"operationTime"] = operationTime;
        dict[@"accessToken"] = accessToken;
        dict[@"taskId"] = self.taskId;
        dict[@"satisfactionDegree"] = self.satisfactionDegree;
        dict[@"remark"] = self.textView.text;
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"http://%@/%@/%@.json", ADDR_IP, ADDR_DIR, CommentUrl] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
            [self.fileArray removeAllObjects];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[RequestSupportViewController class]]) {
                    RequestSupportViewController *revise =(RequestSupportViewController *)controller;
                    [self.navigationController popToViewController:revise animated:YES];
                }
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            showAlert(error);
        }];
    }


}

- (IBAction)cancelActon:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)uploadFileAction:(UIButton *)sender {
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
- (void)viewWillAppear:(BOOL)animated
{
    self.scroll.contentSize = CGSizeMake(APP_W, 600);
}

#pragma mark - DeleteBtnInImageViewDelegate
- (void)deleteBtnInImageView:(SelfImgeView *)imgeView
{
    for (int i =0; i<self.fileArray.count; i++) {
        [[self.scroll viewWithTag:500+i] removeFromSuperview];
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
        SelfImgeView *imageView = [[SelfImgeView alloc] initWithFrame:CGRectMake(self.uploadBtn.frame.origin.x+70+sec*(60+10), self.uploadBtn.frame.origin.y+row*(60+10), 60, 60)];
        FileModel *model = self.fileArray[i];
        UIImage *image = model.image;
        imageView.delegate = self;
        imageView.image = image;
        imageView.tag = 500+i;
        [self.scroll addSubview:imageView];
    }
    
}

@end
