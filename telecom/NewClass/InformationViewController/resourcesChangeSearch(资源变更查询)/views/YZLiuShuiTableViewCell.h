//
//  YZLiuShuiTableViewCell.h
//  CheckResourcesChange
//
//  Created by 锋 on 16/5/3.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZLiuShuiTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *label_department;
@property (nonatomic, strong) UILabel *label_desc;
@property (nonatomic, strong) UILabel *label_status;
@property (nonatomic, strong) UILabel *label_time;

@end

@interface YZLiuShuiInfo : NSObject

@property (nonatomic, copy) NSString *string_department;
@property (nonatomic, copy) NSString *string_desc;
@property (nonatomic, copy) NSString *string_status;
@property (nonatomic, copy) NSString *string_time;

- (instancetype)initWithParserDictionary:(NSDictionary *)dict;

@end
