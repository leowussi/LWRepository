//
//  SignFailedReasonView.m
//  telecom
//
//  Created by ZhongYun on 15-3-21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "SignFailedReasonView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UploadFile.h"
#import "JSON.h"

#define TITLE_H 62
#define ROW_H   NAV_H
#define BTN_H   NAV_H

#define PicTmpFileName      @"pick_tmp_photo.png"

@interface SignFailedReasonView()<UITextFieldDelegate>
{
    UIView* m_boxView;
    NSArray* m_reasons;
}
@end

@implementation SignFailedReasonView

- (void)dealloc
{
    [m_reasons release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self getReasonList];
    }
    return self;
}

- (void)getReasonList
{
    httpGET1(@{URL_TYPE:NW_GetSignFailedReasons}, ^(id result) {
        m_reasons = [[NSArray alloc] initWithArray:result[@"list"]];
        mainThread(buildView, nil);
    });
}

- (void)buildView
{
    UIView* backView = [[UIView alloc] initWithFrame:self.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.4;
    [self addSubview:backView];
    [backView release];
    
    CGFloat box_h = TITLE_H + m_reasons.count * ROW_H + BTN_H;
    m_boxView = [[UIView alloc] initWithFrame:RECT(25, (self.fh-box_h)/2, APP_W-50, box_h)];
    m_boxView.clipsToBounds = YES;
    m_boxView.backgroundColor = [UIColor whiteColor];
    m_boxView.layer.cornerRadius = 4;
    [self addSubview:m_boxView];
    
    newLabel(m_boxView, @[@50, RECT_OBJ(0, 0, m_boxView.fw, TITLE_H), RGB(0x000000), FontB(Font2), @"选择失败原因"]).textAlignment = NSTextAlignmentCenter;

    CGFloat item_y = TITLE_H;
    for (int i = 0; i < m_reasons.count; i++) {
        NSString* title = m_reasons[i][@"reason"];
        if (NSNotFound == [title rangeOfString:@"其他"].location) {
            UIButton* btnItem = [[UIButton alloc] initWithFrame:RECT(0, item_y, m_boxView.fw, ROW_H)];
            btnItem.titleLabel.font = Font(Font2);
            btnItem.tag = 100 + i;
            [btnItem setTitle:title forState:0];
            [btnItem setTitleColor:RGB(0x007aff) forState:0];
            [btnItem setBackgroundImage:color2Image(RGB(0xffffff)) forState:0];
            [btnItem addTarget:self action:@selector(onBtnItemTouched:) forControlEvents:UIControlEventTouchUpInside];
            [m_boxView addSubview:btnItem];
            [btnItem release];
        } else {
            UITextField* txt = newTextField(m_boxView, @[@51, RECT_OBJ(15, item_y, m_boxView.fw-30, ROW_H), RGB(0x000000), Font(Font2), title, @""]);
            txt.delegate = self;
        }
        
        UIView* line = [[UIView alloc] initWithFrame:RECT(0, item_y, m_boxView.fw, 0.5)];
        line.backgroundColor = RGB(0xafafb3);
        [m_boxView addSubview:line];
        [line release];
        item_y += ROW_H;
    }
    
    UIView* line1 = [[UIView alloc] initWithFrame:RECT(0, m_boxView.fh-BTN_H, m_boxView.fw, 0.5)];
    line1.backgroundColor = RGB(0xafafb3);
    [m_boxView addSubview:line1];
    [line1 release];
    
    UIView* line2 = [[UIView alloc] initWithFrame:RECT(m_boxView.fw/2, line1.fy, 0.5, BTN_H)];
    line2.backgroundColor = RGB(0xafafb3);
    [m_boxView addSubview:line2];
    [line2 release];
    
    CGFloat btn_w = (m_boxView.fw/2);
    UIButton* btnCancle = [[UIButton alloc] initWithFrame:RECT(0, m_boxView.fh-BTN_H, btn_w, BTN_H)];
    btnCancle.backgroundColor = [UIColor clearColor];
    btnCancle.titleLabel.font = Font(Font2);
    [btnCancle setTitle:@"取消" forState:0];
    [btnCancle setTitleColor:RGB(0x007aff) forState:0];
    [btnCancle addTarget:self action:@selector(onBtnCancleTouched:) forControlEvents:UIControlEventTouchUpInside];
    [m_boxView addSubview:btnCancle];
    [btnCancle release];
    
    UIButton* btnCommit = [[UIButton alloc] initWithFrame:RECT(m_boxView.fw/2, m_boxView.fh-BTN_H, btn_w, BTN_H)];
    btnCommit.backgroundColor = [UIColor clearColor];
    btnCommit.titleLabel.font = FontB(Font2);
    [btnCommit setTitle:@"确定" forState:0];
    [btnCommit setTitleColor:RGB(0x007aff) forState:0];
    [btnCommit addTarget:self action:@selector(onBtnCommitTouched:) forControlEvents:UIControlEventTouchUpInside];
    [m_boxView addSubview:btnCommit];
    [btnCommit release];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

- (void)dialogClose
{
    [self removeFromSuperview];
}

- (void)onBtnCancleTouched:(id)sender
{
    [self dialogClose];
}

- (void)onBtnCommitTouched:(id)sender
{
    NSString* desc = tagViewEx(self, 51, UITextField).text;
    if (desc.length == 0) {
        showAlert(@"请填写原因！");
        return;
    }
    
    NSDictionary* item = nil;
    for (int i = 0; i < m_reasons.count; i++) {
        if (NSNotFound != [m_reasons[i][@"reason"] rangeOfString:@"其他"].location) {
            item = m_reasons[i];
            break;
        }
    }
    if (item == nil) return;
    
    if (self.respBlock) {
        self.respBlock(item, desc);
    }
    [self dialogClose];
}

- (void)onBtnItemTouched:(UIButton*)sender
{
    int index = sender.tag - 100;
    if (self.respBlock) {
        self.respBlock(m_reasons[index], nil);
    }
    [self dialogClose];
}



@end



@interface SignFailedReason()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, NSURLConnectionDataDelegate>
{
    NSDictionary* m_reason;
    NSString* m_desc;
    UIViewController* _viewController;
    NSMutableData* _mResponseData;
}
@end

@implementation SignFailedReason

- (void)showDialog:(UIViewController*)viewCtrl
{
    _viewController = viewCtrl;
    SignFailedReasonView* dialog = [[SignFailedReasonView alloc] initWithFrame:RECT(0, 0, SCREEN_W, SCREEN_H)];
    dialog.respBlock = ^(NSDictionary* reason, NSString* desc) {
        m_reason = [[NSDictionary alloc] initWithDictionary:reason];
        m_desc = [desc copy];
        mainThread(showGetPhoto, nil);
    };
    [_viewController.view addSubview:dialog];
    [dialog release];
}

- (void)sendSignFailedReason
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *tmpfilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:PicTmpFileName];
    NSString* imgFileName = format(@"%@.png", date2str([NSDate date], @"yyyyMMddHHmmss"));
    
    UploadFile* httpup = [[UploadFile alloc] init];
    httpup.respBlocker = ^(int t, id v) {
        [self httpUploadFileResp:t Value:v];
    };
    [httpup send:@{URL_TYPE:NW_UploadSignFailedFile, FILE_PATH:tmpfilePath, @"fileName":imgFileName}];
    [httpup release];
}

