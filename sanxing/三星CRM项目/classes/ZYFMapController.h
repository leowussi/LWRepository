//
//  MapController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/24.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYFSaleList.h"

@class ZYFMapController;

@protocol MapControllerDelegate <NSObject>

- (void)mapController:(ZYFMapController *)ctrl updateAdress:(NSString *)address;

@end

@interface ZYFMapController : UIViewController
//地址文本
@property (nonatomic,copy) NSString *text;
//经度
@property (nonatomic,assign) CGFloat  longitude;
//纬度
@property (nonatomic,assign) CGFloat latitude;

@property (nonatomic,strong) ZYFSaleList *sale;

@property (nonatomic,assign) id<MapControllerDelegate> delegate;

@property (nonatomic,copy) NSString *cleanTaskId;




@end
