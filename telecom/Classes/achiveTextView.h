//
//  achiveTextView.h
//  telecom
//
//  Created by SD0025A on 16/6/3.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol achiveTextViewDelegate <NSObject>

- (void)goActionWithText:(NSString *)fillNote isAffectUser:(NSString *)isAffectUser startTime:(NSString *)startTime endTime:(NSString *)endTime;
- (void)choooseBeginDate;
- (void)choooseEndDate;
@end
@interface achiveTextView : UIView
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
- (IBAction)yesAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
- (IBAction)noAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)goAction:(UIButton *)sender;
- (IBAction)backAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *chooseView;
@property (weak, nonatomic) IBOutlet UIButton *endTimeBtn;

- (IBAction)endTimeAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *startTimeBtn;
- (IBAction)startTimeAction:(UIButton *)sender;
@property (nonatomic,assign) NSString * isAffectUser;
@property (nonatomic,weak) id<achiveTextViewDelegate> delegate;
@end
