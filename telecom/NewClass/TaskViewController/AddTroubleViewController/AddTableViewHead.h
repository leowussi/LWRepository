//
//  AddTableViewHead.h
//  telecom
//
//  Created by Sundear on 16/2/18.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TroubleBtn.h"

@protocol AddTableViewHeadDelegate <NSObject>
-(void)YinHuanGroup:(NSString *)str;
-(void)YinHuanSelsct:(NSString *)str;
-(void)BMbtnClick :(NSArray *)array;
-(void)ZYbtnClick :(NSArray *)array;
-(void)YanZhenBtnCick;
@end

@interface AddTableViewHead : UIView

@property (weak, nonatomic) IBOutlet TroubleBtn *sheBei;
@property (weak, nonatomic) IBOutlet TroubleBtn *SafeAndState;

@property (weak, nonatomic) IBOutlet TroubleBtn *nomalBtn;
@property (weak, nonatomic) IBOutlet TroubleBtn *BMbtn;
@property (weak, nonatomic) IBOutlet TroubleBtn *ZYbtn;
@property (weak, nonatomic) IBOutlet UITextField *textK;
@property (weak, nonatomic) IBOutlet TroubleBtn *zhongDa;



@property (weak, nonatomic)id<AddTableViewHeadDelegate>delegate;
@end
