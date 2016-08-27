//
//  SelledFaultReciptView.h
//  telecom
//
//  Created by SD0025A on 16/5/31.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelledFaultReciptViewDelegate <NSObject>

- (void)uploadFile;
- (void)chooseFaultReason;

@end
@interface SelledFaultReciptView : UIView
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
- (IBAction)yesAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *noBtn;
- (IBAction)noAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *reseaonTextField;
- (IBAction)searchBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITextView *descTextView;

- (IBAction)uploadBtn:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *upLoadBtn;

@property (weak, nonatomic) IBOutlet UILabel *receiveInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveBaseInfoLabel;

@property (nonatomic,assign) BOOL isContact;

@property (nonatomic,weak) id<SelledFaultReciptViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextView *chooseReasonTextField;

@end
