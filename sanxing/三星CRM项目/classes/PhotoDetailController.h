//
//  PhotoDetailController.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/2.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) NSArray *images;

@end
