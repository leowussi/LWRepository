//
//  ZYFAttributes.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/2.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYFLookUp.h"
#import "ZYFPickList.h"


/**
 *  Attributes
 */

@interface ZYFAttributes : NSObject <NSCoding>


@property (nonatomic,copy) NSString *myKey;

@property (nonatomic,copy) NSString *myValueString;

@property (nonatomic,copy) NSString *myDateTime;



@property (nonatomic,strong) ZYFLookUp *lookUp;
@property (nonatomic,strong) ZYFPickList *pickList;



-(instancetype)initWithDict:(NSDictionary*)dict valueType:(NSString*)valueType;
+(instancetype)attributesWithDict:(NSDictionary*)dict valueType:(NSString*)valueType;

@end
