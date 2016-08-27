//
//  DifferentPanelsView.m
//  TestScrollPanel
//
//  Created by liuyong on 15/6/16.
//  Copyright (c) 2015年 liuyong. All rights reserved.
//

#define kSmallPanelSpace 1
#define kSmallRadius     3
#define kLeadingSpace    5

#define ying_lian_jie [UIColor colorWithRed:229/255.0f green:75/255.0f blue:163/255.0f alpha:1.0f]
#define guan_lian     [UIColor colorWithRed:114/255.0f green:26/255.0f blue:64/255.0f alpha:1.0f]
#define tiao_jie      [UIColor colorWithRed:234/255.0f green:103/255.0f blue:62/255.0f alpha:1.0f]
#define kong_xian     [UIColor colorWithRed:180/255.0f green:225/255.0f blue:93/255.0f alpha:1.0f]

#import "DifferentPanelsView.h"
#import "PanelModel.h"

@interface DifferentPanelsView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray *_dataArray;
    
    UIView *_selectedView;
}
@end

@implementation DifferentPanelsView

- (instancetype)initWithFrame:(CGRect)frame withDataArray:(NSMutableArray *)dataArray
{
    
    if (self = [super initWithFrame:frame]) {
      
        _dataArray = dataArray;

        for (int i=0; i<_dataArray.count; i++) {
            UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
            layOut.sectionInset = UIEdgeInsetsMake(kSmallPanelSpace, kSmallPanelSpace, kSmallPanelSpace, kSmallPanelSpace);
            layOut.minimumInteritemSpacing = kSmallPanelSpace;
            layOut.minimumLineSpacing = kSmallPanelSpace;
            layOut.itemSize = CGSizeMake(kSmallRadius, kSmallRadius);
            
                UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kLeadingSpace+(50+kLeadingSpace)*i, 5, 50, 60) collectionViewLayout:layOut];
                collectionView.backgroundColor = [UIColor whiteColor];
                collectionView.tag = 10000+i;
                collectionView.delegate = self;
                collectionView.dataSource = self;
                collectionView.scrollEnabled = NO;
                [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"resue-%d",i]];
                [self addSubview:collectionView];
                
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePanel:)];
                [collectionView addGestureRecognizer:tapGes];
            
            UILabel *indexLabel = [[UILabel alloc] initWithFrame:RECT(0, 0, collectionView.fw, collectionView.fh)];
            indexLabel.text = [NSString stringWithFormat:@"%d",i+1];
            indexLabel.font = [UIFont systemFontOfSize:30];
            indexLabel.alpha = 0.4f;
            indexLabel.textAlignment = NSTextAlignmentCenter;
            indexLabel.userInteractionEnabled = YES;
            [collectionView addSubview:indexLabel];
        }
    }
    return self;
}

- (void)choosePanel:(UITapGestureRecognizer *)ges
{
    UIView *view = ges.view;
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(switchPanelFrom:to:)]) {
        [self.delegate switchPanelFrom:_selectedView.tag-10000 to:view.tag-10000];
    }
    _selectedView = view;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger index = collectionView.tag - 10000;
    PanelModel *panelModel = _dataArray[index];
    return panelModel.connectors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = collectionView.tag - 10000;

    NSString *reuseId = [NSString stringWithFormat:@"resue-%d",index];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UICollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, kSmallRadius, kSmallRadius)];
    }
    
    PanelModel *panelModel = _dataArray[index];
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
    
    return cell;
}

@end
