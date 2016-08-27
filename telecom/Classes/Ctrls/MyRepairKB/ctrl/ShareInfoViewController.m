//
//  ShareInfoViewController.m
//  telecom
//
//  Created by liuyong on 15/4/23.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "ShareInfoViewController.h"
#import "ShareInfoModel.h"
#import "ShareInfoCell.h"
#import "SharePersonView.h"
#import "AttachmentDetailController.h"
#import "BannerView.h"
#import <ShareSDK/ShareSDK.h>

@interface ShareInfoViewController ()<UITableViewDataSource,UITableViewDelegate,SharePersonViewDelegate>
{
    BannerView *_weiXinShareBannerView;
    BannerView *_sharePersonBannerView;
    BannerView *_shareInfoBannerView;
    
    SharePersonView *_sharePersonView;
}
@property(nonatomic,strong)NSMutableArray *shareInfoArray;
@property(nonatomic,strong)UITableView *shareInfoTbView;
@end

@implementation ShareInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"共享";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.shareInfoArray = [NSMutableArray array];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSharePersonShowing"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShareInfoShowing"];
    
    [self setUpUI];
}

- (void)setUpUI
{
//    _weiXinShareBannerView = [[BannerView alloc] initWithFrame:RECT(10, 84, APP_W-20, 25) withImage:@"weixin.png" title:@"微信分享"];
//    [_weiXinShareBannerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showWeiXinShareAction)]];
//    [_baseScrollView addSubview:_weiXinShareBannerView];
    
    _sharePersonBannerView = [[BannerView alloc] initWithFrame:RECT(10, 84, APP_W-20, 25) withImage:nil title:@"被共享人:"];//_weiXinShareBannerView.ey+8
    [_sharePersonBannerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSharePersonList)]];
    [_baseScrollView addSubview:_sharePersonBannerView];
    
//    _shareInfoBannerView = [[BannerView alloc] initWithFrame:RECT(10, _sharePersonBannerView.ey+8, APP_W-20, 25) withImage:nil title:@"共享信息列表"];
//    [_shareInfoBannerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showShareInfoList)]];
//    [_baseScrollView addSubview:_shareInfoBannerView];
}

- (void)showWeiXinShareAction
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    //故障流水单号orderNo
    //站点site
    //专业spec
    //工单受理时间acceptTime
    //工单类别faultPartDesc3
    //工单状态workStatus
    //工单内容workContent
    //工单预计时间expectTime
    //共享故障人员  未知
    
    //构造分享内容
    NSString *shareInfoString = [NSString stringWithFormat:@"故障流水单号:%@,站点:%@,专业:%@,工单受理时间:%@,工单类别:%@,工单状态:%@,工单内容:%@,工单预计时间:%@,共享故障人员:%@",
                                 self.workInfoDict[@"orderNo"],
                                 self.workInfoDict[@"site"],
                                 self.workInfoDict[@"spec"],
                                 self.workInfoDict[@"acceptTime"],
                                 self.workInfoDict[@"faultPartDesc3"],
                                 self.workInfoDict[@"workStatus"],
                                 self.workInfoDict[@"workContent"],
                                 self.workInfoDict[@"expectTime"],
                                 @""];
    id<ISSContent> publishContent = [ShareSDK content:shareInfoString
                                            defaultContent:@"故障单共享"
                                            image:[ShareSDK imageWithPath:imagePath]
                                            title:@"复旦光华"
                                            url:@"http://www.guanghua.sh.cn"
                                            description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)showSharePersonList
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isSharePersonShowing"]) {
        [_shareInfoBannerView setFy:_shareInfoBannerView.fy+170];
        [_shareInfoTbView setFy:_shareInfoTbView.fy+170];
        _baseScrollView.contentSize = CGSizeMake(APP_W, _baseScrollView.contentSize.height+170);
        UIImageView *rightImageView = (UIImageView *)[_sharePersonView viewWithTag:12346];
        rightImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
        _sharePersonView = [[[NSBundle mainBundle] loadNibNamed:@"SharePersonView" owner:self options:nil] lastObject];
        _sharePersonView.frame = RECT(_sharePersonBannerView.fx , _sharePersonBannerView.ey+5, _sharePersonBannerView.fw, APP_H-_sharePersonBannerView.ey);
        _sharePersonView.delegate = self;
        [_baseScrollView addSubview:_sharePersonView];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSharePersonShowing"];
        [_sharePersonView loadTableView];
        [_sharePersonView loadSharePersonInfoWithURL:kGetShareableUser];
    }
}

