//
//  TaskFaultRisk.m
//  telecom
//
//  Created by ZhongYun on 15-3-26.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "TaskFaultRisk.h"
#import "UIImageView+WebCache.h"
#import "PhotoPicker.h"
#import "UploadFile.h"
#import "PhotoViewer.h"
#import "JSON.h"
#import "UploadFiler.h"

#define OP_TO_NONE      0
#define OP_TO_ADD       1
#define OP_TO_DEL       2
#define OP_TO_ADDING    3

@interface TaskFaultRisk ()<UITextFieldDelegate,UploadFileDelegate>
{
    BOOL isSubTaskFile;
    UITextField* m_desc;
    PhotoPicker* m_photoPicker;
    UploadFile* m_uploadFile;
    UIButton* m_btnAddPic;

    NSMutableArray* m_filesEx;
    NSURL *url;
    int a;
}
@end

@implementation TaskFaultRisk

- (void)dealloc
{
    [m_filesEx release];
    [m_uploadFile release];
    [m_btnAddPic release];
    [m_photoPicker release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加隐患";
    self.view.backgroundColor = [UIColor whiteColor];
    NOTIF_ADD(DEL_SELECTED_PHOTO, onDelSelectedPhoto:);
    isSubTaskFile = (self.subTaskId != nil);
    m_filesEx = [[NSMutableArray alloc] init];
    
    m_uploadFile = [[UploadFile alloc] init];
    m_uploadFile.respBlocker = ^(int t, id v) {[self uploadSelectedPhotosResp:t Value:v];};
    
    m_photoPicker = [[PhotoPicker alloc] init];
    m_photoPicker.parentVC = self;
    m_photoPicker.pickBlock = ^(UIImage* image){mainThread(onPickPhoto:, nil);};
    
    UIImage* checkIcon = [UIImage imageNamed:@"nav_check.png"];
    UIButton* checkBtn = [[UIButton alloc] initWithFrame:RECT((APP_W-10-checkIcon.size.width), (NAV_H-checkIcon.size.height)/2,
                                                             checkIcon.size.width, checkIcon.size.height)];
    [checkBtn setBackgroundImage:checkIcon forState:0];
    [checkBtn addTarget:self action:@selector(onCheckBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
//    [self.navBarView addSubview:checkBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:checkBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [rightItem release];
    [checkBtn release];
    
    UIView* bgview = [[UIView alloc] initWithFrame:RECT(15, 64, APP_W-30, 30)];
    bgview.hidden = isSubTaskFile;
    bgview.backgroundColor = RGB(0xffffff);
    bgview.clipsToBounds = YES;
    bgview.layer.borderColor = RGB(0x999999).CGColor;
    bgview.layer.borderWidth = 0.5;
    [self.view addSubview:bgview];
    [bgview release];
    
    m_desc = newTextField(self.view, @[@50, RECT_OBJ(20, self.navBarView.ey+15+20, APP_W-35, 30), RGB(0x000000), Font(Font3), @"请输入隐患内容", @""]);
    m_desc.hidden = isSubTaskFile;
    
    CGFloat top_y = (isSubTaskFile ? m_desc.fy : m_desc.ey);
    UILabel* title = newLabel(self.view, @[@51, RECT_OBJ(15, top_y+15+20, 100, Font2), RGB(0x2b65c8), FontB(Font2), @"附件"]);

    UIImage* addpicIcon = [UIImage imageNamed:@"addpic.png"];
    m_btnAddPic = [[UIButton alloc] initWithFrame:RECT(15, title.ey+15+20, addpicIcon.size.width, addpicIcon.size.height)];
    [m_btnAddPic setBackgroundImage:addpicIcon forState:0];
    [m_btnAddPic addTarget:self action:@selector(onAddPicBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:m_btnAddPic];
    
    if (isSubTaskFile) {
        self.title = @"添加附件";
        [self loadSubTaskFiles];
    }
}

- (void)loadSubTaskFiles
{
    httpGET1(@{URL_TYPE:NW_GetSecondaryTaskFileList, @"subTaskId":self.subTaskId}, ^(id result) {
        NSLog(@"%@",result[@"list"]);
        for (id item in result[@"list"]) {
            mainThread(addSelectedImage:, item);
        }
    });
}

- (void)clearCache
{
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    [[SDImageCache sharedImageCache] clearMemory];
}


- (void)addSelectedImage:(id)imageInfo
{
    [self clearCache];
    BOOL isNetImage = [imageInfo isKindOfClass:[NSDictionary class]];
    
    UIButtonEx* btnPhoto = [[UIButtonEx alloc] initWithFrame:m_btnAddPic.frame];
    [btnPhoto addTarget:self action:@selector(onBtnPhotoTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPhoto];
    
    UIImageView* bg_img = [[UIImageView alloc] initWithFrame:btnPhoto.bounds];
    [btnPhoto addSubview:bg_img];
    
    NSDictionary* info = nil;
    if (isNetImage) {
        NSString* imgURL = format(@"http://%@/%@/%@", ADDR_IP, ADDR_DIR, imageInfo[@"downloadLocation"]);
        NSLog(@"%@",imgURL);
        [bg_img sd_setImageWithURL:[NSURL URLWithString:imgURL]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        info = @{@"path":imgURL,
                 @"info":imageInfo,
                 @"btn":btnPhoto,
                 @"imgView":bg_img,
                 @"todo":@(OP_TO_NONE), };
    } else {
        bg_img.image = [UIImage imageWithContentsOfFile:imageInfo];

        url = [NSURL fileURLWithPath:imageInfo];
        info = @{@"path":imageInfo,
                 //@"info":imageInfo,
                 @"btn":btnPhoto,
                 @"imgView":bg_img,
                 @"todo":@(OP_TO_ADD), };
    }
    [m_filesEx addObject:[[info mutableCopy] autorelease]];

    btnPhoto.info = m_filesEx.lastObject;
    
    [bg_img release];
    [btnPhoto release];
    
    
    //移动添加图片按钮;
    [UIView animateWithDuration:0.3 animations:^{
        CGFloat fx = (m_btnAddPic.fx + m_btnAddPic.fw + 15);
        CGFloat fy = m_btnAddPic.fy;
        if (fx > (APP_W - m_btnAddPic.fw - 10)) {
            fx = 15;
            fy += (m_btnAddPic.fh+15);
        }
        m_btnAddPic.fx = fx;
        m_btnAddPic.fy = fy;
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


- (void)onCheckBtnTouched:(id)sender
{
    if (!isSubTaskFile && m_desc.text.length == 0) {
        showAlert(@"请输入隐患内容");
        return;
    }

    
    //1. 先提交删除的文件;
    NSMutableArray* fileIds = [NSMutableArray array];
    NSMutableArray* del_list = [NSMutableArray array];
    for (id item in m_filesEx) {
        if ([item[@"todo"] intValue] == OP_TO_DEL) {
            [fileIds addObject:item[@"info"][@"fileId"]];
            [del_list addObject:item];
        }
    }
    
    if (del_list.count > 0) {
        NSString* strFileIds = [fileIds componentsJoinedByString:@","];
        [m_filesEx removeObjectsInArray:del_list];
        
        httpGET1(@{URL_TYPE:NW_DelSecondaryTaskFile, @"subTaskId":self.subTaskId, @"fileId":strFileIds}, ^(id result) {
            mainThread(onCheckBtnTouched:, nil);
        });
    } else {
        //2. 再提交新增的文件;
        NSString* imgFile = nil;
//        NSURL *url = nil;
        for (id item in m_filesEx) {
            a++;
            if ([item[@"todo"] intValue] == OP_TO_ADD) {
                imgFile = [item[@"path"] copy];
                url = [NSURL fileURLWithPath:imgFile];
                item[@"todo"] = @(OP_TO_ADDING);
                break;
            }
        }
        
        if (imgFile != nil) {
            NSString* imgFileName = format(@"%@.jpg", date2str([NSDate date], @"yyyyMMddHHmmss"));
            
            if (isSubTaskFile) {
                
                UploadFiler *upFiler = [[UploadFiler alloc] init];
                upFiler.delegate = self;
                NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
                paraDict[URL_TYPE] = NW_UploadSecondaryTaskFile;
                paraDict[FILE_PATH] = imgFile;
                paraDict[@"fileName"] = imgFileName;
                paraDict[@"subTaskId"] = self.subTaskId;
                [upFiler send:paraDict];
                
                
//                [m_uploadFile send:@{URL_TYPE:NW_UploadSecondaryTaskFile,
//                                     FILE_PATH:imgFile,
//                                     @"fileName":imgFileName,
//                                     @"subTaskId":self.subTaskId}];
            
            } else {
                
                [m_uploadFile send:@{URL_TYPE:NW_uploadFualtRiskFile, FILE_PATH:imgFile, @"fileName":imgFileName}];
             
            }
        } else {
            if (isSubTaskFile) {
                showAlert(@"提交成功!");
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                //3. 提交基本数据;
                NSMutableDictionary* params = [NSMutableDictionary dictionary];
                params[URL_TYPE] = NW_submitFualtRisk;
                params[@"taskId"] = self.task[@"taskId"];
                params[@"content"] = m_desc.text;
                
                NSMutableArray* tempIds = [NSMutableArray array];
                for (id item in m_filesEx) {
                    if ([item[@"todo"] intValue] == OP_TO_NONE) {
                        [tempIds addObject:item[@"info"][@"fileId"]];
                    }
                }
                if (tempIds.count > 0) {
                    params[@"fileId"] = [tempIds componentsJoinedByString:@","];
                }
                httpGET1(params, ^(id result) {
                    showAlert(@"数据提交成功");
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        }
    }
}


- (void)deliverResultFileId:(NSData *)receiveData
{
    id result = [NSJSONSerialization JSONObjectWithData:receiveData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"result:%@",result);
}

- (void)uploadSelectedPhotosResp:(int)t Value:(id)v
{
    if (t == RESP_WILL_SEND) {
        showLoading(@"请稍等");
    } else if (t == RESP_PROGRESS) {
        ;
    } else if (t == RESP_ERROR) {
        hideLoading();
    } else if (t == RESP_FAILED) {
        hideLoading();
    } else if (t == RESP_TIMEOUT) {
        hideLoading();
    } else if (t == RESP_SUCCESS) {
        hideLoading();
        NSDictionary* rsDict = [v JSONValue];
        if ([rsDict[@"result"] isEqualToString:@"0000000"]) {
            for (id item in m_filesEx) {
                if ([item[@"todo"] intValue] == OP_TO_ADDING) {
                    item[@"todo"] = @(OP_TO_NONE);
                    
                    if (!isSubTaskFile) {
                        NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:rsDict[@"detail"][@"fileId"],@"fileId", nil];
                        item[@"info"] = mutDict;
//                        item[@"info"] = [@{@"fileId":rsDict[@"detail"][@"fileId"]} mutableCopy];
                    }
                    break;
                }
            }
            mainThread(onCheckBtnTouched:, nil);
        }
    }
}

- (void)onAddPicBtnTouched:(id)sender
{
    NSString* imgFileName = format(@"%@.jpg", date2str([NSDate date], @"yyyyMMddHHmmss"));
    [m_photoPicker pickWithSize:CGSizeZero ImageName:imgFileName];
}

- (void)onPickPhoto:(UIImage*)image
{
    mainThread(addSelectedImage:, m_photoPicker.imagePath);
}

- (void)onBtnPhotoTouched:(UIButtonEx*)sender
{
    [PhotoViewer showPhoto:sender.info Parent:self];
}
- (void)onDelSelectedPhoto:(NSNotification*)notification
{
    NSMutableDictionary* imgInfo = notification.object;
    UIButtonEx* del_photo = imgInfo[@"btn"];
    
    if ([imgInfo[@"todo"] intValue] == OP_TO_ADD) {
        [m_filesEx removeObject:imgInfo];
    } else if ([imgInfo[@"todo"] intValue] == OP_TO_NONE) {
        imgInfo[@"todo"] = @(OP_TO_DEL);
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        del_photo.alpha = 0.0;
        
        CGFloat fx = 15, fy = tagView(self.view, 51).ey + 15;
        for (id item in m_filesEx) {
            if ([item[@"todo"] intValue] == OP_TO_DEL) {
                continue;
            }
            
            UIView* view = item[@"btn"];
            view.fx = fx;
            view.fy = fy;
            
            fx += (view.fw + 15);
            if (fx > (APP_W - view.fw - 10)) {
                fx = 15;
                fy += (view.fh+15);
            }
        }
        
        m_btnAddPic.fx = fx;
        m_btnAddPic.fy = fy;
    } completion:^(BOOL finished) {
        del_photo.hidden = YES;
        [del_photo removeFromSuperview];
    }];
    
}


@end
