//
//  YZAcceptanceApplicationViewController.m
//  AcceptanceApplication
//
//  Created by 锋 on 16/5/16.
//  Copyright © 2016年 鲍可庆. All rights reserved.
//

#import "YZAcceptanceApplicationViewController.h"
#import "YZResourcesInfoDetailTableViewCell.h"
#import "YZChooseChangeTableViewCell.h"
#import "YZChangeTableViewCell.h"
#import "YZChooseView.h"
#import "YZImageCollectionViewCell.h"
#import "ZYQAssetPickerController.h"
#import "IQKeyboardManager.h"
#import "YZDatePicker.h"
#import "YZPhotoBrowserViewController.h"

@interface YZAcceptanceApplicationViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_titleArray;
    NSArray *_showMoreTitleArray;
    
    YZChooseView *_chooseView;
    
    UICollectionView *_collectionView;
    
    //保存图片的URL
    NSMutableArray *_imageURLArray;
    
    YZDatePicker* _datePicker;
    
    NSMutableDictionary *_chooseDict;
    
    //保存字典表ID
    NSMutableDictionary *_idDict;
    
    UIView *_buttonView;
    
    //底部的scrollview
    UIScrollView *_backgroundScrollView;
    CALayer *_backgroundLayer;
    
    
}
@end

@implementation YZAcceptanceApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"验收申请";
    [self loadLocalData];
    [self createBackgroundScrollView];
    [self createTableView];
    [self addNavigationLeftButton];
}

- (void)createBackgroundScrollView
{
    _backgroundScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight)];
    _backgroundLayer = [CALayer layer];
    _backgroundLayer.frame = CGRectMake(10, 10, kScreenWidth - 20, 814);
    _backgroundLayer.backgroundColor = [UIColor whiteColor].CGColor;

    _backgroundLayer.shadowColor = [UIColor blackColor].CGColor;
    _backgroundLayer.shadowOffset = CGSizeMake(1, 1);
    _backgroundLayer.shadowRadius = 3;
    _backgroundLayer.shadowOpacity = .3f;
    [_backgroundScrollView.layer addSublayer:_backgroundLayer];
    _backgroundScrollView.contentSize = CGSizeMake(kScreenWidth, 960);
    [self.view addSubview:_backgroundScrollView];
    
    [self createBottomButtonWithFrame:CGRectMake(0, 830, kScreenWidth, 56)];
}

- (void)loadLocalData
{
    _titleArray = [[NSMutableArray alloc] initWithObjects:@"适用场景类型:",@"工  单  编  号:",@"工  程  名  称:",@"工  程  编  号:",@"工程验收局站:",@"工程验收机房:",@"专              业:",@"发     起     人:",@"所  在  部  门:",@"发起人联系电话:",@"配  合  任  务:",@"工  程  类  别:",@"开始验收时间:",@"完成验收时间:",@"任  务  说  明:",@"", nil];
    _showMoreTitleArray = [[NSArray alloc] initWithObjects:@"工  程  来  源:",@"工 程 管 理 员:",@"工程覆盖范围:",@"施  工  单  位:",@"施  工  队  长:",@"施工队长联系电话:",@"是否FTTH工程:",@"验  收  类  别:",@"难  度  等  级:",@"经  验  耗  时:",@"积              分:",@"需  要  人  数:",@"技  能  要  求:", nil];
    
    _imageArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"upload_btn"], nil];
    _imageURLArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    
    NSArray *dictArray1 = @[@"施工证明审查",@"设备开箱验货",@"施工规范监督",@"工程余料清理",@"安全管理",@"设备线缆标示",@"现场管理"];
    NSArray *dictArray2 = @[@"一次性验收",@"初验",@"终验"];
    NSArray *dictArray3 = @[@"设备",@"管道",@"光缆",@"铜缆",@"分光器",@"设五类线"];
    NSArray *dictArray4 = @[@"共建共享FTTH",@"非共建共享FTTH",@"非FTTH"];
    NSArray *dictArray5 = @[@"常规工程",@"子工程",@"共建共享",@"引入民资"];
    NSArray *dictArray6 = @[@"高",@"中",@"低"];
    _chooseDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:dictArray1,@"10",dictArray3,@"11",dictArray4,@"22",dictArray2,@"23",dictArray5,@"16",dictArray6,@"24", nil];
}

