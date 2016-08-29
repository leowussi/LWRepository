//
//  DownPhotos.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/2.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownPhotos : NSObject

@property (nonatomic,strong) NSArray *beforeArray;
@property (nonatomic,strong) NSArray *afterArray;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)downPhotoWithDict:(NSDictionary *)dict;

@end
