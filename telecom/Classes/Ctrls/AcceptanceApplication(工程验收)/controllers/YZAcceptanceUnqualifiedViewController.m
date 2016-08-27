//
//  YZAcceptanceDetailViewController.m
//  telecom
//
//  Created by 锋 on 16/5/31.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZResourcesInfoDetailTableViewCell.h"
#import "YZImageCollectionViewCell.h"
#import "ZYQAssetPickerController.h"
#import "YZChooseAlertView.h"
#import "YZRemindDetailViewController.h"
#import "YZAcceptanceUnqualifiedViewController.h"
#import "YZPhotoBrowserViewController.h"

@interface YZAcceptanceUnqualifiedViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    //底部的scrollview
    UIScrollView *_backgroundScrollView;
    CALayer *_backgroundLayer;
    UIView *_buttonView;
    UITableView *_tableView;
    UICollectionView *_collectionView;
    
    UIView *_excuteRecordsView;
    
}
@end

@implementation YZAcceptanceUnqualifiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"工程验收执行";
    [self createBackgroundScrollView];
    if (!_isFromDetailVC) {
        [self loadLocalData];
        [self loadData];
    }else{
        [self createExcuteRecordsView];
    }
    [self addNavigationLeftButton];
    
    [self createTableView];
    if (_isFromDetailVC) {
        [self setButtonStatusWithSelectedButton:YES];
    }
}

-(void)leftAction
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}

//执行记录
- (void)createExcuteRecordsView
{
    _excuteRecordsView = [[UIView alloc] initWithFrame:CGRectMake(10, 820, kScreenWidth - 20, 160)];
    _excuteRecordsView.backgroundColor = [UIColor whiteColor];
    _excuteRecordsView.layer.borderColor = COLOR(190, 190, 190).CGColor;
    _excuteRecordsView.layer.cornerRadius = 3;
    _excuteRecordsView.layer.borderWidth = .5;
    _excuteRecordsView.layer.shadowColor = [UIColor blackColor].CGColor;
    _excuteRecordsView.layer.shadowOffset = CGSizeMake(1, 1);
    _excuteRecordsView.layer.shadowRadius = 3;
    _excuteRecordsView.layer.shadowOpacity = .3f;
    [_backgroundScrollView addSubview:_excuteRecordsView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _excuteRecordsView.frame.size.width, 30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"执行记录:";
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    //    titleLabel.textColor = TEXTCOLOR;
    [_excuteRecordsView addSubview:titleLabel];
    
    CGFloat markHeight = 30;
    for (int i = 0; i < _recordArray.count; i++) {
        NSDictionary *recordDict = _recordArray[i];
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, markHeight + 2, 120, 24)];
        timeLabel.text = [[recordDict objectForKey:@"executeTime"] substringToIndex:13];;
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
        [_excuteRecordsView addSubview:timeLabel];
        
        UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, markHeight + 2, kScreenWidth - 142, 24)];
        statusLabel.text = [recordDict objectForKey:@"checkResult"];
        statusLabel.font = [UIFont systemFontOfSize:15];
        statusLabel.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
        statusLabel.textAlignment = NSTextAlignmentRight;
        [_excuteRecordsView addSubview:statusLabel];
        
        
        UILabel *commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, markHeight + 26, 110, 24)];
        commentsLabel.text = @"备                 注:";
        commentsLabel.font = [UIFont systemFontOfSize:15];
        commentsLabel.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
        [_excuteRecordsView addSubview:commentsLabel];
        
        NSString *executeRemark = [recordDict objectForKey:@"executeRemark"];
        if ([executeRemark isKindOfClass:[NSNull class]]) {
            executeRemark = @"";
        }
        
        CGFloat height = [self calculateTextheight:executeRemark];
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, markHeight + 26, kScreenWidth - 142, height + 4 > 24 ? height + 4 : 24 )];
        descLabel.text = executeRemark;
        descLabel.font = [UIFont systemFontOfSize:15];
        descLabel.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
        descLabel.numberOfLines = 0;
        [_excuteRecordsView addSubview:descLabel];
        
        markHeight = descLabel.frame.origin.y + descLabel.frame.size.height;
    }
    
    _excuteRecordsView.frame = CGRectMake(10, 820, kScreenWidth - 20, markHeight);
    [self createBottomButtonWithFrame:CGRectMake(0, _excuteRecordsView.frame.origin.y + _excuteRecordsView.frame.size.height + 10, kScreenWidth, 56)];
    CGSize scrollSize = _backgroundScrollView.contentSize;
    scrollSize.height += markHeight + 20;
    _backgroundScrollView.contentSize = scrollSize;
    
    
}

