//
//  YZResourcesChangeViewController.m
//  ResouceChanged
//
//  Created by 锋 on 16/4/26.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZResourcesChangeViewController.h"
#import "YZSystemTableViewCell.h"
#import "YZChangeTableViewCell.h"
#import "YZImageCollectionViewCell.h"
#import "ZYQAssetPickerController.h"
#import "YZChooseView.h"
#import "YZChooseChangeTableViewCell.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "IQKeyboardManager.h"
#import "YZPhotoBrowserViewController.h"

@interface YZResourcesChangeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIActionSheetDelegate,UICollectionViewDelegate,UICollectionViewDataSource,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,BMKLocationServiceDelegate>
{
    UITableView *_tableView;
    UICollectionView *_collectionView;
    NSRange _redRange;
    
    BOOL _isShowSystemDetail;
    
    NSMutableArray *_titeArray;
        
    NSMutableDictionary *_chooseDict;
    
    //系统情况字符
    NSMutableAttributedString *_systemAttributedString;
    //百度地图定位
    BMKLocationService *_locService;
    
    
    //保存删除图片的id
    NSMutableArray *_deleteImageArray;
    
    YZChooseView *_chooseView;
    
    NSString *_systemInfo;
}
@end

@implementation YZResourcesChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"新建资源变更工单";
    
    [self data];
    [self createTableView];
    [self addNavigationLeftButton];
    [self addNavigationRightButton];
    [self requestData];
    [self baiduMapLocation];
    
}

- (void)baiduMapLocation
{
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}

