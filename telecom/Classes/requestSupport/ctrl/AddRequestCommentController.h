//
//  AddRequestCommentController.h
//  telecom
//
//  Created by SD0025A on 16/6/1.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "BaseViewController.h"

@interface AddRequestCommentController : BaseViewController
@property (weak, nonatomic) IBOutlet UIView *rateView;
@property (nonatomic,copy) NSString *taskId;
- (IBAction)yesAction:(UIButton *)sender;
- (IBAction)cancelActon:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadFileAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;

@end
