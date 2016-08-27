//
//  FixsViewController.m
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "FixsViewController.h"
//#import "FixReasonViewController.h"
//#import "FixWaysView.h"

#import "OptionView.h"
#import "FixWayView.h"

#import "iflyMSC/IFlySpeechUtility.h"
#import "iflyMSC/IFlyRecognizerView.h"
#import "iflyMSC/IFlySpeechConstant.h"
#import "iflyMSC/IFlyRecognizerViewDelegate.h"
#import "iflyMSC/IFlyDataUploader.h"
#import "iflyMSC/IFlyUserWords.h"

#import "ZYQAssetPickerController.h"

@interface FixsViewController ()<UITextFieldDelegate,IFlyRecognizerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,ZYQAssetPickerControllerDelegate,UIScrollViewDelegate,FixWayViewDelegate,OptionViewDelegate,UITextViewDelegate>
{
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    NSMutableArray *imageNameArr;
    BOOL _isShowcheckFixReason;
}
@property(nonatomic,strong)UIButton *rightBtn;
@property(nonatomic,strong)UIView *firBottomView;
@property(nonatomic,strong)UIView *attachmentInfo;
@property(nonatomic,strong)UIScrollView *attachScrollView;
@property(nonatomic,strong)UILabel *fixReasonLabel;
@property(nonatomic,strong)UITextField *fixDescTextField;
@property(nonatomic,strong)UILabel *fixWayLabel;

@property(nonatomic,strong)OptionView *optionView;
@property(nonatomic,strong)FixWayView *fixWayView;

@property(nonatomic,copy)NSString *userWords;

@property (nonatomic, strong) ZYPlaceholderTextView *fixDescTextView;
@end

@implementation ZYPlaceholderTextView

#pragma mark - 重写父类方法
- (void)setText:(NSString *)text {
    [super setText:text];
    [self drawPlaceholder];
    return;
}

- (void)setPlaceholder:(NSString *)placeholder {
    if (![placeholder isEqual:_placeholder]) {
        _placeholder = placeholder;
        [self drawPlaceholder];
    }
    return;
}

#pragma mark - 父类方法
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configureBase];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configureBase];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_shouldDrawPlaceholder) {
        [_placeholderTextColor set];
        [_placeholder drawInRect:CGRectMake(8.0f, 8.0f, self.frame.size.width - 16.0f,
                                            self.frame.size.height - 16.0f) withFont:self.font];
    }
    return;
}

- (void)configureBase {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    self.placeholderTextColor = [UIColor colorWithWhite:0.702f alpha:1.0f];
    _shouldDrawPlaceholder = NO;
    return;
}

- (void)drawPlaceholder {
    BOOL prev = _shouldDrawPlaceholder;
    _shouldDrawPlaceholder = self.placeholder && self.placeholderTextColor && self.text.length == 0;
    if (prev != _shouldDrawPlaceholder) {
        [self setNeedsDisplay];
    }
    return;
}

- (void)textChanged:(NSNotification *)notification {
    [self drawPlaceholder];
    return;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    return;
}

@end


@implementation FixsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修复";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFixReasonShowing"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFixWayShowing"];

    imageNameArr = [NSMutableArray array];
    imageDataUrlArr = [NSMutableArray array];
    imgArr = [NSMutableArray array];
    
    imageNameArr = [NSMutableArray array];
    imageDataUrlArr = [NSMutableArray array];
    imgArr = [NSMutableArray array];
    
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"552504d3"];
    [IFlySpeechUtility createUtility:initString];
    
    [self setUpUI];
    
    [self setUpRightBarButton];
    
    //创建语音听写的对象
    self.iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
    //delegate需要设置，确保delegate回调可以正常返回
    _iflyRecognizerView.delegate = self;
    
    [self addImagePicker];
}

