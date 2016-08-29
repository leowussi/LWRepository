//
//  ExpenseType.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/16.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExpenseType : NSObject

@property (nonatomic,strong ) NSArray *keyArray;
@property (nonatomic,strong ) NSArray *valueArray;

+(instancetype)expenseType;

@end
