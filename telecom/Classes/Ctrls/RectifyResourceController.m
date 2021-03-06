//
//  RectifyResourceController.m
//  telecom
//
//  Created by liuyong on 15/5/18.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "RectifyResourceController.h"
#import "ELCImagePickerHeader.h"
#import "OriginalImageController.h"
#import "UploadFiler.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

@interface RectifyResourceController ()<UITextFieldDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,OriginalImageControllerDelegate,UIActionSheetDelegate,UploadFileDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableData *_receiveData;
}
@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,strong)NSMutableArray *ReferenceURLs;
@property(nonatomic,strong)NSMutableArray *imagesFullPathArray;
@property(nonatomic,strong)NSMutableArray *fileIdArray;

@property(nonatomic,strong)UITextField *inputShareInfo;
@property(nonatomic,strong)UIScrollView *attachmentInfo;

@end

@implementation RectifyResourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加资源矫正信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.inputShareInfo.delegate = self;
    
    self.fileIdArray = [NSMutableArray array];
    self.images = [NSMutableArray array];
    self.imagesFullPathArray = [NSMutableArray array];
    self.ReferenceURLs = [NSMutableArray array];
    
    [self setUpUI];
    [self setUpRightBarButton];
    [self addImagePicker];
}

- (void)setUpUI
{
    UILabel *titleLabel = [MyUtil createLabel:RECT(0, 64, APP_W, 30) text:@"  资源矫正描述信息"
                                    alignment:NSTextAlignmentLeft
                                    textColor:[UIColor whiteColor]];
    titleLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:titleLabel];
    
    self.inputShareInfo = [[UITextField alloc] initWithFrame:RECT(8, CGRectGetMaxY(titleLabel.frame)+4, APP_W-16, 30)];
    self.inputShareInfo.placeholder = @"  请输入资源矫正描述信息";
    self.inputShareInfo.borderStyle = UITextBorderStyleRoundedRect;
    self.inputShareInfo.delegate = self;
    [self.view addSubview:self.inputShareInfo];
    
    UILabel *attachmentLabel = [MyUtil createLabel:RECT(0, CGRectGetMaxY(self.inputShareInfo.frame)+4, APP_W, 30) text:@"  添加附件" alignment:NSTextAlignmentLeft textColor:[UIColor whiteColor]];
    attachmentLabel.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:attachmentLabel];
    
    self.attachmentInfo = [[UIScrollView alloc] initWithFrame:RECT(8, CGRectGetMaxY(attachmentLabel.frame)+4, APP_W-16, 76)];
    [self.view addSubview:self.attachmentInfo];
}


#pragma mark - 右侧按钮
- (void)setUpRightBarButton
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightBtn.frame = CGRectMake(APP_W-40, 7, 30, 30);
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_check@2x"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(addRectifyResAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

- (void)addImagePicker
{
    UIImageView *addImage = [[UIImageView alloc] initWithFrame:RECT(0, 0, 76, 76)];
    addImage.image = [UIImage imageNamed:@"addImag1"];
    addImage.userInteractionEnabled = YES;
    [addImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageAction)]];
    [self.attachmentInfo addSubview:addImage];
}

- (void)addImageAction
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"相机", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addImageFromAlbum];
    }
    
    if (buttonIndex == 1) {
        [self addImageFromCamera];
    }
}

- (void)addImageFromAlbum
{
    ELCImagePickerController *elcImagePicker = [[ELCImagePickerController alloc] initImagePicker];
    elcImagePicker.maximumImagesCount = 9;
    elcImagePicker.onOrder = YES;
    elcImagePicker.returnsOriginalImage = YES;
    elcImagePicker.returnsImage = YES;
    elcImagePicker.imagePickerDelegate = self;
    [self presentViewController:elcImagePicker animated:YES completion:^{
        nil;
    }];
}