- (void)loadLocalData
{
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"适用场景类型:",@"工  单  编  号:",@"工  程  名  称:",@"工  程  编  号:",@"工程验收局站:",@"工程验收机房:",@"专              业:",@"发     起     人:",@"所  在  部  门:",@"发起人联系电话:",@"配  合  任  务:",@"工  程  类  别:",@"任  务  说  明:",@"预计验收时间:",@"开始验收时间:",@"完成验收时间:",@"", nil];
    _showMoreTitleArray = [[NSArray alloc] initWithObjects:@"工  程  来  源:",@"工 程 管 理 员:",@"工程覆盖范围:",@"施  工  单  位",@"施  工  队  长",@"施工队长联系电话:",@"是否FTTH工程:",@"验  收  类  别:",@"难  度  等  级:",@"经  验  耗  时:",@"积              分:",@"需  要  人  数:",@"技  能  要  求:", nil];
    
    _imageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"upload_btn"], nil];
    
    _imageURLArray = [[NSMutableArray alloc] initWithCapacity:0];
}


#pragma mark --- 底部的scrollView
- (void)createBackgroundScrollView
{
    _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    _backgroundLayer = [CALayer layer];
    _backgroundLayer.frame = CGRectMake(10, 10, kScreenWidth - 20, 794);
    _backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;
    
    _backgroundLayer.shadowColor = [UIColor blackColor].CGColor;
    _backgroundLayer.shadowOffset = CGSizeMake(1, 1);
    _backgroundLayer.shadowRadius = 3;
    _backgroundLayer.shadowOpacity = .3f;
    [_backgroundScrollView.layer addSublayer:_backgroundLayer];
    _backgroundScrollView.contentSize = CGSizeMake(kScreenWidth, 940);
    [self.view addSubview:_backgroundScrollView];
    
    
    
}

