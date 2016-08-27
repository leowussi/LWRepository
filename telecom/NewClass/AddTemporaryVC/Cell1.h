//
//  Cell1.h
//  KuanJiaDemo
//
//  Created by 郝威斌 on 15/3/11.
//  Copyright (c) 2015年 XXX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Cell1 : UITableViewCell

@property(strong,nonatomic)UILabel *titleLabel;
@property(strong,nonatomic)UIImageView *leftImageView;
@property(strong,nonatomic)UIImageView *arrowImageView;

- (void)changeArrowWithUp:(BOOL)up;
@end
