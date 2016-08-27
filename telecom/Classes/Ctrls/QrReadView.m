//
//  QrReadView.m
//  telecom
//
//  Created by ZhongYun on 14-6-14.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "QrReadView.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZBarSDK.h"
#import "NSTimer+Blocks.h"

@interface QrReadView ()<ZBarReaderViewDelegate>
{
    ZBarReaderView* m_readerView;
    AVCaptureDevice *inputDevice;
    UIButton *flashlightButton;
    BOOL flashlightOn;

    NSTimer* m_timer;
    UILabel *discrLable;
    
    UIImageView *backGroudView;
    UIImageView* scanLine;
}
@end
static NSString *TAG;
@implementation QrReadView


- (void)addNavigationRightButton:(NSString *)str
{
    flashlightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    flashlightButton.frame = CGRectMake(kScreenWidth-[UIImage imageNamed:str].size.width/2, 12,[UIImage imageNamed:str].size.width/1.3,[UIImage imageNamed:str].size.height/1.3);
    [flashlightButton setBackgroundImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
    [flashlightButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:flashlightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [rightButtonItem release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"二维码扫描";
    TAG = @"qr";//默认为二维码扫描
    UIImage *img = [UIImage imageNamed:@"ewmsm2.png"];
    self.view.backgroundColor = RGBCOLOR(178, 178, 178);
    
    [self addNavigationRightButton:@"ewmsm1.png"];
    
    inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
    [self.captureSession addInput:captureInput];
    
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
        

    m_readerView = [[ZBarReaderView alloc] init];
    m_readerView.frame = CGRectMake(kScreenWidth/2-img.size.width/4, 155, img.size.width/2, img.size.height/2);
    m_readerView.readerDelegate = self;
    m_readerView.torchMode = 0;
    m_readerView.trackingColor = [UIColor clearColor];
    [self.view addSubview:m_readerView];
    CGRect scanMaskRect = CGRectMake(kScreenWidth/2-img.size.width/4, 155, img.size.width/2, img.size.height/2);
//    m_readerView.scanCrop = [self getScanCrop:scanMaskRect readerViewBounds:m_readerView.bounds];
    [self addScanblackMaskView:scanMaskRect];
    
    discrLable = [[UILabel alloc]initWithFrame:CGRectMake(50,170+img.size.height/2, kScreenWidth-100, 20)];
    discrLable.textAlignment=NSTextAlignmentCenter;
    discrLable.text = @"把二维码放入框内,即可自动扫描";
    discrLable.font = [UIFont systemFontOfSize:15.0];
    discrLable.textColor = [UIColor whiteColor];
    [self.view addSubview:discrLable];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-70, kScreenWidth, 70)];
    bgView.backgroundColor = RGBCOLOR(36, 36, 36);
    [self.view addSubview:bgView];
    [bgView release];
    
    UIImage *leftImg = [UIImage imageNamed:@"ewmsm3.png"];
    UIImage *rightImg = [UIImage imageNamed:@"ewmsm4.png"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(kScreenWidth/4-leftImg.size.width/2, 10, leftImg.size.width/1.5, leftImg.size.height/1.5)];
    [leftBtn setBackgroundImage:leftImg forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:leftBtn];
    
    UILabel *leftLable = [UnityLHClass initUILabel:@"二维码" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth/4-leftImg.size.width/2, leftImg.size.height/1.5+10, rightImg.size.width/1.5, 20)];
    leftLable.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:leftLable];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(kScreenWidth/2+rightImg.size.width, 10, rightImg.size.width/1.5, rightImg.size.height/1.5)];
    [rightBtn setBackgroundImage:rightImg forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rightBtn];
    
    UILabel *rightLable = [UnityLHClass initUILabel:@"条形码" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(kScreenWidth/2+rightImg.size.width, rightImg.size.height/1.5+10, rightImg.size.width/1.5, 20)];
    rightLable.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:rightLable];
    
    [m_readerView start];
}


- (void)buttonPressed:(UIButton *)button
{
    if (button == flashlightButton)
    {
        if (flashlightOn == NO)
        {
            [flashlightButton setBackgroundImage:[UIImage imageNamed:@"关闭闪光灯.png"] forState:UIControlStateNormal];
            flashlightOn = YES;
            [inputDevice lockForConfiguration:nil];
            [inputDevice setTorchMode: AVCaptureTorchModeOn];
            [inputDevice unlockForConfiguration];
            
        }
        else
        {
            [flashlightButton setBackgroundImage:[UIImage imageNamed:@"ewmsm1.png"] forState:UIControlStateNormal];
            flashlightOn = NO;
            [inputDevice lockForConfiguration:nil];
            [inputDevice setTorchMode: AVCaptureTorchModeOff];
            [inputDevice unlockForConfiguration];
            
            
        }
        
        
        
    }
}


