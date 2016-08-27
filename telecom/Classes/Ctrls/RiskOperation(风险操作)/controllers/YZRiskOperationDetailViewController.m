//
//  YZRiskOperationDetailViewController.m
//  telecom
//
//  Created by 锋 on 16/6/20.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZRiskOperationDetailViewController.h"
#import "ZYQAssetPickerController.h"
#import "YZResourcesInfoDetailTableViewCell.h"
#import "YZImageCollectionViewCell.h"
#import "YZQualityIndexViewController.h"
#import "YZImageAccessoryViewController.h"
#import "YZPhotoBrowserViewController.h"

@interface YZRiskOperationDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>
{
    //底部的scrollview
    UIView *_buttonView;
    UITableView *_tableView;
    UICollectionView *_collectionView;
    
    NSMutableArray *_titleArray;
    NSArray *_showMoreTitleArray;
    
    //图片
    NSMutableArray *_imageArray;
    //保存图片的URL
    NSMutableArray *_imageURLArray;
    
    UIView *_footerView;
}
@end

@implementation YZRiskOperationDetailViewController

- (void)dealloc
{
    [self deleteLocalImage];
}

- (void)deleteLocalImage
{
    [_imageURLArray enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSURL class]]) {
            NSError *error = nil;
            if([[NSFileManager defaultManager] removeItemAtPath:obj.parameterString error:&error]){
            }
        }
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"风险操作详情";
    [self loadLocalData];
    [self addNavigationLeftButton];
    [self addNavigationRightItem];
    
    [self createTableView];
    
    if ([_dataArray[0][11] isEqualToString:@""]) {
        [self setButtonStatusWithSelectedButton:NO];
    }else{
        [self setButtonStatusWithSelectedButton:YES];
    }
    

}

