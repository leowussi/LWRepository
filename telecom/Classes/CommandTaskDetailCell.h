//
//  CommandTaskDetailCell.h
//  telecom
//
//  Created by SD0025A on 16/5/16.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommandTaskDetailModel;
@protocol CommandTaskDetailCellDelegate <NSObject>

- (void)showMoreView:(UIView *)moreView;
- (void)uploadFile;
@end
@interface CommandTaskDetailCell : UITableViewCell
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
@property (weak, nonatomic) IBOutlet UILabel *label11;
@property (weak, nonatomic) IBOutlet UILabel *label12;

@property (weak, nonatomic) IBOutlet UILabel *label13;
@property (weak, nonatomic) IBOutlet UILabel *label14;
@property (weak, nonatomic) IBOutlet UILabel *label15;
@property (weak, nonatomic) IBOutlet UILabel *label16;
@property (weak, nonatomic) IBOutlet UILabel *label17;



@property (weak, nonatomic) IBOutlet UIButton *isShowBtn;
- (IBAction)isShowBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *moreView;//height 130
@property (nonatomic,weak) id<CommandTaskDetailCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadBtn:(UIButton *)sender;
- (void)configModel:(CommandTaskDetailModel *)model;
@end
