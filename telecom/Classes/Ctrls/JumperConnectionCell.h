//
//  JumperConnectionCell.h
//  telecom
//
//  Created by SD0025A on 16/4/1.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JumperConnectionCellModel ;
@interface JumperConnectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (nonatomic,assign) CGFloat cellHeight;
- (void)configModel:(JumperConnectionCellModel *)model;

@end
