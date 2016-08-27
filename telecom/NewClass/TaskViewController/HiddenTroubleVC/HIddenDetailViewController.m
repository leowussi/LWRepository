//
//  HIddenDetailViewController.m
//  telecom
//
//  Created by 郝威斌 on 15/8/19.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "HIddenDetailViewController.h"
#import "DetailTableViewCell.h"
#import "InfoTableViewCell.h"
#import "ZYQAssetPickerController.h"
#import "HWBProgressHUD.h"
#import "HiddenEditViewController.h"
#import "FrameModel.h"

@interface HIddenDetailViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *classView;
    UIView *backView;
    UITableView *myTableView;  //详细信息
    UITableView *myTableView1; //流水信息
    NSString *strPath;
    NSURL *imageDataUrl;
    NSMutableArray *photoArr;
    NSMutableArray *imgArr;
    NSMutableArray *imageDataUrlArr;
    UIImageView *photoImgView;
    UIImageView *addPhotoImgView;
    UIImageView *addImgView;
    NSArray *leftDetailArr;
    NSMutableDictionary *detailArr;
    NSMutableArray *infoArr;
    NSInteger imgNum;
    NSString *biaoshiStr;
    float addY ;
}
@end

@implementation HIddenDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self hiddenBottomBar:YES];
}

- (void)popBtn:(NSInteger)index
{
    NSLog(@"%d",index);
    [self updateTable];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"隐患详细";
    [self addNavigationLeftButton];
    [_baseScrollView setBackgroundColor:RGBCOLOR(235, 238, 243)];
    
    imgArr = [[NSMutableArray alloc]initWithCapacity:10];
    imageDataUrlArr = [[NSMutableArray alloc]initWithCapacity:10];
    
    detailArr = [self.dic objectForKey:@"detail"];
    infoArr = [[self.dic objectForKey:@"detail"] objectForKey:@"recordList"];
    
    photoArr = [[self.dic objectForKey:@"detail"] objectForKey:@"fileList"];
    
    biaoshiStr = [[self.dic objectForKey:@"detail"] objectForKey:@"dangerStatusCode"];
    
    if ([biaoshiStr isEqualToString:@"1"] || [biaoshiStr isEqualToString:@"2"]){
        
        [self addNavigationRightButton:@"3_1.png"];
        
    }else{
        
    }
    /**
删除右边按钮   隐患详细页面不要编辑选项
     
    

     */
//    if ([self.Vctag isEqualToString:@"1"]){
//        
//        [self addNavigationRightButton:@"3_1.png"];
//        
//    }else{
//        
//    }
    
    [self initView];
}


