//
//  AutomobileRecorderController.m
//  telecom
//
//  Created by SD0025A on 16/7/20.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//行车记录

#import "AutomobileRecorderController.h"
#import "ImageAndVideoPicker.h"
#import "FileModel.h"
#import "SelfImgeView.h"
@interface AutomobileRecorderController ()<ImageAndVideoPickerDelegate,DeleteBtnInImageViewDelegate>
@property (nonatomic,strong) ImageAndVideoPicker *picker;
@property (nonatomic,strong) NSMutableArray *fileArray;
@end

@implementation AutomobileRecorderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
}
- (void)createUI
{
    self.navigationItem.title = @"行车记录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //右边item
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 30, 30);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"checkBtn"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (IBAction)uploadAction:(UIButton *)sender {
    self.picker = [[ImageAndVideoPicker alloc ]init];
    self.picker.delegate  = self;
    self.picker.ctrl = self;
    [self.picker pickImageFromPhotos];
    
}
- (NSMutableArray *)fileArray
{
    if (nil == _fileArray) {
        _fileArray = [NSMutableArray array];
    }
    return _fileArray;
}

#pragma mark - DeleteBtnInImageViewDelegate
- (void)deleteBtnInImageView:(SelfImgeView *)imgeView
{
    for (int i =0; i<self.fileArray.count; i++) {
        [[self.uploadBtn.superview viewWithTag:500+i] removeFromSuperview];
    }
    NSInteger index = imgeView.tag - 500;
    FileModel *model = self.fileArray[index];
    [self.fileArray removeObject:model];
    [self showImage];
    
    
}

#pragma mark - ImageAndVideoPickerDelegate
- (void)addImageFromTZI:(NSArray *)array
{
    for (UIImage *image in array) {
        FileModel *model = [[FileModel alloc] init];
        model.image = image;
        [self.fileArray addObject:model];
        
    }
    [self showImage];
    
}
- (void)addVedioFromTZI:(NSData *)movieData coverImage:(UIImage *)coverImage
{
    FileModel *model = [[FileModel alloc] init];
    model.image = coverImage;
    model.movieData = movieData;
    [self.fileArray addObject:model];
    [self showImage];
}
- (void)showImage
{
    for (int i=0; i<self.fileArray.count; i++) {
        int row  = i/3;
        int sec  = i%3;
        SelfImgeView *imageView = [[SelfImgeView alloc] initWithFrame:CGRectMake(self.uploadBtn.frame.origin.x+70+sec*(60+10), self.uploadBtn.frame.origin.y+row*(60+10), 60, 60)];
        FileModel *model = self.fileArray[i];
        UIImage *image = model.image;
        imageView.delegate = self;
        imageView.image = image;
        imageView.tag = 500+i;
        [self.uploadBtn.superview addSubview:imageView];
    }
    
    if (self.fileArray.count == 0) {
        self.beginUseConstant.constant = 15;
    }else{
        int count = self.fileArray.count%3 == 0 ? self.fileArray.count/3 -1:self.fileArray.count/3  ;
        self.beginUseConstant.constant = count*70 +15;
    }
    
}
@end