- (void)addNavigationRightItem
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 33, 33);
    [button setBackgroundImage:[UIImage imageNamed:@"3_1"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightItemClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)rightItemClicked
{
    YZImageAccessoryViewController *accessoryVC = [[YZImageAccessoryViewController alloc] init];
    accessoryVC.workNo = _workNo;
    [self.navigationController pushViewController:accessoryVC animated:YES];
}


- (UIView *)createBottomButton
{
     _buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
   
    
    UIButton *applicationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applicationButton.frame = CGRectMake(12, 12, (kScreenWidth - 36)/2, 40);
    applicationButton.backgroundColor = [UIColor colorWithRed:48/255.0 green:107/255.0 blue:180/255.0 alpha:1];
    [applicationButton setTitle:@"开    始" forState:UIControlStateNormal];
    [applicationButton addTarget:self action:@selector(applicationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    applicationButton.titleLabel.font = [UIFont systemFontOfSize:20];
    applicationButton.layer.cornerRadius = 4;
    [_buttonView addSubview:applicationButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(12 + (kScreenWidth - 36)/2 + 12, 12, (kScreenWidth - 36)/2, 40);
    //    cancelButton.backgroundColor = [UIColor colorWithRed:57/255.0 green:155/255.0 blue:47/255.0 alpha:1];
    cancelButton.backgroundColor = [UIColor grayColor];
    [cancelButton setTitle:@"结    束" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
    cancelButton.layer.cornerRadius = 4;
    [_buttonView addSubview:cancelButton];
    
    return _buttonView;
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

//开始执行
- (void)applicationButtonClicked
{
    [self executeRiskOperationWithAction:@"start"];
    
}
//结束执行
- (void)cancelButtonClicked
{
    [self executeRiskOperationWithAction:@"end"];
}

#pragma mark -- 风险操作执行
- (void)executeRiskOperationWithAction:(NSString *)action
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    
    NSString *operationTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/riskOperation/ExecuteRiskOperation.json",ADDR_IP,ADDR_DIR];
    paraDict[@"accessToken"] = accessToken;
    paraDict[@"operationTime"] = operationTime;
    paraDict[@"action"] = action;
    paraDict[@"workNo"] = _workNo;
    
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
        NSLog(@"%@",responseObject);
        if ([action isEqualToString:@"start"] && [[responseObject objectForKey:@"result"] isEqualToString:@"0000000"]) {
            [self setStartActionTime:operationTime];
            [self showAlertViewWithMessage:@"操作成功" isEndAction:NO];
        }else if ([action isEqualToString:@"end"] && [[responseObject objectForKey:@"result"] isEqualToString:@"0000000"]){
            [self showAlertViewWithMessage:@"操作成功" isEndAction:YES];
        }else {
            NSString *error = NoNullStr([responseObject objectForKey:@"error"]);
            [self showAlertViewWithMessage:error isEndAction:NO];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorStr = NoNullStr(error.description);
        [self showAlertViewWithMessage:errorStr isEndAction:NO];

    }];

}

//设置执行开始时间
- (void)setStartActionTime:(NSString *)time
{

    [self deleteLocalImage];
    [_imageURLArray removeAllObjects];
    
    [_imageArray removeObjectsInRange:NSMakeRange(0, _imageArray.count - 1)];
    [self changeViewSizeWithHeight:-64 contianCollectionView:YES];


    [self setButtonStatusWithSelectedButton:YES];
    NSMutableArray *sectionArray = _dataArray[0];
    [sectionArray replaceObjectAtIndex:11 withObject:time];
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:0]withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark -- 弹出警告框
- (void)showAlertViewWithMessage:(NSString *)message isEndAction:(BOOL)action
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    if (action) {
        alertView.tag = 34;
    }else{
        alertView.tag = 33;
    }
    [alertView show];
}


#pragma mark -- 创建表
- (void)createTableView
{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, kScreenWidth, kScreenHeight - 30) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [self createBottomButton];
    _tableView.tableHeaderView = nil;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

#pragma mark -- collectionView
- (UIView *)createTableViewFootView
{
    
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 144)];
    
    UIButton * showMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showMoreButton.frame = CGRectMake(30, 110, kScreenWidth - 60, 30);
    [showMoreButton setTitle:@"显示更多" forState:UIControlStateNormal];
    [showMoreButton setTitle:@"收起" forState:UIControlStateSelected];
    [showMoreButton setTitleColor:[UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [showMoreButton addTarget:self action:@selector(showMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    showMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [_footerView addSubview:showMoreButton];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(75, 64);
    layout.minimumLineSpacing = 18;
    layout.minimumInteritemSpacing  = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, 24, 10, 18);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 112) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[YZImageCollectionViewCell class] forCellWithReuseIdentifier:@"image"];
    [_footerView addSubview:_collectionView];
    
    return _footerView;
    
}

#pragma mark -- 显示更多
- (void)showMoreButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;

    if ( sender.selected) {
        if (_showMoreTitleArray == nil) {
            _showMoreTitleArray = [[NSArray alloc] initWithObjects:@"是否影响公众客户:",@"实  施  人  电  话:",@"配  合  人  电  话:",@"监  控  人  电  话:",@"发     起     地     市:",@"风险操作涉及设备范围:",@"客 户 服 务 影 响:",@"影 响 范 围 和 时 长:",@"是否需要现场操作:",@"现 场 操 作 时 间:",@"现 场 操 作 要 求:",@"是否需要业务测试:",@"业 务 测 试 要 求:",@"任 务 位 置 经 度:",@"任 务 位 置 纬 度:",@"耗                       时:",@"难                       度:",@"需     求     人     数:",@"积                       分:",@"技     能     要     求:", nil];
        }
        [_titleArray addObject:_showMoreTitleArray];
        
        [_tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        [_titleArray removeLastObject];
        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    
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
    //如果是结束执行成功跳转页面
    if (alertView.tag == 34) {
        [self setButtonStatusWithSelectedButton:NO];
        YZQualityIndexViewController *qualityIndexVC = [[YZQualityIndexViewController alloc] init];
        qualityIndexVC.riskKind = _dataArray[0][8];
        qualityIndexVC.riskId = _riskId;
        
        [self.navigationController pushViewController:qualityIndexVC animated:YES];
        return;
    }else if (alertView.tag == 33) {
        return;
    }

    //图片的处理
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
    imageView.frame = CGRectMake(cell.frame.origin.x, _collectionView.frame.origin.y  + cell.frame.origin.y  + _footerView.frame.origin.y -_tableView.contentOffset.y + 8 + 30, cell.frame.size.width - 8, cell.frame.size.height - 8);
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
    CGRect imageFrame = CGRectMake(cell.frame.origin.x, _collectionView.frame.origin.y  + cell.frame.origin.y  + _footerView.frame.origin.y -_tableView.contentOffset.y + 8 + 30, cell.frame.size.width - 8, cell.frame.size.height - 8);
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

    [self changeViewSizeWithHeight:0 contianCollectionView:YES];
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
    
    [self changeViewSizeWithHeight:0 contianCollectionView:YES];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionArray = _titleArray[section];
    return sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZResourcesInfoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YZResourcesInfoDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.label_title.frame = CGRectMake(10, 4, 127, 36);
        cell.label_title.numberOfLines =  1;

    }
    cell.label_title.text = _titleArray[indexPath.section][indexPath.row];
    cell.label_detail.text = _dataArray[indexPath.section][indexPath.row];
    [cell.label_title setAdjustsFontSizeToFitWidth:YES];
    cell.label_detail.frame = CGRectMake(138, 4, kScreenWidth - 146, [_heightArray[indexPath.section][indexPath.row] floatValue]);
    return cell;
}

#pragma mark -- 区尾视图

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return nil;
    }
    if (_footerView == nil) {
        [self createTableViewFootView];
    }
    return _footerView;
}

