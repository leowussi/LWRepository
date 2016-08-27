//
//  FiltViewController.h
//  telecom  SXABaseViewController
//
//  Created by Sundear on 16/2/19.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MathBlock)(NSString *,NSString *);
@interface FiltViewController :SXABaseViewController
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,copy)MathBlock bloc;
@end
