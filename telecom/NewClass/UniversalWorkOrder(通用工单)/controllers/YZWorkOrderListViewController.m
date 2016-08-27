//
//  YZWorkOrderListViewController.m
//  telecom
//
//  Created by 锋 on 16/6/13.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "YZWorkOrderListViewController.h"
#import "YZWorkOrderListCollectionViewCell.h"
#import "MJRefresh.h"
#import "YZWorkOrderDetailViewController.h"

@interface YZWorkOrderListViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    YZInDicatorView *_inDicatorView;
    
    UILabel *_label_title;
    NSMutableAttributedString *_textString;
    //数据源数组
    NSMutableArray *_dataArray;
    
    //下拉刷新
    MJRefreshHeaderView *_refreshHeader;
    MJRefreshFooterView *_refreshFooter;
    NSInteger _nextPage;
}
@end

@implementation YZInDicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:216/255.0 green:240/255.0 blue:1 alpha:1].CGColor);
    CGContextMoveToPoint(context, 0, 6);
    CGContextAddLineToPoint(context, 10, 0);
    CGContextAddLineToPoint(context, 10, 12);
    CGContextAddLineToPoint(context, 0, 6);
    CGContextFillPath(context);
}

@end

@implementation YZWorkOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.65];
    _inDicatorView = [[YZInDicatorView alloc] initWithFrame:CGRectMake(45, _inDicatorLocation.y, 12, 12)];
    _inDicatorView.layer.cornerRadius = 4;
    _inDicatorView.layer.masksToBounds = NO;
    [self.view addSubview:_inDicatorView];
    
    [self createCollectionView];
    [self mjRefresh];
    
}

#pragma mark -- 下拉刷新
- (void)dealloc
{
    [_refreshHeader free];
    [_refreshFooter free];
}

- (void)mjRefresh
{
    _refreshHeader = [MJRefreshHeaderView header];
    _refreshHeader.scrollView = _collectionView;
    [_refreshHeader beginRefreshing];
    __weak YZWorkOrderListViewController *selfVC = self;
    __block NSInteger nextPage = _nextPage;
    _refreshHeader.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        nextPage = 1;
        [selfVC loadDataWithNextPage:nextPage pageSize:10];
    };
    
    
    _refreshFooter = [MJRefreshFooterView footer];
    _refreshFooter.scrollView = _collectionView;
    _refreshFooter.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView)
    {
        nextPage ++;
        [selfVC loadDataWithNextPage:nextPage pageSize:10];
    };
    
}

#pragma mark --- set方法
- (void)setWorkOrderTitle:(NSString *)workOrderTitle
{
    _workOrderTitle = workOrderTitle;
    _label_title.text = workOrderTitle;
    
}

- (void)setInDicatorLocation:(CGPoint)inDicatorLocation
{
    _inDicatorView.center = CGPointMake(_inDicatorView.center.x, inDicatorLocation.y);
    _inDicatorLocation = inDicatorLocation;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(workOrderListViewControllerWillDisappear)]) {
        [_delegate workOrderListViewControllerWillDisappear];
    }
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}


#pragma mark -- 加载数据
- (void)loadDataWithNextPage:(NSInteger)nextPage pageSize:(NSInteger)pageSize
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];

    paraDict[URL_TYPE] = @"commonBill/QueryCommBillList";
    
    //搜索条件
    NSDictionary *conditionDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"WorkOrderSiftCondition"];
    
    if ([conditionDict objectForKey:@"conditionList0"] && ![[conditionDict objectForKey:@"conditionList0"] isEqualToString:@"选择"]) {
        paraDict[@"startTime"] = [NSString stringWithFormat:@"%@ 00:00:00",[conditionDict objectForKey:@"conditionList0"]];
    }
    
    if ([conditionDict objectForKey:@"conditionList1"] && ![[conditionDict objectForKey:@"conditionList0"] isEqualToString:@"选择"]) {
        paraDict[@"endTime"] = [NSString stringWithFormat:@"%@ 00:00:00",[conditionDict objectForKey:@"conditionList1"]];
    }
    NSArray *array = @[@"全部",@"故障单",@"业务开通单",@"风险操作工单",@"作业计划",@"指挥任务单",@"随工单",@"资源变更工单",@"请求支撑单"];
   
    NSString *billType = [_workOrderTitle componentsSeparatedByString:@"("][0];
    NSInteger billTypeId = [array indexOfObject:billType];
    paraDict[@"billType"] = [NSString stringWithFormat:@"%d",billTypeId];
    
    paraDict[@"orgId"] = [conditionDict objectForKey:@"orgId"];
    paraDict[@"userName"] = [conditionDict objectForKey:@"conditionList4"];
    
    paraDict[@"status"] = ![[conditionDict objectForKey:@"conditionList5"] isEqualToString:@"-3"] ? [conditionDict objectForKey:@"conditionList5"] : nil;
    
    //--------
    
    paraDict[@"billId"] = _billId;
    paraDict[@"curPage"] = @(nextPage);
    paraDict[@"pageSize"] = @(10);
    NSLog(@"%@",paraDict);
    httpPOST(paraDict, ^(id result) {
        [_refreshHeader endRefreshing];
        [_refreshFooter endRefreshing];
        NSLog(@"%@",result);
        UIFont *font = [UIFont systemFontOfSize:13];
        if (nextPage == 1) {
            [_dataArray removeAllObjects];
        }
        NSArray *listArray = [result objectForKey:@"list"];
        for (NSDictionary *dict in listArray) {
             YZWorkOrderList *list = [[YZWorkOrderList alloc] initWithParserDictionary:dict withFont:font width:kScreenWidth - 130 billTypeId:billTypeId];
            [_dataArray addObject:list];
        }
        [_collectionView reloadData];
        
    }, ^(id result) {
        [_refreshHeader endRefreshing];
        [_refreshFooter endRefreshing];
        NSLog(@"%@",result);
    });

}

- (void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(kScreenWidth - 90, 120);
    layout.sectionInset = UIEdgeInsetsMake(2, 10, 10, 10);

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(55, 32, kScreenWidth - 70, kScreenHeight - 64) collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    _collectionView.layer.cornerRadius = 4;
    _collectionView.backgroundColor = [UIColor colorWithRed:216/255.0 green:240/255.0 blue:1 alpha:1];
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[YZWorkOrderListCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    _label_title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _collectionView.frame.size.width, 40)];
    _label_title.textAlignment = NSTextAlignmentCenter;
    _label_title.font = [UIFont systemFontOfSize:15];
    _label_title.text = _workOrderTitle;
    [_collectionView addSubview:_label_title];
    
    
}

#pragma mark -- collectionView代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZWorkOrderListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    YZWorkOrderList *list = _dataArray[indexPath.row];
    cell.label_workOrderId.text = list.billNo;
    cell.label_status.text = list.status;
    cell.label_createTime.text = list.createTime;
    
    [cell.label_detail setAttributedText:list.billContent];
    [cell updateWorkOrderIdLabelHeight:list.height_billNo detailLabelHeight:list.height_billContent];
    return cell;
}

#pragma mark -- 选中单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZWorkOrderList *list = _dataArray[indexPath.row];
    
    if (_delegate && [_delegate respondsToSelector:@selector(workOrderListViewController:workOrderDidSelected:)]) {
        [_delegate workOrderListViewController:self workOrderDidSelected:list];
    }

}

#pragma mark -- 设置item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return section == 0 ? CGSizeMake(_collectionView.frame.size.width, 40) : CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YZWorkOrderList *list = _dataArray[indexPath.row];
    return CGSizeMake(kScreenWidth - 90, list.height_billContent + 62);
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
