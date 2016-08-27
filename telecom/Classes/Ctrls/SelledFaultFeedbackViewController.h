//
//  SelledFaultFeedbackViewController.h
//  telecom
//
//  Created by SD0025A on 16/4/8.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface SelledFaultFeedbackViewController : BaseViewController
@property (nonatomic,copy) NSString *workNo;
@property (nonatomic,copy) NSString *orderNO;
@property (nonatomic,copy) NSString *actionType;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;
- (IBAction)uploadBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *upLoadBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
