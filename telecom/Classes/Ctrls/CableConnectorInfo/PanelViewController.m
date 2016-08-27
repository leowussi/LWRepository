//
//  PanelViewController.m
//  TestScrollPanel
//
//  Created by liuyong on 15/6/8.
//  Copyright (c) 2015年 liuyong. All rights reserved.
//

#define WIDTH  self.view.bounds.size.width
#define HEIGHT self.view.bounds.size.height
#define colNum  12
#define kSpace  5
#define kRadius 100

#define kCheckLabelNum   4
#define kLeadingSpace    5

#define ying_lian_jie [UIColor colorWithRed:229/255.0f green:75/255.0f blue:163/255.0f alpha:1.0f]
#define guan_lian     [UIColor colorWithRed:114/255.0f green:26/255.0f blue:64/255.0f alpha:1.0f]
#define tiao_jie      [UIColor colorWithRed:234/255.0f green:103/255.0f blue:62/255.0f alpha:1.0f]
#define kong_xian     [UIColor colorWithRed:180/255.0f green:225/255.0f blue:93/255.0f alpha:1.0f]

#import "PanelViewController.h"
#import "SSUIViewMiniMe.h"
#import "PanelModel.h"
#import "DifferentPanelsView.h"
#import "YZResourcesChangeViewController.h"

@interface PanelViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SSUIViewMiniMeDelegate,DifferentPanelsViewDelegate>
{
    UICollectionView *_panelCollectionView;
    UIView *_titleView;
    
    UIScrollView *_verticalIndexScrollView;
    UIView *_verticalIndexView;
    
    UIScrollView *_horizontalIndexScrollView;
    UIView *_horizontalIndexView;
    
    CGFloat _scaleFactor;
    
    NSMutableArray *_differentPanelsData;
    
    NSInteger _panelIndex;
    
    NSInteger _panelsNumber;
    
    NSInteger _colNum;
    NSInteger _rowNum;
    
    NSMutableArray *_terminalsNumberArray;
    NSMutableArray *_terminalsRowNumberArray;
    
    DifferentPanelsView *_diffPanelView;
    CGFloat _contentOffSetX;
    
    SSUIViewMiniMe *_ssView;
}
@end

@implementation PanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"面板图(%@)",self.rackName];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _differentPanelsData = [NSMutableArray array];
    _terminalsNumberArray = [NSMutableArray array];
    _terminalsRowNumberArray = [NSMutableArray array];
    
    
    [self addNavigationLeftButton];
    
    [self setUpCheckView];
    
    [self loadPanelInfo];
}

- (void)loadPanelInfo
{
    NSMutableDictionary *paraDict = [NSMutableDictionary dictionary];
    paraDict[URL_TYPE] = kGetCableById;
    paraDict[@"rackId"] = self.rackId;
    
    httpGET3(paraDict, ^(id result) {
        NSArray *listArray = result[@"list"];
        _panelsNumber = listArray.count;//面板块数
        
        for (NSDictionary *dict in listArray) {
            PanelModel *panelModel = [[PanelModel alloc] init];
            [panelModel setValuesForKeysWithDictionary:dict];
            
            NSMutableArray *tempArray = [NSMutableArray array];
            panelModel.connectors = tempArray;
            
            NSArray *connectorArray = dict[@"connectors"];
            NSInteger row = 0;
            if (connectorArray.count != 0) {
                row = connectorArray.count % colNum == 0 ? connectorArray.count / colNum : connectorArray.count / colNum + 1;
            }
            
            [_terminalsNumberArray addObject:@(connectorArray.count)];//每块面板上端子数
            [_terminalsRowNumberArray addObject:@(row)];//每块面板上端子行数
            
            for (NSDictionary *subDict in connectorArray) {
                ConnectorsModel *connectorModel = [[ConnectorsModel alloc] init];
                [connectorModel setValuesForKeysWithDictionary:subDict];
                [tempArray addObject:connectorModel];
            }
            [_differentPanelsData addObject:panelModel];
        }
        _panelIndex = 0;
        _rowNum = [_terminalsRowNumberArray[_panelIndex] integerValue];
        _colNum = colNum;
        
        if (_differentPanelsData.count != 0) {
            [self setUpPanelCollectionViewWithRow:_rowNum col:_colNum];
            [self setUpDifferentPanelViews];
        }
    }, ^(id result) {
        showAlert(@"连接错误，请重试");
        return;
    }, ^(id result) {
        showAlert(@"连接超时,请重试");
        return;
    });
}