-(void)initView
{
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
    backView.backgroundColor = [UIColor clearColor];
    backView.hidden = YES;
    [self.view addSubview:backView];
    
    classView = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth-70, 64, 70, 100)];
    classView.backgroundColor = RGBCOLOR(245, 245, 245);
    classView.hidden = YES;
    [self.view addSubview:classView];
    
    //        若状态为“正在解决”，可上传附件（拍照、语音等）和“上传”按钮，其他状态不显示上传附件和“上传”按钮。
    //        1表示待解决、2表示解决中、3表示已解决、4表示已关闭
    if ([biaoshiStr isEqualToString:@"1"]) {
        
        
        [classView setFrame:CGRectMake(kScreenWidth-70, 64, 70, 100-25)];
        
        NSArray *classArr = @[@"编辑",@"撤销"];
        
        for (int i = 0; i < classArr.count; i++) {
            UIButton* classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [classBtn setFrame:CGRectMake(0, 29*i+10, 70, 20)];
            [classBtn setTitle:[classArr objectAtIndex:i] forState:UIControlStateNormal];
            [classBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            classBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            classBtn.tag = 100+i;
            [classBtn addTarget:self action:@selector(classBtn:) forControlEvents:UIControlEventTouchUpInside];
            [classView addSubview:classBtn];
        }

    }else if ([biaoshiStr isEqualToString:@"2"]){//2表示解决中
        
        
        [classView setFrame:CGRectMake(kScreenWidth-70, 64, 70, 100-50)];
        
        NSArray *classArr = @[@"整改隐患"];
        
        for (int i = 0; i < classArr.count; i++) {
            UIButton* classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [classBtn setFrame:CGRectMake(0, 29*i+10, 70, 20)];
            [classBtn setTitle:[classArr objectAtIndex:i] forState:UIControlStateNormal];
            [classBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            classBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
            classBtn.tag = 100+i;
            [classBtn addTarget:self action:@selector(classBtn:) forControlEvents:UIControlEventTouchUpInside];
            [classView addSubview:classBtn];
        }

    }else if ([biaoshiStr isEqualToString:@"3"]){//3表示已解决
        
        
        
    }else if ([biaoshiStr isEqualToString:@"4"]){//4表示已关闭
        
        
    }else if ([biaoshiStr isEqualToString:@"5"]){//4表示已解决待确认
        
        
    }
    
    
        
    
        
    
    
    NSArray* array1  = [NSArray arrayWithObjects:@"详细信息",@"流水信息", nil];
    
    for (int i = 0; i<array1.count; i++) {
        
        UIButton* butt = [UIButton buttonWithType:UIButtonTypeCustom];
        [butt setFrame:CGRectMake(70*i+10, 15, 90, 30)];
        [butt setTag:10+i];
        [butt setTitle:[array1 objectAtIndex:i] forState:UIControlStateNormal];
        
        [butt setTitleColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        butt.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [butt setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
        [butt addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_baseScrollView addSubview:butt];
        
        
        if (i == 0) {
            [butt setBackgroundImage:[UIImage imageNamed:@"tab_bg_white"] forState:UIControlStateNormal];
            
            
        }
        
        if (i == 1) {
            [butt setFrame:CGRectMake(100, 15, 90, 30)];
            [butt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
    }
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 45, kScreenWidth-20, kScreenHeight+1000)];
    bgView.backgroundColor = [UIColor whiteColor];
    [_baseScrollView addSubview:bgView];
    _baseScrollView.scrollEnabled = NO;
    
//    leftDetailArr = @[@"隐患编号",@"隐患分类",@"网元/对象",@"当前状态",@"提交时间",@"隐患内容"];
    UIView *footView = [self tableFootView];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight+64) style:UITableViewStylePlain];
    myTableView.dataSource = self;
    myTableView.delegate = self;
    myTableView.tableFooterView = footView;
    myTableView.showsVerticalScrollIndicator = NO;

    [bgView addSubview:myTableView];
    
    myTableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-20, kScreenHeight-115) style:UITableViewStylePlain];
    myTableView1.dataSource = self;
    myTableView1.delegate = self;
    myTableView1.hidden = YES;
    [self setExtraCellLineHidden:myTableView1];
    [bgView addSubview:myTableView1];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


#pragma mark == 右上方按钮
-(void)rightAction
{
//    1表示待解决、2表示解决中、3表示已解决、4表示已关闭
    
    if ([biaoshiStr isEqualToString:@"1"]){//表示待解决
        
        backView.hidden = NO;
        classView.hidden = NO;
        
    }else if ([biaoshiStr isEqualToString:@"2"]){//表示解决中
        
        backView.hidden = NO;
        classView.hidden = NO;
        
    }else if ([biaoshiStr isEqualToString:@"3"]){//表示已解决
        
        backView.hidden = YES;
        classView.hidden = YES;
        
    }else if ([biaoshiStr isEqualToString:@"4"]){//已关闭
        
        backView.hidden = YES;
        classView.hidden = YES;
        
    }else if ([biaoshiStr isEqualToString:@"5"]){//已解决待确认
        
//        backView.hidden = YES;
//        classView.hidden = NO;
        
    }
   
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    classView.hidden = YES;
    backView.hidden = YES;
}

