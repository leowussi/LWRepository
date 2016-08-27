//
//  YZWorkOrderDetailViewController.m
//  telecom
//
//  Created by 锋 on 16/6/30.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZWorkOrderDetailViewController.h"
#import "YZResourcesInfoDetailTableViewCell.h"
#import "YZImageCollectionViewCell.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "YZPhotoBrowserViewController.h"

@interface YZWorkOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    UITableView *_tableView;
    UIView *_footerView;
    UICollectionView *_collectionView;
    
    //标题
    NSMutableArray *_titleArray;
    
    NSArray *_showMoreTitleArray;
    
    NSMutableArray *_heightArray;
}
@end

@implementation YZWorkOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self addNavigationLeftButton];
    [self createTableView];
    [self loadData];
    
    NSArray *titleArray = @[@"故障单详细",@"业务开通单详细",@"风险操作工单详细",@"作业计划详细",@"指挥任务单详细",@"随工单详细",@"资源变更工单详细",@"请求支撑单详细"];
    self.navigationItem.title = titleArray[_typeId - 1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark - 用户自定义方法
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIImageView *imageView = [UnityLHClass initUIImageView:@"back_btn" rect:CGRectMake(0, 7,navImg.size.width/1,navImg.size.height/1)];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    [leftButton addSubview:imageView];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 请求数据
- (void)loadData
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionaryWithCapacity:0];
    paraDict[URL_TYPE] = [self getWorkOrderDetailUrlString];
    if (_typeId == 6) {
        paraDict[@"appointmentId"] = _workOrderId;
    }else if (_typeId == 5) {
        paraDict[@"taskId"] = [[_workOrderId componentsSeparatedByString:@","] firstObject];
        paraDict[@"upTaskId"] = [[_workOrderId componentsSeparatedByString:@","] lastObject];
        
//        paraDict[@"taskId"] = @"140071";
//        paraDict[@"upTaskId"] = @"118816";        //1328
    }else if (_typeId == 8) {
        
         paraDict[@"taskId"] = _workOrderId;
    }else{
        
         paraDict[@"id"] = _workOrderId;
    }
  
    NSLog(@"%@",paraDict);
     httpPOST(paraDict, ^(id result) {
    
        NSLog(@"%@",result);
         if (![[result objectForKey:@"result"] isEqualToString:@"0000000"]) {
             UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
             [alertView show];
             return ;
         }
         if (_heightArray == nil) {
             _heightArray = [[NSMutableArray alloc] initWithCapacity:0];
         }
        NSDictionary *detailDict = [result objectForKey:@"detail"];
        NSArray *keyArray = [self getWorkOrderKeyArray];
    
        UIFont *font = [UIFont systemFontOfSize:15];
        for (NSArray *sectionArray in keyArray) {
            NSMutableArray *mutArray = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *mutHeightArray = [NSMutableArray arrayWithCapacity:0];
            for (NSString *key in sectionArray) {
                NSString *obj = NoNullStr([detailDict objectForKey:key]);
                if ([obj isKindOfClass:[NSNumber class]]) {
                    obj = [(NSNumber *)obj stringValue];
                }
                
               CGFloat height = [self calculateTextHeight:obj textWidth:kScreenWidth - 140 textFont:font] + 2;
                height = height > 26 ? height : 26;
                [mutHeightArray addObject:@(height)];
                [mutArray addObject:obj];
                
            }
            [_dataArray addObject:mutArray];
            [_heightArray addObject:mutHeightArray];
         }
         
         [self setWOrkOrderTitle];

         [self adjustDataArraySequence];
         [self getattachmentListWtihDictionary:detailDict];
         
        [_tableView reloadData];
    }, ^(id result) {

        NSLog(@"%@",result);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"error"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];

    });

    
}

