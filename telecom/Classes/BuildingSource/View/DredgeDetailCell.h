//
//  DredgeDetailCell.h
//  telecom
//
//  Created by SD0025A on 16/6/22.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>



@class FloorListDataModel;
@protocol DredgeDetailCellDelegate <NSObject>
- (void)tapView:(UITapGestureRecognizer *)ges indexPath:(NSIndexPath *)indexPath;


@end
@interface DredgeDetailCell : UITableViewCell
//宽带
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UILabel *label5;

//语音
@property (weak, nonatomic) IBOutlet UIView *view21;
@property (weak, nonatomic) IBOutlet UILabel *label21;
@property (weak, nonatomic) IBOutlet UIView *view22;
@property (weak, nonatomic) IBOutlet UILabel *label22;
@property (weak, nonatomic) IBOutlet UIView *view23;
@property (weak, nonatomic) IBOutlet UILabel *label23;
@property (weak, nonatomic) IBOutlet UIView *view24;
@property (weak, nonatomic) IBOutlet UILabel *label24;

//光纤
@property (weak, nonatomic) IBOutlet UIView *view31;
@property (weak, nonatomic) IBOutlet UILabel *label31;
@property (weak, nonatomic) IBOutlet UIView *view32;
@property (weak, nonatomic) IBOutlet UILabel *label32;

@property (nonatomic,weak) id<DredgeDetailCellDelegate> delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
- (void)configModel:(FloorListDataModel *)model;
@end