- (void)setUpUI
{
    UILabel *workNoTitleLabel = [MyUtil createLabel:RECT(8, 84, 80, 25) text:@"流水单号:"
                                          alignment:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    workNoTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_baseScrollView addSubview:workNoTitleLabel];
    
    UILabel *workNoLabel = [MyUtil createLabel:RECT(CGRectGetMaxX(workNoTitleLabel.frame)+5, 84, 150, 25) text:self.orderNo alignment:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    workNoLabel.font = [UIFont systemFontOfSize:15.0f];
    [_baseScrollView addSubview:workNoLabel];
    
    UILabel *handlePersonTitleLabel = [MyUtil createLabel:RECT(8, workNoTitleLabel.ey+10, 80, 25) text:@"处理人员:"
                                                alignment:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    handlePersonTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_baseScrollView addSubview:handlePersonTitleLabel];
    
    UILabel *handlePersonLabel = [MyUtil createLabel:RECT(handlePersonTitleLabel.ex+5, workNoLabel.ey+10, 150, 25) text:UGET(U_NAME) alignment:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    handlePersonLabel.font = [UIFont systemFontOfSize:15.0f];
    [_baseScrollView addSubview:handlePersonLabel];
    
    UILabel *fixDescTitleLabel = [MyUtil createLabel:RECT(8, handlePersonTitleLabel.ey+10, 80, 25) text:@"修复原因:" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    fixDescTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    [_baseScrollView addSubview:fixDescTitleLabel];
    
    self.fixDescTextField = [[UITextField alloc] initWithFrame:RECT(fixDescTitleLabel.ex+5, handlePersonLabel.ey+10, 150, 25)];
    self.fixDescTextField.borderStyle = UITextBorderStyleNone;
    self.fixDescTextField.delegate = self;
    self.fixDescTextField.placeholder = @"";
    self.fixDescTextField.font = [UIFont systemFontOfSize:13.0f];
    self.fixDescTextField.layer.borderWidth = 0.5;
    self.fixDescTextField.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    [_baseScrollView addSubview:self.fixDescTextField];
    
    UIImage *voiceImage = [UIImage imageNamed:@"voiceInput.png"];
    UIImageView *voiceInputImageView = [[UIImageView alloc] initWithFrame:RECT(0, 0, voiceImage.size.width/1.2, voiceImage.size.height/1.2)];
    voiceInputImageView.image = voiceImage;
    voiceInputImageView.userInteractionEnabled = YES;
    [voiceInputImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voiceInputAction:)]];
    self.fixDescTextField.rightView = voiceInputImageView;
    self.fixDescTextField.rightViewMode = UITextFieldViewModeAlways;
    
//    UILabel *fixReasonTitleLabel = [MyUtil createLabel:RECT(8, self.fixDescTextField.ey+5, 80, 25) text:@"修复原因:"
//                                             alignment:NSTextAlignmentLeft  textColor:[UIColor blackColor]];
//    fixReasonTitleLabel.font = [UIFont systemFontOfSize:15.0f];
//    [_baseScrollView addSubview:fixReasonTitleLabel];
    
    self.fixReasonLabel = [MyUtil createLabel:RECT(fixDescTitleLabel.frame.origin.x + fixDescTitleLabel.frame.size.width + 5, self.fixDescTextField.ey+5, 200, 25) text:@"  请选择修复原因" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    self.fixReasonLabel.font = [UIFont systemFontOfSize:13.0f];
    self.fixReasonLabel.textColor = RGBCOLOR(168, 168, 168);
    self.fixReasonLabel.layer.borderWidth = 0.5;
    self.fixReasonLabel.numberOfLines = 0;
    self.fixReasonLabel.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    [_baseScrollView addSubview:self.fixReasonLabel];
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"检索.png"];
    checkBtn.frame = RECT(self.fixDescTextField.ex+5, fixDescTitleLabel.frame.origin.y, image.size.width/1.8, image.size.height/1.5);
    [checkBtn setBackgroundImage:[UIImage imageNamed:@"检索.png"] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(checkFixReason) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:checkBtn];
    
    self.firBottomView = [[UIView alloc] initWithFrame:RECT(8, self.fixReasonLabel.ey+20, APP_W-16, 200)];
    self.firBottomView.userInteractionEnabled = YES;
    self.firBottomView.backgroundColor = [UIColor clearColor];
    [_baseScrollView addSubview:self.firBottomView];
    
    
    
    UILabel *fixReasonTitleLabel = [MyUtil createLabel:RECT(0, 0, 80, 25) text:@"修复描述:" alignment:NSTextAlignmentLeft  textColor:[UIColor blackColor]];
    fixReasonTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.firBottomView addSubview:fixReasonTitleLabel];
    
    
    _fixDescTextView = [[ZYPlaceholderTextView alloc] initWithFrame:CGRectMake(85, 0, 200, 80)];
    _fixDescTextView.font = [UIFont systemFontOfSize:13];
    _fixDescTextView.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    _fixDescTextView.layer.borderWidth = .5f;
    _fixDescTextView.placeholder = @"请输入修复描述";
    _fixDescTextView.delegate = self;
    [self.firBottomView addSubview:_fixDescTextView];

    
    UILabel *fixWayTitleLabel = [MyUtil createLabel:RECT(0, 85, 80, 25) text:@"修复方式"
                                          alignment:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    fixWayTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.firBottomView addSubview:fixWayTitleLabel];
    
    
    self.fixWayLabel = [MyUtil createLabel:RECT(85, 85, 200, 25) text:@"  请选择修复方式" alignment:NSTextAlignmentLeft textColor:[UIColor blackColor]];
    self.fixWayLabel.userInteractionEnabled = YES;
    self.fixWayLabel.font = [UIFont systemFontOfSize:13.0f];
    self.fixWayLabel.textColor = RGBCOLOR(168, 168, 168);
    self.fixWayLabel.layer.borderWidth = 0.5;
    self.fixWayLabel.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    [self.fixWayLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseFixWay)]];
    [self.firBottomView addSubview:self.fixWayLabel];
    
    self.attachmentInfo= [[UIView alloc] initWithFrame:RECT(0, fixWayTitleLabel.ey+10, self.firBottomView.frame.size.width, 102)];
    self.attachmentInfo.userInteractionEnabled = YES;
    self.attachmentInfo.backgroundColor = [UIColor clearColor];
    [self.firBottomView addSubview:self.attachmentInfo];
    
    UILabel *attachTitleLabel = [MyUtil createLabel:RECT(0, 0, self.attachmentInfo.fw, 25) text:@" 附件信息" alignment:
                                 NSTextAlignmentLeft textColor:[UIColor whiteColor]];
    attachTitleLabel.font = [UIFont systemFontOfSize:15.0f];
    attachTitleLabel.backgroundColor = RGBCOLOR(92, 178, 249);
    [self.attachmentInfo addSubview:attachTitleLabel];
    
    self.attachScrollView = [[UIScrollView alloc] initWithFrame:RECT(0, 35, self.attachmentInfo.fw, 77)];//attachTitleLabel.ey+10
    [self.attachmentInfo addSubview:self.attachScrollView];
    
    _baseScrollView.scrollEnabled = YES;
    [self addOptionView];
}