- (void)showShareInfoList
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isShareInfoShowing"]) {
        _baseScrollView.contentSize = CGSizeMake(APP_W, _baseScrollView.contentSize.height+250);
        UIImageView *rightImageView = (UIImageView *)[_sharePersonView viewWithTag:12346];
        rightImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        
    self.shareInfoTbView = [[UITableView alloc] initWithFrame:RECT(10, _shareInfoBannerView.ey+8, APP_W-20, 250) style:UITableViewStylePlain];
    self.shareInfoTbView.delegate = self;
    self.shareInfoTbView.dataSource = self;
    [_baseScrollView addSubview:self.shareInfoTbView];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShareInfoShowing"];
        [self loadShareInfoDataWithURL:kGetFaultShareInfo];
    }else{
        _baseScrollView.contentSize = CGSizeMake(APP_W, _baseScrollView.contentSize.height-250);
        UIImageView *rightImageView = (UIImageView *)[_sharePersonView viewWithTag:12346];
        rightImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        [self.shareInfoTbView removeFromSuperview];
        self.shareInfoTbView = nil;
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShareInfoShowing"];
    }
}

- (void)loadShareInfoDataWithURL:(NSString *)urlString
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = urlString;
    paraDict[@"faultId"] = self.faultId;
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            
            for (NSDictionary *dict in result[@"list"]) {
                ShareInfoModel *model = [[ShareInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.shareInfoArray addObject:model];
            }
        }
        [self.shareInfoTbView reloadData];
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shareInfoArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"reuseCell";
    ShareInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ShareInfoCell" owner:self options:nil] lastObject];
    }
    ShareInfoModel *model = self.shareInfoArray[indexPath.row];
    [cell config:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShareInfoModel *model = self.shareInfoArray[indexPath.row];
    if (![model.fileCount isEqualToString:@"0"]) {
        AttachmentDetailController *attachVc = [[AttachmentDetailController alloc] init];
        attachVc.commentId = model.commentId;
        [self.navigationController pushViewController:attachVc animated:YES];
    }
}

- (void)deliverSharePersonName:(NSString *)sharePersonName
{
    UILabel *titleLabel = (UILabel *)[_sharePersonBannerView viewWithTag:12345];
    titleLabel.text = [NSString stringWithFormat:@"当前共享人: %@",sharePersonName];
    
    [_shareInfoBannerView setFy:_shareInfoBannerView.fy-170];
    [_shareInfoTbView setFy:_shareInfoTbView.fy-170];
    _baseScrollView.contentSize = CGSizeMake(APP_W, _baseScrollView.contentSize.height-170);
    UIImageView *rightImageView = (UIImageView *)[_sharePersonView viewWithTag:12346];
    rightImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSharePersonShowing"];
    
    [_sharePersonView removeFromSuperview];
    _sharePersonView = nil;
}

- (void)setSharePerson:(NSString *)userId
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = kSetShareableUser;
    paraDict[@"userId"] = userId;
    paraDict[@"faultId"]  = self.faultId;
    httpGET2(paraDict, ^(id result) {
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}

- (void)cancelSharePerson
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = kSetShareableUser;
    paraDict[@"userId"] = @(-1);
    paraDict[@"faultId"]  = self.faultId;
    httpGET2(paraDict, ^(id result) {
        if ([result[@"result"] isEqualToString:@"0000000"]) {
            UILabel *titleLabel = (UILabel *)[_sharePersonBannerView viewWithTag:12345];
            titleLabel.text = [NSString stringWithFormat:@"当前共享人: 当前未设置共享人"];
        }
    }, ^(id result) {
        showAlert(result[@"error"]);
    });

    [_shareInfoBannerView setFy:_shareInfoBannerView.fy-170];
    [_shareInfoTbView setFy:_shareInfoTbView.fy-170];
    _baseScrollView.contentSize = CGSizeMake(APP_W, _baseScrollView.contentSize.height-170);
    UIImageView *rightImageView = (UIImageView *)[_sharePersonView viewWithTag:12346];
    rightImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSharePersonShowing"];
    
    [_sharePersonView removeFromSuperview];
    _sharePersonView = nil;
    
}
@end
