//
//  ApplyForSupportController.m
//  telecom
//
//  Created by liuyong on 15/8/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "ApplyForSupportController.h"
#import "ZYQAssetPickerController.h"

@interface ApplyForSupportController ()<ZYQAssetPickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    NSMutableArray *imageNameArr;
}
@end

@implementation ApplyForSupportController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"支撑申请";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    imageNameArr = [NSMutableArray array];
    imageDataUrlArr = [NSMutableArray array];
    imgArr = [NSMutableArray array];
    
    [self addNavigationLeftButton];
    
    [self setUpRightNavButton];
    
    [self addImagePicker];
    
    self.workNumLabel.text = self.orderNo;
    self.descTextView.layer.borderWidth = 0.5;
    self.descTextView.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
}

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
    [checkBtn addTarget:self action:@selector(supportAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)supportAction
{
        NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");//yyyy-MM-dd HH:mm:ss
        NSString *accessToken = UGET(U_TOKEN);
        NSString *workNo = self.workNum;
        NSString *description = self.descTextView.text;
        
        NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
        paraDict[@"operationTime"] = operationTime;
        paraDict[@"accessToken"] = accessToken;
        paraDict[@"workNo"] = workNo;
        paraDict[@"description"] = description;
    
        NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/%@.json",ADDR_IP,ADDR_DIR,kApplyForSupportAction];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:requestUrl parameters:paraDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (int i = 0; i < imageDataUrlArr.count; i++) {
                if (imageDataUrlArr.count == 0) {
                }else{
                    NSURL *imgUrl = [imageDataUrlArr objectAtIndex:i];
                    [formData appendPartWithFileURL:imgUrl name:imageNameArr[i] error:nil];
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            showAlert(responseObject[@"error"]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            showAlert([error localizedDescription]);
        }];
}

- (void)addImagePicker
{
    UIImageView *addImage = [[UIImageView alloc] initWithFrame:RECT(0, 0, 76, 76)];
    addImage.image = [UIImage imageNamed:@"addImag1"];
    addImage.userInteractionEnabled = YES;
    [addImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)]];
    [self.attachmentScrollView addSubview:addImage];
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
        picker.allowsEditing = YES;
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
    [imageNameArr addObject:imageName];
    [imageDataUrlArr addObject:url];
    
    [self showImagesOnScrollViewWithArray:imgArr];
}


- (void)showImagesOnScrollViewWithArray:(NSArray *)array
{
    for (UIView *view in self.attachmentScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i=0; i<array.count+1; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT((74+3)*i, 0, 74, 74)];
        imageView.userInteractionEnabled = YES;
        [imageView setContentMode:UIViewContentModeScaleToFill];
        if (i>=0 && i<array.count) {
            imageView.image = array[i];
            
            UIImageView *deleteImageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, 16, 16)];
            deleteImageView.tag = 90000+i;
            deleteImageView.userInteractionEnabled = YES;
            deleteImageView.image = [UIImage imageNamed:@"delete-circular.png"];
            [imageView addSubview:deleteImageView];
            
            [deleteImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImage:)]];
            
        }else{
            imageView.image = [UIImage imageNamed:@"addImag1"];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)]];
        }
        [self.attachmentScrollView addSubview:imageView];
    }
    self.attachmentScrollView.contentSize = CGSizeMake(77*(array.count+1), 0);
    self.attachmentScrollView.showsHorizontalScrollIndicator = YES;
}

- (void)deleteImage:(UITapGestureRecognizer *)ges
{
    UIView *view = ges.view;
    NSInteger index = view.tag - 90000;
    [imgArr removeObjectAtIndex:index];
    [imageNameArr removeObjectAtIndex:index];
    [imageDataUrlArr removeObjectAtIndex:index];
    
    for (UIView *view in self.attachmentScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    [self showImagesOnScrollViewWithArray:imgArr];
}

@end
