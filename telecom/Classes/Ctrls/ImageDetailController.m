//
//  ImageDetailController.m
//  telecom
//
//  Created by liuyong on 15/7/21.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "ImageDetailController.h"

@interface ImageDetailController ()<UIScrollViewDelegate>

@end

@implementation ImageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"附件详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _baseScrollView.hidden = YES;
    self.imageDetailScrollView.delegate = self;
    self.pageCtrl.currentPage = self.pageIndex;
    self.pageCtrl.numberOfPages = self.fileIdArray.count;
    self.pageCtrl.pageIndicatorTintColor = [UIColor greenColor];
    self.pageCtrl.currentPageIndicatorTintColor = [UIColor purpleColor];
    [self setUpImageView];
}

- (void)setUpImageView
{
    for (int i=0; i<self.fileIdArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:RECT(self.imageDetailScrollView.bounds.size.width*i, 0, self.imageDetailScrollView.bounds.size.width, self.imageDetailScrollView.bounds.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/attachment/taskAppointmentFile/%@",ADDR_IP,ADDR_DIR,self.fileIdArray[i][@"fileId"]]]];
        imageView.userInteractionEnabled = YES;
        [self.imageDetailScrollView addSubview:imageView];
    }
    self.imageDetailScrollView.contentSize = CGSizeMake(self.imageDetailScrollView.bounds.size.width * self.fileIdArray.count, 0);
    self.imageDetailScrollView.contentOffset = CGPointMake(self.imageDetailScrollView.bounds.size.width*self.pageIndex, 0);
    self.imageDetailScrollView.pagingEnabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    self.pageCtrl.currentPage = index;
}

@end
