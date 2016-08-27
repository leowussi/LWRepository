//
//  SHTiaoZhuanViewController.h
//  telecom
//
//  Created by Sundear on 16/2/24.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@protocol SHTiaoZhuanViewControllerDelegate <NSObject>
-(void)Select:(NSString *)str withID:(NSString *)par And:(NSIndexPath *)indexPath;

@end


typedef void(^Tblock)(NSString *,NSString *);
@interface SHTiaoZhuanViewController : SXABaseViewController
@property(nonatomic,strong)NSArray *DeleArray;
@property(nonatomic,copy)Tblock Tblock;
@property(nonatomic,weak)id<SHTiaoZhuanViewControllerDelegate>delegate;
@end
