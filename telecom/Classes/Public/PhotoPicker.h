//
//  PhotoPicker.h
//  rrhl
//
//  Created by ZhongYun on 15-4-5.
//  Copyright (c) 2015年 hillor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoPicker : NSObject
- (void)pickWithSize:(CGSize)size ImageName:(NSString*)name;
@property (nonatomic,copy)void(^pickBlock)(UIImage* image);
@property (nonatomic,copy,readonly)NSString* imagePath;
@property (nonatomic,retain)UIViewController* parentVC;
@end
NSString* getPathForPickImage(NSString* imgFileName);