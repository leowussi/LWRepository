//
//  BusinessBtnModel.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/6/30.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BusinessBtnModel : NSObject <NSCoding>

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)businessBtnModelWithDict:(NSDictionary*)dict;

/**
 *  按钮显示的名称
 */
@property (nonatomic,copy) NSString *displayName;
/**
 *  按钮图片的名称
 */
@property (nonatomic,copy) NSString *iconName;
/**
 *  按钮图片的地址
 */
@property (nonatomic,copy) NSString *iconUrl;


@end