- (void)createBottomButtonWithFrame:(CGRect)frame
{
    _buttonView = [[UIView alloc] initWithFrame:frame];
    [_backgroundScrollView addSubview:_buttonView];
    
    UIButton *applicationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applicationButton.frame = CGRectMake(12, 6, (kScreenWidth - 36)/2, 40);
    applicationButton.backgroundColor = [UIColor colorWithRed:48/255.0 green:107/255.0 blue:180/255.0 alpha:1];
    [applicationButton setTitle:@"开始执行" forState:UIControlStateNormal];
    [applicationButton addTarget:self action:@selector(applicationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    applicationButton.titleLabel.font = [UIFont systemFontOfSize:20];
    applicationButton.layer.cornerRadius = 4;
    [_buttonView addSubview:applicationButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(12 + (kScreenWidth - 36)/2 + 12, 6, (kScreenWidth - 36)/2, 40);
    //    cancelButton.backgroundColor = [UIColor colorWithRed:57/255.0 green:155/255.0 blue:47/255.0 alpha:1];
    cancelButton.backgroundColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
    [cancelButton setTitle:@"结束执行" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
    cancelButton.layer.cornerRadius = 4;
    [_buttonView addSubview:cancelButton];
    
    
}

//开始执行
- (void)applicationButtonClicked
{
    [self updateToServerIsBegin:YES checkResultId:nil message:nil];
    NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH");
    [_dataArray replaceObjectAtIndex:14 withObject:opreatinTime];
    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:14 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

//结束执行
- (void)cancelButtonClicked
{
    
    YZChooseAlertView *alertView = [[YZChooseAlertView alloc] initWithFrame:self.view.frame];
    alertView.respBlock = ^(NSInteger SelectedIndex,NSString *message){
        [self updateToServerIsBegin:NO checkResultId:[NSString stringWithFormat:@"%d",SelectedIndex] message:message];
        NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH");
        
        [_dataArray replaceObjectAtIndex:15 withObject:opreatinTime];
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:15 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
    };
    
    [self.view addSubview:alertView];
    return;
    
}

- (void)updateToServerIsBegin:(BOOL)isBegin checkResultId:(NSString *)checkResultId message:(NSString *)message
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    
    NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/MyTask/WithWork/ExecuteProjectCheck.json",ADDR_IP,ADDR_DIR];
    paraDict[@"accessToken"] = accessToken;
    paraDict[@"operationTime"] = opreatinTime;
    paraDict[@"checkId"] = _checkId;
    if (isBegin) {
        paraDict[@"startTime"] = opreatinTime;
        paraDict[@"tag"] = @"begin";
    }else{
        paraDict[@"endTime"] = opreatinTime;
        paraDict[@"tag"] = @"end";
        paraDict[@"checkResultId"] = checkResultId;
    }
    if ([checkResultId isEqualToString:@"2"]) {
        paraDict[@"remark"] = message;
    }else{
        paraDict[@"leftoverProblem"] = message;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:requestUrl parameters:paraDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < _imageURLArray.count; i++) {
            if (_imageURLArray.count == 0) {
                
            }else{
                id imageURL = _imageURLArray[i];
                
                [formData appendPartWithFileURL:imageURL name:[NSString stringWithFormat:@"image%d",i] error:nil];
            }
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [responseObject objectForKey:@"result"];
        if (isBegin && [result isEqualToString:@"0000000"]) {
            [self showAlertWithTitle:@"提示" :@"开始执行成功" :@"OK" :nil];
            [self setButtonStatusWithSelectedButton:YES];
            return ;
            
        }else if ([checkResultId isEqualToString:@"2"] && !isBegin && [result isEqualToString:@"0000000"]) {
            
            
            [self AddexcuteRecordDate:opreatinTime message:message];
            
        }else if ([checkResultId isEqualToString:@"3"] && !isBegin && [result isEqualToString:@"0000000"]){
            
            YZRemindDetailViewController *remindVC = [[YZRemindDetailViewController alloc] init];
            remindVC.checkId = _checkId;
            remindVC.dataArray = [NSArray arrayWithObjects:_dataArray[10],_dataArray[1],_dataArray[2],_dataArray[3],_dataArray[7],_dataArray[8],_dataArray[9],@"", nil];
            [self.navigationController pushViewController:remindVC animated:YES];
            
        }else if ([checkResultId isEqualToString:@"1"] && !isBegin && [result isEqualToString:@"0000000"]){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAcceptanceList" object:self];
            [self showAlertWithTitle:@"提示" :@"结束执行成功" :@"OK" :nil];
            
        }
        //        [self setButtonStatusWithSelectedButton:NO];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"---->>>%@",error);
    }];
    
}
#pragma mark -- 设置button的状态
- (void)setButtonStatusWithSelectedButton:(BOOL)isStart
{
    if (isStart) {
        _buttonView.subviews[0].userInteractionEnabled = NO;
        _buttonView.subviews[0].backgroundColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
        _buttonView.subviews[1].backgroundColor = [UIColor colorWithRed:57/255.0 green:155/255.0 blue:47/255.0 alpha:1];
        _buttonView.subviews[1].userInteractionEnabled = YES;
    }else{
        _buttonView.subviews[0].userInteractionEnabled = YES;
        _buttonView.subviews[0].backgroundColor = [UIColor colorWithRed:48/255.0 green:107/255.0 blue:180/255.0 alpha:1];
        _buttonView.subviews[1].backgroundColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
        _buttonView.subviews[1].userInteractionEnabled = NO;
    }
}

- (void)AddexcuteRecordDate:(NSString *)date message:(NSString *)message
{
    CGFloat markHeight = 0.0;
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 32, 120, 24)];
    timeLabel.text = [date substringToIndex:13];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
    
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 32, kScreenWidth - 142, 24)];
    statusLabel.text = @"不合格";
    statusLabel.font = [UIFont systemFontOfSize:15];
    statusLabel.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
    statusLabel.textAlignment = NSTextAlignmentRight;
    
    
    
    UILabel *commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(7, 58, 110, 24)];
    commentsLabel.text = @"备                 注:";
    commentsLabel.font = [UIFont systemFontOfSize:15];
    commentsLabel.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
    
    
    
    CGFloat height = [self calculateTextheight:message];
    UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(114, 58, kScreenWidth - 142, height + 4 > 24 ? height + 4 : 24 )];
    descLabel.text = message;
    descLabel.font = [UIFont systemFontOfSize:15];
    descLabel.textColor = [UIColor colorWithRed:134/255.0 green:134/255.0 blue:134/255.0 alpha:1];
    descLabel.numberOfLines = 0;
    
    
    markHeight = descLabel.frame.origin.y + descLabel.frame.size.height - 30;
    
    
    [_excuteRecordsView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx != 0) {
            [UIView animateWithDuration:.16 animations:^{
                CGRect rect = obj.frame;
                rect.origin.y += markHeight;
                obj.frame = rect;
            }];
        }
    }];
    
    [_excuteRecordsView addSubview:timeLabel];
    [_excuteRecordsView addSubview:statusLabel];
    [_excuteRecordsView addSubview:commentsLabel];
    [_excuteRecordsView addSubview:descLabel];
    
    
    CGRect recordRect = _excuteRecordsView.frame;
    CGSize scrollSize = _backgroundScrollView.contentSize;
    CGRect buttonRect = _buttonView.frame;
    recordRect.size.height += markHeight;
    scrollSize.height += markHeight;
    buttonRect.origin.y += markHeight;
    
    [UIView animateWithDuration:.16 animations:^{
        _excuteRecordsView.frame = recordRect;
        _backgroundScrollView.contentSize = scrollSize;
        _buttonView.frame = buttonRect;
    }];
    
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 794) style:UITableViewStylePlain];
    //        _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.cornerRadius = 3;
    _tableView.layer.borderColor = COLOR(190, 190, 190).CGColor;
    _tableView.layer.borderWidth = .5f;
    _tableView.tableFooterView = [self createTableViewFootView];
    [_backgroundScrollView addSubview:_tableView];
    
    
    if (_isFromDetailVC) {
        [self changeViewSizeWithHeight:_taskDescHeight - 40 contianCollectionView:NO];
    }
}

