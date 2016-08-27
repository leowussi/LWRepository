//
//  backTextView.h
//  telecom
//
//  Created by SD0025A on 16/6/3.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol backTextViewDelegate <NSObject>

- (void)backOrderWithText:(NSString *)text;

@end
@interface backTextView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)goAction:(UIButton *)sender;
- (IBAction)backAction:(UIButton *)sender;
@property (nonatomic,weak) id<backTextViewDelegate> delegate;
@end
