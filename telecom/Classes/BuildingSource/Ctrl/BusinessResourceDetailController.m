//
//  BusinessResourceDetailController.m
//  telecom
//
//  Created by SD0025A on 16/7/4.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "BusinessResourceDetailController.h"
#import "BusinessResourceDetailCell.h"  //五类线宽带
#import "BusinessResouceGQCell.h"  //光纤宽带
#import "BusinessResouceIPMANCell.h" //IPMAN       光分纤箱
#import "BusinessResouceIPMANGJJXCell.h"//IPMAN    光交接箱
#import "BusinessResouceZYSWTwo.h" //专用上网       光分纤箱
#import "BusinessResourceModel.h"

#define BusinessResourceDetailUrl   @"house/GetBusinessResList"

@interface BusinessResourceDetailController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *table;
@property (nonatomic,strong) NSMutableArray *dataArray;
@end

@implementation BusinessResourceDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self downloadData];
}
- (void)downloadData
{
    [self.dataArray removeAllObjects];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[URL_TYPE] = BusinessResourceDetailUrl;
    params[@"deviceId"] = self.deviceId;
    params[@"deviceType"] =self.deviceType;
    httpGET2(params, ^(id result) {
       // NSLog(@"%@",result);
        NSArray *array = result[@"list"];
        self.dataArray = [BusinessResourceModel arrayOfModelsFromDictionaries:array error:nil];
        [self.table reloadData];
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
}
- (NSMutableArray *)dataArray
{
    if (nil == _dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)createUI
{
    self.navigationItem.title = @"业务资源详细";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, APP_W, APP_H- 64) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.table];
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BusinessResourceModel *model = self.dataArray[indexPath.row];
    switch (self.viewTag) {
        case 11:{
            return [self configWLXHeight:model];
        }
            break;
        case 12:{
            return [self configGXKDHeight:model];
        }
            break;
        case 13:{
            return [self configWLXHeight:model];
        }
            break;
        case 14:{
            if ([model.deviceType isEqualToString:@"光分纤箱"]) {
                return [self configIPMANGFHeight:model];
            }else{
                return [self configIPMANGXHeight:model];
            }
        }
            break;
        case 15:{
            if ([model.deviceType isEqualToString:@"OBD"]) {
                return [self configGXKDHeight:model];
            }else{
                return [self configZWSWGFHeight:model];
            }
            
        }
            break;
        case 21:{
            if ([model.deviceType isEqualToString:@"光分纤箱"]) {
                return [self configIPMANGFHeight:model];
            }else{
                return [self configIPMANGXHeight:model];
            }
        }
            break;
        case 22:{
            if ([model.deviceType isEqualToString:@"光分纤箱"]) {
                return [self configIPMANGFHeight:model];
            }else{
                return [self configIPMANGXHeight:model];
            }

        }
        case 23:{
            return [self configGXKDHeight:model];
        }
        case 24:{
             return [self configWLXHeight:model];
        }
            break;
        case 31:{
            if ([model.deviceType isEqualToString:@"光分纤箱"]) {
                return [self configIPMANGFHeight:model];
            }else{
                return [self configIPMANGXHeight:model];
            }
        }
            break;
        case 32:{
            if ([model.deviceType isEqualToString:@"光分纤箱"]) {
                return [self configIPMANGFHeight:model];
            }else{
                return [self configIPMANGXHeight:model];
            }
        }
            break;
            
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    BusinessResourceModel *model = self.dataArray[indexPath.row];
    switch (self.viewTag) {
        case 11:{
            //五类线宽带
            static NSString *cellId = @"businessResourceDetailCell";
           BusinessResourceDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (nil == cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResourceDetailCell" owner:nil options:nil]lastObject];
            }
            cell.addressLabel.text = [NSString stringWithFormat:@"%@",self.currentAddress];
            [cell configModel:model];
            return cell;
        }

            
            break;
        case 12:{
            //光纤宽带
            static NSString *cellId = @"businessResouceGQCell";
              BusinessResouceGQCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (nil == cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResouceGQCell" owner:nil options:nil]lastObject];
            }
           cell.addressLabel.text = self.currentAddress;
            [cell configModel:model];
            return cell;
            
        }
        
            break;
        case 13:{
            //ADSL宽带
            static NSString *cellId = @"businessResourceDetailCell";
            BusinessResourceDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (nil == cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResourceDetailCell" owner:nil options:nil]lastObject];
            }
           cell.addressLabel.text = [NSString stringWithFormat:@"%@",self.currentAddress];
            [cell configModel:model];
            return cell;

        }
            
            break;
        case 14:{
            //   IPMAN  光分纤箱
            if ([model.deviceType isEqualToString:@"光分纤箱"]) {
                static NSString *cellId = @"businessResouceIPMANCell";
                BusinessResouceIPMANCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResouceIPMANCell" owner:nil options:nil]lastObject];
                }
                cell.addressLabel.text = [NSString stringWithFormat:@"%@",self.currentAddress];
                 [cell configModel:model];
                return cell;
            }else{
                //  IPMAN  光交接箱
                static NSString *cellId = @"businessResouceIPMANGJJXCell";
                BusinessResouceIPMANGJJXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"BusinessResouceIPMANGJJXCell" owner:nil options:nil]lastObject];
                }
               cell.addressLabel.text = [NSString stringWithFormat:@"%@",self.currentAddress];
                [cell configModel:model];
                return cell;
            }
        }
            
            break;
        case 15:{
            if ([model.deviceType isEqualToString:@"OBD"]) {
                //专网上网    OBD
                static NSString *cellId = @"businessResouceGQCell";
                BusinessResouceGQCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResouceGQCell" owner:nil options:nil]lastObject];
                }
                cell.addressLabel.text = [NSString stringWithFormat:@"%@",self.currentAddress];
                [cell configModel:model];
                return cell;
            }else{
                // 专网上网   光分纤箱
                static NSString *cellId = @"businessResouceZYSWTwo";
                BusinessResouceZYSWTwo * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResouceZYSWTwo" owner:nil options:nil]lastObject];
                }
                cell.addressLabel.text = [NSString stringWithFormat:@"%@",self.currentAddress];                [cell configModel:model];
                return cell;
            }
            
        }
            
            break;
        case 21:{
            //   IPMAN  光分纤箱
            if ([model.deviceType isEqualToString:@"光分纤箱"]) {
                static NSString *cellId = @"businessResouceIPMANCell";
                BusinessResouceIPMANCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResouceIPMANCell" owner:nil options:nil]lastObject];
                }
                cell.addressLabel.text = self.currentAddress;
                [cell configModel:model];
                return cell;
            }else{
                //  IPMAN  光交接箱
                static NSString *cellId = @"businessResouceIPMANGJJXCell";
                BusinessResouceIPMANGJJXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"BusinessResouceIPMANGJJXCell" owner:nil options:nil]lastObject];
                }
                cell.addressLabel.text = self.currentAddress;
                [cell configModel:model];
                return cell;
            }
        }
            
            break;
        case 22:{
            //   IPMAN  光分纤箱
            if ([model.deviceType isEqualToString:@"光分纤箱"]) {
                static NSString *cellId = @"businessResouceIPMANCell";
                BusinessResouceIPMANCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResouceIPMANCell" owner:nil options:nil]lastObject];
                }
                cell.addressLabel.text = self.currentAddress;
                [cell configModel:model];
                return cell;
            }else{
                //  IPMAN  光交接箱
                static NSString *cellId = @"businessResouceIPMANGJJXCell";
                BusinessResouceIPMANGJJXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"BusinessResouceIPMANGJJXCell" owner:nil options:nil]lastObject];
                }
                cell.addressLabel.text = self.currentAddress;
                [cell configModel:model];
                return cell;
            }
        }
            
            break;
        case 23:{
            //光电话
            static NSString *cellId = @"businessResouceGQCell";
            BusinessResouceGQCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (nil == cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResouceGQCell" owner:nil options:nil]lastObject];
            }
           cell.addressLabel.text = self.currentAddress;
            [cell configModel:model];
            return cell;
        
        }
            
            break;
        case 24:{
            static NSString *cellId = @"businessResourceDetailCell";
            BusinessResourceDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (nil == cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResourceDetailCell" owner:nil options:nil]lastObject];
            }
            cell.addressLabel.text = self.currentAddress;
            [cell configModel:model];
            return cell;
        }
            
            break;
        case 31:{
            //   IPMAN  光分纤箱
            if ([model.deviceType isEqualToString:@"光分纤箱"]) {
                static NSString *cellId = @"businessResouceIPMANCell";
                BusinessResouceIPMANCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResouceIPMANCell" owner:nil options:nil]lastObject];
                }
                cell.addressLabel.text = self.currentAddress;
                [cell configModel:model];
                return cell;
            }else{
                //  IPMAN  光交接箱
                static NSString *cellId = @"businessResouceIPMANGJJXCell";
                BusinessResouceIPMANGJJXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"BusinessResouceIPMANGJJXCell" owner:nil options:nil]lastObject];
                }
                cell.addressLabel.text = self.currentAddress;
                [cell configModel:model];
                return cell;
            }
        }
            
            break;
        case 32:{
            //   IPMAN  光分纤箱
            if ([model.deviceType isEqualToString:@"光分纤箱"]) {
                static NSString *cellId = @"businessResouceIPMANCell";
                BusinessResouceIPMANCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessResouceIPMANCell" owner:nil options:nil]lastObject];
                }
                cell.addressLabel.text = self.currentAddress;
                [cell configModel:model];
                return cell;
            }else{
                //  IPMAN  光交接箱
                static NSString *cellId = @"businessResouceIPMANGJJXCell";
                BusinessResouceIPMANGJJXCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle]loadNibNamed:@"BusinessResouceIPMANGJJXCell" owner:nil options:nil]lastObject];
                }
                cell.addressLabel.text = self.currentAddress;
                [cell configModel:model];
                return cell;
            }
        }
            
            break;
            
        default:
            break;
    }
    return nil;
}
 //计算cell的高度