- (void)setUpCheckView
{
    NSArray *wordArray = @[@"跳接",@"硬连接",@"关联",@"空闲"];
    NSArray *colorArray = @[tiao_jie,ying_lian_jie,guan_lian,kong_xian];
    
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 40)];
    _titleView.layer.borderColor = [UIColor purpleColor].CGColor;
    _titleView.layer.borderWidth = 1;
    _titleView.layer.cornerRadius = 4;
    _titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_titleView];
    
    CGFloat colorLabelWidth = ((WIDTH - ((kCheckLabelNum*2+1)*kLeadingSpace)))/4 * 0.4;
    CGFloat wordLabelWidth = ((WIDTH - ((kCheckLabelNum*2+1)*kLeadingSpace)))/4 * 0.6;
    for (int i=0; i<4; i++) {
        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeadingSpace + (colorLabelWidth+wordLabelWidth+2*kLeadingSpace)*i, 10, colorLabelWidth, 20)];
        colorLabel.backgroundColor = colorArray[i];
        [_titleView addSubview:colorLabel];
        
        UILabel *wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeadingSpace+colorLabelWidth+kLeadingSpace+(colorLabelWidth+wordLabelWidth+2*kLeadingSpace)*i, 10, wordLabelWidth, 20)];
        wordLabel.text = wordArray[i];
        wordLabel.font = [UIFont systemFontOfSize:13];
        [_titleView addSubview:wordLabel];
    }
}

- (void)setUpPanelCollectionViewWithRow:(NSInteger)row col:(NSInteger)col
{
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    layOut.sectionInset = UIEdgeInsetsMake(kSpace, kSpace, kSpace, kSpace);
    layOut.minimumInteritemSpacing = kSpace;
    layOut.minimumLineSpacing = kSpace;
    layOut.itemSize = CGSizeMake(kRadius, kRadius);
    
    _panelCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, col*kRadius+kSpace*(col+1), kRadius*row+kSpace*(row+1)) collectionViewLayout:layOut];
    _panelCollectionView.backgroundColor = [UIColor whiteColor];
    _panelCollectionView.delegate = self;
    _panelCollectionView.dataSource = self;
    _panelCollectionView.scrollEnabled = NO;
    [_panelCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuseId"];
    
    _ssView = [[SSUIViewMiniMe alloc] initWithView:_panelCollectionView withRatio:15];
    _ssView.frame = CGRectMake(25, 129, self.view.bounds.size.width-25, self.view.bounds.size.height-129);
    
    _ssView.delegate = self;
    [self.view addSubview:_ssView];
    
    _horizontalIndexScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(_titleView.frame), WIDTH-25, 25)];
    _horizontalIndexScrollView.delegate = self;
    _horizontalIndexScrollView.backgroundColor = [UIColor whiteColor];
    _horizontalIndexScrollView.showsHorizontalScrollIndicator = NO;
    _horizontalIndexScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_horizontalIndexScrollView];
    
    [self layoutHorientalIndexViewWith:_ssView.bounds.size.width andRow:1 col:col];
    
    _verticalIndexScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 129, 25, HEIGHT - 129)];
    _verticalIndexScrollView.delegate = self;
    _verticalIndexScrollView.backgroundColor = [UIColor whiteColor];
    _verticalIndexScrollView.showsHorizontalScrollIndicator = NO;
    _verticalIndexScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_verticalIndexScrollView];
    
    [self layoutVeritalIndexViewWith:_panelCollectionView.bounds.size.height*0.235 andRow:row col:1];
}

- (void)layoutHorientalIndexViewWith:(CGFloat)width andRow:(NSInteger)row col:(NSInteger)col
{
    for (UIView *subView in _horizontalIndexScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    _horizontalIndexView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, _horizontalIndexScrollView.bounds.size.height)];
    _horizontalIndexView.backgroundColor = [UIColor lightGrayColor];
    [_horizontalIndexScrollView addSubview:_horizontalIndexView];
    
    
    CGFloat indexWidth = width / col;
    for (int i=0; i<col; i++) {
        UILabel *indexLabel = [[UILabel alloc] initWithFrame:CGRectMake((indexWidth)*i, 0, indexWidth, 25)];
        indexLabel.textColor = [UIColor whiteColor];
        indexLabel.text = [NSString stringWithFormat:@"%d",i+1];
        indexLabel.textAlignment = NSTextAlignmentCenter;
        indexLabel.font = [UIFont systemFontOfSize:14.0f];
        [_horizontalIndexView addSubview:indexLabel];
    }
}

