//
//  AnnotationTopView.h
//  telecom
//
//  Created by SD0025A on 16/6/22.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnnotationTopViewDelegate <NSObject>

- (void)deleteAnnotationTopView;

@end
@interface AnnotationTopView : UIView
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
- (IBAction)deleteView:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;
@property (nonatomic,weak) id<AnnotationTopViewDelegate> delegate;
@property (nonatomic,copy) NSString *road;
@property (nonatomic,copy) NSString *lane;
@property (nonatomic,copy) NSString *gate;
@property (nonatomic,copy) NSString *lou;
@end
