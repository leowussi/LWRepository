//
//  DownPhotoController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/31.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "DownPhotoController.h"
#import "ZYFHttpTool.h"
#import "ZYFUrlTask.h"
#import "DownPhotos.h"
#import "MBProgressHUD+MJ.h"
#import "HMImageCell.h"
#import "HMLineLayout.h"
#import "UIImageView+WebCache.h"
#import "PhotoDetailController.h"

static NSString* const ID = @"photocell";

@interface DownPhotoController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray *beforeImages;
@property (nonatomic,strong) NSMutableArray *afterImages;

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic,assign) CGRect oldFrame;
@property (nonatomic,assign) CGRect currentFrame;

@property (nonatomic,assign) NSInteger segmentSelectedIndex;

@end


@implementation DownPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [UIScreen mainScreen].bounds;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:[[HMLineLayout alloc] init]];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerNib:[UINib nibWithNibName:@"HMImageCell" bundle:nil] forCellWithReuseIdentifier:ID];
    collectionView.backgroundColor = [UIColor grayColor];
    
    self.title = @"";
    
    [self.view addSubview:collectionView];
    
    self.collectionView = collectionView;
    [self getPhotoFromServer];
    [self setSegument];
    
}

- (void)setSegument
{
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"维修前",@"维修后"]];
    segment.tintColor = [UIColor whiteColor];
    [segment addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    //默认选中维修前
    segment.selectedSegmentIndex = 0;
    [self segmentChanged:segment];
    
    self.navigationItem.titleView = segment;
}


-(void)segmentChanged:(UISegmentedControl*) segment
{
    self.segmentSelectedIndex = segment.selectedSegmentIndex;
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)getPhotoFromServer
{
//    NSString *url = kDownloadPhoto;
//    NSString *urlString = [NSString stringWithFormat:@"%@?id=%@",url,self.cleanTaskId];
    NSString *urlString = self.urlString;

//    NSString *urlString = [NSString stringWithFormat:@"%@?id=D041709C-22E8-445F-9A7B-026E77EBB8D6",url];

    [MBProgressHUD showMessage:nil toView:self.view ];
    
    [ZYFHttpTool getWithURL:urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:json options:NSJSONReadingMutableLeaves   error:nil];
        NSString *code = dictionary[@"Code"];
        NSString *Msg = dictionary[@"Msg"];
        if (code.intValue == 1) {
            DownPhotos *photos = [DownPhotos downPhotoWithDict:dictionary];
            for (NSString *before in photos.beforeArray) {
                NSString *beforeStr = [NSString stringWithFormat:@"%@?action=showimage&name=%@",kDownloadPhoto22,before];
                [self.beforeImages addObject:beforeStr];
            }
            for (NSString *after in photos.afterArray) {
                NSString *afterStr = [NSString stringWithFormat:@"%@?action=showimage&name=%@",kDownloadPhoto22,after];
                [self.afterImages addObject:afterStr];
            }
            [self.collectionView reloadData];
        }else{
            [MBProgressHUD showError:Msg];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *errorStr = [NSString stringWithFormat:@"%@",error];
        [MBProgressHUD showError:errorStr];
        
    }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.segmentSelectedIndex == 0) {
        //维修前
        return self.beforeImages.count;
    }else if(self.segmentSelectedIndex == 1){
        //维修后
        return self.afterImages.count;
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HMImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    NSURL *url = [[NSURL alloc]init];
    if (self.segmentSelectedIndex == 0) {
        url = [NSURL URLWithString:self.beforeImages[indexPath.item]];
    }else if (self.segmentSelectedIndex == 1){
        url = [NSURL URLWithString:self.afterImages[indexPath.item]];
    }
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRetryFailed];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *array = [[NSArray alloc]init];
    if (self.segmentSelectedIndex == 0) {
        array = self.beforeImages;
    }else if (self.segmentSelectedIndex == 1){
        array = self.afterImages;
    }
    PhotoDetailController *ctrl = [[PhotoDetailController alloc]init];
    ctrl.images = array;
    ctrl.currentIndex = indexPath.row;
    [self.navigationController pushViewController:ctrl animated:YES];
}


- (NSMutableArray *)beforeImages
{
    if (_beforeImages == nil) {
        _beforeImages = [NSMutableArray array];
    }
    return _beforeImages;
}

- (NSMutableArray *)afterImages
{
    if (_afterImages == nil) {
        _afterImages = [NSMutableArray array];
    }
    return _afterImages;
}


@end
