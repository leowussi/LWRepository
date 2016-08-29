//
//  PostPhotoController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/23.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "PostPhotoController.h"
#import "UzysAssetsPickerController.h"
#import "CRMHelper.h"
#import "MBProgressHUD+MJ.h"
#import "AFNetworking.h"
#import "ZYFUrlTask.h"
#import "ZYFHttpTool.h"
#import "ZYFUpLoad.h"
#import "UIImage+ZYF.h"

//允许上传的最大照片的数量
#define kMaxPhotoCount 9
//存储在本地的照片的张数
#define ZYFLocalPhotoCount @"kLocalPhotoCount"

@interface PostPhotoController () <UzysAssetsPickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *btnImage;
@property (nonatomic,strong) UILabel *labelDescription;

@property (nonatomic,strong) NSMutableArray *imagViewArray;

@property (nonatomic,strong) NSMutableArray  *images;

@property (nonatomic,assign) NSInteger selectedImageCount;

@property (nonatomic,assign) CGRect oldFrame;
@property (nonatomic,assign) CGRect currentFrame;

@property (nonatomic,assign) NSInteger postSuccessNum;

@end

@implementation PostPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"上传" style:UIBarButtonItemStyleDone target:self action:@selector(postPhoto)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.postSuccessNum = 0;
    [self setupControl];
    [self readImagesFromDisk];
}

- (void)readImagesFromDisk
{
    NSString *directPath = [self getDirectoryPath];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray *photoPaths = [fileMgr subpathsAtPath:directPath];
    [self createImageViews: photoPaths.count];
    
    for (int i = 0; i < photoPaths.count; i ++ ) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%d.png",directPath,i];
        
        if ([fileMgr fileExistsAtPath:filePath]) {
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            [self.images addObject:image];
            UIImageView *imageView = [self.imagViewArray objectAtIndex: i];
            imageView.image = image;
        }else{
            ZYFLog(@"readImagesFromDisk file is not exsit");
            return;
        }
    }
    self.selectedImageCount = photoPaths.count;
    [self setAddButtonFrame];
    
}

- (void)back
{
    //每次点击返回，先清除上一次已经缓存的，然后再缓存本次的
//    [self cleanPhotos];
    if (self.images) {
        NSString *directPath = [self getDirectoryPath];
        NSLog(@"directPath===%@",directPath);
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        //创建文件目录
        if ( ! [fileMgr fileExistsAtPath:directPath]) {
            if ( ! [fileMgr createDirectoryAtPath:directPath withIntermediateDirectories:YES attributes:nil error:nil]){
                ZYFLog(@"--back--create directory failure");
            }
        }else{
            ZYFLog(@"--back--file is always exsits");
        }
        
        for (int i= 0; i < self.images.count; i ++) {
            //保存在当前对应的消缺下
            NSString *filePath = [NSString stringWithFormat:@"%@/%d.png",directPath,i];
            
            UIImage *image = self.images[i];
            if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
                ZYFLog(@"--success--fileName=%@",filePath);
            }else{
                ZYFLog(@"--shibai--");
            }
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//上传成功后清除本地记录需要上传的缓存的image
- (void)cleanPhotos{
    
    NSString *directPath = [self getDirectoryPath];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSArray *photoPaths = [fileMgr subpathsAtPath:directPath];
    
    for (int i = 0; i < photoPaths.count; i ++ ) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%d.png",directPath,i];
        if ([fileMgr fileExistsAtPath:filePath]) {
            if ( ! [fileMgr removeItemAtPath:filePath error:nil]){
                ZYFLog(@"remove file failure");
            }else{
                ZYFLog(@"remove file success");
            }
        }else{
            ZYFLog(@"cleanPhotos file is not exsit");
            return;
        }
    }
}

- (NSString *)getDirectoryPath
{
    NSString *cleanTaskId = self.cleanTaskId;
    if ([cleanTaskId containsString:@"-"]) {
        cleanTaskId = [cleanTaskId stringByReplacingOccurrencesOfString:@"-" withString:@"bbb"];
    }
    NSString *directPath = [CRMHelper createFilePathWithFileName:cleanTaskId];
    return directPath;
}

- (void)postPhoto
{
    UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"维修前照片",@"维修后照片", nil];
    [action showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //维修前
        [self postPhotoWithType:@"before"];
    }else if (buttonIndex == 1){
        //维修后
        [self postPhotoWithType:@"after"];
    }
}

-(void)postPhotoWithType: (NSString *)type
{
    if (self.images.count <= 0) {
        [MBProgressHUD showError:@"你没有选择任何照片"];
    }else{
        //调用上传照片接口
        if (self.images.count > 0) {
            for (UIImage *image in self.images) {
                [self upload:image type:type];
            }
        }
    }
}

