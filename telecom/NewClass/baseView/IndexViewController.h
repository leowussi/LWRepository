//
//  IndexViewController.h
//  JingRong360
//
//  Created by thsboy on 14-6-06.
//  Copyright (c) 2014年 qian.sundear. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol firstIn <NSObject>

-(void)firstIn;

@end

@interface IndexViewController : UIViewController
@property (nonatomic,assign) id<firstIn> delegate;
@end
