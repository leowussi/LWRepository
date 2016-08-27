//
//  TroubleHeaderFooterView.h
//  telecom
//
//  Created by Sundear on 16/2/18.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  TroubleHeaderFooterView;
@protocol TroubleHeaderFooterViewDelegate <NSObject>

-(void)headerViewDidClick:(TroubleHeaderFooterView *)header;

@end


@interface TroubleHeaderFooterView : UITableViewHeaderFooterView
@property(nonatomic,weak)id<TroubleHeaderFooterViewDelegate>delegate;
+(instancetype)headerViewWithTableview:(UITableView *)tableview;
@end
