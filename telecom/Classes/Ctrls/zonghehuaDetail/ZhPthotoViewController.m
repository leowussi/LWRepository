//
//  ZhPthotoViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/9/25.
//  Copyright © 2015年 ZhongYun. All rights reserved.
//

#import "ZhPthotoViewController.h"
#import "ZYQAssetPickerController.h"
#import "HWBProgressHUD.h"

@interface ZhPthotoViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>

{
    UITableView *myTableView;
    UIImageView *photoImgView;
    UIImageView *addPhotoImgView;
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    NSURL *imageDataUrl;
    UIButton *deleteImgBtn;
    float addY;
}
@end

@implementation ZhPthotoViewController
@synthesize photoArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addNavigationLeftButton];
    [self addNavigationRightButton:@"123.png"];
    
    self.title = @"附件信息";
    
    imgArr = [[NSMutableArray alloc]initWithCapacity:10];
    imageDataUrlArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    [self initView];
}

-(void)initView
{
    UIView *footView = [self tableFootView];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableFooterView = footView;
    [self.view addSubview:myTableView];
}


#pragma mark == 表尾
-(UIView *)tableFootView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 800)];
    footView.backgroundColor = [UIColor whiteColor];
    
    UILabel *fujianLable = [UnityLHClass initUILabel:@"附件:" font:13.0 color:[UIColor blackColor] rect:CGRectMake(10, 10, 80, 20)];
    [footView addSubview:fujianLable];
    
    UIImage *img4 = [UIImage imageNamed:@"upload_btn"];
    UIImage *addImg = [UIImage imageNamed:@"addImage"];
    UIImage *deleteImg = [UIImage imageNamed:@"delete-circular"];//
    
    
    
    for (int i = 0; i < photoArr.count; i++) {
        
        NSUInteger row = i/4;
        NSUInteger col = i%4;
        NSUInteger distance = kScreenWidth/4;
        NSUInteger size = distance/1.3;
        NSUInteger margin = size/5;
        
        photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance+50, img4.size.width/2.2, img4.size.width/2.2)];
        photoImgView.userInteractionEnabled = YES;
        
        
        
        if (photoArr.count == 0) {
            
            
        }else{
            
            [photoImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/attachment/zqUploadFile/%@/",ADDR_IP,ADDR_DIR,[[photoArr objectAtIndex:i] objectForKey:@"fileId"]]] placeholderImage:[UIImage imageNamed:@"等待图片.png"]];
            
        }
        
        
        [footView addSubview:photoImgView];
        
        deleteImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [deleteImgBtn setBackgroundImage:deleteImg forState:UIControlStateNormal];
        [deleteImgBtn setFrame:CGRectMake(0,0, img4.size.width/2.2, img4.size.width/2.2)];
        deleteImgBtn.tag = 100+i;
        [deleteImgBtn setBackgroundColor:[UIColor clearColor]];
//        deleteImgBtn.hidden = YES;
        [deleteImgBtn addTarget:self action:@selector(deleteImgBtn:) forControlEvents:UIControlEventTouchUpInside];
        [photoImgView addSubview:deleteImgBtn];
        
        
        
        
        addY = row*distance+40+size;
        
        
        
        
    }
    
    
    for (int i = 0; i < imgArr.count+1; i++) {
            
        NSUInteger row = i/4;
        NSUInteger col = i%4;
        NSUInteger distance = kScreenWidth/4;
        NSUInteger size = distance/1.3;
        NSUInteger margin = size/5;
        
        addPhotoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance+30+addY, img4.size.width/2.2, img4.size.height/2.2)];
        addPhotoImgView.userInteractionEnabled = YES;
        [footView addSubview:addPhotoImgView];
        
        if (i == imgArr.count) {
            
            UIButton *upImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [upImgBtn setFrame:CGRectMake(0, 0, img4.size.width/2, img4.size.height/2)];
            [upImgBtn setBackgroundImage:img4 forState:UIControlStateNormal];
            [upImgBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
            [addPhotoImgView addSubview:upImgBtn];
            
        }else{
            addPhotoImgView.image = [imgArr objectAtIndex:i];
        }
        
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setBackgroundImage:deleteImg forState:UIControlStateNormal];
        [deleteBtn setFrame:CGRectMake(6+i*(img4.size.width/2.2+15), row*distance+17+addY, deleteImg.size.width/2, deleteImg.size.height/2)];
        deleteBtn.tag = 100+i;
        deleteBtn.hidden = YES;
        [deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:deleteBtn];
        
        if (i == 4) {
            [addPhotoImgView setFrame:CGRectMake(10, row*distance+20+addY, img4.size.width/2, img4.size.height/2)];
//            [deleteBtn setFrame:CGRectMake(6, row*distance+7+addY, deleteImg.size.width/2, deleteImg.size.height/2)];
        }
        
        
        
        
        UIButton *upImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [upImgBtn setFrame:CGRectMake(0, 0, img4.size.width/2, img4.size.height/2)];
        [upImgBtn setBackgroundImage:img4 forState:UIControlStateNormal];
        [upImgBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
        [addPhotoImgView addSubview:upImgBtn];
        
        if (imgArr.count == 4) {
            addPhotoImgView.hidden = NO;
            upImgBtn.hidden = YES;
            deleteBtn.hidden = NO;
        }else{
            if (i == imgArr.count) {
                upImgBtn.hidden = NO;
                deleteBtn.hidden = YES;
            }else{
                upImgBtn.hidden = YES;
                deleteBtn.hidden = NO;
                addPhotoImgView.hidden = NO;
                
            }
        }
        
    }
    
    return footView;
}


#pragma mark == 删除图片

-(void)deleteImgBtn:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"photoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}

-(void)addPhoto
{
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
        NSLog(@"该设备无摄像头");
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
    
    [imageData writeToFile:fullPathToFile atomically:NO];
    
    [imgArr addObject:tempImage];
    [imageDataUrlArr addObject:imageDataUrl];
    
    
    UIView *headView = [self tableFootView];
    myTableView.tableHeaderView = headView;
    [myTableView reloadData];
    
}

-(void)deleteBtn:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    [imgArr removeObjectAtIndex:sender.tag-100];
    [imageDataUrlArr removeObjectAtIndex:sender.tag-100];
    UIView *headView = [self tableFootView];
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


#pragma mark == 右上方按钮
-(void)rightAction
{
    if (imageDataUrlArr.count == 0) {
        
    }else{
     
        NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/MyTask/UploadCycleTotalizationFile.json?operationTime=%@&accessToken=%@",ADDR_IP,ADDR_DIR,opreatinTime,accessToken];
        
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSLog(@"uid == %@",requestUrl);
        
//
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.strTaskID forKey:@"taskId"];
    
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
                hud.detailsLabelText = @"上传成功";
                //弹出框的动画效果及时间
                [hud showAnimated:YES whileExecutingBlock:^{
                    //执行请求，完成
                    sleep(1);
                } completionBlock:^{
                    //完成后如何操作，让弹出框消失掉
                    [hud removeFromSuperview];
                    
                    [self.delegate screenVC:self.strTaskID indexPath:self.indexPath];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            }else{
                HWBProgressHUD *hud = [HWBProgressHUD showHUDAddedTo:self.view animated:YES];
                //弹出框的类型
                hud.mode = HWBProgressHUDModeText;
                //弹出框上的文字
                hud.detailsLabelText = @"上传失败";
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

@end