- (void)addImageFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickerCtrl = [[UIImagePickerController alloc] init];
        imagePickerCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerCtrl.delegate = self;
        imagePickerCtrl.allowsEditing = YES;
        [self presentViewController:imagePickerCtrl animated:YES completion:^{
            nil;
        }];
    }else{
        showAlert(@"你没有摄像头");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
    for (UIView *v in [self.attachmentInfo subviews]) {
        [v removeFromSuperview];
    }
    
//    self.images = [NSMutableArray array];
    [self.images addObject:image];
    
    [self showImagesOnScrollViewWithArray:self.images];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    for (UIView *v in [self.attachmentInfo subviews]) {
        [v removeFromSuperview];
    }
    
//    self.images = [NSMutableArray arrayWithCapacity:[info count]];
//    self.imagesFullPathArray = [NSMutableArray arrayWithCapacity:[info count]];
//    self.ReferenceURLs = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [self.images addObject:image];
                
                NSURL *fileURL = [dict objectForKey:UIImagePickerControllerReferenceURL];
                ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
                {
                    ALAssetRepresentation *representation = [myasset defaultRepresentation];
                    NSString *fileName = [representation filename];
                    
                    CGImageRef imageRef = [myasset thumbnail];
                    UIImage *needSaveImage = [UIImage imageWithCGImage:imageRef];
                    NSString *tempString = [self saveImage:needSaveImage withName:fileName];
                    [self.imagesFullPathArray addObject:tempString];
                    [self.ReferenceURLs addObject:fileName];
                    //                    NSLog(@"fileName : %@",fileName);
                    //                    NSLog(@"self.ReferenceURLs : %@",self.ReferenceURLs);
                    //                    NSLog(@"self.imagesFullPathArray : %@",self.imagesFullPathArray);
                };
                
                ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
                [assetslibrary assetForURL:fileURL
                               resultBlock:resultblock
                              failureBlock:nil];
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
    }
    
    [self showImagesOnScrollViewWithArray:self.images];
}

- (void)showImagesOnScrollViewWithArray:(NSMutableArray *)array
{
    for (UIView *view in self.attachmentInfo.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i=0; i<array.count+1; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT((74+3)*i, 0, 74, 74)];
        imageView.userInteractionEnabled = YES;
        [imageView setContentMode:UIViewContentModeScaleToFill];
        if (i>=0 && i<array.count) {
            imageView.image = array[i];
            imageView.tag = i+3333;
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageDetailAction:)]];
        }else{
            imageView.image = [UIImage imageNamed:@"addImag1"];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImageAction)]];
        }
        [self.attachmentInfo addSubview:imageView];
//        [imageView release];
    }
    self.attachmentInfo.contentSize = CGSizeMake(77*(array.count+1), 0);
    self.attachmentInfo.showsHorizontalScrollIndicator = YES;
}

- (void)imageDetailAction:(UITapGestureRecognizer *)ges
{
    UIImageView *gesView = (UIImageView *)ges.view;
    NSInteger index = gesView.tag - 3333;
    OriginalImageController *originalVc = [[OriginalImageController alloc] init];
    originalVc.delegate  = self;
    originalVc.images = self.images;
    originalVc.index = index;
    [self.navigationController pushViewController:originalVc animated:YES];
}

- (void)deleteImagesOfIndexInArray:(NSMutableArray *)indexArray
{
    [self.images removeAllObjects];
    self.images = indexArray;
    [self showImagesOnScrollViewWithArray:self.images];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)saveImage:(UIImage *)image withName:(NSString *)imageName;
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    [imageData writeToFile:fullPathToFile atomically:NO];
//    NSLog(@"%@",fullPathToFile);
    return fullPathToFile;
}

- (void)addRectifyResAction
{
    UploadFiler *upFiler = [[UploadFiler alloc] init];
    upFiler.delegate = self;
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = NW_RectifyResUploadFile;
    
    for (int i=0; i<self.imagesFullPathArray.count; i++) {
        paraDict[FILE_PATH] = self.imagesFullPathArray[i];
        paraDict[@"fileName"] = self.ReferenceURLs[i];
        [upFiler send:paraDict];
    }
//    [upFiler release];
}

- (void)deliverResultFileId:(NSData *)receiveData
{
//    NSLog(@"代理方法调用了");
    id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"result:%@",result);
    if ([result[@"result"] isEqualToString:@"0000000"]) {
        NSString *fileId = result[@"detail"][@"fileId"];
        [self.fileIdArray addObject:fileId];
    }
    NSString * respondTotalFileId =  [self.fileIdArray componentsJoinedByString:@","];
//    NSLog(@"respondTotalFileId:%@",respondTotalFileId);
    
    if (self.fileIdArray.count == self.imagesFullPathArray.count) {//判断是不是上传到最后一张图片
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[URL_TYPE] = NW_ExecuteCorrectInfo;
        paraDict[@"taskId"] = self.callBackInfoDict[@"taskId"];
        paraDict[@"fileId"] = respondTotalFileId;
        if (self.inputShareInfo.text != nil) {
            paraDict[@"problemContent"] = [self.inputShareInfo.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
        
        httpGET2(paraDict, ^(id result) {
            if ([result[@"result"] isEqualToString:@"0000000"]) {
                showAlert(@"资源矫正完成");
            }
        }, ^(id result) {
            showAlert(result[@"error"]);
        });
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    [_inputShareInfo release];
//    [_attachmentInfo release];
//    [_images release];
//    [_imagesFullPathArray release];
//    [_ReferenceURLs release];
//    [_fileIdArray release];
//    [super dealloc];
//}
@end