#pragma mark == 右上方按钮菜单
-(void)classBtn:(UIButton *)sender
{
    classView.hidden = YES;
    backView.hidden = YES;
    NSLog(@"%@",sender.titleLabel.text);
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {

        HiddenEditViewController *hiddenVC = [[HiddenEditViewController alloc]init];
        hiddenVC.dic = detailArr;
        hiddenVC.strDangerId = self.strDangerId;
        hiddenVC.delegate = self;
        [self.navigationController pushViewController:hiddenVC animated:YES];
        
    }else if ([sender.titleLabel.text isEqualToString:@"撤销"]) {
        
        [self getData:@"2"];
        
    }else if ([sender.titleLabel.text isEqualToString:@"整改隐患"]) {
        
        [self getData:@"3"];
        
    }
}


-(void)getData:(NSString *)strType
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"MyTask/DisposeDangerOperate";
    paraDict[@"dangerId"] = self.strDangerId;
    paraDict[@"actionStatus"] = strType;//1表示编辑、2表示撤销、3整改隐患
    
    if ([strType isEqualToString:@"1"]) {
        
        paraDict[@"dangerCatetory"] = [[detailArr objectForKey:@"dangerCategoryCode"] description];
        paraDict[@"dangerContent"] = [[detailArr objectForKey:@"dangerContent"] description];
    }
    
    
    
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
        }
        
    }, ^(id result) {
        
    });
}


