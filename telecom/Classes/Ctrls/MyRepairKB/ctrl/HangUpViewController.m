//
//  HangUpViewController.m
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "HangUpViewController.h"
#import "DatePickerView.h"
#import "HangUpReasonView.h"
#import "ZYQAssetPickerController.h"

@interface HangUpViewController ()<DatePickerViewDelegate,UITextFieldDelegate,HangUpReasonViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ZYQAssetPickerControllerDelegate>
{
    NSDate *_beginDAndT;
    
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    NSMutableArray *imageNameArr;
}
@property(nonatomic,strong)HangUpReasonView *hangUpReasonView;
@end

@implementation HangUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"挂起";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowing"];
    
    imageNameArr = [NSMutableArray array];
    imageDataUrlArr = [NSMutableArray array];
    imgArr = [NSMutableArray array];
    
    self.listNumber.text = self.orderNo;
    self.handlePerson.text = UGET(U_NAME);
    
    self.hangUpDesc.delegate  = self;
    self.hangUpDesc.layer.borderWidth = 0.5;
    self.hangUpDesc.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    

    self.hangUpReason.layer.borderWidth = 0.5;
    self.hangUpReason.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    
    self.endDateAndTime.layer.borderWidth = 0.5;
    self.endDateAndTime.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    
    self.bottomScrollView.frame = RECT(0, 64, APP_W, APP_H-44);
    self.bottomScrollView.showsHorizontalScrollIndicator = NO;
    self.bottomScrollView.showsVerticalScrollIndicator = NO;
    self.bottomScrollView.contentSize = CGSizeMake(0, self.attachmentInfo.frame.origin.y + self.attachmentInfo.frame.size.height+10);
    
    [self.startDateAndTime setTitle:date2str([NSDate date], @"yyyy-MM-dd HH:mm") forState:UIControlStateNormal];
    [self.endDateAndTime setTitle:date2str([NSDate dateWithTimeIntervalSinceNow:3600], @"yyyy-MM-dd HH:mm") forState:UIControlStateNormal];
    
    [self setUpRightNavButton];
    
    [self addImagePicker];
}

#pragma mark - setUpRightNavButton
- (void)setUpRightNavButton
{
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"checkBtn.png"];
    checkBtn.frame = RECT(APP_W-40, 7, image.size.width/2, image.size.height/2);
    [checkBtn setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(hangUpAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)addImagePicker
{
    UIImageView *addImage = [[UIImageView alloc] initWithFrame:RECT(0, 0, 76, 76)];
    addImage.image = [UIImage imageNamed:@"addImag1"];
    addImage.userInteractionEnabled = YES;
    [addImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)]];
    [self.attachmentInfo addSubview:addImage];
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
    for (UIView *view in self.attachmentInfo.subviews) {
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
        [self.attachmentInfo addSubview:imageView];
    }
    self.attachmentInfo.contentSize = CGSizeMake(77*(array.count+1), 0);
    self.attachmentInfo.showsHorizontalScrollIndicator = YES;
}

- (void)deleteImage:(UITapGestureRecognizer *)ges
{
    UIView *view = ges.view;
    NSInteger index = view.tag - 90000;
    [imgArr removeObjectAtIndex:index];
    [imageNameArr removeObjectAtIndex:index];
    [imageDataUrlArr removeObjectAtIndex:index];
    
    for (UIView *view in self.attachmentInfo.subviews) {
        [view removeFromSuperview];
    }
    
    [self showImagesOnScrollViewWithArray:imgArr];
}

- (void)hangUpAction
{
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    NSString *workNo = self.workNum;
    NSString *cause = [self.hangUpReason.titleLabel.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *endTime = self.endDateAndTime.titleLabel.text;
    NSString *description = [self.hangUpDesc.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/%@.json?operationTime=%@&accessToken=%@&workNo=%@&cause=%@&endTime=%@&description=%@",ADDR_IP,ADDR_DIR,kHangUpAction,operationTime,accessToken,workNo,cause,endTime,description];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager POST:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < imageDataUrlArr.count; i++) {
            if (imageDataUrlArr.count == 0) {
            }else{
                NSURL *imgUrl = [imageDataUrlArr objectAtIndex:i];
                [formData appendPartWithFileURL:imgUrl name:imageNameArr[i] error:nil];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            showAlert(@"挂起成功!");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        showAlert([error localizedDescription]);
    }];
}

- (IBAction)chooseHangUpReason:(UIButton *)sender {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isShowing"]) {
        self.hangUpReasonView = [[HangUpReasonView alloc] initWithFrame:RECT(0, APP_H, APP_W, 200)];
        self.hangUpReasonView.backgroundColor = [UIColor whiteColor];
        self.hangUpReasonView.delegate = self;
        [self.view addSubview:self.hangUpReasonView];
        
        [UIView animateWithDuration:0.2f animations:^{
            CGRect tempFrame = self.hangUpReasonView.frame;
            tempFrame.origin.y = APP_H - 170;
            self.hangUpReasonView.frame = tempFrame;
        }];
        
        [self.hangUpReasonView loadDateWithURL:kHangUpReason];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowing"];
    };
}

