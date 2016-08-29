//
//  ZYFDisplayCols.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/3.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZYFDisplayCols : NSObject <NSCoding>

/**
*  需要显示的key
*/
@property (nonatomic,strong) NSArray *keyArray;
/**
 *  需要显示的key对应的类型
 */
@property (nonatomic,strong) NSArray *valueArray;
/**
 *  需要显示的key对应的中文名字
 */
@property (nonatomic,strong) NSArray *nameArray;
/**
 *  需要显示的key是否可编辑
 */
@property (nonatomic,strong) NSArray *editableArray;

/**
 *  每次请求得到的数据的当前页数，用于每次刷新时，页数加1
 */
@property (nonatomic,assign) NSInteger page;


-(instancetype)initWithDict:(NSDictionary*)dict;
+(instancetype)displayColWithDict:(NSDictionary*)dict;





@end