#pragma mark -- 调整dataArray的排序
- (void)adjustDataArraySequence
{
    switch (_typeId) {
        case 1:
        {
            //是否关联工单
            NSString *billRelation = _dataArray[1][22];
            if ([billRelation isEqualToString:@"Y"]) {
                [_dataArray[1] replaceObjectAtIndex:22 withObject:@"关联"];
            }else if ([billRelation isEqualToString:@"N"]) {
                 [_dataArray[1] replaceObjectAtIndex:22 withObject:@"无关联"];
            }
            
            //关联类型
            NSString *billRelationType = _dataArray[1][23];
            if ([billRelationType isEqualToString:@"MAIN"]) {
                [_dataArray[1] replaceObjectAtIndex:23 withObject:@"主单"];
            }else if ([billRelationType isEqualToString:@"SUB"]) {
                [_dataArray[1] replaceObjectAtIndex:23 withObject:@"从单"];
            }
            
            NSString *recallRelationBill = _dataArray[1][24];
            if ([recallRelationBill isEqualToString:@"Y"]) {
                [_dataArray[1] replaceObjectAtIndex:24 withObject:@"需要回单"];
            }else if ([recallRelationBill isEqualToString:@"N"]) {
                [_dataArray[1] replaceObjectAtIndex:24 withObject:@"不需要"];
            }

            
        }
            break;
            
        case 5:
        {
            NSString *status = [_dataArray[0] lastObject];
            if ([status isEqualToString:@"0"]) {
                [_dataArray[0] replaceObjectAtIndex:[_dataArray[0] count] - 1 withObject:@"待接受"];
            }else if ([status isEqualToString:@"1"]) {
                [_dataArray[0] replaceObjectAtIndex:[_dataArray[0] count] - 1 withObject:@"已接受"];
            }
        }
            break;
        case 6:
        {
            //拆分时间
            NSString *time = _dataArray[0][2];
            if ([time isEqualToString:@""]) {
                [_dataArray[0] insertObject:@"" atIndex:3];
                [_heightArray[0] insertObject:@(26) atIndex:3];
            }else{
                NSArray *timeArray = [time componentsSeparatedByString:@"~"];
                [_dataArray[0] replaceObjectAtIndex:2 withObject:timeArray[0]];
                [_heightArray[0] replaceObjectAtIndex:2 withObject:@(26)];

                [_dataArray[0] insertObject:timeArray[1] atIndex:3];
                [_heightArray[0] insertObject:@(26) atIndex:3];
            }
            
            [_dataArray[0] replaceObjectAtIndex:13 withObject:@"工程现场配合"];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark --- 获取图片
- (void)getattachmentListWtihDictionary:(NSDictionary *)dict
{
    NSArray *fileArray = nil;
    if (_imageArray == nil) {
        _imageArray = [[NSMutableArray alloc] initWithCapacity:0];
    }

    switch (_typeId) {
        case 3:
        {
            fileArray = [dict objectForKey:@"attachmentList"];
            if ([fileArray isKindOfClass:[NSNull class]]) {
                return;
            }
            for (NSDictionary *fileDict in fileArray) {
                NSString *imagePath = [NSString stringWithFormat:@"http://%@/%@/attachment/riskAttachment/%@/",ADDR_IP,ADDR_DIR,[fileDict objectForKey:@"id"]];
                [_imageArray addObject:imagePath];
            }

        }
            break;
        case 5:
        {
            fileArray = [dict objectForKey:@"attachmentList"];
            for (NSString *fileId in fileArray) {
                NSString *imagePath = [NSString stringWithFormat:@"http://%@/%@/attachment/ywglTask/%@/",ADDR_IP,ADDR_DIR,fileId];
                [_imageArray addObject:imagePath];
            }
        }
            break;
        case 7:
        {
            NSArray *fileListArray = [dict objectForKey:@"fileList"];
            if (fileListArray == nil) {
                break;
            }
            for (NSDictionary *dict in fileListArray) {
                NSString *fileId = [dict objectForKey:@"fileId"];
                NSString *imagePath = [NSString stringWithFormat:@"http://%@/%@/attachment/adjustResFile/%@/",ADDR_IP,ADDR_DIR,fileId];
                [_imageArray addObject:imagePath];
            }

        }
            break;
            
        case 8:
        {
            fileArray = [dict objectForKey:@"attachmentList"];
            for (NSString *fileId in fileArray) {
                NSString *imagePath = [NSString stringWithFormat:@"http://%@/%@/attachment/ywglSupportTask/%@/",ADDR_IP,ADDR_DIR,fileId];
                [_imageArray addObject:imagePath];
            }

        }
            break;
        default:
            break;
    }
    
    NSLog(@"%@",_imageArray);
//    [_collectionView reloadData];
}

- (NSString *)getWorkOrderDetailUrlString
{
    NSArray *array = @[@"commonBill/QueryFaultBillDetail",@"commonBill/QueryServiceFullfillDetail",@"commonBill/QueryRiskOperationDetail",@"commonBill/QueryWorkPlanDetail",@"task/SearchTaskInfo",@"MyTask/WithWork/TaskInfo",@"adjustRes/QueryAdjustResById",@"task/SearchSupportTaskInfo"];
    
    return array[_typeId - 1];
}

//获取字段 的key
- (NSArray *)getWorkOrderKeyArray
{
    
    NSArray *keyArray = nil;
    NSArray *moreKeyArray = nil;
    switch (_typeId) {
        case 1:
        {
            keyArray = [NSArray arrayWithObjects:@"sceneType",@"faultNo",@"source",@"manufacturer",@"operatorInfo",@"businessNo",@"orderNo",@"region",@"site",@"faultacceptTime",@"faultType",@"workStatus",@"workContent",@"room",@"expectTime",@"contactWay",@"faultLevel",@"faultTimeLimit",@"finishTime",@"handupTime",@"remainTime",@"spec",@"workType",@"faultPartDesc1",@"faultPartDesc2",@"faultPartDesc3",@"faultPartDesc4",@"faultPartDesc5",@"faultPartDesc6",@"faultPartDesc7",@"faultPartDesc8",@"skill",@"faultStartTime",@"faultEndTime",@"dealLine",@"isOverTime",@"deptNm",@"faultDetail",@"faultReason", nil];
            
            
            moreKeyArray = [NSArray arrayWithObjects:@"deviceNo",@"alertId",@"netType",@"faultLongtitude",@"longtitudeable",@"faultlatitude",@"latitudeable",@"needPersonNums",@"difficultLevel",@"recureTime",@"sceneKind",@"costTime",@"userInfo",@"serviceInfo",@"serviceKind",@"serviceType",@"suspendReason",@"suspendStartTime",@"suspendEndTime",@"faultSysLevel",@"isEffectMajor",@"effectMajors",@"billRelation",@"billRelationType",@"recallRelationBill",@"isBlocBill",@"blocBillLevel",@"faultImptLevel",@"conflationReason",@"conflationDetail",@"repeatTitleNums",@"faultSatisfy", nil];

        
        }
            break;

        case 2:
        {
            keyArray = [NSArray arrayWithObjects:@"sceneType",@"orderNo",@"projectNm",@"billLink",@"billStatus",@"ServiceType",@"accpectTime",@"applyTime",@"finishTime",@"cusName",@"contractTel",@"applyDept",@"billType",@"crmType",@"companyInfo",@"linkInfo", nil];
            moreKeyArray = [NSArray arrayWithObjects:@"isAdjust",@"adjust",@"creatAdjustBill",@"taskLongtitude",@"taskLatitude",@"difficultLevel",@"costTime",@"score",@"needPersonNum",@"skill", nil];
        }
            break;
        case 3:
        {
            keyArray = [NSArray arrayWithObjects:@"sceneType",@"billNo",@"title",@"applyUser",@"applyUserCompy",@"applyUserDept",@"applyMajor",@"riskOperationType",@"startTime",@"endTime",@"applyReason",@"influence",@"operator",@"isEffectUser",@"cooperator",@"monitor",@"operatorPhone",@"cooperatorPhone",@"monitorPhone",@"remark",@"city",@"riskRegion",@"customerInfluence",@"influenceRegion",@"needSceneOperate",@"sceneOperateTime",@"OperateRequire",@"needTest",@"testRequire", nil];
            moreKeyArray = [NSArray arrayWithObjects:@"taskLongtitude",@"taskLatitude",@"difficultLevel",@"costTime",@"score",@"needPersonNum",@"skill", nil];

        }
            break;
        case 4:
        {
            keyArray = [NSArray arrayWithObjects:@"sceneType",@"major",@"billNo",@"projectNm",@"projectNo",@"monthPlanNm",@"orgNm",@"startTime",@"endTime",@"excetor",@"completedNums",@"testResult",@"nuNm",@"totalPlanNums",@"dealStatus",@"duty",@"deallines",@"isOverTime", nil];
            moreKeyArray = [NSArray arrayWithObjects:@"operateTime",@"normalNums",@"abnormalNums",@"maintain",@"isTrans",@"transUser",@"taskLongtitude",@"taskLatitude",@"difficultLevel",@"costTime",@"score",@"needPersonNum",@"skill", nil];
        }
            break;

        case 5:
        {
            keyArray = [NSArray arrayWithObjects:@"sceneType",@"taskNo",@"taskContent",@"taskCreateDate",@"taskAppltReason",@"taskCreateOrg",@"taskCreatePeo",@"applyPeoPh",@"applyEmail",@"taskUrgent",@"taskType",@"taskBeginDate",@"taskEndDate",@"costTime",@"score",@"specialSkill",@"needPerNum",@"status", nil];
        }
            break;
            
        case 6:
        {
            //taskTime字段需拆分
            keyArray = [NSArray arrayWithObjects:@"projectName",@"projectNo",@"taskTime",@"taskAddress",@"reason",@"siteName",@"orgName",@"projectNum",@"taskCompany",@"executeUserName",@"taskContent",@"constructor",@"适用场景类型",@"matchTask", nil];
            
            moreKeyArray = [NSArray arrayWithObjects:@"level",@"costTime",@"score",@"skill", nil];
        }
            break;
            
        case 7:
        {
            keyArray = [NSArray arrayWithObjects:@"orderid",@"sysinfo",@"subtype",@"subtyperemark",@"major",@"title",@"remarks",@"liveinfo",@"source",@"faulttype",@"faulttyperemark",@"dealdept",@"dealrole",@"status",@"createtime",@"username",@"dealuser", nil];
            moreKeyArray = [NSArray arrayWithObjects:@"localnetnm",@"gridname",@"limittime",@"dealines",@"taskcode",@"tasklongtitude",@"tasklatitude",@"difficultylevel",@"costtime",@"score",@"needpersonnum",@"skill",@"emergency",@"dealresult", nil];
        }
            break;
            
        case 8:
        {
            keyArray = [NSArray arrayWithObjects:@"sceneType",@"taskNo",@"name",@"taskCreatePeo",@"oneType",@"twoType",@"account",@"taskBeginDate",@"taskEndDate",@"remark",@"status", nil];
            
        }
            break;
        default:
            break;
    }
    
    NSArray *allKeyArray = nil;
    if (keyArray) {
        if (moreKeyArray == nil) {
            allKeyArray = @[keyArray];
        }else {
            allKeyArray = @[keyArray,moreKeyArray];
        }
    }
   
    return allKeyArray;
}

- (void)setWOrkOrderTitle
{
   
    NSArray *sectionArray0 = nil;
    switch (_typeId) {
        case 1:
        {
            sectionArray0 = [NSArray arrayWithObjects:@"适 用 场 景 类 型:",@"故 障 单 流 水 号:",@"故    障    来    源 :",@"厂                    商 :",@"运  营  商  信  息 :",@"业        务        号 :",@"订        单        号 :",@"区                    域 :",@"站                    点 :",@"故障单受理时间 :",@"故  障  单  类  别 :",@"故  障  单  状  态 :",@"故  障  单  内  容 :",@"相    关    机    房 :",@"故障单预计时间 :",@"联系人和联系方式:",@"故    障    等    级 :",@"处    理    时    限 :",@"故  障  单  历  时 :",@"挂    起    时    长 :",@"剩    余    时    间 :",@"专                    业 :",@"工                    种 :",@"故   障   部   位 1 :",@"故   障   部   位 2 :",@"故   障   部   位 3 :",@"故   障   部   位 4 :",@"故   障   部   位 5 :",@"故   障   部   位 6 :",@"故   障   部   位 7 :",@"故   障   部   位 8 :",@"特殊技能资质要求:",@"告 警 开 始 时 间:",@"告 警 恢 复 时 间:",@"工 单 归 档 时 间:",@"是    否    超    时 :",@"责任部门处理人 :",@"故 障 处 理 描 述:",@"故    障    原    因 :", nil];
            
            _showMoreTitleArray = [[NSArray alloc] initWithObjects:@"设    备    编    码 :",@"告        警        ID :",@"网    管    类    型 :",@"障 碍 位 置 经 度:",@"外 线 经 度 可 选:",@"障 碍 位 置 纬 度:",@"外 线 纬 度 可 选:",@"需    要    人    数 :",@"难    度    等    级 :",@"业 务 恢 复 时 间:",@"障碍远程/现场类型:",@"经    验    耗    时 :",@"重 要 用 户 信 息:",@"业    务    信    息 :",@"业    务    种    类 :",@"业    务    类    别 :",@"预 约 挂 起 原 因:",@"预约挂起开始时间:",@"预约挂起结束时间:",@"故 障 系 统 级 别:",@"是 否 影 响 业 务:",@"影    响    专    业 :",@"是 否 关 联 工 单:",@"关    联    类    型 :",@"关联从单是否需要回单:",@"是 否 集 团 工 单:",@"集 团 工 单 等 级:",@"故障重要性等级 :",@"归    并    原    因 :",@"归    并    详    情 :",@"标题重复工单次数:",@"故障工单满意度 :", nil];
        }
            break;
        case 2:
        {
            sectionArray0 = [NSArray arrayWithObjects:@"适 用 场 景 类 型:",@"工    单    编    号 :",@"项    目    名    称 :",@"工    单    环    节 :",@"工    单    状    态 :",@"服    务    类    型 :",@"派    单    时    间 :",@"申    请    日    期 :",@"用户要求完成时间:",@"客    户    名    称 :",@"联 系 人 及 电 话:",@"申    请    部    门 :",@"工    单    种    类 :",@"CRM  订  单  类  型:",@"资源入网设备信息:",@"链    路    信    息 :", nil];
            _showMoreTitleArray = [NSArray arrayWithObjects:@"资 源 是 否 变 更:",@"资    源    变    更 :",@"发起资源变更单 :",@"任 务 位 置 经 度:",@"任 务 位 置 纬 度:",@"难    度    等    级 :",@"经    验    耗    时 :",@"积                    分 :",@"需    要    人    数 :",@"技    能    要    求 :", nil];
        }
            break;
        case 3:
        {
            sectionArray0 = [NSMutableArray arrayWithObjects:@"适 用 场 景 类 型:",@"工    单    编    号 :",@"工    单    标    题 :",@"工  单  申  请  人 :",@"工单申请人公司 :",@"工单申请人部门 :",@"申    请    专    业 :",@"风 险 操 作 分 类:",@"申    请    时    间 :",@"执    行    时    间 :",@"申    请    原    因 :",@"影    响    范    围 :",@"实 施 人 / 工 位 :",@"是 否 影 响 用 户:",@"配        合        人 :",@"监        控        人 :",@"实  施  人  电  话 :",@"配  合  人  电  话 :",@"监  控  人  电  话 :",@"备                    注 :",@"发    起    地    市 :",@"风险操作涉及设备范围:",@"客 户 服 务 影 响:",@"影响范围和时长:",@"是否需要现场操作:",@"现 场 操 作 时 间:",@"现 场 操 作 要 求:",@"是否需要业务测试:",@"业 务 测 试 要 求:", nil];
            _showMoreTitleArray = [NSArray arrayWithObjects:@"任 务 位 置 经 度:",@"任 务 位 置 纬 度:",@"难    度    等    级 :",@"经    验    耗    时 :",@"积                    分 :",@"需    要    人    数 :",@"技    能    要    求 :", nil];
        }
            break;
        case 4:
        {
            sectionArray0 = [NSArray arrayWithObjects:@"适 用 场 景 类 型:",@"专                    业 :",@"工    单    编    号 :",@"项    目    名    称 :",@"项    目    编    号 :",@"月  计  划  名  称 :",@"组                    织 :",@"开    始    时    间 :",@"结    束    时    间 :",@"执       行        人 :",@"完    成    数    量 :",@"测    试    结    果 :",@"站点/网 元 选 择:",@"总  作  业  项  数 :",@"处    理    状    态 :",@"责        任        岗 :",@"工 单 归 档 时 间:",@"是    否    超    时 :", nil];
            _showMoreTitleArray = [NSArray arrayWithObjects:@"上 次 作 业 时 间:",@"正    常    项    数 :",@"异    常    项    数 :",@"维    护    属    性 :",@"是    否    转    派 :",@"转        派        人 :",@"作 业 位 置 经 度:",@"作 业 位 置 纬 度:",@"难    度    等    级 :",@"经    验    耗    时 :",@"积                    分 :",@"需    要    人    数 :",@"特殊技能资质要求:", nil];
        }
            break;
        case 5:
        {
            sectionArray0 = [NSArray arrayWithObjects:@"适 用 场 景 类 型:",@"工    单    编    号 :",@"任    务    主    题 :",@"制    定    时    间 :",@"发    起    原    因 :",@"申    请    单    位 :",@"申        请        人 :",@"申请人联系电话 :",@"申  请  人  邮  箱 :",@"缓    急    程    度 :",@"任    务    类    型 :",@"任 务 开 始 时 间:",@"任 务 结 束 时 间:",@"经    验    耗    时 :",@"特殊技能资质要求:",@"需    要    人    数 :",@"状                    态 :", nil];
        }
            break;
        case 6:
        {
            sectionArray0 = [NSArray arrayWithObjects:@"工    程    名    称 :",@"工    程    编    号 :",@"预 计 施 工 时 间:",@"施 工 结 束 时 间:",@"预 计 施 工 地 点:",@"预 计 施 工 内 容:",@"区                    局 :",@"提    交    部    门 :",@"施    工    数    量 :",@"施    工    单    位 :",@"施 工 监 护 名 单 :",@"施    工    详    情 :",@"施 工 人 员 名 单:",@"适 用 场 景 类 型:",@"配    合    任    务 :", nil];
            _showMoreTitleArray = [[NSArray alloc] initWithObjects:@"难    度    等    级 :",@"经    验    耗    时 :",@"积                    分 :",@"技    能    要    求 :", nil];
        }
            break;

            case 7:
        {
            sectionArray0 = [[NSArray alloc] initWithObjects:@"工    单    编    号 :",@"系    统    情    况 :",@"细 化 任 务 类 型:",@"细化任务类型(其他):",@"专                    业 :",@"任    务    标    题 :",@"任    务    内    容 :",@"现    场    情    况 :",@"来                    源 :",@"错    误    类    型 :",@"错 误 类 型(其他):",@"处    理    部    门 :",@"处  理  人  角  色 :",@"工    单    状    态 :",@"工 单 受 理 时 间:",@"发        起        人 :",@"执        行        人 :", nil];
            
            _showMoreTitleArray = [[NSArray alloc] initWithObjects:@"本  地  网  名  称 :",@"区域或班组名称 :",@"工    单    时    限 :",@"工 单 归 档 时 间:",@"文                    号 :",@"任 务 位 置 经 度:",@"任 务 位 置 纬 度:",@"难    度    等    级 :",@"经    验    耗    时 :",@"积                    分 :",@"需    要    人    数 :",@"技    能    要    求 :",@"紧    急    程    度 :",@"处    理    结    果 :", nil];

        }
            break;
            
        case 8:
        {
            sectionArray0 = [NSArray arrayWithObjects:@"适 用 场 景 类 型:",@"工    单    编    号 :",@"名                    称 :",@"工  单  申  请  人 :",@"一    级    类    别 :",@"二    级    类    别 :",@"受    派    人（组):",@"任 务 开 始 时 间:",@"任 务 结 束 时 间:",@"任    务    描    述 :",@"任    务    状    态 :", nil];
           
        }
            break;

        default:
            break;
    }
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (NSString *str in sectionArray0) {
        NSMutableParagraphStyle *paragarph = [[NSMutableParagraphStyle alloc] init];
        paragarph.alignment = NSTextAlignmentJustified;
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15],NSParagraphStyleAttributeName:paragarph,NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)}];
        [array addObject:attributeString];
    }
    
    _titleArray = [[NSMutableArray alloc] initWithObjects:sectionArray0, nil];
}