#pragma mark -- 单元格高度

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [_heightArray[indexPath.section][indexPath.row] floatValue];
    return height + 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 0;
    }
    if (_footerView == nil) {
        [self createTableViewFootView];
    }
    return _footerView.frame.size.height;
}

#pragma mark -- 改变所有视图的大小

- (void)changeViewSizeWithHeight:(CGFloat)changeHeight contianCollectionView:(BOOL)isContian
{
    NSInteger count = (_imageArray.count == 10 ? 9 : _imageArray.count) - 1;
     CGFloat height = (112 + count/3 * 74) - _collectionView.frame.size.height;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.16];
    if (isContian) {
        
        UIButton *button = [_footerView.subviews objectAtIndex:0];
        CGRect rect = _collectionView.frame;
        CGRect footerRect = _footerView.frame;
        CGRect buttonRect = button.frame;
        
        rect.size.height += height;
        footerRect.size.height += height;
        buttonRect.origin.y += height;
        
        _collectionView.frame = rect;
        _footerView.frame = footerRect;
        button.frame = buttonRect;
        
        [_collectionView reloadData];
        [_tableView reloadData];
        
        
    }

    [UIView commitAnimations];
}


#pragma mark -- 加载本地数据
- (void)loadLocalData
{
    NSMutableArray *sectionArray0 = [NSMutableArray arrayWithObjects:@"工     单     编     号:",@"工     单     标     题:",@"工  单  申  请  人:",@"申     请     公     司:",@"申 请 人 部 门 名:",@"流     程     状     态:",@"申     请     类     型:",@"申     请     专     业:",@"风 险 操 作 分 类:",@"申 请 开 始 时 间:",@"申 请 结 束 时 间:",@"执 行 开 始 时 间:",@"申     请     原     因:",@"影     响     范     围:",@"是否影响敏感客户:",@"实          施         人:",@"配          合         人:",@"监          控         人:",@"备                       注:", nil];
    
    _titleArray = [[NSMutableArray alloc] initWithObjects:sectionArray0, nil];
   
    
    _imageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"upload_btn"], nil];
    
    _imageURLArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
}


#pragma mark - 返回按钮
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(0, 7,navImg.size.width/1,navImg.size.height/1)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,44,44);
    //    [leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