#pragma mark - 右侧按钮
- (void)setUpRightBarButton
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightBtn.frame = CGRectMake(APP_W-40, 7, 30, 30);
    [self.rightBtn setBackgroundImage:[[UIImage imageNamed:@"checkBtn.png"]  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(fixAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

- (void)addImagePicker
{
    UIImageView *addImage = [[UIImageView alloc] initWithFrame:RECT(0, 0, 76, 76)];
    addImage.image = [UIImage imageNamed:@"addImag1"];
    addImage.userInteractionEnabled = YES;
    [addImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImage)]];
    [self.attachScrollView addSubview:addImage];
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
    for (UIView *view in self.attachScrollView.subviews) {
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
        [self.attachScrollView addSubview:imageView];
    }
    self.attachScrollView.contentSize = CGSizeMake(77*(array.count+1), 0);
    self.attachScrollView.showsHorizontalScrollIndicator = YES;
}

- (void)deleteImage:(UITapGestureRecognizer *)ges
{
    UIView *view = ges.view;
    NSInteger index = view.tag - 90000;
    [imgArr removeObjectAtIndex:index];
    [imageNameArr removeObjectAtIndex:index];
    [imageDataUrlArr removeObjectAtIndex:index];
    
    for (UIView *view in self.attachScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    [self showImagesOnScrollViewWithArray:imgArr];
}


- (void)fixAction
{
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    NSString *workNo = self.workNum;
    NSString *cause = self.fixReasonLabel.text;
    NSString *fixWay = self.fixWayLabel.text;
//    NSString *description = self.fixDescTextField.text;
    NSString *description = _fixDescTextView.text;
    if ([cause isEqualToString:@"请选择修复原因"]) {
        showAlert(@"请选择修复原因!");
        return;
    }
    
    if ([fixWay isEqualToString:@"选择修复方式"]) {
        showAlert(@"请选择修复方式!");
        return;
    }
    
    if ([description isEqualToString:@""]) {
        showAlert(@"请输入修复描述!");
        return;
    }
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[@"operationTime"] = operationTime;
    paraDict[@"accessToken"] = accessToken;
    paraDict[@"workNo"] = workNo;
    paraDict[@"cause"] = cause;
    paraDict[@"fixWay"] = fixWay;
    paraDict[@"description"] = description;
    
//    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/%@.json?operationTime=%@&accessToken=%@&workNo=%@&cause=%@&fixWay=%@&description=%@",ADDR_IP,ADDR_DIR,kFaultFix,operationTime,accessToken,workNo,cause,fixWay,description];
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/%@.json",ADDR_IP,ADDR_DIR,kFaultFix];
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

#pragma mark -- 匹配结果
- (void)addOptionView
{
    [self.firBottomView setFy:self.firBottomView.fy+25];
    
    self.optionView = [[OptionView alloc] initWithFrame:RECT(8, self.fixReasonLabel.ey+15 , APP_W-16, 200) withTitle:@"匹配结果"];
    self.optionView.delegate = self;
    self.optionView.clipsToBounds = YES;
    self.optionView.backgroundColor = [UIColor whiteColor];
    [_baseScrollView addSubview:self.optionView];
    
    _baseScrollView.contentSize = CGSizeMake(APP_W, APP_H + 100);
    
    self.optionView.frame = RECT(8, self.fixReasonLabel.ey+15 , APP_W-16, 20);
    UIControl *control = [[UIControl alloc] initWithFrame:self.optionView.titleLabel.frame];
    [control addTarget:self action:@selector(tapGesture) forControlEvents:UIControlEventTouchUpInside];
    [self.optionView addSubview:control];
    
    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(self.optionView.frame.size.width - 20, 2, 11, 15);
    imageLayer.contents = (id)[UIImage imageNamed:@"right_arrow_cur"].CGImage;
    [self.optionView.layer addSublayer:imageLayer];
}

#pragma mark -- textViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect scrollRect = _baseScrollView.frame;
    scrollRect.size.height -= 297;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:7];
    [UIView setAnimationDuration:.25f];
    _baseScrollView.frame = scrollRect;
    [UIView commitAnimations];
    [_baseScrollView scrollRectToVisible:CGRectMake(textView.frame.origin.x + textView.superview.frame.origin.x, textView.frame.origin.y + textView.superview.frame.origin.y, textView.frame.size.width, textView.frame.size.height) animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect scrollRect = _baseScrollView.frame;
    scrollRect.size.height += 297;
    _baseScrollView.frame = scrollRect;
}

- (void)tapGesture
{
    CALayer *layer = [self.optionView.layer.sublayers lastObject];
    if (!_isShowcheckFixReason) {
        
        layer.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
        [self checkFixReason];
    }else{
        layer.transform = CATransform3DIdentity;
        [UIView animateWithDuration:0.25f animations:^{
            self.optionView.frame = RECT(8, self.fixReasonLabel.ey+15 , APP_W-16, 20);
            [self.firBottomView setFy:self.firBottomView.fy-205];
            _baseScrollView.contentSize = CGSizeMake(APP_W, APP_H+100);
             [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFixReasonShowing"];
        }];

    }
    _isShowcheckFixReason = !_isShowcheckFixReason;
}

- (void)checkFixReason
{
//    if ([self.fixDescTextField.text isEqualToString:@""]) {
//        showAlert(@"请先输入修复原因关键词!");
//        return;
//    }
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFixReasonShowing"]) {
        [UIView animateWithDuration:0.25f animations:^{
            [self.firBottomView setFy:self.firBottomView.fy+205];
            self.optionView.frame = RECT(8, self.fixReasonLabel.ey+15 , APP_W-16, 200);
            
        }];
        _baseScrollView.contentSize = CGSizeMake(APP_W, APP_H+300);
        NSString *fixReasonText = self.fixDescTextField.text;
        
        [self.optionView loadFixReasonsDataWithURL:kGetVoiceResultList parameter:[NSString stringWithFormat:@"%@&%@",self.spec,fixReasonText] functionId:@"0"];
//
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFixReasonShowing"];
    }
}

- (void)deliverFixReason:(NSString *)fixReasonString
{
    _isShowcheckFixReason = NO;
    [UIView animateWithDuration:0.25f animations:^{
        self.fixReasonLabel.text = fixReasonString;
        self.optionView.frame = RECT(8, self.fixReasonLabel.ey+15 , APP_W-16, 20);
        [self.firBottomView setFy:self.firBottomView.fy-205];
         _baseScrollView.contentSize = CGSizeMake(APP_W, APP_H+100);
    }];
    if (self.fixReasonLabel.frame.size.height < 30) {
        CGRect labelRect = self.fixReasonLabel.frame;
        labelRect.size.height = 34;
        self.fixReasonLabel.frame = labelRect;
    }

    CALayer *layer = [self.optionView.layer.sublayers lastObject];
    layer.transform = CATransform3DIdentity;
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFixReasonShowing"];
    self.fixReasonLabel.textColor = [UIColor blackColor];
}


- (void)chooseFixWay
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isFixWayShowing"]) {
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.attachmentInfo setFy:self.attachmentInfo.fy+205];
            [self.firBottomView setFh:self.firBottomView.fh+205];
        }];
        
        self.fixWayView = [[FixWayView alloc] initWithFrame:RECT(self.fixWayLabel.fx, self.fixWayLabel.ey+5, self.fixWayLabel.fw, 180)];
        self.fixWayView.delegate = self;
        self.fixWayView.backgroundColor = [UIColor whiteColor];
        [self.firBottomView addSubview:self.fixWayView];
        
        _baseScrollView.contentSize = CGSizeMake(APP_W, APP_H+300);
        
        [self.fixWayView loadFixWaysDataWithURL:kFixWayReasons];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isFixWayShowing"];
    }
}

