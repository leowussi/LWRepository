//
//  RecordCell.h
//  telecom
//
//  Created by liuyong on 15/7/20.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecordCellDelegate <NSObject>

- (void)showDetailImageWithIndex:(NSInteger)index fileIdDict:(NSDictionary *)dict;

@end

@interface RecordCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *constuctorLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *fileScrollView;
@property (strong, nonatomic) IBOutlet UILabel *fileTitleLabel;

@property(nonatomic,weak)id <RecordCellDelegate> delegate;
@property(nonatomic,strong)NSDictionary *fileIdDict;
- (void)configCell:(NSDictionary *)dict;
+ (CGFloat)heightForCell:(NSDictionary *)dict;
@end
