//
//  PublicModel.h
//  telecom
//
//  Created by Sundear on 16/3/29.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GdjModel;
@class OltModel;
@class ObdModel;
@class OnuModel;

@interface PublicModel : NSObject
@property(nonatomic,strong)GdjModel *GDjMoedl;
@property(nonatomic,strong)OltModel *OltModel;
@property(nonatomic,strong)ObdModel *OBDModel;
@property(nonatomic,strong)OnuModel *ONUModel;
@property(nonatomic,assign)CGFloat hight;
@end
