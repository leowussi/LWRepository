//
//  PipelineInfoCell.h
//  telecom
//
//  Created by SD0025A on 16/4/7.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PoliticalAndCompanyTransListModel;

@interface PipelineInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *handleDepartment;//处理部门
@property (weak, nonatomic) IBOutlet UILabel *handleStatus;//操作动作
@property (weak, nonatomic) IBOutlet UILabel *handlePerson;//处理人
@property (weak, nonatomic) IBOutlet UILabel *agent;//代理人
@property (weak, nonatomic) IBOutlet UILabel *source;//来源
@property (weak, nonatomic) IBOutlet UILabel *handleDescrpection;//处理描述
@property (weak, nonatomic) IBOutlet UILabel *step;//步骤
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间
- (void)comfigModel:(PoliticalAndCompanyTransListModel *)model;
@end
