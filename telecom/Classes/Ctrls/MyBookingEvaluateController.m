//
//  MyBookingEvaluateController.m
//  telecom
//
//  Created by liuyong on 15/7/16.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "MyBookingEvaluateController.h"
#import "BanZuInfoController.h"
#import "ZYQAssetPickerController.h"
#import "MyBookingSGRWController.h"


#define kImageCol 4
#define kImageWH  65

@interface MyBookingEvaluateController ()<UITextFieldDelegate,UITextViewDelegate,ZYQAssetPickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIScrollViewDelegate,UIScrollViewDelegate,BanZuInfoControllerDelegate>
{
    BOOL _is1Stared;
    BOOL _is2Stared;
    BOOL _is3Stared;
    BOOL _is4Stared;
    BOOL _is5Stared;
    NSString *_starNum;
    
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    NSMutableArray *imageNameArr;
}
@end

@implementation MyBookingEvaluateController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"施工点评";
    self.view.backgroundColor = [UIColor whiteColor];
    _is1Stared = NO;
    _is2Stared = NO;
    _is3Stared = NO;
    _is4Stared = NO;
    _is5Stared = NO;
    
    imageNameArr = [NSMutableArray array];
    imageDataUrlArr = [NSMutableArray array];
    imgArr = [NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView.hidden = YES;
    self.banzuInfo2.enabled = NO;
    
    self.evaluateInfo.layer.borderWidth = 0.5;
    self.evaluateInfo.layer.cornerRadius = 4;
    self.evaluateInfo.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.fileView.layer.borderWidth = 0.5;
    self.fileView.layer.cornerRadius = 4;
    self.fileView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UIButton *checkBtn = [[UIButton alloc] initWithFrame:RECT(0, 0, 30, 30)];
    [checkBtn setImage:[UIImage imageNamed:@"nav_check@2x.png"] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    
    self.banzuInfo.delegate = self;
    self.banzuInfo2.delegate = self;
    self.evaluateInfo.delegate = self;
    self.bottomScrollView.delegate = self;
    
    UIButton *banZuBtn = [[UIButton alloc] initWithFrame:self.banzuInfo.bounds];
    banZuBtn.backgroundColor = [UIColor clearColor];
    [banZuBtn addTarget:self action:@selector(banZuChoose) forControlEvents:UIControlEventTouchUpInside];
    [self.banzuInfo addSubview:banZuBtn];
    
    self.star1.userInteractionEnabled = YES;
    self.star2.userInteractionEnabled = YES;
    self.star3.userInteractionEnabled = YES;
    self.star4.userInteractionEnabled = YES;
    self.star5.userInteractionEnabled = YES;
    
    [self.star1 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addStar1:)]];
    [self.star2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addStar2:)]];
    [self.star3 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addStar3:)]];
    [self.star4 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addStar4:)]];
    [self.star5 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addStar5:)]];
    
    [self addAttachmentWithImageArray:nil];
}

- (void)banZuChoose
{
    BanZuInfoController *banZuCtrl = [[BanZuInfoController alloc] init];
    banZuCtrl.delegate = self;
    [self.navigationController pushViewController:banZuCtrl animated:YES];
}

- (void)deliverBanZuInfo:(NSString *)banZuInfo
{
    self.banzuInfo.text = banZuInfo;
}

- (void)checkAction
{
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    NSString *appointmentId = self.taskDict[@"appointmentId"];
    
    NSString *chooseBanZuInfo = self.banzuInfo.text;
    NSString *iuputBanZuInfo = self.banzuInfo2.text;
    
    if (chooseBanZuInfo == nil && iuputBanZuInfo == nil) {
        showAlert(@"请填写班组信息");
    }
    
    NSString *banZuInfo = ([chooseBanZuInfo isEqualToString:@""]) ? iuputBanZuInfo : chooseBanZuInfo;
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/MyTask/WithWork/TaskEvaluation.json?operationTime=%@&accessToken=%@&appCode=%@&appointmentId=%@&constructionTeam=%@&myScore=%@",ADDR_IP,ADDR_DIR,operationTime,accessToken,@"10000",appointmentId,banZuInfo,_starNum];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < imageDataUrlArr.count; i++) {
            if (imageDataUrlArr.count == 0) {
            }else{
                NSURL *imgUrl = [imageDataUrlArr objectAtIndex:i];
                [formData appendPartWithFileURL:imgUrl name:[NSString stringWithFormat:@"image%d",i] error:nil];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        showAlert(@"点评添加成功");
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        showAlert([error localizedDescription]);
    }];
}

