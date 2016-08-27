//
//  ImageAndVideoPicker.h
//  telecom
//
//  Created by SD0025A on 16/5/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import <MediaPlayer/MediaPlayer.h>
@protocol ImageAndVideoPickerDelegate <NSObject>
- (void)addImageFromTZI:(NSArray *)array;
- (void)addVedioFromTZI:(NSData *)movieData coverImage:(UIImage *)coverImage;


@end
@interface ImageAndVideoPicker : NSObject<TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong) UIViewController *ctrl;

@property (nonatomic,strong) TZImagePickerController *TZI;

@property (nonatomic,strong) UIImage *movieImage;


@property (nonatomic,weak) id<ImageAndVideoPickerDelegate> delegate;
- (void)pickImageFromPhotos;
- (void)pickResourceFormCamera;
@end