- (void)addNavigationRightButton
{
    UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [itemButton setBackgroundImage:[UIImage imageNamed:@"nav_check"] forState:UIControlStateNormal];
    [itemButton addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    itemButton.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:itemButton];
}
- (void)rightAction:(id)sender
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    for ( int i = 0; i < 10; i++) {
        NSString *obj = [_dataDict objectForKey:[NSString stringWithFormat:@"%d",i]];
        if (obj == nil || [obj isEqualToString:@""]) {
            
            NSMutableAttributedString *mutStr = [_titeArray objectAtIndex:i];
            if (i == 1 || i == 8) {
                NSString *previousStr = [_dataDict objectForKey:[NSString stringWithFormat:@"%d",i - 1]];
                if ([previousStr isEqualToString:@"其他"]) {
                    YZChooseChangeTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
                    if (cell.textField_choose.text != nil && ![cell.textField_choose.text isEqualToString:@""]) {
                        [_dataDict setObject:cell.textField_choose.text forKey:[NSString stringWithFormat:@"%d",i]];
                        continue;
                    }
                    
                    [self showAlertWithTitle:@"提示" :[NSString stringWithFormat:@"请输入%@",mutStr.string] :@"确认" :nil];
                    return;
                }
                
            }else if(i != 6 ){
                YZChooseChangeTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
                if (cell.textField_choose.text != nil && ![cell.textField_choose.text isEqualToString:@""]) {
                    [_dataDict setObject:cell.textField_choose.text forKey:[NSString stringWithFormat:@"%d",i]];
                    continue;
                }
                [self showAlertWithTitle:@"提示" :[NSString stringWithFormat:@"请输入%@",mutStr.string] :@"确认" :nil];
                return;
            }
        }
        
    }
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[@"id"] = [_dataDict objectForKey:@"infoId"];
    paraDict[@"type"] = _resources_type;
    paraDict[@"typeId"] = _resources_id;
    paraDict[@"sceneId"] = @"3";
    if (_haveSystemInfo) {
        paraDict[@"sysInfo"] = [_systemArray componentsJoinedByString:@";"];
    }else{
        if (_systemInfo == nil || [_systemInfo isEqualToString:@""]) {
            [self showAlertWithTitle:@"提示" :@"请输入系统情况" :@"确认" :nil];
            return;
        }else{
            paraDict[@"sysInfo"] = _systemInfo;
        }
    }
    
    //细化任务类型
    __block NSInteger markNumber = -1;
    NSArray *array = [_chooseDict objectForKey:@"0"];
    
    NSString *subType = [_dataDict objectForKey:@"0"];
    
    markNumber = [array indexOfObject:subType];
    if ([subType isEqualToString:@"其他"]) {
        markNumber = 998;
    }
  
    paraDict[@"subType"] = [NSString stringWithFormat:@"%d",markNumber + 1];
    
    
    paraDict[@"subTypeRemark"] = [_dataDict objectForKey:@"1"];
    //专业
    array = [_chooseDict objectForKey:@"2"];
    NSString *major = [_dataDict objectForKey:@"2"];
    markNumber = [array indexOfObject:major];
    if ([major isEqualToString:@"其他"]) {
        markNumber = 998;
    }
   
    paraDict[@"majorId"] = [NSString stringWithFormat:@"%d",markNumber + 1];
    
    paraDict[@"orderType"] = @"1";
    paraDict[@"title"] = [_dataDict objectForKey:@"3"];
    paraDict[@"remarks"] = [_dataDict objectForKey:@"4"];
    paraDict[@"liveInfo"] = [_dataDict objectForKey:@"5"];
    //来源
    markNumber = -1;
    array = [_chooseDict objectForKey:@"6"];
    NSString *source  = [_dataDict objectForKey:@"6"];
    markNumber = [array indexOfObject:source];
    if ([source isEqualToString:@"其他"]) {
        markNumber = 998;
    }
  
    if (markNumber >= 0) {
        paraDict[@"source"] = [NSString stringWithFormat:@"%d",markNumber + 1];
    }
    //错误类型
    array = [_chooseDict objectForKey:@"7"];
    NSString *faultType = [_dataDict objectForKey:@"7"];
    markNumber = [array indexOfObject:faultType];
    if ([faultType isEqualToString:@"其他"]) {
        markNumber = 998;
    }
  
    paraDict[@"faultType"] = [NSString stringWithFormat:@"%d",markNumber + 1];
    paraDict[@"faultTypeRemark"] = [_dataDict objectForKey:@"8"];
    paraDict[@"taskLatitude"] = [NSString stringWithFormat:@"%f",_locService.userLocation.location.coordinate.latitude];
    paraDict[@"taskLongtitude"] = [NSString stringWithFormat:@"%f",_locService.userLocation.location.coordinate.longitude];
    paraDict[@"emergency"] = [[_dataDict objectForKey:@"9"] isEqualToString:@"正常"] ? @"1" : @"2";
    
    
    //图片变更
    if (_isUpdateResources && _deleteImageArray != nil) {
        paraDict[@"delFileIds"] = [_deleteImageArray componentsJoinedByString:@","];
    }
    
    NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/adjustRes/SaveAdjustRes.json",ADDR_IP,ADDR_DIR];
    paraDict[@"accessToken"] = accessToken;
    paraDict[@"operationTime"] = opreatinTime;
    NSLog(@"%@",paraDict);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:requestUrl parameters:paraDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < _imageURLArray.count; i++) {
            if (_imageURLArray.count == 0) {
                
            }else{
                id imageURL = _imageURLArray[i];
                if ([imageURL isKindOfClass:[NSURL class]]) {
                    [formData appendPartWithFileURL:imageURL name:[NSString stringWithFormat:@"image%d",i] error:nil];
                }
            }
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *result = [responseObject objectForKey:@"result"];
        if ([result isEqualToString:@"0000000"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传变更工单成功" delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
            alertView.tag = 11;
            [alertView show];
            
        }else{
            NSLog(@"%@",responseObject);
            [self showAlertWithTitle:@"提示" :[responseObject objectForKey:@"error"] :@"确认" :nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"---->>>%@",error);
    }];
}



#pragma mark -- 请求及数据
- (void)requestData
{
    if (!_isUpdateResources && _resources_id != nil && ![_resources_id isEqualToString:@""]) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
            paraDict[URL_TYPE] = @"adjustRes/QuerySystemInfo";
            paraDict[@"type"] = _resources_type;
            paraDict[@"id"] = _resources_id;
            httpPOST(paraDict, ^(id result) {
                if ([[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
                    _haveSystemInfo = YES;
                    NSString *detailString = [result objectForKey:@"detail"];
                    _systemArray = [detailString componentsSeparatedByString:@";"];
                    [_systemAttributedString replaceCharactersInRange:_redRange withString:@" "];
                    [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    
                }else{
                    [self showAlertWithTitle:@"提示" :[result objectForKey:@"error"] :@"确认" :nil];
                }
            }, ^(id result) {
                NSLog(@"%@",result);
            });
            
        });
    }
    [self queryMajorDic];
    [self querySourceDic];
    [self querySubTypeDic];
    [self queryFaultTypeDic];
    NSArray *array = @[@"正常",@"紧急"];
    [_chooseDict setObject:array forKey:@"9"];
}