-(void)leftBtn
{
    NSLog(@"二维码扫描");
    TAG = @"qr";//二维码
    scanLine.hidden = NO;
    
    UIImage *img = [UIImage imageNamed:@"ewmsm2.png"];
    UIImage* linepic = [UIImage imageNamed:@"scan_line.png"];
    
    discrLable.text = @"把二维码放入框内,即可自动扫描";
    
    backGroudView.frame = CGRectMake(kScreenWidth/2-img.size.width/4, 155, img.size.width/2, img.size.height/2);
    m_readerView.frame = CGRectMake(kScreenWidth/2-img.size.width/4, 155, img.size.width/2, img.size.height/2);
    
    scanLine.frame = RECT(kScreenWidth/2-img.size.width/4,
                          155 + self.navBarView.ey + img.size.height/2-30,
                          img.size.width/2, linepic.size.height);
}

-(void)rightBtn
{
    NSLog(@"条形码扫描");
    TAG = @"bar";//条形码
    scanLine.hidden = YES;
    
    UIImage *img = [UIImage imageNamed:@"ewmsm2.png"];
    UIImage* linepic = [UIImage imageNamed:@"scan_line.png"];
    
    discrLable.text = @"把条形码放入框内,即可自动扫描";
    
    backGroudView.frame = CGRectMake(30, 155, kScreenWidth-60, img.size.height/2-30);
    m_readerView.frame = CGRectMake(30, 155, kScreenWidth-60, img.size.height/2-30);
    scanLine.frame = RECT(kScreenWidth/2-img.size.width/4,
                          155 + self.navBarView.ey + img.size.height/2-30,
                          img.size.width/2, linepic.size.height);
    
}


- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    NSString *result = nil;
    for (ZBarSymbol *symbol in symbols) {
        result = symbol.data;
        if ([result canBeConvertedToEncoding:NSShiftJISStringEncoding])
        {
            result = [NSString stringWithCString:[result cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        break;
        
    }
    
    [m_readerView stop];
    //[m_timer invalidate];
    [self.view viewWithTag:1887].hidden = YES;
    
    if (self.respBlock) {
        self.respBlock(result);
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (self.WZBlock) {
        self.WZBlock(result,TAG);
    }
    
}

- (void)addScanblackMaskView:(CGRect)scanMaskRect
{
    UIImage *img = [UIImage imageNamed:@"ewmsm2.png"];
//    newImageView(self.view, @[@50, @"ewmsm2.png",RECT_OBJ(kScreenWidth/2-img.size.width/4, 155, img.size.width/2, img.size.height/2)]);
    
    backGroudView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-img.size.width/4, 155, img.size.width/2, img.size.height/2)];
    backGroudView.image = img;
    backGroudView.userInteractionEnabled = YES;
    [self.view addSubview:backGroudView];
    
    UIImage* linepic = [UIImage imageNamed:@"scan_line.png"];
    scanLine = [[UIImageView alloc] initWithImage:linepic];
    scanLine.tag = 1887;
    scanLine.frame = RECT(kScreenWidth/2-img.size.width/4,
                          scanMaskRect.origin.y + self.navBarView.ey + scanMaskRect.size.height/2,
                          img.size.width/2, linepic.size.height);
    [self.view addSubview:scanLine];
    
    m_timer = [NSTimer scheduledTimerWithTimeInterval:0.01 block:^{
        CGFloat max_y = self.navBarView.ey + scanMaskRect.origin.y + scanMaskRect.size.height - scanLine.fh;
        scanLine.fy += 1;
        if (scanLine.fy >= max_y) {
            scanLine.fy = scanMaskRect.origin.y + self.navBarView.ey;
        }
    } repeats:YES];
    
    [scanLine release];
    
//    UIView* scanBox = [[UIView alloc] initWithFrame:scanMaskRect];
//    scanBox.backgroundColor = [UIColor clearColor];
//    scanBox.layer.borderWidth = 1;
//    [m_readerView addSubview:scanBox];
}

-(CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds
{
    CGFloat x,y,width,height;
    
    x = (rect.origin.x / readerViewBounds.size.width) + 0.050;
    y = (rect.origin.y / readerViewBounds.size.height) - 0.068;
    width = (rect.size.width / readerViewBounds.size.height) + 0.025;
    height = (rect.size.height / readerViewBounds.size.width) + 0.025;

    return CGRectMake(x, y, width, height);
}

+ (BOOL)checkCamera
{
#if !TARGET_IPHONE_SIMULATOR
    
    BOOL Custom= [UIImagePickerController
                  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];//判断摄像头是否能用
    if (Custom) {
        return YES;
    }
//    if (iOSv7) {
//        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//        if (status != AVAuthorizationStatusAuthorized) {
//            showAlert(@"相机权限未开启");
//            return NO;
//        }
//    }
    return YES;
#else
    return NO;
#endif
}

+ (void)requestCamera
{
#if !TARGET_IPHONE_SIMULATOR
    if (![QrReadView checkCamera]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {}];
    }
#endif
}

@end
