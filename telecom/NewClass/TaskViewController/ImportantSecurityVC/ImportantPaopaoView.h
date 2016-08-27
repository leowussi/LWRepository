//
//  ImportantPaopaoView.h
//  telecom
//
//  Created by 郝威斌 on 15/10/26.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol importantDelegate <NSObject>

- (void)tagBtn:(NSInteger)index;

@end

@interface ImportantPaopaoView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSDictionary *_infoDict;
    UILabel         *titleLabel;
    UILabel         *detailLabel;
    //    UIButton        *rightButton;
    NSUInteger      index;
    UIView *view;
    
}

@property (nonatomic, retain)NSDictionary *infoDict;
@property(strong,nonatomic)UIButton *rightButton;
@property(strong,nonatomic)NSMutableArray *arr;
@property(strong,nonatomic)NSMutableArray *arr1;
@property(strong,nonatomic)NSMutableArray *arr2;
@property(strong,nonatomic)NSMutableArray *arr3;
@property(strong,nonatomic)NSMutableArray *arr4;
@property(strong,nonatomic)NSMutableArray *arr5;
@property(strong,nonatomic)NSMutableArray *arr6;

@property(strong,nonatomic)NSMutableArray *detailArr;

@property NSUInteger index;

@property(strong,nonatomic)UITableView *myTableView;

@property(assign,nonatomic)id<importantDelegate>delegate;
- (BOOL)showFromRect:(CGRect)rect;
- (void)makePhoneCall;

@end
