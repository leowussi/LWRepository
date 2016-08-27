//
//  YZPhotoBrowserViewController.m
//  YZPhotoBrowser
//
//  Created by 锋 on 16/6/30.
//  Copyright © 2016年 holden. All rights reserved.
//

#import "YZPhotoBrowserViewController.h"
#import "UIImageView+WebCache.h"

@interface YZPhotoBrowserCollectionViewCell ()<UIScrollViewDelegate>

@end

@implementation YZPhotoBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.delegate = self;
        [self.contentView addSubview:_scrollView];
        
        
        _imageView = [[UIImageView alloc] init];
        _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [_scrollView addSubview:_imageView];
        
        UITapGestureRecognizer *doubleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleGesture.numberOfTapsRequired = 2;
        [_scrollView addGestureRecognizer:doubleGesture];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        tapGesture.numberOfTapsRequired = 1;
        [_scrollView addGestureRecognizer:tapGesture];
        [tapGesture requireGestureRecognizerToFail:doubleGesture];
    }
    
    return self;
}

- (void)tapGesture
{
    [_delegate collectionView:(UICollectionView *)self.superview didSelectItem:self];
}


- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer
{
    if (_isMaximumZoomScale) {
        [_scrollView setZoomScale:1 animated:YES];
    }else {
        CGRect zoomRect = [self zoomRectForScale:2 withCenter:[gestureRecognizer locationInView:self]];
        [_scrollView zoomToRect:zoomRect animated:YES];
        
    }
    _isMaximumZoomScale = !_isMaximumZoomScale;
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.width = self.frame.size.width/scale;
    zoomRect.size.height = self.frame.size.height/scale;
    
    zoomRect.origin.x = center.x - zoomRect.size.width/2;
    zoomRect.origin.y = center.y - zoomRect.size.height/2;
    
    return zoomRect;
}

- (void)adjustImageViewBasisImageSize
{
    CGSize imageSize = _imageView.image.size;
    CGSize screenSize = self.frame.size;
    
    //根据屏幕的大小,调整比例
    if (imageSize.width <= screenSize.width && imageSize.height <= screenSize.height) {
        
        _imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
        
    }else{
        
        _imageView.bounds = CGRectMake(0, 0, screenSize.width, screenSize.width * imageSize.height/imageSize.width);
        
    }
    _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    _scrollView.minimumZoomScale = 1;
    _scrollView.maximumZoomScale = 2;
    self.isMaximumZoomScale = NO;
    [_scrollView setZoomScale:1];
}

#pragma mark -- scrollView代理
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    _imageView.center = CGPointMake(_imageView.frame.size.width <= scrollView.frame.size.width ? scrollView.frame.size.width/2:scrollView.contentSize.width/2, _imageView.frame.size.height <= scrollView.frame.size.height ?  scrollView.frame.size.height/2 : scrollView.contentSize.height/2);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}

@end


@interface YZPhotoBrowserViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,YZPhotoBrowserCollectionViewCellDelegate>
{
    UICollectionView *_collectionView;
}
@end

@implementation YZPhotoBrowserViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 10, self.view.frame.size.height) collectionViewLayout:layout];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
    
    
    [_collectionView registerClass:[YZPhotoBrowserCollectionViewCell class] forCellWithReuseIdentifier:@"image"];
    
    _indexLabel = [[UILabel alloc] init];
    _indexLabel.center = CGPointMake(self.view.frame.size.width/2, 24);
    _indexLabel.bounds = CGRectMake(0, 0, 100, 20);
    _indexLabel.font = [UIFont boldSystemFontOfSize:15];
    _indexLabel.textColor = [UIColor whiteColor];
    _indexLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_indexLabel];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    _indexLabel.text = [NSString stringWithFormat:@"%d/%d",_showIndex + 1,_imageArray.count];
    [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_showIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -- collectionViewDetegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    cell.delegate = self;
    if ([_imageArray[indexPath.item] isKindOfClass:[UIImage class]]) {
        cell.imageView.image = _imageArray[indexPath.row];
        [cell adjustImageViewBasisImageSize];
    }else {
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[indexPath.item]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [cell adjustImageViewBasisImageSize];
        }];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItem:(YZPhotoBrowserCollectionViewCell *)cell
{
    NSIndexPath *indexPath = [_collectionView indexPathForCell:cell];
    if (_backBlock != nil) {
        _backBlock(cell.imageView.image,cell.imageView.frame,indexPath.item);
    }
    [self.navigationController popViewControllerAnimated:_showAnimationWhenPop];
    
    
}

#pragma mark -- scrollView代理
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _showIndex = scrollView.contentOffset.x/_collectionView.frame.size.width;
    _indexLabel.text  = [NSString stringWithFormat:@"%d/%d",_showIndex + 1,_imageArray.count];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