- (void)deliverHangUpReason:(NSString *)hangUpReason
{
    self.Reason = hangUpReason;
    [self.hangUpReason setTitle:hangUpReason forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)chooseStartDateAndTime:(UIButton *)sender {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isShowing"]) {
        NSInteger btnTag = sender.tag;
        DatePickerView *dateAndTimePicker1 = [[DatePickerView alloc] initWithFrame:RECT(0, APP_H, APP_W, 200)];
        dateAndTimePicker1.btnTag = btnTag;
        dateAndTimePicker1.delegate  = self;
        dateAndTimePicker1.backgroundColor = [UIColor whiteColor];
        dateAndTimePicker1.seekForDateAndTime.minimumDate = [NSDate date];
        _beginDAndT = str2date(self.startDateAndTime.titleLabel.text, @"yyyy-MM-dd HH:mm");
        dateAndTimePicker1.seekForDateAndTime.date = _beginDAndT;
        [self.view addSubview:dateAndTimePicker1];
        
        
        [UIView animateWithDuration:0.2f animations:^{
            CGRect tempFrame = dateAndTimePicker1.frame;
            tempFrame.origin.y = (APP_H-180);
            dateAndTimePicker1.frame = tempFrame;
        }];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowing"];
    }
}

- (IBAction)chooseEndDateAndTime:(UIButton *)sender {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isShowing"]) {
        NSInteger btnTag = sender.tag;
        DatePickerView *dateAndTimePicker2 = [[DatePickerView alloc] initWithFrame:RECT(0, APP_H, APP_W, 200)];
        dateAndTimePicker2.btnTag = btnTag;
        dateAndTimePicker2.delegate  = self;
        dateAndTimePicker2.backgroundColor = [UIColor whiteColor];
        NSDate *minDate = str2date(self.endDateAndTime.titleLabel.text, @"yyyy-MM-dd HH:mm");
        dateAndTimePicker2.seekForDateAndTime.minimumDate = minDate;
        //        [dateAndTimePicker2.seekForDateAndTime setDate:[NSDate dateWithTimeIntervalSinceNow:3600] animated:YES];
        dateAndTimePicker2.seekForDateAndTime.date = str2date(self.endDateAndTime.titleLabel.text, @"yyyy-MM-dd HH:mm");
        [self.view addSubview:dateAndTimePicker2];
        
        
        [UIView animateWithDuration:0.2f animations:^{
            CGRect tempFrame = dateAndTimePicker2.frame;
            tempFrame.origin.y = (APP_H-180);
            dateAndTimePicker2.frame = tempFrame;
        }];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowing"];
    }
}

- (void)deliverDateAndTime:(NSString *)dateAndTime withBtn:(NSInteger)btnTag
{
    if (btnTag == 8888) {
        self.begin = dateAndTime;
        [self.startDateAndTime setTitle:dateAndTime forState:UIControlStateNormal];
        
        NSString *endDAndT = self.endDateAndTime.titleLabel.text;
        NSDate *endDate = str2date(endDAndT, @"yyyy-MM-dd HH:mm");
        NSDate *beginDate = str2date(dateAndTime, @"yyyy-MM-dd HH:mm");
        NSDate *tempDate = [beginDate dateByAddingTimeInterval:3600];
        if ([tempDate compare:endDate] == NSOrderedDescending) {
            [self.endDateAndTime setTitle:date2str(tempDate, @"yyyy-MM-dd HH:mm") forState:UIControlStateNormal];
        }
    }
    
    if (btnTag == 9999) {
        self.end = dateAndTime;
        [self.endDateAndTime setTitle:dateAndTime forState:UIControlStateNormal];
    }
    
}
@end