- (void)upload:(UIImage *)image type:(NSString *)type
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
//    NSString *urlStr = kUploadPhoto;
//    NSString *urlString = [NSString stringWithFormat:@"%@?action=task&code=%@&id=%@",urlStr,type,self.cleanTaskId];
    NSString *urlString = [NSString stringWithFormat:@"%@&code=%@",self.urlString,type];

    
    //把图片的大小压缩为269.5 x 359.7
    CGFloat scaleW = 269.5 ;
    CGFloat scaleH = 359.7 ;
    
    UIImage *newImage =  [UIImage imageWithImage:image scaledToSize:CGSizeMake(scaleW,scaleH)];
    
    NSData *imageData = UIImagePNGRepresentation(newImage);
    
    
    [ZYFUpLoad upload:urlString filename:@"zyf.png" mimeType:@"image/png" fileData:imageData params:nil success:^(NSData *data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSString *code = dict[@"Code"];
        NSString *msg = dict[@"Msg"];
        if (code.intValue == 1) {
            self.postSuccessNum ++;
            NSString *successStr = [NSString stringWithFormat:@"上传成功%d张照片",self.postSuccessNum];
            [MBProgressHUD showSuccess:successStr];
            [self cleanPhotos];
            self.images = nil;
            
        }else{
                        [MBProgressHUD showError:msg];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:[NSString stringWithFormat:@"error = %@",error]];
    }];
}

-(NSMutableArray *)images
{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

-(NSMutableArray *)imagViewArray{
    if (_imagViewArray == nil) {
        _imagViewArray = [NSMutableArray array];
    }
    return _imagViewArray;
}


-(void)createImageViews :(NSInteger)count
{
    if (count > 0) {
        for (NSInteger i = self.selectedImageCount; i < count; i ++) {
            UIImageView *imageView = [[UIImageView alloc]init];
            CGFloat margin = 9.0 / 3.0;
            CGFloat w = (kSystemScreenWidth - 9 ) * 0.25;
            CGFloat h = (kSystemScreenWidth - 9 ) * 0.25;
            CGFloat x = margin + (i % 4)* (margin + w);
            CGFloat y = margin + 64 + i / 4 * (h + margin);
            imageView.frame = CGRectMake(x , y,w , h);
            imageView.backgroundColor = [UIColor lightGrayColor];
            [imageView setUserInteractionEnabled:YES];
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(scalePhoto:)];
            [imageView addGestureRecognizer:tapGesture];
            
            [self.view addSubview:imageView];
            
            [self.imagViewArray addObject:imageView];
        }
    }
}

#pragma mark -- 放大或者缩小图片
- (void)scalePhoto: (UILongPressGestureRecognizer*)tapGesture
{
    UIImageView *touchView = (UIImageView *)tapGesture.view;
    self.currentFrame = touchView.frame;
    
    if ((touchView.center.x == self.view.center.x) && (touchView.center.y == self.view.center.y)) {
        [UIView animateWithDuration:0.3f animations:^{
            touchView.frame = self.oldFrame;
        }];
        self.navigationController.navigationBar.hidden = NO;
    }else{
        [UIView animateWithDuration:0.6f animations:^{
            touchView.frame = self.view.frame;
        }];
        self.navigationController.navigationBar.hidden = YES;
        [self.view bringSubviewToFront:touchView];
    }
    self.oldFrame = self.currentFrame;
    
}

//添加更多照片的按钮 “+”号的初始化
-(void)setupControl
{
    self.btnImage = [UIButton buttonWithType:UIButtonTypeSystem];
    
    CGFloat margin = 9.0 / 3.0;
    CGFloat w = (kSystemScreenWidth - 9 ) * 0.25;
    CGFloat h = (kSystemScreenWidth - 9 ) * 0.25;
    CGFloat x = margin + (0 % 4)* (margin + w);
    CGFloat y = margin + 64 + 0 / 4 * (h + margin);
    self.btnImage.frame = CGRectMake(x , y,w , h);
    [self.btnImage setImage:[UIImage imageNamed:@"addphoto"] forState:UIControlStateNormal];
    [self.btnImage setImage:[UIImage imageNamed:@"addphoto_press"] forState:UIControlStateNormal];
    
    [self.btnImage addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.btnImage];
}


- (void)buttonAction:(id)sender
{
    
    if (self.selectedImageCount == kMaxPhotoCount) {
        //如果超出了最大的选择张数，进行提醒
        NSString *message = [NSString stringWithFormat:@"一次最多只能添加%d张照片",kMaxPhotoCount];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    
    picker.maximumNumberOfSelectionVideo = 0;
    //还可以选择的照片的数量
    picker.maximumNumberOfSelectionPhoto = (kMaxPhotoCount - self.selectedImageCount);
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    self.imageView.backgroundColor = [UIColor clearColor];
    //    self.selectedImageCount = self.imagViewArray.count;
    [self createImageViews: (assets.count + self.selectedImageCount)];
    
    __weak typeof(self) weakSelf = self;
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            
            UIImageView *imageView = [weakSelf.imagViewArray objectAtIndex: (self.selectedImageCount + idx)];
            imageView.image = img;
            [self.images addObject:img];
        }];
        
        self.selectedImageCount = self.imagViewArray.count;
        [self setAddButtonFrame];
        
    }
    else //Video
    {
        
    }
    
}



- (void)setAddButtonFrame
{
    NSInteger i = self.selectedImageCount;
    CGFloat margin = 9.0 / 3.0;
    CGFloat w = (kSystemScreenWidth - 9 ) * 0.25;
    CGFloat h = (kSystemScreenWidth - 9 ) * 0.25;
    CGFloat x = margin + (i  % 4)* (margin + w);
    CGFloat y = margin + 64 + i  / 4 * (h + margin);
    self.btnImage.frame = CGRectMake(x , y,w , h);
}

@end
