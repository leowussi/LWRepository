//
//  AddRequestSupportView.h
//  telecom
//
//  Created by SD0025A on 16/5/25.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XGW_comboboxButton.h"

@class PullDownViewInAddRequest;
@protocol AddRequestSupportViewDelegate <NSObject>

- (void)choooseBeginDate;
- (void)choooseEndDate;
- (void)chooseAddRequestPhoto;
- (void)getAccountId:(NSArray *)accountIdArray;

@end
@interface AddRequestSupportView : UIView
@property (weak, nonatomic) IBOutlet XGW_comboboxButton *requestBtn;
- (IBAction)requestBtn:(XGW_comboboxButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *applicantTextField;
@property (weak, nonatomic) IBOutlet XGW_comboboxButton *handleServeBtn;
- (IBAction)handleServeBtn:(XGW_comboboxButton *)sender;
@property (weak, nonatomic) IBOutlet XGW_comboboxButton *handleComplaintBtn;
- (IBAction)handleComplaintBtn:(XGW_comboboxButton *)sender;
@property (weak, nonatomic) IBOutlet XGW_comboboxButton *groupBtn;
- (IBAction)groupBtn:(XGW_comboboxButton *)sender;
@property (weak, nonatomic) IBOutlet XGW_comboboxButton *personBtn;
- (IBAction)personBtn:(XGW_comboboxButton *)sender;
- (IBAction)beginDateBtn:(UIButton *)sender;
- (IBAction)endDateBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *beginDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *endDateBtn;

@property (weak, nonatomic) IBOutlet UITextView *descTextView;

@property (nonatomic,assign) id<AddRequestSupportViewDelegate> delegate;

@property (nonatomic,strong) PullDownViewInAddRequest *pullViewOne;
@property (nonatomic,strong) PullDownViewInAddRequest *pullViewTwo;
@property (nonatomic,strong) PullDownViewInAddRequest *pullViewThree;
@property (nonatomic,strong) PullDownViewInAddRequest *pullViewFour;
@property (nonatomic,strong) PullDownViewInAddRequest *pullViewFive;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
- (IBAction)uploadAction:(UIButton *)sender;

@property (nonatomic,strong) NSMutableArray *photoArray;
@property (nonatomic,strong) NSMutableArray *sceneTypeList;
@property (nonatomic,strong) NSMutableArray *oneTypeList;
@property (nonatomic,strong) NSMutableArray *twoTypeList;
@property (nonatomic,strong) NSMutableArray *orgList;
@property (nonatomic,strong) NSMutableArray *personTitleArray;
@property (nonatomic,copy) NSString *source;

@end