#pragma mark == 分类块
-(void)clickBtn:(UIButton *)sender
{
    UIButton *btn = (UIButton *)[_baseScrollView viewWithTag:10];
    UIButton *btn1 = (UIButton *)[_baseScrollView viewWithTag:11];
    if (sender.tag == 10) {
        
        [btn setBackgroundImage:[UIImage imageNamed:@"tab_bg_white"] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        myTableView.hidden = NO;
        myTableView1.hidden = YES;
        [myTableView reloadData];
        
    }else{
        
        [btn setBackgroundImage:[UIImage imageNamed:@"tab_bg"] forState:UIControlStateNormal];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"tab_bg_white"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn1 setTitleColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        myTableView.hidden = YES;
        myTableView1.hidden = NO;
        [myTableView1 reloadData];
    }
}



#pragma mark == 表尾
-(UIView *)tableFootView
{
    UIView *footView = [[UIView alloc]init];
    footView.backgroundColor = [UIColor whiteColor];
    
    UILabel *fujianLable = [UnityLHClass initUILabel:@"附件信息:" font:13.0 color:[UIColor blackColor] rect:CGRectMake(10, 5, 80, 20)];
    
      footView.frame =CGRectMake(0, 0, kScreenWidth, 364);
    [footView addSubview:fujianLable];
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [upBtn setFrame:CGRectMake(90, 5, 60, 20)];
    [upBtn setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:158.0/255.0 blue:234.0/255.0 alpha:1.0]];
    [upBtn setTitle:@"上传" forState:UIControlStateNormal];
    [upBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    upBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    [upBtn addTarget:self action:@selector(upBtn) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:upBtn];
    
//    1表示待解决、2表示解决中、3表示已解决、4表示已关闭
    
    if ([biaoshiStr isEqualToString:@"1"] || [biaoshiStr isEqualToString:@"3"] || [biaoshiStr isEqualToString:@"4"]|| [biaoshiStr isEqualToString:@"5"]) {
        
        upBtn.hidden = YES;
    }else{
        upBtn.hidden = NO;
    }
    
    UIImage *img4 = [UIImage imageNamed:@"upload_btn"];
    UIImage *addImg = [UIImage imageNamed:@"addImage"];
    UIImage *deleteImg = [UIImage imageNamed:@"delete-circular"];//
    
    
    
    for (int i = 0; i < photoArr.count; i++) {
        
        NSUInteger row = i/3;
        NSUInteger col = i%3;
        NSUInteger distance = (kScreenWidth-20)/3;
        NSUInteger size = distance/1.3;
        NSUInteger margin = size/5;
        
        photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance+40, img4.size.width/2, img4.size.width/2)];
        photoImgView.userInteractionEnabled = YES;
        
        if (photoArr.count == 0) {
            
//            photoImgView.image = addImg;
            
        }else{
            
            [photoImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@/attachment/kbFaultFile/%@/",ADDR_IP,ADDR_DIR,[[photoArr objectAtIndex:i] objectForKey:@"fileId"]]]];
            
        }
        
        
        [footView addSubview:photoImgView];
        
       
        addY = row*distance+40+size;
        
        


    }
    
    if ([biaoshiStr isEqualToString:@"1"]  || [biaoshiStr isEqualToString:@"3"] || [biaoshiStr isEqualToString:@"4"]|| [biaoshiStr isEqualToString:@"5"]) {
        upBtn.hidden=YES;
//        若状态为“正在解决”，可上传附件（拍照、语音等）和“上传”按钮，其他状态不显示上传附件和“上传”按钮。
//        1表示待解决、2表示解决中、3表示已解决、4表示已关闭
        
    }else{
        
        
        for (int i = 0; i < imgArr.count+1; i++) {
            
            NSUInteger row = i/3;
            NSUInteger col = i%3;
            NSUInteger distance = (kScreenWidth-20)/3;
            NSUInteger size = img4.size.width/2;
            NSUInteger margin = size/5;
            
            addPhotoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(col*distance+margin, row*distance+40+addY, img4.size.width/2, img4.size.height/2)];
            addPhotoImgView.userInteractionEnabled = YES;
            [footView addSubview:addPhotoImgView];
            
            if (i == imgArr.count) {
                
                UIButton *upImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [upImgBtn setFrame:CGRectMake(0, 0, img4.size.width/2, img4.size.height/2)];
                [upImgBtn setBackgroundImage:img4 forState:UIControlStateNormal];
                [upImgBtn addTarget:self action:@selector(upImgBtn) forControlEvents:UIControlEventTouchUpInside];
                [addPhotoImgView addSubview:upImgBtn];
                
            }else{
                addPhotoImgView.image = [imgArr objectAtIndex:i];
            }
            
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setBackgroundImage:deleteImg forState:UIControlStateNormal];
            [deleteBtn setFrame:CGRectMake(6+i*(img4.size.width/2+26), row*distance+38+addY, deleteImg.size.width/2, deleteImg.size.height/2)];
            deleteBtn.tag = 100+i;
            deleteBtn.hidden = YES;
            [deleteBtn addTarget:self action:@selector(deleteBtn:) forControlEvents:UIControlEventTouchUpInside];
            [footView addSubview:deleteBtn];
            
            if (i == 3) {
                [addPhotoImgView setFrame:CGRectMake(10, row*distance+40+addY, img4.size.width/2, img4.size.height/2)];
                [deleteBtn setFrame:CGRectMake(6, row*distance+38+addY, deleteImg.size.width/2, deleteImg.size.height/2)];
            }
            
            
            
            
            UIButton *upImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [upImgBtn setFrame:CGRectMake(0, 0, img4.size.width/2, img4.size.height/2)];
            [upImgBtn setBackgroundImage:img4 forState:UIControlStateNormal];
            [upImgBtn addTarget:self action:@selector(upImgBtn) forControlEvents:UIControlEventTouchUpInside];
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
    }
//    footView.frame =CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(photoImgView.frame )+64);
    DLog(@"%@",footView.frame);
    return footView;
}


#pragma mark == UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == myTableView) {
        return 1;
    }else{
        return infoArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == myTableView) {
        
        static NSString *detailCell = @"detailCell";
        DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCell];
        if (!cell) {
            cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:detailCell];
        }

        cell.dic = detailArr;
        return cell;
        
    }else{
        
        static NSString *infoCell = @"infoCell";
        InfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCell];
        if (!cell) {
            cell = [[InfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoCell];
        }
        
        cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@",[[infoArr objectAtIndex:indexPath.row] objectForKey:@"executeStatusName"],[[infoArr objectAtIndex:indexPath.row] objectForKey:@"userName"]];
        
        cell.contentLabel.text = [[infoArr objectAtIndex:indexPath.row] objectForKey:@"dealContent"];
        
        cell.dateLabel.text = [[infoArr objectAtIndex:indexPath.row] objectForKey:@"dealTime"];
        
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:myTableView1]) {
        return 60;
    }
    if ([tableView isEqual:myTableView]) {
        FrameModel *model = [[FrameModel alloc]init];
        model.dic =detailArr;
        return model.hight;
    }else{
        return 60;
    }
}



