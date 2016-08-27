//
//  AddTroubleViewController.m
//  telecom
//
//  Created by liuyong on 15/5/18.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "AddTroubleViewController.h"
#import "ZYQAssetPickerController.h"
#import "HWBProgressHUD.h"



@interface AddTroubleViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

{
    UITextView *myTextView;
    NSString *strPath;
    NSURL *imageDataUrl;
    UILabel *placeholderLabel;
    UIImageView *addImgView;
    UIImageView *photoImgView;
    NSString *backTypeStr;//反馈类型
    NSString *backtextStr;//反馈内容
    NSString *backType;//反馈类型（一般 重大）
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    UITableView *myTableView;
    UIView *view;

}

@end

@implementation AddTroubleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    DLog(@"%@",self.callBackInfoDict);
    self.title = @"新增隐患";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpRightBarButton];
    
    imgArr = [[NSMutableArray alloc]initWithCapacity:10];
    imageDataUrlArr = [[NSMutableArray alloc]initWithCapacity:10];
    [self setUpUI];
    [self initView];
}

-(void)initView
{
    UIView *headView = [self tableHeadView];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 334, kScreenWidth, kScreenHeight-74) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableHeaderView = headView;
    myTableView.scrollEnabled = NO;
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
}

#pragma mark ==  UITableView
-(UIView *)tableHeadView
{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIImage *img4 = [UIImage imageNamed:@"upload_btn"];
    UIImage *addImg = [UIImage imageNamed:@"addImage"];
    UIImage *deleteImg = [UIImage imageNamed:@"delete-circular"];//
    
    
    for (int i = 0; i < imgArr.count+1; i++) {
        
        photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*(img4.size.width/2+16), 10, img4.size.width/2, img4.size.height/2)];
        if (imgArr.count == 0) {
            photoImgView.image = addImg;
        }else if (i == imgArr.count) {
        }
        else{
            photoImgView.image = [imgArr objectAtIndex:i];
        }
        
        photoImgView.userInteractionEnabled = YES;
        [view addSubview:photoImgView];
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setBackgroundImage:deleteImg forState:UIControlStateNormal];
        [deleteBtn setFrame:CGRectMake(6+i*(img4.size.width/2+16), 0, deleteImg.size.width/2, deleteImg.size.height/2)];
        deleteBtn.tag = 100+i;
        deleteBtn.hidden = YES;
        [deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:deleteBtn];
        
        if (i == 3) {
            [photoImgView setFrame:CGRectMake(10, 10+img4.size.width/2, img4.size.width/2, img4.size.height/2)];
            [deleteBtn setFrame:CGRectMake(6, 0+img4.size.width/2, deleteImg.size.width/2, deleteImg.size.height/2)];
        }
        
        
        UIButton *upImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [upImgBtn setFrame:CGRectMake(0, 0, img4.size.width/2, img4.size.height/2)];
        [upImgBtn setBackgroundImage:img4 forState:UIControlStateNormal];
        [upImgBtn addTarget:self action:@selector(upImgBtn) forControlEvents:UIControlEventTouchUpInside];
        [photoImgView addSubview:upImgBtn];
        
        if (imgArr.count == 4) {
            photoImgView.hidden = NO;
            upImgBtn.hidden = YES;
            deleteBtn.hidden = NO;
        }else{
            if (i == imgArr.count) {
                //                photoImgView.hidden = YES;
                upImgBtn.hidden = NO;
                deleteBtn.hidden = YES;
            }else{
                upImgBtn.hidden = YES;
                deleteBtn.hidden = NO;
                photoImgView.hidden = NO;
                
            }
        }
        
    }
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}


