//
//  QrReadView.h
//  telecom
//
//  Created by ZhongYun on 14-6-14.
//  Copyright (c) 2014年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ZBarReaderController.h"


@interface QrReadView : BaseViewController<UIAlertViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>


@property (nonatomic,copy)void(^respBlock)(NSString* v);
@property (nonatomic, retain) AVCaptureSession *captureSession;

@property (nonatomic,copy)void(^WZBlock)(NSString* v,NSString *w);

+ (BOOL)checkCamera;
+ (void)requestCamera;
@end
