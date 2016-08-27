//
//  AddFaultOrderController.m
//  telecom
//
//  Created by liuyong on 15/5/15.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AddFaultOrderController.h"
#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"

#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>

#import "ZYQAssetPickerController.h"
#import "WorkTypeAndFaultSymModel.h"

#import "WorkInfoController.h"
#import "FaultSymController.h"
#import "FaultLevelView.h"

@interface AddFaultOrderController ()<IFlyRecognizerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate,ZYQAssetPickerControllerDelegate,WorkInfoControllerDelegate,FaultSymControllerDelegate,FaultLevelViewDelegate>
{
    NSMutableArray *_baseInfo;
    NSMutableData *_receiveData;
    
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    NSMutableArray *imageNameArr;
    
    NSString *_nuId;
    NSString *_workTypeId;
    NSString *_faultSymId;
    NSString *_faultLevelId;
    
    BOOL _isFaultLevelShow;
    FaultLevelView *_faultLevelView;
}
@end

@implementation AddFaultOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加故障单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _baseInfo = [NSMutableArray array];
    _isFaultLevelShow = NO;
    _faultLevelId = @"4";
    
    imageNameArr = [NSMutableArray array];
    imageDataUrlArr = [NSMutableArray array];
    imgArr = [NSMutableArray array];
    
    self.voiceInputImageView.layer.masksToBounds = YES;
    
    UIButton *descBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    descBtn.frame = self.descOfFaultText.frame;
    [descBtn setBackgroundColor:[UIColor clearColor]];
    [descBtn addTarget:self action:@selector(descBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:descBtn];
    
    
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"552504d3"];
    [IFlySpeechUtility createUtility:initString];
    
    //创建语音听写的对象
    self.iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    //delegate需要设置，确保delegate回调可以正常返回
    _iflyRecognizerView.delegate = self;
    
    [self setUpRightBarButton];
    [self addImagePicker];
    [self loadBaseInfoData];
    
    self.voiceInputImageView.userInteractionEnabled = YES;
    [self.voiceInputImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceInputAction)]];
    self.faultLevelLabel.userInteractionEnabled = YES;
    [self.faultLevelLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseFaultLevelAction)]];
}

#pragma mark - 右侧按钮
- (void)setUpRightBarButton
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightBtn.frame = CGRectMake(APP_W-40, 7, 30, 30);
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_check@2x"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(addShareInfoAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

- (void)addShareInfoAction
{
    if (![_nuId isEqualToString:@""] && _workTypeId != nil && _faultSymId != nil) {
        NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd-HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        NSString *nuId = _nuId;
        NSString *workTypeId = _workTypeId;
        NSString *faultSymId = _faultSymId;
        NSString *faultLevelId = _faultLevelId;
        
        NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/%@.json?operationTime=%@&accessToken=%@&nuId=%@&workTypeId=%@&faultSymId=%@&faultLevelId=%@",ADDR_IP,ADDR_DIR,@"KBFault/GetFaultInsert",operationTime,accessToken,nuId,workTypeId,faultSymId,faultLevelId];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"%@",requestUrl);
        [manager POST:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
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
    }else{
        showAlert(@"当前无法新建故障单");
    }
}

- (void)chooseFaultLevelAction
{
    if (_isFaultLevelShow == NO) {
        _faultLevelView = [[FaultLevelView alloc] initWithFrame:CGRectMake(25, 200, 280, 180)];
        _faultLevelView.delegate = self;
        _faultLevelView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_faultLevelView];
        
        [_faultLevelView loadDataWithURL:kGetFaultLevel];
    }
}

- (void)deliverFaultLevel:(NSString *)faultLevel faultLevelId:(NSString *)faultLevelId
{
    self.faultLevelLabel.text = faultLevel;
    _faultLevelId = faultLevelId;
    [_faultLevelView removeFromSuperview];
    _isFaultLevelShow = NO;
}

- (void)descBtnAction:(id)sender
{
    if (_workTypeId != nil) {
        FaultSymController *faultSymCtrl = [[FaultSymController alloc] init];
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:faultSymCtrl];
        faultSymCtrl.workTypeId = _workTypeId;
        faultSymCtrl.delegate = self;
        [self presentViewController:navCtrl animated:YES completion:nil];
    }
}

- (void)deliverFaultSymInfo:(NSString *)FaultSymInfo FaultSymInfoId:(NSString *)FaultSymInfoId
{
    _faultSymId = FaultSymInfoId;
    self.descOfFaultText.text = FaultSymInfo;
}

- (void)addImagePicker
{
    UIImageView *addImage = [[UIImageView alloc] initWithFrame:RECT(0, 0, 76, 76)];
    addImage.image = [UIImage imageNamed:@"addImag1"];
    addImage.userInteractionEnabled = YES;
    [addImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)]];
    [self.attachmentImage addSubview:addImage];
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
    for (UIView *view in self.attachmentImage.subviews) {
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
        [self.attachmentImage addSubview:imageView];
    }
    self.attachmentImage.contentSize = CGSizeMake(77*(array.count+1), 0);
    self.attachmentImage.showsHorizontalScrollIndicator = YES;
}

- (void)deleteImage:(UITapGestureRecognizer *)ges
{
    UIView *view = ges.view;
    NSInteger index = view.tag - 90000;
    [imgArr removeObjectAtIndex:index];
    [imageNameArr removeObjectAtIndex:index];
    [imageDataUrlArr removeObjectAtIndex:index];
    
    for (UIView *view in self.attachmentImage.subviews) {
        [view removeFromSuperview];
    }
    
    [self showImagesOnScrollViewWithArray:imgArr];
}

- (void)loadBaseInfoData
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = NW_GetFaultInfo;
    paraDict[@"taskId"] = self.callBackInfoDict[@"taskId"];
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            
            self.majorLabel.text = result[@"detail"][@"specialtyName"];
            self.kindOfWorkLabel.text = result[@"detail"][@"workName"];
            self.faultLevelLabel.text = @"一般";
            self.zoneAreaInfoLabel.text = result[@"detail"][@"regionName"];
            self.stationInfoLabel.text = result[@"detail"][@"sitenName"];
            self.machineRoomInfoLabel.text = result[@"detail"][@"roomName"];
            self.wangYuanInfoLabel.text = result[@"detail"][@"nuName"];
            
            _nuId = result[@"detail"][@"nuId"];
            
            if (![_nuId isEqualToString:@""]) {
                WorkInfoController *workCtrl = [[WorkInfoController alloc] init];
                workCtrl.nuId = _nuId;
                workCtrl.delegate = self;
                UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:workCtrl];
                [self presentViewController:navCtrl animated:YES completion:nil];
            }
        }
        
        
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (void)deliverWorkInfo:(NSString *)workInfo workInfoId:(NSString *)workInfoId
{
    self.kindOfWorkLabel.text = workInfo;
    _workTypeId = workInfoId;
}

- (void)voiceInputAction
{
    [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    //设置结果数据格式，可设置为json，xml，plain，默认为json。
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    [_iflyRecognizerView start];
}

/** 识别结束回调方法
 @param resultArray 返回数组
 */
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    self.descOfFaultText.text = [NSString stringWithFormat:@"%@",result];
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    NSLog(@"errorCode:%d",[error errorCode]);
}


@end
