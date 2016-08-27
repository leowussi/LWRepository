//
//  LQFoceList.h
//  telecom
//
//  Created by Sundear on 16/3/25.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PglModel.h"
@interface LQFoceList : NSObject
@property(nonatomic,strong)PglModel *model;
@property(nonatomic,assign)CGFloat RightViewHihgt;
/**
 *  cell高度
 */
@property(nonatomic,assign)CGFloat rowHihgt;
@end
