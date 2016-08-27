//
//  AccessoryListCell.h
//  telecom
//
//  Created by SD0025A on 16/4/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AccessoryListModel;


@protocol AccessoryDeleteBtnDelegate <NSObject>

- (void)deleteBtnWasClicked:(AccessoryListModel *)cell path:(NSIndexPath *)indexPath;
- (void)fileNameLabelWasTaped:(NSString *)fileName attachmentId:(NSString *)attachmentId;
@end

@interface AccessoryListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak,nonatomic) id<AccessoryDeleteBtnDelegate>delegate;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) AccessoryListModel *model;
@end
