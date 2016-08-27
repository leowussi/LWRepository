//
//  SelectTableViewCell.h
//  telecom
//
//  Created by 郝威斌 on 15/5/25.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTableViewCell : UITableViewCell
{
    BOOL			m_checked;
    UIImageView*	m_checkImageView;
}

@property(strong,nonatomic)UILabel *leftLable;
@property(strong,nonatomic)UIImageView *leftImgView;

- (void)setChecked:(BOOL)checked;
@end