- (void)httpUploadFileResp:(int)t Value:(id)v
{
    if (t == RESP_WILL_SEND) {
        showLoading(@"请稍等");
    } else if (t == RESP_PROGRESS) {
        ;
    } else if (t == RESP_ERROR) {
        hideLoading();
        self.signOverBlock(NO);
    } else if (t == RESP_FAILED) {
        hideLoading();
        self.signOverBlock(NO);
    } else if (t == RESP_TIMEOUT) {
        hideLoading();
        self.signOverBlock(NO);
    } else if (t == RESP_SUCCESS) {
        hideLoading();
        NSDictionary* rsDict = [v JSONValue];
        if ([rsDict[@"result"] isEqualToString:@"0000000"]) {
            NSDictionary* param = @{URL_TYPE:NW_submitSignFailedReason,
                                    @"regionId":self.regionId,
                                    @"reason":(m_desc ? m_desc : m_reason[@"reason"]),
                                    @"attachmentId":rsDict[@"detail"][@"fileId"]};
            httpGET2(param, ^(id result) {
                self.signOverBlock(YES);
            }, ^(id result) {
                self.signOverBlock(NO);
            });
        } else {
            self.signOverBlock(NO);
        }
    }
}


- (void)showGetPhoto
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"选择照片"
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"相机", @"相册", nil];
    [alertView showWithBlock:^(NSInteger btnIndex) {
        if (btnIndex == 1) {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController * picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [_viewController presentModalViewController:picker animated:YES];
                [picker release];
            } else {
                showAlert(@"模拟器不支持相机");
            }
        } else if (btnIndex == 2) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [_viewController.navigationController presentModalViewController:picker animated:YES];
            [picker release];
        }
    }];
    [alertView release];
}

- (void)catchPickedPhoto:(UIImage*)image
{
    if (image == nil) {
        showAlert(@"图片获取失败");
        return;
    }
    
    CGFloat imgScale = 1*(image.size.width>image.size.height ? (SCREEN_W/image.size.width) : (SCREEN_H/image.size.height));
    if (imgScale < 1) {
        image = [self scaleToSize:image size:CGSizeMake(image.size.width*imgScale, image.size.height*imgScale)];
        if (image == nil) {
            return;
        }
    }
    
    NSString* filePath = [SignFailedReason saveImage:image Name:PicTmpFileName];
    if (!filePath) return ;
    [_viewController.navigationController dismissModalViewControllerAnimated:YES];
    mainThread(sendSignFailedReason, nil);
}

-(UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (scaledImage == nil) {
        showAlert(format(@"图片压缩失败(%d,%d)", (int)size.width, (int)size.height));
    }
    return scaledImage;
    
}

+ (NSString*)saveImage:(UIImage*)image Name:(NSString*)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:name];
    //NSLog(@"%d>>>%f", __LINE__, CFAbsoluteTimeGetCurrent());
    if (![UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
        showAlert(@"图片缓存失败");
        return nil;
    }
    //NSLog(@"%d>>>%f", __LINE__, CFAbsoluteTimeGetCurrent());
    return filePath;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage* image = (UIImage *)[info objectForKey: UIImagePickerControllerOriginalImage];
        mainThread(catchPickedPhoto:, image);
    } else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:info[UIImagePickerControllerReferenceURL] resultBlock:^(ALAsset *asset) {
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            CGImageRef imgRef = [representation fullResolutionImage];
            UIImage* image = [UIImage imageWithCGImage:imgRef
                                                 scale:representation.scale
                                           orientation:(UIImageOrientation)representation.orientation];
            mainThread(catchPickedPhoto:, image);
        }failureBlock:^(NSError *error){
            showAlert(@"获取图片失败");
        }];
    }
}



@end