//
//  YZImageAccessoryViewController.h
//  telecom
//
//  Created by 锋 on 16/6/27.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZImageAccessoryViewController : UIViewController

@property (nonatomic, copy) NSString *workNo;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end


@interface YZImageAccessoryList : NSObject

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSAttributedString *accessoryName;
@property (nonatomic, copy) NSString *attachmentId;
- (instancetype)initWithParserWithDictionary:(NSDictionary *)dict textColor:(UIColor *)color;
@end