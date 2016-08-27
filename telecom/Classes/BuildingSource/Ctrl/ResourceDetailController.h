//
//  ResourceDetailController.h
//  telecom
//
//  Created by liuyong on 16/3/2.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceModel.h"
#import "AnnotationDetailDataModel.h"

@interface ResourceDetailController : UIViewController

@property(nonatomic,strong)AnnotationDetailDataModel *singleModel;
@property (nonatomic,copy) NSString *road;
@property (nonatomic,copy) NSString *lane;
@property (nonatomic,copy) NSString *gate;
@property (nonatomic,copy) NSString *lou;
@property (nonatomic,copy) NSString *currentAddress;
@end
