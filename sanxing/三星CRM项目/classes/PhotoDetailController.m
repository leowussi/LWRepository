//
//  PhotoDetailController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/8/2.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "PhotoDetailController.h"
#import "UIImageView+WebCache.h"

@interface PhotoDetailController ()

@end

@implementation PhotoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationController.navigationBar.hidden = YES;
    [self setGesture];
    [self changeImage:self.currentIndex];
}

- (void)setGesture
{
    //向右横扫，查看上一张图片
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightGesture];
    
    //向左横扫，查看下一张图片
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe:)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftGesture];
}

- (void)swipe: (UISwipeGestureRecognizer *)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        //下一张
        self.currentIndex += 1;
        NSLog(@"--left--");
    }else if (gesture.direction == UISwipeGestureRecognizerDirectionRight){
        //上一张
        self.currentIndex -= 1;
        NSLog(@"--right--");
    }
    [self changeImage:self.currentIndex];
}

- (void)changeImage: (NSInteger)index
{
    //此处self.images.count需要进行强转，否则uint和int类型比较时，会出现
    if (index > ((NSInteger)self.images.count - 1)) {
        index = 0;
        self.currentIndex = 0;
    }
    if (index < 0) {
        index = self.images.count - 1;
        self.currentIndex = self.images.count - 1;
    }
    NSLog(@"index == %ld",index);
    
    [self.imageView sd_setImageWithURL:self.images[index] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRetryFailed];

}

@end