- (void)setUpUI
{
        NSArray *classAr = @[@"隐患分类:",@"隐患等级:",@"部       门:",@"专       业:",@"隐患部位:"];
    for (int i =0; i<classAr.count; i++) {
        UILabel *yhClassLable = [UnityLHClass initUILabel:classAr[i] font:13.0 color:[UIColor blackColor] rect:CGRectMake(10, 84+i*26, 70, 20)];
        [self.view addSubview:yhClassLable];
    }
    DLog(@"%@",self.callBackInfoDict);
    NSMutableArray *labelArr = [NSMutableArray array];
    [labelArr addObject:self.callBackInfoDict[@"regionName"]];
    [labelArr addObject:self.callBackInfoDict[@"specName"]];
    [labelArr addObject:self.callBackInfoDict[@"dangerPosition"]];
    for (int i = 0; i<labelArr.count; i++) {
        UILabel *yhClassLable = [UnityLHClass initUILabel:labelArr[i] font:13.0 color:[UIColor blackColor] rect:CGRectMake(80, 136+i*26, 170, 20)];
        yhClassLable.tag = 300+i;
        [self.view addSubview:yhClassLable];
    }
    NSArray *classArr = @[@"设备",@"安全/环境"];
    for (int i = 0; i < classArr.count; i++) {
        UIButton *classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [classBtn setFrame:CGRectMake(80+i*70, 84, 60, 20)];
        classBtn.layer.borderWidth = 1;
        classBtn.layer.borderColor = [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0] CGColor];
        [classBtn setTitle:[classArr objectAtIndex:i] forState:UIControlStateNormal];
        classBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        [classBtn setBackgroundColor:[UIColor whiteColor]];
        [classBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        classBtn.tag = 100+i;
        [classBtn addTarget:self action:@selector(classBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:classBtn];
        
        

    }
    backType = @"0";
    NSArray *classArr1 = @[@"重大",@"一般"];
    for (int i = 0; i < classArr1.count; i++) {
        UIButton *classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [classBtn setFrame:CGRectMake(80+i*70, 110, 60, 20)];
        classBtn.layer.borderWidth = 1;
        classBtn.layer.borderColor = [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0] CGColor];
        [classBtn setTitle:[classArr1 objectAtIndex:i] forState:UIControlStateNormal];
        classBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
        
        if (i==0) {
            [classBtn setBackgroundColor:[UIColor whiteColor]];
        }else{
            [classBtn setBackgroundColor:[UIColor greenColor]];
        }
        
        [classBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        classBtn.tag = 200+i;
        [classBtn addTarget:self action:@selector(BtnClass:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:classBtn];
        
    }
    
    
    UILabel *yhContentLable = [UnityLHClass initUILabel:@"隐患现象:" font:13.0 color:[UIColor blackColor] rect:CGRectMake(10, 214, 70, 20)];
    [self.view addSubview:yhContentLable];
   
    myTextView = [[UITextView alloc] initWithFrame:RECT(80, 214, APP_W-96, 70)];
    myTextView.layer.borderWidth = 1;
    myTextView.layer.borderColor = [[UIColor colorWithRed:232.0/255.0 green:232.0/255.0 blue:232.0/255.0 alpha:1.0] CGColor];
    myTextView.font = [UIFont systemFontOfSize:13.0];
    myTextView.delegate = self;
    [self.view addSubview:myTextView];
    
    placeholderLabel = [UnityLHClass initUILabel:@"请输入内容..." font:10.0 color:[UIColor grayColor] rect:CGRectMake(5, 5, 100, 15)];
    [myTextView addSubview:placeholderLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 294, kScreenWidth-20, 20)];
    lineView.backgroundColor = RGBCOLOR(16, 219, 232);
    [self.view addSubview:lineView];

    UILabel *yhInfoLable = [UnityLHClass initUILabel:@"附件信息" font:13.0 color:[UIColor whiteColor] rect:CGRectMake(10, 0, 70, 20)];
    yhInfoLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [lineView addSubview:yhInfoLable];


}

#pragma mark - 右侧按钮
- (void)setUpRightBarButton
{
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.rightBtn.frame = CGRectMake(APP_W-40, 7, 30, 30);
    [self.rightBtn setBackgroundImage:[UIImage imageNamed:@"123.png"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(addTroubleInfoAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
}

-(void)addTroubleInfoAction
{
    [myTextView resignFirstResponder];
    if (backTypeStr == nil || [backTypeStr isEqualToString:@""]) {
        showAlert(@"请选择隐患分类");
    }else if (backtextStr == nil || [backtextStr isEqualToString:@""]){
        showAlert(@"请输入内容");
    }else{
        
        NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        NSString *strTaskID = self.subTaskId;

        
        NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/MyTask/submitFualtRisk.json?operationTime=%@&accessToken=%@&subTaskId=%@&category=%@&falutLevel=%@&regionId=%@&content=%@",ADDR_IP,ADDR_DIR,opreatinTime,accessToken,strTaskID,backTypeStr,backType,self.callBackInfoDict[@"regionId"],backtextStr];
        
        NSLog(@"uid == %@",requestUrl);
        
        
        
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"uid == %@",requestUrl);
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:strTaskID forKey:@"subTaskId"];
        [dic setObject:backTypeStr forKey:@"category"];
        [dic setObject:backtextStr forKey:@"content"];
        [dic setObject:backType forKey:@"falutLevel"];
        [dic setObject:self.callBackInfoDict[@"regionId"] forKey:@"regionId"];
        DLog(@"%@",dic);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager POST:requestUrl parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            for (int i = 0; i < imageDataUrlArr.count; i++) {
                
                
                if (imageDataUrlArr.count == 0) {
                    
                }else{
                    NSURL *imgUrl = [imageDataUrlArr objectAtIndex:i];
                    [formData appendPartWithFileURL:imgUrl name:[NSString stringWithFormat:@"image%d",i] error:nil];
                }
                
                
            }
            
            
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"Success: %@", responseObject);
            if ([[responseObject objectForKey:@"result"]isEqualToString:@"0000000"]) {
                HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
                //弹出框的类型
                hud.mode = HWBProgressHUDModeText;
                //弹出框上的文字
                hud.detailsLabelText = @"提交成功";
                //弹出框的动画效果及时间
                [hud showAnimated:YES whileExecutingBlock:^{
                    //执行请求，完成
                    sleep(1);
                } completionBlock:^{
                    //完成后如何操作，让弹出框消失掉
                    [hud removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else{
                HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
                //弹出框的类型
                hud.mode = HWBProgressHUDModeText;
                //弹出框上的文字
                hud.detailsLabelText = @"提交失败";
                //弹出框的动画效果及时间
                [hud showAnimated:YES whileExecutingBlock:^{
                    //执行请求，完成
                    sleep(1);
                } completionBlock:^{
                    //完成后如何操作，让弹出框消失掉
                    [hud removeFromSuperview];
                }];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"Error: %@", error);
        }];
    }
}
-(void)BtnClass:(UIButton *)sender{
    UIButton *btn  = (UIButton *)[self.view viewWithTag:200];
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:201];
    
    if (sender.tag == 200) {
        [btn setBackgroundColor:[UIColor greenColor]];
        [btn1 setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        backType = @"1";
    }else{
        [btn1 setBackgroundColor:[UIColor greenColor]];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        backType = @"0";
    }
}
-(void)classBtn:(UIButton *)sender
{
    UIButton *btn  = (UIButton *)[self.view viewWithTag:100];
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:101];
    
    if (sender.tag == 100) {
        [btn setBackgroundColor:[UIColor greenColor]];
        [btn1 setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        backTypeStr = @"1";
        
    }else if (sender.tag == 101){
        
        [btn1 setBackgroundColor:[UIColor greenColor]];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        backTypeStr = @"2";
        
    }

}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{    if (![text isEqualToString:@""])
    
{
    
    placeholderLabel.hidden = YES;
    
}
    
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1)
        
    {
        
        placeholderLabel.hidden = NO;
        
    }
    
    return YES;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    backtextStr = textView.text;
}

- (void)upImgBtn
{
    [myTextView resignFirstResponder];
    UIActionSheet *chooseImageSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选取", nil];
    [chooseImageSheet showInView:self.view];
    
    
    
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
    picker.maximumNumberOfSelection = 4-imgArr.count;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 4-imgArr.count;
        } else {
            return YES;
        }
        
    }];
    
    [self presentViewController:picker animated:NO completion:NULL];
}