//加附件
- (void)addAttachmentWithImageArray:(NSArray *)imageArray
{
    for (UIView *view in self.fileView.subviews) {
        [view removeFromSuperview];
    }
    
    if (imageArray) {
        NSInteger count = imageArray.count;
        int space = (self.fileView.fw - kImageCol*kImageWH) / (kImageCol+1);
        for (int i=0; i<count+1; i++) {
            int row = i / kImageCol;
            int col = i % kImageCol;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT(space+(kImageWH+space)*col, space+(kImageWH+space)*row, kImageWH, kImageWH)];
            imageView.userInteractionEnabled = YES;
            [self.fileView addSubview:imageView];
            
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
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.fileView setFh:(kImageWH + space)*rowNum + space];
            self.bottomScrollView.contentSize = CGSizeMake(APP_W, 600);
        }];
        NSLog(@"%f",self.bottomScrollView.contentSize.height);
    }else{
        UIImageView *addImageBtn = [[UIImageView alloc] initWithFrame:RECT(5, 5, kImageWH, kImageWH)];
        addImageBtn.image = [UIImage imageNamed:@"add.png"];
        addImageBtn.userInteractionEnabled = YES;
        [self.fileView addSubview:addImageBtn];
        
        [addImageBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)]];
    }
}
- (void)deleteImage:(UITapGestureRecognizer *)ges
{
    UIView *view = ges.view;
    NSInteger index = view.tag - 90000;
    [imgArr removeObjectAtIndex:index];
    
    for (UIView *view in self.fileView.subviews) {
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
    [imageDataUrlArr addObject:url];
    
    [self addAttachmentWithImageArray:imgArr];
}

- (void)addStar1:(UITapGestureRecognizer *)ges
{
    if (_is1Stared == NO) {
        self.star1.image = [UIImage imageNamed:@"黄.png"];
        self.star2.image = [UIImage imageNamed:@"灰.png"];
        self.star3.image = [UIImage imageNamed:@"灰.png"];
        self.star4.image = [UIImage imageNamed:@"灰.png"];
        self.star5.image = [UIImage imageNamed:@"灰.png"];
        _starNum = @"1";
        _is1Stared = YES;
    }else{
        self.star1.image = [UIImage imageNamed:@"灰.png"];
        self.star2.image = [UIImage imageNamed:@"灰.png"];
        self.star3.image = [UIImage imageNamed:@"灰.png"];
        self.star4.image = [UIImage imageNamed:@"灰.png"];
        self.star5.image = [UIImage imageNamed:@"灰.png"];
        _starNum = 0;
        _is1Stared = NO;
    }
}

- (void)addStar2:(UITapGestureRecognizer *)ges
{
    if (_is2Stared == NO) {
        self.star1.image = [UIImage imageNamed:@"黄.png"];
        self.star2.image = [UIImage imageNamed:@"黄.png"];
        self.star3.image = [UIImage imageNamed:@"灰.png"];
        self.star4.image = [UIImage imageNamed:@"灰.png"];
        self.star5.image = [UIImage imageNamed:@"灰.png"];
        _starNum = @"2";
        _is2Stared = YES;
    }else{
        self.star1.image = [UIImage imageNamed:@"黄.png"];
        self.star2.image = [UIImage imageNamed:@"灰.png"];
        self.star3.image = [UIImage imageNamed:@"灰.png"];
        self.star4.image = [UIImage imageNamed:@"灰.png"];
        self.star5.image = [UIImage imageNamed:@"灰.png"];
        _starNum = @"1";
        _is2Stared = NO;
    }
}

- (void)addStar3:(UITapGestureRecognizer *)ges
{
    if (_is3Stared == NO) {
        self.star1.image = [UIImage imageNamed:@"黄.png"];
        self.star2.image = [UIImage imageNamed:@"黄.png"];
        self.star3.image = [UIImage imageNamed:@"黄.png"];
        self.star4.image = [UIImage imageNamed:@"灰.png"];
        self.star5.image = [UIImage imageNamed:@"灰.png"];
        _starNum = @"3";
        _is3Stared = YES;
    }else{
        self.star1.image = [UIImage imageNamed:@"黄.png"];
        self.star2.image = [UIImage imageNamed:@"黄.png"];
        self.star3.image = [UIImage imageNamed:@"灰.png"];
        self.star4.image = [UIImage imageNamed:@"灰.png"];
        self.star5.image = [UIImage imageNamed:@"灰.png"];
        _starNum = @"2";
        _is3Stared = NO;
    }
}

- (void)addStar4:(UITapGestureRecognizer *)ges
{
    if (_is4Stared == NO) {
        self.star1.image = [UIImage imageNamed:@"黄.png"];
        self.star2.image = [UIImage imageNamed:@"黄.png"];
        self.star3.image = [UIImage imageNamed:@"黄.png"];
        self.star4.image = [UIImage imageNamed:@"黄.png"];
        self.star5.image = [UIImage imageNamed:@"灰.png"];
        _starNum = @"4";
        _is4Stared = YES;
    }else{
        self.star1.image = [UIImage imageNamed:@"黄.png"];
        self.star2.image = [UIImage imageNamed:@"黄.png"];
        self.star3.image = [UIImage imageNamed:@"黄.png"];
        self.star4.image = [UIImage imageNamed:@"灰.png"];
        self.star5.image = [UIImage imageNamed:@"灰.png"];
        _starNum = @"3";
        _is4Stared = NO;
    }
}

- (void)addStar5:(UITapGestureRecognizer *)ges
{
    if (_is5Stared == NO) {
        self.star1.image = [UIImage imageNamed:@"黄.png"];
        self.star2.image = [UIImage imageNamed:@"黄.png"];
        self.star3.image = [UIImage imageNamed:@"黄.png"];
        self.star4.image = [UIImage imageNamed:@"黄.png"];
        self.star5.image = [UIImage imageNamed:@"黄.png"];
        _starNum = @"5";
        _is5Stared = YES;
    }else{
        self.star1.image = [UIImage imageNamed:@"黄.png"];
        self.star2.image = [UIImage imageNamed:@"黄.png"];
        self.star3.image = [UIImage imageNamed:@"黄.png"];
        self.star4.image = [UIImage imageNamed:@"黄.png"];
        self.star5.image = [UIImage imageNamed:@"灰.png"];
        _starNum = @"4";
        _is5Stared = NO;
    }
}

- (IBAction)switch:(UISwitch *)sender {
    if(sender.isOn){
        self.banzuInfo.enabled = NO;
        UIButton *btn = (UIButton *)[self.banzuInfo.subviews firstObject];
        btn.enabled = NO;
        self.banzuInfo2.enabled = YES;
        self.banzuInfo2.text = @"";
        self.banzuInfo.text = @"";
    }else{
        self.banzuInfo.enabled = YES;
        self.banzuInfo2.text = @"";
        self.banzuInfo.text = @"";
        UIButton *btn = (UIButton *)[self.banzuInfo.subviews firstObject];
        btn.enabled = YES;
        self.banzuInfo2.enabled = NO;
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    NSTimeInterval animationDuration = 0.30f;
//    CGRect frame = self.view.frame;
//    frame.origin.y -= 320;
//    frame.size.height += 320;
//    self.view.frame = frame;
//    [UIView beginAnimations:@"ResizeView" context:nil];
//    [UIView setAnimationDuration:animationDuration];
//    self.view.frame = frame;
//    [UIView commitAnimations];
    
    
    [UIView animateWithDuration:0.30f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= 50;
        frame.size.height += 50;
        self.view.frame = frame;
    }];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.30f animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y -= 5;
        frame.size.height += 5;
        self.view.frame = frame;
    }];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
}

@end