- (void)querySubTypeDic
{
    NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
    para1[URL_TYPE] = @"adjustRes/QuerySubTypeDic";
    httpPOST(para1, ^(id result) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *listArray = [result objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
            [mutArray addObject:[dict objectForKey:@"name"]];
        }
        [_chooseDict setObject:mutArray forKey:@"0"];
    }, ^(id result) {
        
    });
    
}

- (void)queryMajorDic
{
    NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
    para1[URL_TYPE] = @"adjustRes/QueryMajorDic";
    httpPOST(para1, ^(id result) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *listArray = [result objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
            [mutArray addObject:[dict objectForKey:@"name"]];
        }
        [_chooseDict setObject:mutArray forKey:@"2"];
    }, ^(id result) {
        
    });
    
}

- (void)querySourceDic
{
    NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
    para1[URL_TYPE] = @"adjustRes/QuerySourceDic";
    httpPOST(para1, ^(id result) {
        
        NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *listArray = [result objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
            [mutArray addObject:[dict objectForKey:@"name"]];
        }
        [_chooseDict setObject:mutArray forKey:@"6"];
    }, ^(id result) {
    });
    
}

- (void)queryFaultTypeDic
{
    NSMutableDictionary *para1 = [NSMutableDictionary dictionary];
    para1[URL_TYPE] = @"adjustRes/QueryFaultTypeDic";
    httpPOST(para1, ^(id result) {
        NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *listArray = [result objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
            [mutArray addObject:[dict objectForKey:@"name"]];
        }
        [_chooseDict setObject:mutArray forKey:@"7"];
    }, ^(id result) {
        NSLog(@"%@",result);
    });
    
}
- (void)data
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        _redRange.location = 0;
        _redRange.length = 1;
        if (_isUpdateResources) {
            _systemAttributedString = [[NSMutableAttributedString alloc] initWithString:@" 系  统  情  况:" attributes:@{NSForegroundColorAttributeName:TEXTCOLOR,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
            
        }else{
            _systemAttributedString = [[NSMutableAttributedString alloc] initWithString:@"*系  统  情  况:" attributes:@{NSForegroundColorAttributeName:TEXTCOLOR,NSFontAttributeName:[UIFont boldSystemFontOfSize:16]}];
            [_systemAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:_redRange];
        }
        if (_dataDict == nil) {
            _dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        }
        
        _chooseDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        if (_imageArray == nil) {
            _imageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"upload_btn"], nil];
            
        }else{
            [_imageArray addObject:[UIImage imageNamed:@"upload_btn"]];
        }
        
        if (_imageURLArray == nil) {
            _imageURLArray = [[NSMutableArray alloc] initWithCapacity:0];
        }
        
        
        _titeArray = [[NSMutableArray alloc] initWithCapacity:0];
        NSArray *array = [[NSArray alloc] initWithObjects:@"*细化任务类型:",@"细化任务类型 (其他):",@"*专             业:",@"*任  务  标  题:",@"*任  务  内  容:",@"*现  场  情  况:",@"来               源:",@"*错  误  类  型:",@"错误类型(其他):",@"*紧  急  情  况:", nil];
        
        [array enumerateObjectsUsingBlock:^(NSString *string, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableAttributedString *noteString = nil;
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            if (idx == 1 || idx == 8) {
                noteString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle}];
            }else{
                noteString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName:TEXTCOLOR,NSFontAttributeName:[UIFont boldSystemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle}];
            }
            if ([string hasPrefix:@"*"]) {
                [noteString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:_redRange];
            }
            
            [_titeArray addObject:noteString];
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [self createTableViewFootView];
    [self.view addSubview:_tableView];
    
}