#pragma mark -- tableView
- (void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -32, kScreenWidth, kScreenHeight + 32) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}

- (void)createTableViewFooterView
{
    CGFloat height = 0.0f;
    if (_imageArray.count != 0) {
        height = 112 + (_imageArray.count - 1)/3 * 74;
    }
    _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height + 40)];
    
    UIButton * showMoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showMoreButton.frame = CGRectMake(30, _footerView.frame.size.height - 34, kScreenWidth - 60, 30);
    [showMoreButton setTitle:@"显示更多" forState:UIControlStateNormal];
    [showMoreButton setTitle:@"收起" forState:UIControlStateSelected];
    [showMoreButton setTitleColor:[UIColor colorWithRed:23/255.0 green:134/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [showMoreButton addTarget:self action:@selector(showMoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    showMoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_footerView addSubview:showMoreButton];
    
    if (height < 1) {
        return;
    }
    //创建collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(75, 64);
    layout.minimumLineSpacing = 18;
    layout.minimumInteritemSpacing  = 10;
    layout.sectionInset = UIEdgeInsetsMake(20, 24, 10, 18);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, height) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[YZImageCollectionViewCell class] forCellWithReuseIdentifier:@"image"];
    [_footerView addSubview:_collectionView];

}

#pragma mark -- 点击显示更多
- (void)showMoreButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_titleArray addObject:_showMoreTitleArray];
        [_tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
        
    }else {
        [_titleArray removeLastObject];
        [_tableView deleteSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -- collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
    cell.button_delete.hidden = YES;
    NSURL *imageUrl = [NSURL URLWithString:_imageArray[indexPath.item]];
    [cell.imageView_upImage sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"等待图片"]];
    
    return cell;
}

