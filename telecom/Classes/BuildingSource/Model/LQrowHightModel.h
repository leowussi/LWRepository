//
//  LQrowHightModel.h
//  telecom
//
//  Created by Sundear on 16/3/23.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GjjxModel.h"
#import "GfqxModel.h"
#import "LQFoceList.h"
@interface LQrowHightModel : NSObject
@property(nonatomic,strong)GjjxModel *model;
@property(nonatomic,assign)CGFloat rowHihgt;
/**
 * 存放文本计算的高度
 */
@property(nonatomic,assign)CGFloat HeaderViewHight;

@property(nonatomic,strong)LQFoceList *foceModel;
/**
 * 存放文本计算的高度
 */
@property(nonatomic,assign)CGFloat rightViewHight;
/**
 *  存放所有focList每个文本计算的高度
 */
@property(nonatomic,assign)NSMutableArray *RightDownarray;
/**
 *  存放所有focList每个view得高度
 */
@property(nonatomic,assign)NSMutableArray *RightDownViewHightarray;

@property (nonatomic, assign, getter = isOpened) BOOL opened;

@end