#pragma mark -- collectionView
- (UIView *)createTableViewFootView
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(75, 64);
    layout.minimumLineSpacing = 18;
    layout.minimumInteritemSpacing  = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, 24, 10, 18);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 114) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[YZImageCollectionViewCell class] forCellWithReuseIdentifier:@"image"];
    
    return _collectionView;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_imageArray.count == 10) {
        return 9;
    }
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    cell.imageView_upImage.image = _imageArray[indexPath.item];
    
    cell.button_delete.tag = indexPath.item;
    [cell.button_delete addTarget:self action:@selector(deleteImageButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    if (indexPath.row == _imageArray.count - 1) {
        cell.button_delete.hidden = YES;
    }else{
        cell.button_delete.hidden = NO;
    }
   
    return cell;
}

- (void)deleteImageButtonClicked:(UIButton *)sender
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定移除该图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = sender.tag;
    [alertView show];
    
}
//alertView代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            NSURL *urlPath = _imageURLArray[alertView.tag];
            if([[NSFileManager defaultManager] removeItemAtPath:urlPath.parameterString error:nil]){
            }
            [_imageURLArray removeObjectAtIndex:alertView.tag];
            [_imageArray removeObjectAtIndex:alertView.tag];
            
            [self changeViewSizeWithHeight:-64 contianCollectionView:YES];
         
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -- 上传图片被点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item != _imageArray.count - 1) {
        [self checkImageWithIndex:indexPath];
        return;
    }
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [chooseImageSheet showInView:self.view];
    
}

//查看图片
- (void)checkImageWithIndex:(NSIndexPath *)indexPath
{
    
    YZImageCollectionViewCell *cell = (YZImageCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    
    
    [window addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.imageView_upImage.image];
    imageView.frame = CGRectMake(cell.frame.origin.x + _tableView.frame.origin.x, _collectionView.frame.origin.y  + cell.frame.origin.y  + _tableView.frame.origin.y -_backgroundScrollView.contentOffset.y + 8 + 64, cell.frame.size.width - 8, cell.frame.size.height - 8);
    [view addSubview:imageView];
    
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [UIView animateWithDuration:.25f animations:^{
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        //        view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        imageView.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
        CGSize imageSize = imageView.image.size;
        CGSize screenSize = self.view.frame.size;
        
        //根据屏幕的大小,调整比例
        if (imageSize.width <= screenSize.width && imageSize.height <= screenSize.height) {
            
            imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
            
        }else{
            
            imageView.bounds = CGRectMake(0, 0, screenSize.width, screenSize.width * imageSize.height/imageSize.width);
            
        }
        
    } completion:^(BOOL finished) {
        [window sendSubviewToBack:view];
        YZPhotoBrowserViewController *photoBrowserVc = [[YZPhotoBrowserViewController alloc] init];
        NSMutableArray *imageArray = [NSMutableArray arrayWithArray:_imageArray];
        [imageArray removeLastObject];
        photoBrowserVc.imageArray = imageArray;
        photoBrowserVc.showIndex = indexPath.item;
        photoBrowserVc.backBlock = ^(UIImage *image,CGRect frame,NSInteger index){
            [window bringSubviewToFront:view];
            imageView.image = image;
            imageView.frame = frame;
            [self imageClicked:imageView withCellIndex:index];
        };
        [self.navigationController pushViewController:photoBrowserVc animated:NO];
        
    }];
}
//图片消失
- (void)imageClicked:(UIImageView *)imageView withCellIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
    CGRect imageFrame = CGRectMake(cell.frame.origin.x + _tableView.frame.origin.x, _collectionView.frame.origin.y  + cell.frame.origin.y  + _tableView.frame.origin.y -_backgroundScrollView.contentOffset.y + 8 + 64, cell.frame.size.width - 8, cell.frame.size.height - 8);
    [UIView animateWithDuration:.25f animations:^{
        imageView.superview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        imageView.frame = imageFrame;
        
    } completion:^(BOOL finished) {
        [imageView.superview removeFromSuperview];
    }];
    
    
}

