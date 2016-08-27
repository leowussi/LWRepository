//
//  RequestSupportDetailCell.h
//  telecom
//
//  Created by SD0025A on 16/5/24.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RequestSupportDetailCell;
@protocol RequestSupportDetailCellDelegate <NSObject>
- (void)taskDetailAction:(RequestSupportDetailCell *)cell;
@end
@class RequestSupportDetailModel;
@interface RequestSupportDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (weak, nonatomic) IBOutlet UILabel *label7;
@property (weak, nonatomic) IBOutlet UILabel *label8;
@property (weak, nonatomic) IBOutlet UILabel *label9;
@property (weak, nonatomic) IBOutlet UILabel *label10;
@property (weak, nonatomic) IBOutlet UIButton *taskBtn;
- (IBAction)taskAction:(UIButton *)sender;

@property (nonatomic,weak) id<RequestSupportDetailCellDelegate> delegate;
- (void)configModel:(RequestSupportDetailModel *)model;
@end