- (void)upImgBtn
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
            [imageDataUrlArr removeAllObjects];
            [imgArr removeAllObjects];
            [self takePhoto];
        }
            break;
        case 1://本地相册
        {
            [imageDataUrlArr removeAllObjects];
            [imgArr removeAllObjects];
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




#pragma mark == 从相册选择
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
    
    NSLog(@"==%@",assets.description);
    
    for (int i=0; i<assets.count; i++) {
        
        ALAsset *asset = assets[i];
        imgNum = assets.count;
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


#pragma mark == 拍照
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
    NSLog(@"imageDataUrlArr == %@",imageDataUrlArr);
    NSLog(@"imgArr == %@",imgArr);
    
    UIView *headView = [self tableFootView];
    myTableView.tableFooterView = headView;
    [myTableView reloadData];
    
    
}


-(void)updateTable
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = @"MyTask/GetDangerDetailInfo";
    paraDict[@"dangerId"] = self.strDangerId;
    
    httpPOST(paraDict, ^(id result) {
        NSLog(@"%@",result);
        if ([result[@"result"] isEqualToString:@"0000000"])
        {
            [photoArr removeAllObjects];
            [detailArr removeAllObjects];
            [infoArr removeAllObjects];
            
            photoArr = [[result objectForKey:@"detail"] objectForKey:@"fileList"];
            detailArr = [result objectForKey:@"detail"];
            infoArr = [[result objectForKey:@"detail"] objectForKey:@"recordList"];

            UIView *headView = [self tableFootView];
            myTableView.tableFooterView = headView;
            [myTableView reloadData];

            
        }else{
            
        }
        
    }, ^(id result) {
        
    });

}


#pragma mark == 照片删除按钮
-(void)deleteBtn:(UIButton *)sender
{
    NSLog(@"%d",sender.tag);
    [imgArr removeObjectAtIndex:sender.tag-100];
    [imageDataUrlArr removeObjectAtIndex:sender.tag-100];
    UIView *headView = [self tableFootView];
    myTableView.tableFooterView = headView;
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


#pragma mark == 上传照片
-(void)upBtn
{
    if (imageDataUrlArr.count == 0){
        [self showAlertWithTitle:@"提示" :@"请选择要上传的附件" :@"确定" :nil];
    }else{
        
        NSString *opreatinTime = date2str([NSDate date], @"yyyy-MM-dd HH:mm:ss");
        NSString *accessToken = UGET(U_TOKEN);
        NSString *strDangerID = [[detailArr  objectForKey:@"riskId"] description];
        NSString *requestUrl = [NSString stringWithFormat:@"http://%@/%@/MyTask/UploadDangerFile.json?operationTime=%@&accessToken=%@&dangerId=%@",ADDR_IP,ADDR_DIR,opreatinTime,accessToken,strDangerID];
        
        NSLog(@"uid == %@",requestUrl);
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [manager POST:requestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            for (int i = 0; i < imageDataUrlArr.count; i++) {
                
                NSURL *imgUrl = [imageDataUrlArr objectAtIndex:i];
                [formData appendPartWithFileURL:imgUrl name:[NSString stringWithFormat:@"image%d",i] error:nil];
                
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
                    [imgArr removeAllObjects];
                    [imageDataUrlArr removeAllObjects];
                    
                    [self updateTable];
//                    UIView *headView = [self tableFootView];
//                    myTableView.tableFooterView = headView;
//                    [myTableView reloadData];

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
