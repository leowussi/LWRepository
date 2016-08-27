//
//  PullDownViewInAddRequest.h
//  telecom
//
//  Created by SD0025A on 16/5/30.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PullDownViewInAddRequest : UIView
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) int currentIndex;
@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UIScrollView *scroll;
- (void)setLabelTitle;
@end