- (void)createBottomButtonWithFrame:(CGRect)frame
{
    _buttonView = [[UIView alloc] initWithFrame:frame];
    [_backgroundScrollView addSubview:_buttonView];
    
    UIButton *applicationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applicationButton.frame = CGRectMake(12, 6, (kScreenWidth - 36)/2, 40);
    applicationButton.backgroundColor = [UIColor colorWithRed:48/255.0 green:107/255.0 blue:180/255.0 alpha:1];
    [applicationButton setTitle:@"申请" forState:UIControlStateNormal];
    [applicationButton addTarget:self action:@selector(applicationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    applicationButton.titleLabel.font = [UIFont systemFontOfSize:20];
    applicationButton.layer.cornerRadius = 4;
    [_buttonView addSubview:applicationButton];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(12 + (kScreenWidth - 36)/2 + 12, 6, (kScreenWidth - 36)/2, 40);
    cancelButton.backgroundColor = [UIColor colorWithRed:48/255.0 green:107/255.0 blue:180/255.0 alpha:1];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
    cancelButton.layer.cornerRadius = 4;
    [_buttonView addSubview:cancelButton];

}

- (void)cancelButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)applicationButtonClicked
{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    
    for (int i = 7; i < 13 ; i++) {
        NSString *obj = [_dataDict objectForKey:[NSString stringWithFormat:@"%d",i]];
        if ([obj isEqualToString:@""] || obj == nil) {
            [self showAlertWithTitle:@"提示" :[NSString  stringWithFormat:@"请输入\"%@\"",_titleArray[i]] :@"OK" :nil];
            return;
        }
    }
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    
    NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
    NSString *accessToken = UGET(U_TOKEN);
    
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/MyTask/WithWork/ApplyProjectCheck.json",ADDR_IP,ADDR_DIR];
    paraDict[@"accessToken"] = accessToken;
    paraDict[@"operationTime"] = opreatinTime;
    paraDict[@"sceneTypeId"] = @"5";
    paraDict[@"taskAppointmentNo"] = [_dataDict objectForKey:@"1"];
    paraDict[@"matchTaskId"] = _idDict[@"10"];
    paraDict[@"projectTypeId"] = _idDict[@"11"];
    paraDict[@"startTime"] = [_dataDict objectForKey:@"12"];
    paraDict[@"endTime"] = [_dataDict objectForKey:@"13"];
    paraDict[@"taskDescript"] =  [_dataDict objectForKey:@"14"];
   
    
    paraDict[@"projectSourceId"] = _idDict[@"16"];
    paraDict[@"projectManager"] = [_dataDict objectForKey:@"17"];
    paraDict[@"projectRange"] = [_dataDict objectForKey:@"18"];
    paraDict[@"constructorDepartment"] = [_dataDict objectForKey:@"19"];
    paraDict[@"constructorCaptain"] = [_dataDict objectForKey:@"20"];
    paraDict[@"captainContactWay"] = [_dataDict objectForKey:@"21"];
    paraDict[@"isFithId"] = _idDict[@"22"];
    paraDict[@"checkTypeId"] = _idDict[@"23"];
    paraDict[@"projectComplexityLevel"] =  _idDict[@"24"];
    
    
    paraDict[@"costTime"] = [_dataDict objectForKey:@"25"];
    paraDict[@"score"] = [_dataDict objectForKey:@"26"];
    paraDict[@"requestPerson"] = [_dataDict objectForKey:@"27"];
    paraDict[@"skillRequire"] = [_dataDict objectForKey:@"28"];
 
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
        if ([result isEqualToString:@"0000000"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"上传验收工单成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alertView.tag = 201;
            [alertView show];
        }else{
            NSLog(@"%@",responseObject);
            [self showAlertWithTitle:@"提示" :[responseObject objectForKey:@"error"] :@"OK" :nil];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"---->>>%@",error);
    }];


}


- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 20, 814) style:UITableViewStylePlain];
//    _tableView.scrollEnabled = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.cornerRadius = 3;
    _tableView.layer.borderColor = COLOR(190, 190, 190).CGColor;
    _tableView.layer.borderWidth = .5f;
    _tableView.tableFooterView = [self createTableViewFootView];
    [_backgroundScrollView addSubview:_tableView];
}

#pragma mark -- tableViewDelegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
      return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.row < 7) {
        YZResourcesInfoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[YZResourcesInfoDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.label_title.frame = CGRectMake(7, 2, 110, 40);
            cell.label_detail.frame = CGRectMake(110, 4, kScreenWidth - 140, 36);
            cell.label_title.textColor = [UIColor blackColor];
        }
        cell.label_title.text = _titleArray[indexPath.row];
        cell.label_detail.text = [_dataDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        return cell;

    }
    
    if (indexPath.row == 14) {
        YZChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textView"];
        if (!cell) {
            cell = [[YZChangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textView"];
            cell.label_title.frame = CGRectMake(7, 2, 110, 40);
            cell.label_title.text = _titleArray[indexPath.row];
            cell.label_title.font = [UIFont boldSystemFontOfSize:15];
//            cell.label_title.textColor = TEXTCOLOR;
            cell.textField_choose.delegate = self;
            cell.textField_choose.frame = CGRectMake(114, 12, kScreenWidth - 141, 80);
        }
        cell.textField_choose.text = [_dataDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        return cell;
    }
    
    if (indexPath.row == 15) {
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
    
    YZChooseChangeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"text"];
    if (!cell) {
        cell = [[YZChooseChangeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"text"];
//        cell.label_title.textColor = TEXTCOLOR;
        cell.label_title.numberOfLines = 0;
        cell.label_title.font = [UIFont boldSystemFontOfSize:15];
        cell.label_title.frame = CGRectMake(7, 2, 110, 36);
        cell.textField_choose.delegate = self;
        [cell.control_choose addTarget:self action:@selector(chooseTextFieldClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.textField_choose.frame = CGRectMake(114, 12, kScreenWidth - 141, 24);
    }
    cell.label_title.text = _titleArray[indexPath.row];

    cell.textField_choose.text = [_dataDict objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    cell.textField_choose.textFieldIndexPath = indexPath;
    cell.control_choose.tag = indexPath.row;
    if (indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 16 || indexPath.row == 22 || indexPath.row == 23 || indexPath.row == 24) {
        cell.textField_choose.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
        cell.imageView_accessory.hidden = NO;
        cell.control_choose.hidden = NO;
    }else{
        if (indexPath.section == 0 && (indexPath.row == 12 || indexPath.row == 13)) {
            cell.control_choose.hidden = NO;
        }else{
            cell.control_choose.hidden = YES;
        }
        cell.textField_choose.backgroundColor =[ UIColor whiteColor];
        cell.imageView_accessory.hidden = YES;
        
    }
    
    return cell;
}

- (void)chooseTextFieldClicked:(UIControl *)control
{
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    YZIndexTextField *textField = (YZIndexTextField *)control.superview;
    NSMutableDictionary *dataDict = _dataDict;
    
    if (textField.textFieldIndexPath.row == 12 || textField.textFieldIndexPath.row == 13) {
        
        if (!_datePicker) {
            _datePicker = [[YZDatePicker alloc] init];
        }
        [self.view addSubview:_datePicker];
        [_datePicker scrollToCurrentTime];
        _datePicker.respBlock  = ^(NSString *dateStr){
            textField.text = dateStr;
            [dataDict setObject:dateStr forKey:[NSString stringWithFormat:@"%d",control.tag]];
        };

        return;
    }
    YZChooseChangeTableViewCell *cell = [_tableView cellForRowAtIndexPath:textField.textFieldIndexPath];
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
        _chooseView = [[YZChooseView alloc] initWithFrame:CGRectMake(0, 0, cell.textField_choose.frame.size.width, 0) tableViewHeight:0];
    }
     _chooseView.frame = CGRectMake(textField.frame.origin.x, cell.frame.origin.y+textField.frame.origin.y, textField.frame.size.width, totalheight);
    CGRect rect = _chooseView.tableView.frame;
    rect.size.height = totalheight;
    _chooseView.tableView.frame = rect;
    _chooseView.selectedIndex = selectedIndex;
    _chooseView.heightArray = heightArray;
    _chooseView.dataArray = array;
    [_tableView addSubview:_chooseView];


    
    _chooseView.alpha = 0.0;
    [UIView animateWithDuration:.1 animations:^{
        _chooseView.alpha = 1.0;
    }];
    
    
    //chooseView选中单元格
    if (_idDict == nil) {
        _idDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    NSMutableDictionary *idDict = _idDict;
    _chooseView.selectedCompletionBlock = ^(NSInteger selectedIndex){
        textField.text = array[selectedIndex];
        [dataDict setObject:textField.text forKey:[NSString stringWithFormat:@"%d",control.tag]];
        [idDict setObject:[NSString stringWithFormat:@"%d",selectedIndex + 1] forKey:[NSString stringWithFormat:@"%d",control.tag]];
    };
}


#pragma mark -- 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 14) {
        return 100;
    }
    return 40;
}


#pragma mark -- collectionView
- (UIView *)createTableViewFootView
{
   
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(75, 64);
    layout.minimumLineSpacing = 18;
    layout.minimumInteritemSpacing  = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, 24, 10, 18);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 20, 112) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[YZImageCollectionViewCell class] forCellWithReuseIdentifier:@"image"];
   
    return _collectionView;
    
}

- (void)showMoreButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _showMoreTitleArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i + 16 inSection:0];
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
    if (alertView.tag == 201) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        return;
    }
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
    
    tableRect.size.height += height;
    scrollSize.height += height;
    layerRect.size.height += height;
    buttonRect.origin.y += height;
    
    _buttonView.frame = buttonRect;
    _tableView.frame = tableRect;
    _backgroundScrollView.contentSize = scrollSize;
    _backgroundLayer.frame = layerRect;
    [UIView commitAnimations];
    
    [_tableView reloadData];
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