- (UIView *)createTableViewFootView
{
    NSInteger count = (_imageArray.count == 10 ? 9 : _imageArray.count) - 1;
    CGFloat height = (112 + count/3 * 74) - _collectionView.frame.size.height;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(75, 64);
    layout.minimumLineSpacing = 18;
    layout.minimumInteritemSpacing  = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, 32, 30, 24);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[YZImageCollectionViewCell class] forCellWithReuseIdentifier:@"image"];
    return _collectionView;
    
}
#pragma mark -- collectViewDelegate
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
    if ([_imageArray[indexPath.item] isKindOfClass:[UIImage class]]) {
        cell.imageView_upImage.image = _imageArray[indexPath.item];
    }else{
        [cell.imageView_upImage sd_setImageWithURL:[NSURL URLWithString:_imageArray[indexPath.item]]];
    }
    
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
    if (alertView.tag == 11) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    switch (buttonIndex) {
        case 1:
        {
            id obj = [_imageURLArray objectAtIndex:alertView.tag];
            if ([obj isKindOfClass:[NSString class]]) {
                if (_deleteImageArray == nil) {
                    _deleteImageArray = [[NSMutableArray alloc] initWithCapacity:0];
                }
                [_deleteImageArray addObject:obj];
            }
            [_imageURLArray removeObjectAtIndex:alertView.tag];
            [_imageArray removeObjectAtIndex:alertView.tag];
            [self changeViewSizeWithHeight:0 contianCollectionView:YES];
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
    UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:view];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:cell.imageView_upImage.image];
    imageView.frame = CGRectMake(cell.frame.origin.x, _collectionView.frame.origin.y + cell.frame.origin.y - _tableView.contentOffset.y + 64 + 8, cell.frame.size.width - 8, cell.frame.size.height - 8);
    [view addSubview:imageView];
    
    
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

    [UIView animateWithDuration:.25f animations:^{
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];

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
        
        YZPhotoBrowserViewController *photoBrowserVC = [[YZPhotoBrowserViewController alloc] init];
        NSMutableArray *array = [NSMutableArray arrayWithArray:_imageArray];
        [array removeLastObject];
        photoBrowserVC.imageArray = array;
        photoBrowserVC.showIndex = indexPath.row;
        photoBrowserVC.backBlock = ^(UIImage *image,CGRect frame,NSInteger index){
            [window bringSubviewToFront:view];

            imageView.image = image;
            imageView.frame = frame;
            [self imageClicked:imageView withCellIndex:index];
        };
        [window sendSubviewToBack:view];

        [self.navigationController pushViewController:photoBrowserVC animated:NO];
    }];
}
//图片消失
- (void)imageClicked:(UIImageView *)imageView withCellIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:indexPath];
    CGRect imageFrame = CGRectMake(cell.frame.origin.x, _collectionView.frame.origin.y + cell.frame.origin.y - _tableView.contentOffset.y + 64 + 8, cell.frame.size.width - 8, cell.frame.size.height - 8);
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
        case 2:
        {
        }
            break;
        default:
            break;
    }
}

//从相册选择
-(void)LocalPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    picker.maximumNumberOfSelection = 10-_imageArray.count;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 创建image 接收图片
    UIImage* tempImg = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(tempImg, 0.1);
    UIImage *image = [UIImage imageWithData:data];
    [_imageArray insertObject:image atIndex:0];
    [_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:0 inSection:0]]];
    
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
    
    
    [self changeViewSizeWithHeight:0 contianCollectionView:YES];
}

#pragma mark -保存图片的路径
- (void)saveImage:(NSData *)tempImageData WithName:(NSString *)imageName
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSURL *url = [NSURL fileURLWithPath:fullPathToFile];
//    [_imageURLArray addObject:url];
    [_imageURLArray insertObject:url atIndex:0];
    [tempImageData writeToFile:fullPathToFile atomically:NO];
    
}

#pragma mark -- 改变所有视图的大小

- (void)changeViewSizeWithHeight:(CGFloat)changeHeight contianCollectionView:(BOOL)isContian
{
    NSInteger count = (_imageArray.count == 10 ? 9 : _imageArray.count) - 1;
    CGFloat height = (132 + count/3 * 74) - _collectionView.frame.size.height;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.16];
    if (isContian) {
        
        CGRect rect = _collectionView.frame;
        
        rect.size.height += height;
        
        _collectionView.frame = rect;
        
        [_collectionView reloadData];
        
        _tableView.tableFooterView = _collectionView;
    }
    
    [UIView commitAnimations];
    
    
}



