//
//  YZAcceptanceListTableViewCell.h
//  AcceptanceApplication
//
//  Created by 锋 on 16/5/16.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZAcceptanceListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIView *view_background;
@property (nonatomic, strong) UILabel *label_title;
@property (nonatomic, strong) UILabel *label_desc;

@property (nonatomic, strong) UIButton *button_delete;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contianDeleteButton:(BOOL)isShow;

@end


@interface YZAcceptanceList : NSObject

@property (nonatomic, copy) NSString *string_projectname;
@property (nonatomic, retain) NSMutableAttributedString *string_desc;
@property (nonatomic, copy) NSString *checkId;

@property (nonatomic, copy) NSString *checkResult;

- (instancetype)initWithParserDictionary:(NSDictionary *)dict;

@end