#pragma mark - ZYQAssetPickerController Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    
    NSLog(@"%@",assets.description);
    
    for (int i=0; i<assets.count; i++) {
        
        ALAsset *asset = assets[i];
        
        UIImage *tempImg = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone systemTimeZone]];
            [formatter setDateFormat:@"yyyy-MM-dd-hh:mm:ss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *imageName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
            [self saveImage:tempImg WithName:imageName];
            
            
        });
    }
    
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
        [self presentModalViewController:picker animated:NO];
    }else {
       showAlert(@"该设备无摄像头");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 创建imdge 接收图片
    UIImage* image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    image = [UIImage imageWithData:imageData];
    UIImage *imageInfo = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage* imageResult = [self imageWithImageSimple:image scaledToSize:CGSizeMake(imageInfo.size.width, 320)];
    addImgView.hidden = NO;
    addImgView.image = image;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone systemTimeZone]];
    [formatter setDateFormat:@"yyyy-MM-dd-hh:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSString *imageName = [NSString stringWithFormat:@"%@.png",dateString];
    [self saveImage:imageResult WithName:imageName];
    
    // 关闭picker
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}
#pragma mark -保存图片的路径
- (void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    NSLog(@"%@",imageName);
    NSData *imageData = UIImageJPEGRepresentation(tempImage, 0.1);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    NSURL *url = [NSURL fileURLWithPath:fullPathToFile];
    imageDataUrl = url;
    strPath = fullPathToFile;
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    [imgArr addObject:tempImage];
    [imageDataUrlArr addObject:imageDataUrl];
    
    
    UIView *headView = [self tableHeadView];
    myTableView.tableHeaderView = headView;
    [myTableView reloadData];
    
}

-(void)deleteBtn:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    [imgArr removeObjectAtIndex:sender.tag-100];
    [imageDataUrlArr removeObjectAtIndex:sender.tag-100];
    UIView *headView = [self tableHeadView];
    myTableView.tableHeaderView = headView;
    [myTableView reloadData];
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    [_inputShareInfo release];
//    [_attachmentInfo release];
//    [super dealloc];
//}
@end

