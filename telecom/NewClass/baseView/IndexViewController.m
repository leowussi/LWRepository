//
//  IndexViewController.m
//  JingRong360
//
//  Created by thsboy on 14-6-06.
//  Copyright (c) 2014年 qian.sundear. All rights reserved.
//

#import "IndexViewController.h"
#import "RootTAMViewController.h"

@interface IndexViewController ()
{
    NSArray *array;
}
@end

@implementation IndexViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    array = @[@"index1",@"index2",@"index3"];
    [self initView];
}
-(void)initView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320,kScreenHeight)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(320*3, kScreenHeight);
    scrollView.pagingEnabled = YES;
//    scrollView.showsHorizontalScrollIndicator=NO;
//    scrollView.showsVerticalScrollIndicator=NO;
    scrollView.userInteractionEnabled = YES;
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [UnityLHClass initUIImageView:[array objectAtIndex:i] rect:CGRectMake(320*i, 0, kScreenWidth, kScreenHeight)];
        [scrollView addSubview:imageView];
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(tapButton) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(self.view.frame.size.width*2+60, kScreenSize.height-68, self.view.frame.size.width-120, 50);
    [scrollView addSubview:button];
    [self.view addSubview:scrollView];
}
-(void)tapButton{
    if ([delegate respondsToSelector:@selector(firstIn)]) {
        [delegate firstIn];
    }
}
@end
