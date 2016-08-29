//
//  UIImage+ZYF.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/31.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "UIImage+ZYF.h"

@implementation UIImage (ZYF)

//对图片尺寸进行压缩--
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
