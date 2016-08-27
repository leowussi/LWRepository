//
//  YZPhotoBrowserViewController.h
//  YZPhotoBrowser
//
//  Created by 锋 on 16/6/30.
//  Copyright © 2016年 holden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZPhotoBrowserViewController : UIViewController

//存放所有要显示的图片数组
@property (nonatomic, strong) NSArray *imageArray;
//显示的图片在imageArray中的索引
@property (nonatomic, assign) NSInteger showIndex;
//索引目录
@property (nonatomic, strong) UILabel *indexLabel;

@property (nonatomic, copy) void (^backBlock)(UIImage *image,CGRect frame,NSInteger index);

@property (nonatomic, assign) BOOL showAnimationWhenPop;

@end

@protocol YZPhotoBrowserCollectionViewCellDelegate;
@interface YZPhotoBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, weak) id<YZPhotoBrowserCollectionViewCellDelegate> delegate;
//记录该图片是否显示到最大比例
@property (nonatomic, assign) BOOL isMaximumZoomScale;
//根据屏幕的大小,调整比例
- (void)adjustImageViewBasisImageSize;

@end

@protocol YZPhotoBrowserCollectionViewCellDelegate <NSObject>

- (void)collectionView:(UICollectionView *)collectionView didSelectItem:(UICollectionViewCell *)cell;

@end