- (CGFloat)configWLXHeight:(BusinessResourceModel *)model
{
    //五类线宽带
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGSize expactSize = CGSizeMake(APP_W-105, MAXFLOAT);
    CGSize size1 = [model.deviceType boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size2 = [model.deviceName boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size3 = [model.onuCode boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size4 = [model.region boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size5 = [model.site boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size6 = [model.room boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size7 = [model.roomAddress boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    CGSize size9 = [model.lifeCycle boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size10 = [model.voicePortTotal boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size11 = [model.voicePortTackup boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size12 = [model.voicePortAvailable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size13 = [model.voicePortKeep boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size14 = [model.adslPortTotal boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size15 = [model.adslPortTackup boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size16 = [model.adslPortAvailable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size17 = [model.adslPortKeep boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size18 = [model.lanPortTotal boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size19 = [model.lanPortTackup boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size20 = [model.lanPortAvailable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size21 = [model.lanPortKeep boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size22 = [model.range boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    return 165 + size1.height+size2.height+size3.height+size4.height+size5.height+size6.height+size7.height+size9.height+size10.height+size11.height+size12.height+size13.height+size14.height+ size15.height+size16.height+size17.height+size18.height+size19.height+size20.height+size21.height+size22.height;
}
- (CGFloat)configGXKDHeight:(BusinessResourceModel *)model
{
    //光纤宽带
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGSize expactSize = CGSizeMake(APP_W-105, MAXFLOAT);
    CGSize size1 = [model.deviceType boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size2 = [model.deviceName boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size3 = [model.onuCode boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size4 = [model.region boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size5 = [model.site boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size6 = [model.room boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size7 = [model.roomAddress boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    CGSize size9 = [model.obdSubType boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size10 = [model.obdGrade boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size11 = [model.obdManufactuer boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size12 = [model.obdPortTotal boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size13 = [model.obdPortAvailable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size14 = [model.obdPortTackup boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size15 = [model.obdPortKeep boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size16 = [model.obdState boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size17 = [model.oltUserfor boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size18 = [model.range boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
     return 150 + size1.height+size2.height+size3.height+size4.height+size5.height+size6.height+size7.height+size9.height+size10.height+size11.height+size12.height+size13.height+size14.height+ size15.height+size16.height+size17.height+size18.height;
}
- (CGFloat)configIPMANGFHeight:(BusinessResourceModel *)model
{
   //IPMAN  光分纤箱
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGSize expactSize = CGSizeMake(APP_W-105, MAXFLOAT);
    CGSize size1 = [model.deviceType boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size2 = [model.deviceName boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size3 = [model.region boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size4 = [model.site boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size5 = [model.room boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size6 = [model.roomAddress boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size8 = [model.gTerminalsTotal boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    CGSize size9 = [model.gTerminalsAvailable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size10 = [model.gTerminalsTakeup boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size11 = [model.gTerminalsKeep boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size12 = [model.fttoPortAvailable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size13 = [model.zwswAvaliable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size14 = [model.tjCirAvaliable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size15 = [model.range boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    return 150 + size1.height+size2.height+size3.height+size4.height+size5.height+size6.height+size8.height+size9.height+size10.height+size11.height+size12.height+size13.height+size14.height+ size15.height;
}
- (CGFloat)configIPMANGXHeight:(BusinessResourceModel *)model
{
    //IPMAN  光交接箱
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGSize expactSize = CGSizeMake(APP_W-105, MAXFLOAT);
    CGSize size1 = [model.deviceType boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size2 = [model.deviceName boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size3 = [model.region boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size4 = [model.site boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size5 = [model.room boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size6 = [model.roomAddress boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size8 = [model.gTerminalsTotal boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    CGSize size9 = [model.gTerminalsAvailable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size10 = [model.gTerminalsTakeup boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size11 = [model.gTerminalsKeep boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size12 = [model.tjCirAvaliable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size13 = [model.range boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
   
    return 130 + size1.height+size2.height+size3.height+size4.height+size5.height+size6.height+size8.height+size9.height+size10.height+size11.height+size12.height+size13.height;
}
//专网上网
- (CGFloat)configZWSWGFHeight:(BusinessResourceModel *)model
{
    //专网上网 光分纤箱
    NSDictionary *dict = @{NSFontAttributeName:[UIFont systemFontOfSize:11]};
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGSize expactSize = CGSizeMake(APP_W-105, MAXFLOAT);
    CGSize size1 = [model.deviceType boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size2 = [model.deviceName boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size3 = [model.region boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size4 = [model.site boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size5 = [model.room boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size6 = [model.roomAddress boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size8 = [model.gTerminalsTotal boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    CGSize size9 = [model.gTerminalsAvailable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size10 = [model.gTerminalsTakeup boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size11 = [model.gTerminalsKeep boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size12 = [model.fttoPortAvailable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size13 = [model.zwswAvaliable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size14 = [model.tjCirAvaliable boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    CGSize size15 = [model.range boundingRectWithSize:expactSize options:options attributes:dict context:nil].size;
    
    return 150 + size1.height+size2.height+size3.height+size4.height+size5.height+size6.height+size8.height+size9.height+size10.height+size11.height+size12.height+size13.height+size14.height+size15.height;
}
@end