- (void)layoutVeritalIndexViewWith:(CGFloat)height andRow:(NSInteger)row col:(NSInteger)col
{
    for (UIView *subView in _verticalIndexScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    _verticalIndexView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _verticalIndexScrollView.bounds.size.width,height)];
    _verticalIndexView.backgroundColor = [UIColor lightGrayColor];
    [_verticalIndexScrollView addSubview:_verticalIndexView];
    
    
    CGFloat indexHeight = height / row;
    for (int i=0; i<row; i++) {
        UILabel *verticalIndexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, indexHeight*i, 25, indexHeight)];
        verticalIndexLabel.textColor = [UIColor whiteColor];
        verticalIndexLabel.text = [NSString stringWithFormat:@"%d",i+1];
        verticalIndexLabel.textAlignment = NSTextAlignmentCenter;
        verticalIndexLabel.font = [UIFont systemFontOfSize:14.0f];
        [_verticalIndexView addSubview:verticalIndexLabel];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    PanelModel *model = _differentPanelsData[_panelIndex];
    return model.connectors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"reuseId";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, kRadius, kRadius)];
    }
    
    PanelModel *panelModel = _differentPanelsData[_panelIndex];
    ConnectorsModel *connectorModel = panelModel.connectors[indexPath.item];
    NSString *status = connectorModel.assocStatus;
    if (status != nil && [status isEqualToString:@"硬连接"]) {
        cell.backgroundColor = ying_lian_jie;
    }else if (status != nil && [status isEqualToString:@"关联"]){
        cell.backgroundColor = guan_lian;
    }else if (status != nil && [status isEqualToString:@"跳接"]){
        cell.backgroundColor = tiao_jie;
    }else{
        cell.backgroundColor = kong_xian;
    }
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 2, cell.contentView.bounds.size.width, 10)];
    label1.text = connectorModel.connInfo;//端子拼装名称
    label1.font = [UIFont systemFontOfSize:10];
    label1.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 14, cell.contentView.bounds.size.width, 10)];
    label2.font = [UIFont systemFontOfSize:10];
    label2.text = connectorModel.cableName;//所属光缆
    label2.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:label2];
    
    if (connectorModel.fiberNo) {
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 26, cell.contentView.bounds.size.width, 26)];
        label3.text = [NSString stringWithFormat:@"光纤序号:%d\n链路状态:%@",connectorModel.fiberNo,connectorModel.serviceStatus];//光纤序号
        label3.font = [UIFont systemFontOfSize:10];
//        label3.adjustsFontSizeToFitWidth = YES;
        label3.numberOfLines = 0;
        label3.textColor = [UIColor whiteColor];
        [cell.contentView addSubview:label3];
    }
    
    
    CGRect bounds;
    if (![connectorModel.jumpConnInfo isEqualToString:@""]) {
        bounds = [connectorModel.jumpConnInfo boundingRectWithSize:CGSizeMake(cell.contentView.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.0f]} context:nil];
    }
    
    if (![connectorModel.portInfo isEqualToString:@""]) {
        bounds = [connectorModel.portInfo boundingRectWithSize:CGSizeMake(cell.contentView.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.0f]} context:nil];
    }
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, cell.contentView.bounds.size.width, bounds.size.height)];
    label4.numberOfLines = 0;
    label4.lineBreakMode = NSLineBreakByCharWrapping;
    label4.font = [UIFont systemFontOfSize:10.0f];
    label4.textColor = [UIColor whiteColor];
    if (![connectorModel.jumpConnInfo isEqualToString:@""]) {
        label4.text = connectorModel.jumpConnInfo;//跳接端子
    }
    
    if (![connectorModel.portInfo isEqualToString:@""]) {
        label4.text = connectorModel.portInfo;//关联设备端口
    }
    
    [cell.contentView addSubview:label4];
    
    CGRect labelBounds = [connectorModel.abName boundingRectWithSize:CGSizeMake(cell.contentView.bounds.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10.0f]} context:nil];
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label4.frame)-2, cell.contentView.bounds.size.width, labelBounds.size.height)];
    label5.text = connectorModel.abName;//链路编号
    label5.font = [UIFont systemFontOfSize:10];
    label5.numberOfLines = 0;
    label5.lineBreakMode = NSLineBreakByCharWrapping;
    label5.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:label5];
    
    //校正按钮
    UIButton *jiaoZhengButton = [UIButton buttonWithType:UIButtonTypeSystem];
    jiaoZhengButton.frame = CGRectMake(cell.frame.size.width - 13, cell.frame.size.height - 13, 11, 11);
    [jiaoZhengButton setBackgroundImage:[UIImage imageNamed:@"资源矫正"] forState:UIControlStateNormal];
    [jiaoZhengButton addTarget:self action:@selector(jiaoZhengButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:jiaoZhengButton];
    return cell;
}
#pragma mark -- 校正按钮被点击
- (void)jiaoZhengButtonClicked:(UIButton *)sender
{
    NSLog(@"校正按钮被点击");
    PanelModel *panelModel = _differentPanelsData[_panelIndex];
    ConnectorsModel *connectorModel = panelModel.connectors[sender.tag];
    YZResourcesChangeViewController *resourcesChangeVC = [[YZResourcesChangeViewController alloc] init];
    resourcesChangeVC.resources_id = [NSString stringWithFormat:@"%d",connectorModel.panelId];
    NSLog(@"%d",connectorModel.panelId);
    resourcesChangeVC.resources_type = @"3-2";
    resourcesChangeVC.resources_sceneId = @"3";
    [self.navigationController pushViewController:resourcesChangeVC animated:YES];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_ssView enlargeAction];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canFocusItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGPoint)collectionView:(UICollectionView *)collectionView targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    UIPanGestureRecognizer *pan = collectionView.panGestureRecognizer;
    CGPoint point = [pan
                     locationInView:collectionView];
    return point;
}