#pragma mark -- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return _isShowSystemDetail ? _systemArray.count : 1;
    }
    return _titeArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_haveSystemInfo) {
            YZSystemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"system"];
            if (!cell) {
                cell = [[YZSystemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"system"];
            }
            
            cell.label_name.text = _systemArray[indexPath.row];
            if (indexPath.row == 0) {
                cell.label_system.hidden = NO;
                cell.imageView_accessory.hidden = NO;
                
                [cell.label_system setAttributedText:_systemAttributedString];
                cell.label_name.frame = CGRectMake(132, 20, self.view.frame.size.width - 170, [self calculateTextheight:cell.label_name.text]);
                
            }else{
                cell.label_system.hidden = YES;
                cell.imageView_accessory.hidden = YES;
                cell.label_name.frame = CGRectMake(132, 8, self.view.frame.size.width - 170, [self calculateTextheight:cell.label_name.text]);
                
            }
            return cell;
            
        }
        YZChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newSystem"];
        if (!cell) {
            cell = [[YZChangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newSystem"];
            cell.textField_choose.tag = -1;
            cell.textField_choose.delegate = self;
        }
        [cell.label_title setAttributedText:_systemAttributedString];
        cell.textField_choose.text = _systemInfo;
        return cell;
    }
    
    
    if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 8) {
        YZChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"change"];
        if (!cell) {
            cell = [[YZChangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"change"];
            cell.textField_choose.delegate = self;
        }
        cell.textField_choose.tag = indexPath.row;
        cell.textField_choose.text = [_dataDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] == nil ? @"" : [_dataDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        [cell.label_title setAttributedText:_titeArray[indexPath.row]];
        if (indexPath.row == 8 && ![_dataDict[@"7"] isEqualToString:@"其他"]) {
            cell.textField_choose.editable = NO;
            cell.textField_choose.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        }else{
            cell.textField_choose.editable = YES;
            cell.textField_choose.backgroundColor = [UIColor whiteColor];
        }
        return cell;
        
    }
    YZChooseChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"choose"];
    if (!cell) {
        cell = [[YZChooseChangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choose"];
        cell.textField_choose.delegate = self;
        [cell.control_choose addTarget:self action:@selector(chooseTextFieldClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.row == 1 || indexPath.row == 3) {
        cell.imageView_accessory.hidden = YES;
        cell.control_choose.hidden = YES;
        if (indexPath.row == 1 && ![_dataDict[@"0"] isEqualToString:@"其他"]) {
            cell.textField_choose.enabled = NO;
            cell.textField_choose.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        }else{
            cell.textField_choose.enabled = YES;
            cell.textField_choose.backgroundColor = [UIColor whiteColor];
        }
    }else{
        cell.textField_choose.enabled = YES;
        cell.imageView_accessory.hidden = NO;
        cell.control_choose.hidden = NO;
        cell.textField_choose.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        
    }
    cell.control_choose.tag = indexPath.row;
    cell.textField_choose.tag = indexPath.row;
    [cell.label_title setAttributedText:_titeArray[indexPath.row]];
    
    cell.textField_choose.text = [_dataDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]] == nil ? @"" : [_dataDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    return cell;
}

- (void)chooseTextFieldClicked:(UIControl *)control
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    YZChooseChangeTableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:control.tag inSection:1]];
    UITextField *textField = cell.textField_choose;
    NSArray *array = [_chooseDict objectForKey:[NSString stringWithFormat:@"%d",control.tag]];
    __block NSInteger selectedIndex = -1;
    NSMutableArray *heightArray = [NSMutableArray arrayWithCapacity:0];
    __block CGFloat totalheight = 0.0f;
    [array enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:textField.text]) {
            selectedIndex = idx;
        }
        CGFloat height = [YZChooseView calculateTextheight:obj withTextWidth:textField.frame.size.width] + 4;
        height = height > 22 ? height : 22;
        totalheight = totalheight + height;
        [heightArray addObject:[NSNumber numberWithFloat:height]];
    }];
    
    
    if (!_chooseView) {
        _chooseView = [[YZChooseView alloc] initWithFrame:CGRectMake(textField.frame.origin.x, cell.frame.origin.y + textField.frame.origin.y, textField.frame.size.width, 26) tableViewHeight:totalheight];
        
    }
    CGRect rect = _chooseView.tableView.frame;
    rect.size.height = totalheight;
    _chooseView.tableView.frame = rect;
    _chooseView.selectedIndex = selectedIndex;
    _chooseView.heightArray = heightArray;
    _chooseView.dataArray = array;
    __weak NSMutableDictionary *dataDict = _dataDict;
    __weak NSMutableArray *titleArray = _titeArray;
    __block NSRange redRange = _redRange;
    __weak UITableView *tempTableView = _tableView;
    __weak YZChooseView *chooseView = _chooseView;
    _chooseView.selectedCompletionBlock = ^(NSInteger selectedIndex){
        [chooseView removeFromSuperview];
        textField.text = array[selectedIndex];
        [dataDict setObject:textField.text forKey:[NSString stringWithFormat:@"%d",textField.tag]];
        if (control.tag == 9) {
            return ;
        }
        NSMutableAttributedString *str  = titleArray[control.tag + 1];
        //获取范围
        NSRange blueRange;
        blueRange.location = 0;
        blueRange.length = str.length;
        if ([textField.text isEqualToString:@"其他"]) {
            if (![str.string hasPrefix:@"*"]) {
                [str addAttributes:@{NSForegroundColorAttributeName:TEXTCOLOR} range:blueRange];
                [str insertAttributedString:[[NSAttributedString alloc] initWithString:@"*" attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}] atIndex:0];
                [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
                [tempTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:textField.tag + 1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                
            }
            
        }else if (textField.tag == 0 || textField.tag == 7) {
            if ([str.string hasPrefix:@"*"]) {
                [str addAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]} range:blueRange];
                [str deleteCharactersInRange:redRange];
                [tempTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:textField.tag + 1 inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }
    };
    
    [_tableView addSubview:_chooseView];
    if (textField.tag == 7) {
        _chooseView.frame = CGRectMake(textField.frame.origin.x, cell.frame.origin.y+textField.frame.origin.y - totalheight/2, textField.frame.size.width, totalheight);
    }else{
        _chooseView.frame = CGRectMake(textField.frame.origin.x, cell.frame.origin.y+textField.frame.origin.y, textField.frame.size.width, totalheight);
    }
    
}
#pragma mark -- 单元格的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (!_haveSystemInfo) {
            return 100;
        }
        CGFloat height = [self calculateTextheight:_systemArray[indexPath.row]] + 20;
        if (indexPath.row == 0) {
            return height > 44 ? height : 44;
        }else{
            return height;
        }
        
    }
    if (indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 8) {
        return 100;
    }
    return 44;
}