- (void)deliverFixWay:(NSString *)fixWay
{
    [UIView animateWithDuration:0.3f animations:^{
        self.fixWayLabel.text = fixWay;
        [self.fixWayView removeFromSuperview];
        self.fixWayView = nil;
        [self.attachmentInfo setFy:self.attachmentInfo.fy-205];
        [self.firBottomView setFh:self.firBottomView.fh-205];
    }];
    self.fixWayLabel.textColor = [UIColor blackColor];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFixWayShowing"];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)voiceInputAction:(id)sender {
    
    [self loadUserWord];
    [self onUploadUserWord:sender];
    
    [_iflyRecognizerView setParameter: @"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    //设置结果数据格式，可设置为json，xml，plain，默认为json。
    [_iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    [_iflyRecognizerView start];
}

- (void)loadUserWord
{
    httpGET2(@{URL_TYPE : kGetKeyWords,@"functionId" : @"1"}, ^(id result) {
        
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            self.userWords = result[@"detail"][@"keyWords"];
        }
        
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

/*
 * @上传用户词
 */
#define NAME @"userwords"
#define USERWORDS   self.userWords

- (void) onUploadUserWord:(id)sender
{
    
    [self.uploader setParameter:@"iat" forKey:[IFlySpeechConstant SUBJECT]];
    [self.uploader setParameter:@"userword" forKey:[IFlySpeechConstant DATA_TYPE]];
    
    
    IFlyUserWords *iFlyUserWords = [[IFlyUserWords alloc] initWithJson:USERWORDS ];
    
    [self.uploader uploadDataWithCompletionHandler:^(NSString * grammerID, IFlySpeechError *error)
     {
         
     } name:NAME data:[iFlyUserWords toString]];
}


- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    
    self.fixDescTextField.text = [NSString stringWithFormat:@"%@",result];
}

/** 识别结束回调方法
 @param error 识别错误
 */
- (void)onError:(IFlySpeechError *)error
{
    //    showAlert([error errorDesc]);
    
    NSLog(@"errorCode:%d",[error errorCode]);
}

#pragma mark -- 计算文字的高度
- (CGFloat)calculateTextheight:(NSString *)text
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} context:nil];
    return ceilf(rect.size.height);
}


@end
