//
//  FeedbackAndReceiptController.h
//  telecom
//
//  Created by SD0025A on 16/4/6.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedbackAndReceiptController : BaseViewController
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *workNo;
@property (nonatomic,copy) NSString *orderNo;
@property(nonatomic,strong)NSString *actionType;
@property (weak, nonatomic) IBOutlet UILabel *baseInfo;//基本信息
@property (weak, nonatomic) IBOutlet UILabel *orderNumber;//工单编号
@property (weak, nonatomic) IBOutlet UILabel *handlePerson;//处理人员
@property (weak, nonatomic) IBOutlet UILabel *replyInfo;//回复信息
@property (weak, nonatomic) IBOutlet UITextView *descriptionInfo;//描述信息
- (IBAction)upLoadBtn:(UIButton *)sender;//上传
@property (weak, nonatomic) IBOutlet UIButton *upLoadBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *testListNum;//工单编号或者 测试单编号
@end
