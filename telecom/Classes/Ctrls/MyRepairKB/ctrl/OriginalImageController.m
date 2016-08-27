//
//  OriginalImageController.m
//  telecom
//
//  Created by liuyong on 15/4/26.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "OriginalImageController.h"

@interface OriginalImageController ()<UIScrollViewDelegate>
@property(nonatomic,assign)NSInteger imageIndex;
@property(nonatomic,assign)NSInteger mutableTotalIndex;
@property(nonatomic,strong)NSMutableArray *mutableArray;
@end

@implementation OriginalImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预览";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.mutableArray removeAllObjects];
    self.mutableArray = [NSMutableArray arrayWithArray:self.images];
    [self setUpRightBarButton];
    [self showAllImageOriginalWithArray:self.mutableArray andCurImageIndex:self.index];
}

- (void)showAllImageOriginalWithArray:(NSArray *)array andCurImageIndex:(NSInteger)curImageIndex
{
    self.mutableTotalIndex = array.count;
    self.imageTitleLabel.text = [NSString stringWithFormat:@"%d/%d",curImageIndex+1,self.mutableTotalIndex];
    self.imageTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    for (UIView *view in self.originalImageScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i=0; i<array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT(self.originalImageScrollView.frame.size.width*i, 0, self.originalImageScrollView.frame.size.width, self.originalImageScrollView.frame.size.height)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelAction)]];
        imageView.image = array[i];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self.originalImageScrollView addSubview:imageView];
        
        self.originalImageScrollView.pagingEnabled = YES;
        self.originalImageScrollView.delegate = self;
        self.originalImageScrollView.contentOffset = CGPointMake(self.originalImageScrollView.frame.size.width*curImageIndex, 0);
        self.originalImageScrollView.contentSize = CGSizeMake(self.originalImageScrollView.frame.size.width*array.count, 0);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.imageIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.imageTitleLabel.text = [NSString stringWithFormat:@"%d/%d",self.imageIndex+1,self.mutableTotalIndex];
}

#pragma mark - 右侧按钮
- (void)setUpRightBarButton
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightBtn.frame = CGRectMake(APP_W-40, 7, 30, 30);
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"nav_check@2x"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

- (void)leftAction
{
    [self cancelAction];
}

- (void)cancelAction
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate) {
        [self.delegate deleteImagesOfIndexInArray:self.mutableArray];
    }
}


- (IBAction)deleteCurImage:(id)sender {
    self.imageIndex = self.originalImageScrollView.contentOffset.x / self.originalImageScrollView.frame.size.width;
    
    if (self.mutableArray.count > 0) {
        [self.mutableArray removeObjectAtIndex:self.imageIndex];
        
        if (self.imageIndex != self.mutableArray.count) {
            [UIView animateWithDuration:0.2f animations:^{
                [self showAllImageOriginalWithArray:self.mutableArray andCurImageIndex:self.imageIndex];
            }];
        }else if (self.imageIndex == self.mutableArray.count){
            [UIView animateWithDuration:0.2f animations:^{
                [self showAllImageOriginalWithArray:self.mutableArray andCurImageIndex:self.imageIndex-1];
            }];
        }
        
    }else{
        [self cancelAction];
    }
}

@end