#pragma mark -- 点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (!_haveSystemInfo) {
            return;
        }
        _isShowSystemDetail = !_isShowSystemDetail;
        YZSystemTableViewCell *cell = (YZSystemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.imageView_accessory.transform =  _isShowSystemDetail ? CGAffineTransformMakeRotation(M_PI/2) : CGAffineTransformIdentity;
        NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 1; i < _systemArray.count; i++) {
            NSIndexPath *insertIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexArray addObject:insertIndexPath];
        }
        
        if (_isShowSystemDetail) {
            [_tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [_tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
}



#pragma mark -- UITextViewDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [_dataDict setObject:textField.text forKey:[NSString stringWithFormat:@"%d",textField.tag]];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1 && range.location > 100) {
        [self showAlertWithTitle:@"提示" :@"请输入少于100个字的类型描述" :@"确认" :nil];
        return NO;
    }
    if (textField.tag == 3 && range.location > 200) {
        [self showAlertWithTitle:@"提示" :@"请输入少于200个字的标题描述" :@"确认" :nil];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.tag == -1) {
        return;
    }
    [_chooseView removeFromSuperview];
    CGRect rect = _tableView.frame;
    rect.size.height = kScreenHeight - 64 - 297;
    [UIView animateWithDuration:.25 animations:^{
        _tableView.frame = rect;
    } completion:^(BOOL finished) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:textView.tag inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.tag == -1) {
        _systemInfo = textView.text;
        return YES;
    }
    [_dataDict setObject:textView.text forKey:[NSString stringWithFormat:@"%d",textView.tag]];
    CGRect rect = _tableView.frame;
    rect.size.height = kScreenHeight - 64;
    _tableView.frame = rect;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.tag == -1 && range.location > 500) {
        [self showAlertWithTitle:@"提示" :@"请输入少于500字的系统情况" :@"确认" :nil];
        return NO;
    }
    
    if (textView.tag == 4 && range.location > 300) {
        [self showAlertWithTitle:@"提示" :@"请输入少于300个字的内容描述" :@"确认" :nil];
        return NO;
    }
    if (textView.tag == 5 && range.location > 300) {
        [self showAlertWithTitle:@"提示" :@"请输入少于300个字的现场情况描述" :@"确认" :nil];
        return NO;
    }
    if (textView.tag == 8 && range.location > 200) {
        [self showAlertWithTitle:@"提示" :@"请输入少于200个字的错误类型描述" :@"确认" :nil];
        return NO;
    }
    return YES;
}
#pragma mark -- 计算文字的高度
- (CGFloat)calculateTextheight:(NSString *)text
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(_tableView.frame.size.width - 170, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil];
    return ceilf(rect.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_imageURLArray enumerateObjectsUsingBlock:^(NSURL *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSURL class]]) {
            NSError *error = nil;
            if([[NSFileManager defaultManager] removeItemAtPath:obj.parameterString error:&error]){
            }
        }
    }];
    
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