#pragma mark -- 显示图片
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
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
        photoBrowserVc.imageArray = _imageArray;
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

#pragma mark -- tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [_titleArray objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZResourcesInfoDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[YZResourcesInfoDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.label_title.frame = CGRectMake(10, 9, 120, 22);
        cell.label_title.numberOfLines =  1;
        [cell.label_title setAdjustsFontSizeToFitWidth:YES];

    }
    CGFloat height = [_heightArray[indexPath.section][indexPath.row] floatValue];
    cell.label_title.text = _titleArray[indexPath.section][indexPath.row];
    cell.label_detail.frame = CGRectMake(130, 8, self.view.frame.size.width - 140, height);
    cell.label_detail.text = _dataArray[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark -- 区尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_showMoreTitleArray.count == 0) {
        return 0;
    }
    
    if (section == 0) {
        return _footerView;
    }
    
    return nil;
}

#pragma mark -- 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [_heightArray[indexPath.section][indexPath.row] floatValue];
    return height + 14;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //如果没有显示更多,则不显示
    if (_showMoreTitleArray.count == 0) {
        return 0;
    }
    
    if (_footerView == nil) {
        [self createTableViewFooterView];
    }
    
    if (section == 0) {
        return _footerView.frame.size.height;
    }
    
    return 0;
}

#pragma mark -- 计算文字的高度
- (CGFloat)calculateTextHeight:(NSString *)text textWidth:(CGFloat)width textFont:(UIFont *)font
{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return ceilf(rect.size.height);
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
