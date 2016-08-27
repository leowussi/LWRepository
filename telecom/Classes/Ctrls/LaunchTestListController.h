//
//  LaunchTestListController.h
//  telecom
//
//  Created by SD0025A on 16/4/6.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@interface LaunchTestListController : BaseViewController
@property (nonatomic,copy) NSString *workNo;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *launchPerson;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *upLoadBtn;
@property (weak, nonatomic) IBOutlet UILabel *testStationLabel;//测试工位按钮

- (IBAction)upLoadBtn:(id)sender;


@end