#pragma mark -照片功能
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://拍照
        {
            [self takePhoto];
        }
            break;
        case 1://本地相册
        {
            [self LocalPhoto];
        }
            break;
        default:
            break;
    }
}

//从相册选择
-(void)LocalPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 10 - _imageArray.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 10 - _imageArray.count;
        } else {
            return YES;
        }
    }];
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (int i = 0; i < assets.count; i++) {
        
        ALAsset *asset = assets[i];
        
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        NSData *data = UIImageJPEGRepresentation(tempImg, 0.1);
        UIImage *image = [UIImage imageWithData:data];
        [_imageArray insertObject:image atIndex:0];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone systemTimeZone]];
            [formatter setDateFormat:@"yyyy-MM-dd-hh:mm:ss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *imageName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
            [self saveImage:data WithName:imageName];
            
            
        });
    }
    [self changeViewSizeWithHeight:-64 contianCollectionView:YES];
    
}

//拍照
-(void)takePhoto{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        //资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

#pragma mark -保存图片的路径
- (void)saveImage:(NSData *)tempImageData WithName:(NSString *)imageName
{
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSURL *url = [NSURL fileURLWithPath:fullPathToFile];
    [_imageURLArray insertObject:url atIndex:0];
    
    [tempImageData writeToFile:fullPathToFile atomically:NO];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 创建imdge 接收图片
    UIImage* tempImg = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(tempImg, 0.1);
    UIImage *image = [UIImage imageWithData:data];
    [_imageArray insertObject:image atIndex:0];
    
    [self changeViewSizeWithHeight:-64 contianCollectionView:YES];
        // 关闭picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setTimeZone:[NSTimeZone systemTimeZone]];
        [formatter setDateFormat:@"yyyy-MM-dd-hh:mm:ss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *imageName = [NSString stringWithFormat:@"%@.png",dateString];
        [self saveImage:data WithName:imageName];
    });
    
}


