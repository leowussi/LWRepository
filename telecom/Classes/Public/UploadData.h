//
//  UploadData.h
//  telecom
//
//  Created by ZhongYun on 15-4-9.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadData : NSObject
@property (nonatomic,copy)void(^respBlocker)(id result);
- (void)send:(NSDictionary*)arg;
@end
