//
//  BusinessButton.h
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/6.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessButton : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//        [btn addTarget:self action:@selector(businessBtnClicked:) forControlEvents:UIControlEventTouchUpInside];


@end