#pragma mark -- textField代理
- (void)textFieldDidEndEditing:(YZIndexTextField *)textField
{
    if (_dataDict == nil) {
        _dataDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    [_chooseView removeFromSuperview];
    CGRect rect = _backgroundScrollView.frame;
    rect.size.height += 297;
    _backgroundScrollView.frame = rect;
    
    [_dataDict setObject:textField.text forKey:[NSString stringWithFormat:@"%d",textField.textFieldIndexPath.row]];
}

- (void)textFieldDidBeginEditing:(YZIndexTextField *)textField
{
    CGRect rect = _backgroundScrollView.frame;
    rect.size.height -= 297;

    [UIView animateWithDuration:.25f animations:^{
        _backgroundScrollView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:textField.textFieldIndexPath];
    [_backgroundScrollView scrollRectToVisible:CGRectMake(0, textField.frame.origin.y + _tableView.frame.origin.y + cell.frame.origin.y + 64, textField.frame.size.width, textField.frame.size.height) animated:YES];
   
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect rect = _backgroundScrollView.frame;
    rect.size.height -= 297;
    
    [UIView animateWithDuration:.25f animations:^{
        _backgroundScrollView.frame = rect;
    } completion:^(BOOL finished) {
        
    }];

    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:14 inSection:0]];
     [_backgroundScrollView scrollRectToVisible:CGRectMake(0, textView.frame.origin.y + _tableView.frame.origin.y + cell.frame.origin.y + 64, textView.frame.size.width, textView.frame.size.height) animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [_chooseView removeFromSuperview];
    CGRect rect = _backgroundScrollView.frame;
    rect.size.height += 297;
    _backgroundScrollView.frame = rect;
    
    [_dataDict setObject:textView.text forKey:@"14"];
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
