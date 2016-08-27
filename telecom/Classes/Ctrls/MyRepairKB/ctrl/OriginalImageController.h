//
//  OriginalImageController.h
//  telecom
//
//  Created by liuyong on 15/4/26.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "BaseViewController.h"

@protocol OriginalImageControllerDelegate <NSObject>
- (void)deleteImagesOfIndexInArray:(NSMutableArray *)indexArray;
@end

@interface OriginalImageController : BaseViewController
@property(nonatomic,assign)id <OriginalImageControllerDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIScrollView *originalImageScrollView;
@property (retain, nonatomic) IBOutlet UILabel *imageTitleLabel;

- (IBAction)deleteCurImage:(id)sender;
@property(nonatomic,strong)NSArray *images;
@property(nonatomic,assign)NSInteger index;
@end
