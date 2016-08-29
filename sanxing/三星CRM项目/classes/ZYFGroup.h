//
//  ZYFGroup.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/18.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYFRelateEntity.h"

@interface ZYFGroup : NSObject

//name和id属性
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *ID;
//cols
@property (nonatomic,strong) NSArray *cols;
//用来存放解析好的form对象
@property (nonatomic,strong) NSArray *formArray;
//用来显示list类型数据的左边的数据
@property (nonatomic,copy) NSString *leftList;
//用来显示list类型数据的右边的数据
@property (nonatomic,copy) NSString *rightList;
//用来显示list右侧更多按钮中的筛选条件的数据
@property (nonatomic,copy) NSArray *relateEntityOfListArray;


/**
 *  标识这组是否需要展开,  YES : 展开 ,  NO : 关闭,(只在表单查询主界面中使用)
 */
@property (nonatomic, assign, getter = isOpened) BOOL opened;


@end