#pragma mark -- tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 16) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"button"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"button"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton * showMoreButton = [UIButton buttonWithType:UIButtonTypeSystem];
            showMoreButton.frame = CGRectMake(30, 8, kScreenWidth - 60, 30);
            [showMoreButton setTitle:@"点击显示更多" forState:UIControlStateNormal];
            [showMoreButton setTitle:@"点击收起" forState:UIControlStateSelected];
            [showMoreButton addTarget:self action:@selector(showMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:showMoreButton];
        }
        return cell;
        
    }
    YZResourcesInfoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YZResourcesInfoDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.label_title.frame = CGRectMake(7, 2, 110, 40);
        cell.label_title.textColor = [UIColor blackColor];
    }
    if (indexPath.row == 12) {
        
        cell.label_detail.frame = CGRectMake(114, 4, kScreenWidth - 142, _taskDescHeight - 4 > 36 ? _taskDescHeight - 4 : 36);
    }else{
        cell.label_detail.frame = CGRectMake(114, 4, kScreenWidth - 142, 36);
    }
    cell.label_title.text = _titleArray[indexPath.row];
    cell.label_detail.text = _dataArray[indexPath.row];
    return cell;
    
    
}
//显示更多
- (void)showMoreButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _showMoreTitleArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + 17 inSection:0];
        [array addObject:indexPath];
    }
    
    if (sender.selected) {
        [_titleArray addObjectsFromArray:_showMoreTitleArray];
        [_tableView insertRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        [self changeViewSizeWithHeight:520 contianCollectionView:NO];
    }else{
        [_titleArray removeObjectsInArray:_showMoreTitleArray];
        [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
        [self changeViewSizeWithHeight:-520 contianCollectionView:NO];
    }
}


#pragma mark -- 改变所有视图的大小

- (void)changeViewSizeWithHeight:(CGFloat)height contianCollectionView:(BOOL)isContian
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.16];
    if (isContian) {
        NSInteger count = (_imageArray.count == 10 ? 9 : _imageArray.count) - 1;
        height = (112 + count/3 * 74) - _collectionView.frame.size.height;
        
        CGRect rect = _collectionView.frame;
        rect.size.height += height;
        _collectionView.frame = rect;
        [_collectionView reloadData];

        
    }
    CGRect tableRect = _tableView.frame;
    CGSize scrollSize = _backgroundScrollView.contentSize;
    CGRect layerRect = _backgroundLayer.frame;
    CGRect buttonRect = _buttonView.frame;
    CGRect exeRect = _excuteRecordsView.frame;
    
    
    tableRect.size.height += height;
    scrollSize.height += height;
    layerRect.size.height += height;
    buttonRect.origin.y += height;
    exeRect.origin.y += height;
    
    
    _buttonView.frame = buttonRect;
    _tableView.frame = tableRect;
    _backgroundScrollView.contentSize = scrollSize;
    _backgroundLayer.frame = layerRect;
    _excuteRecordsView.frame = exeRect;
    [UIView commitAnimations];
    [_tableView reloadData];

}

#pragma mark -- 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 12) {
        
        return _taskDescHeight > 40 ? _taskDescHeight : 40;
    }
    return 40;
}

- (void)loadData
{
    NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
    para1[URL_TYPE] = @"MyTask/WithWork/GetProjectCheckDetail";
    para1[@"checkId"] = _checkId;
    httpPOST(para1, ^(id result) {
        NSLog(@"%@",result);
        self.recordArray = [[result objectForKey:@"detail"] objectForKey:@"excuteRecords"];
        [self createExcuteRecordsView];
        
        _dataArray = [[NSMutableArray alloc] initWithObjects:@"工程现场配合", nil];
        NSArray *array = @[@"taskAppontmentNo",@"projectName",@"projectNo",@"projectSiteName",@"projectRoomName",@"specName",@"startPerson",@"department",@"contactWay",@"matchTask",@"projectType",@"taskDescript",@"actualStartTime",@"",@"projectSource",@"",@"projectManager",@"projectRange",@"constructorDepartment",@"constructorCaptain",@"captainContactWay",@"isFith",@"checkType",@"projectComplexityLevel",@"costTime",@"score",@"requestPerson",@"skillRequired"];
        for (NSString *key in array) {
            NSString *string = NoNullStr([[result objectForKey:@"detail"] objectForKey:key]);

            if ([key isEqualToString:@"taskDescript"]) {
                CGFloat height = [self calculateTextheight:string];
                
                if (height + 8 > 40) {
                    _taskDescHeight = height + 8;
                    [self changeViewSizeWithHeight:_taskDescHeight - 40 contianCollectionView:NO];
                }else{
                    _taskDescHeight = 40;
                }
            }
  
            [_dataArray addObject:string];
        }
        
        
        NSString *startTime = [[[result objectForKey:@"detail"] objectForKey:@"startTime"] substringToIndex:13];
        NSString *endTime = [[[result objectForKey:@"detail"] objectForKey:@"endTime"] substringToIndex:13];
        [_dataArray insertObject:[NSString stringWithFormat:@"%@~\n%@",startTime,endTime] atIndex:13];
        
        [_tableView reloadData];
        
        
        if ([[[result objectForKey:@"detail"] objectForKey:@"executeStuats"] isEqualToString:@"执行中"]) {
            [self setButtonStatusWithSelectedButton:YES];
        }else{
            [self setButtonStatusWithSelectedButton:NO];
        }
        
        
    }, ^(id result) {
        
    });
}


- (CGFloat)calculateTextheight:(NSString *)text
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - 142, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    return ceilf(rect.size.height);
}

- (void)dealloc
{
    if (!_isFromDetailVC) {
        [_imageURLArray enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSURL class]]) {
                NSError *error = nil;
                if([[NSFileManager defaultManager] removeItemAtPath:obj.parameterString error:&error]){
                }
            }
        }];
    }
    
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
