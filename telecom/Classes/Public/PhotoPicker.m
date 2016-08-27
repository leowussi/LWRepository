//
//  PhotoPicker.m
//  rrhl
//
//  Created by ZhongYun on 15-4-5.
//  Copyright (c) 2015年 hillor. All rights reserved.
//

#import "PhotoPicker.h"
#import <AssetsLibrary/AssetsLibrary.h>

extern UIViewController* getCurrViewController(void);
@interface PhotoPicker ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    CGSize m_size;
    BOOL m_allowsEditing;
}
@end

@implementation PhotoPicker

- (id)init
{
    if (self = [super init]) {
        _imagePath = nil;
    }
    return self;
}

- (void)pickWithSize:(CGSize)size ImageName:(NSString*)name
{
    m_size = size;
    m_allowsEditing = !CGSizeEqualToSize(m_size, CGSizeZero);
    _imagePath = [getPathForPickImage(name) copy];
    [self showPickDialog];
}

- (void)showPickDialog
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
                picker.allowsEditing = m_allowsEditing;
                [self.parentVC presentModalViewController:picker animated:YES];
                [picker release];
            } else {
                showAlert(@"模拟器不支持相机");
            }
        } else if (btnIndex == 2) {
            UIImagePickerController * picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.allowsEditing = m_allowsEditing;
            [self.parentVC.navigationController presentModalViewController:picker animated:YES];
            [picker release];
        }
    }];
    [alertView release];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = info[m_allowsEditing ? UIImagePickerControllerEditedImage : UIImagePickerControllerOriginalImage];
    
    
    [self catchImage:image];
    //[UIImagePNGRepresentation(image) writeToFile:getPathForPickImage(PICK_TEMP_NAME) atomically:YES];
    [self.parentVC.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)catchImage:(UIImage*)image
{
    //NSLog(@"BGN:%f", CFAbsoluteTimeGetCurrent());
    //缩小图片尺寸;
    UIImage* scaledImage = [self resizeImage:image];
    NSData* imgData = UIImageJPEGRepresentation(scaledImage, 0.75);
    
    if (![imgData writeToFile:_imagePath atomically:YES]) {
        showAlert(@"图片缓存失败");
        return;
    }
    //NSLog(@"END:%f", CFAbsoluteTimeGetCurrent());
    
    UIImage* tmpimg = [UIImage imageWithContentsOfFile:_imagePath];
    if (self.pickBlock) {
        self.pickBlock(tmpimg);
    }
}

- (UIImage*)resizeImage:(UIImage*)image
{
    CGSize scaleSize = image.size;
    BOOL isPortrait = (image.size.height > image.size.width);
    if ( !m_allowsEditing ) {
        //整个图片，不用截取(上传照片用);
        if (isPortrait) {
            //纵向图片: 以宽为准，宽度缩小到手机分辨率宽(SCREEN_W * SCREEN_S)
            CGFloat target_w = SCREEN_W * SCREEN_S;
            if (scaleSize.width > target_w) {
                scaleSize.height = (target_w / scaleSize.width) * scaleSize.height;
                scaleSize.width = target_w;
            }
        } else {
            //横向图片: 以高为准，高度缩小到手机分辨率宽(SCREEN_W * SCREEN_S, 注：因为是横置手机，所以还用这个表达式);
            CGFloat target_h = SCREEN_W * SCREEN_S;
            if (scaleSize.height > target_h) {
                scaleSize.width = (target_h / scaleSize.height) * scaleSize.width;
                scaleSize.height = target_h;
            }
        }
    } else {
        //截取部分图片(头像用)
        scaleSize.width = m_size.width * SCREEN_S;
        scaleSize.height = m_size.height * SCREEN_S;
    }
    
    UIGraphicsBeginImageContext(scaleSize);
    [image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (scaledImage == nil) {
        showAlert(format(@"图片压缩失败(%d,%d)->(%d,%d)",
                         (int)image.size.width, (int)image.size.height,
                         (int)scaleSize.width, (int)scaleSize.height ));
    }
    return scaledImage;
}

@end

NSString* getPathForPickImage(NSString* imgFileName)
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* pickPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"PickPhoto"];
    NSString *filePath = [pickPath stringByAppendingPathComponent:imgFileName];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:pickPath]) {
        [fileManager createDirectoryAtPath:pickPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return filePath;
}