- (void)setUpDifferentPanelViews
{
    _diffPanelView = [[DifferentPanelsView alloc] initWithFrame:CGRectMake(0, HEIGHT-70, WIDTH, 70) withDataArray:_differentPanelsData];
    _diffPanelView.backgroundColor = [UIColor colorWithRed:230/255.0f green:240/255.0f blue:240/255.0f alpha:1.0f];
    _diffPanelView.showsHorizontalScrollIndicator = YES;
    _diffPanelView.showsVerticalScrollIndicator = NO;
    _diffPanelView.contentSize = CGSizeMake(_panelsNumber*55+5, 0);
    _diffPanelView.delegate = self;
    [self.view addSubview:_diffPanelView];
    
    if (_contentOffSetX) {
        CGPoint contentOff = _diffPanelView.contentOffset;
        contentOff.x = _contentOffSetX;
        _diffPanelView.contentOffset = contentOff;
    }
}

- (void)switchPanelFrom:(NSInteger)from to:(NSInteger)to
{
    NSLog(@"from--%ld,to--%ld",(long)from,(long)to);
    
    _contentOffSetX = _diffPanelView.contentOffset.x;

    _panelIndex = to;
    
    for (__strong UIView *view in self.view.subviews) {
        [view removeFromSuperview];
        view = nil;
    }
    
    
    [self setUpCheckView];
    
    _rowNum = [_terminalsRowNumberArray[_panelIndex] integerValue];
    _colNum = colNum;
    [self setUpPanelCollectionViewWithRow:_rowNum col:12];
    
    [self setUpDifferentPanelViews];
}

- (void)enlargedView:(SSUIViewMiniMe *)enlargedView didEndZoom:(UIScrollView *)scrollView
{
    enlargedView.miniMe.hidden = YES;
}

- (void)enlargedView:(SSUIViewMiniMe *)enlargedView didScroll:(UIScrollView *)scrollView
{
    enlargedView.miniMe.hidden = NO;
    
    NSLog(@"%f,%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    CGPoint contentOffVertical = _verticalIndexScrollView.contentOffset;
    contentOffVertical.y = scrollView.contentOffset.y;
    _verticalIndexScrollView.contentOffset = contentOffVertical;
    
    CGPoint contentOffHoriental = _horizontalIndexScrollView.contentOffset;
    contentOffHoriental.x = scrollView.contentOffset.x;
    _horizontalIndexScrollView.contentOffset = contentOffHoriental;
}

- (void)enlargedView:(SSUIViewMiniMe *)enlargedView didEndDragging:(UIScrollView *)scrollView
{
    enlargedView.miniMe.hidden = YES;
}

- (void)enlargedView:(SSUIViewMiniMe *)enlargedView didEndDecelerating:(UIScrollView *)scrollView
{
    enlargedView.miniMe.hidden = YES;
}

- (void)enlargedView:(SSUIViewMiniMe *)enlargedView didZoom:(UIScrollView *)scrollView
{
    enlargedView.miniMe.hidden = NO;
    _scaleFactor = scrollView.zoomScale;
    NSLog(@"_scaleFactor--%f",_scaleFactor);
    
    CGFloat x = _panelCollectionView.bounds.size.width * _scaleFactor;
    CGFloat y = _panelCollectionView.bounds.size.height * _scaleFactor;
    
    NSLog(@"X--%f,Y--%f",x,y);
    
    [self layoutHorientalIndexViewWith:x andRow:1 col:12];
    [self layoutVeritalIndexViewWith:y andRow:_rowNum col:1];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews.firstObject;
}

#pragma mark - addNavigationLeftButton
- (void)addNavigationLeftButton
{
    UIImage *navImg = [UIImage imageNamed:@"back_btn"];
    UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
    leftButton.frame = CGRectMake(0,0,44,44);
    [leftButton setImage:[navImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

- (void)leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
