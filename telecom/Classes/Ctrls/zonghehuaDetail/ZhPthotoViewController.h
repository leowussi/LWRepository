//
//  ZhPthotoViewController.h
//  telecom
//
//  Created by 郝威斌 on 15/9/25.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "SXABaseViewController.h"

@protocol upPhotoDlegate <NSObject>

- (void)screenVC:(NSString *)str indexPath:(NSIndexPath *)indexPath;

@end

@interface ZhPthotoViewController : SXABaseViewController

@property(strong,nonatomic)NSArray *photoArr;
@property(strong,nonatomic)NSString *strTaskID;
@property(nonatomic,strong)NSIndexPath *indexPath;

@property(assign,nonatomic)id<upPhotoDlegate>delegate;

@end
