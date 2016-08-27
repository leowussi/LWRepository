//
//  OpenModel.h
//  telecom
//
//  Created by Sundear on 16/3/17.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "MJExtension.h"

@class AddressModel;

@interface OpenModel : NSObject

@property(nonatomic,copy)NSString *gridCode;
@property(nonatomic,copy)NSString *gridName;
@property(nonatomic,strong)NSMutableArray *addressList;
@property (nonatomic, assign, getter = isOpened) BOOL opened;
+ (instancetype)OpenModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
