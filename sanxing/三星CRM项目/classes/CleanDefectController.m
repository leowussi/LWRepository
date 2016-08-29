//
//  CleanDefectController.m
//  三星CRM项目
//
//  Created by yufeng Zhu on 15/7/20.
//  Copyright (c) 2015年 ZYF. All rights reserved.
//

#import "CleanDefectController.h"
#import "BusinessCell.h"
#import "MBProgressHUD+MJ.h"
#import "ZYFDisplayCols.h"
#import "ZYFUrlTask.h"
#import "ZYFHttpTool.h"
#import "ZYFMapView.h"
#import "PostPhotoController.h"
#import "ZYFMapController.h"
#import "DownPhotoController.h"


@interface CleanDefectController () <MapControllerDelegate>
//消缺明细数据
@property (nonatomic,strong) NSArray *cleanData;

@property (nonatomic,strong) ZYFDisplayCols *displayCols;

@end

@implementation CleanDefectController

-(void)loadView
{
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"消缺明细"];
    
    [self getDataFromServer];
    //    [self setFooterView];
}

-(void)setFooterView
{
//    ZYFMapView *mapView = [[ZYFMapView alloc]init];
//    self.tableView.tableFooterView = mapView;
}



-(void)getDataFromServer
{
    [MBProgressHUD showMessage:nil toView:self.view ];
    
    NSString *urlStr = kCleanDefect;
    NSString *ID = @"";
    for (ZYFAttributes *attr in self.saleList.attrArray) {
        if ([attr.myKey isEqualToString:@"new_operation_fault_detailsid"]) {
            ID = attr.lookUp.Id;
        }
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?page=1&id=%@",urlStr,self.saleList.Id];
    //    NSString *urlString = [NSString stringWithFormat:@"%@?page=1&id=%@",urlStr,ID];
    //    NSString *urlString = [NSString stringWithFormat:@"%@?page=1&id=35BA5C72-AD0C-493F-9EAA-09F9AD6C3B0B",urlStr];
    
    
    //    NSLog(@"urlString == %@",urlString);
    
    [ZYFHttpTool getWithURLCache:urlString params:nil success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.cleanData = json;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cleanDefect";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ZYFSaleList *sale = [self.cleanData firstObject];
    NSString *deviceTypeStr = @"";
    NSString *addressStr = @"";
    
    for (ZYFAttributes *attr in sale.attrArray) {
        if ([attr.myKey isEqualToString:@"new_devicetype"]) {
            //设备类型
            if (attr.pickList.value) {
                deviceTypeStr = [self getValueString:attr sale:sale];
            }
        }
        if ([attr.myKey isEqualToString:@"new_ammeter_install_position"]) {
            //地址
            addressStr = [self getValueString:attr sale:sale];
        }
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"上传照片";
        cell.detailTextLabel.text = deviceTypeStr;
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"查看照片";
        cell.detailTextLabel.text = addressStr;
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"地址";
        cell.detailTextLabel.text = addressStr;
    }
    
    return cell;
}

-(NSString*)getValueString:(ZYFAttributes*)attr sale:(ZYFSaleList* )sale
{
    NSString *resultString = @"";
    
    if (attr.myValueString) {
        resultString = attr.myValueString;
    }else if(attr.lookUp){
        resultString = attr.lookUp.Name;
    }else if (attr.pickList){
        //如果是picklist类型，从formattedValue中（格式化后的）来显示
        for (ZYFFormattedValue *format in sale.formatValueArray) {
            if (format.myKey == NULL) {
                break ;
            }else{
                if ([format.myKey isEqualToString:attr.myKey]) {
                    resultString = format.myValueString;
                }
            }
        }
    }else{
        //如果是date类型，从formattedValue中（格式化后的）来显示
        for (ZYFFormattedValue *format in sale.formatValueArray) {
            if (format.myKey == NULL) {
                break;
            }else{
                if ([format.myKey isEqualToString:attr.myKey]) {
                    resultString= format.myValueString;
                }
            }
        }
    }
    return resultString;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        //上传照片
        PostPhotoController *ctrl = [[PostPhotoController alloc]init];
        ctrl.cleanTaskId = self.saleList.Id;
        NSString *urlStr = kUploadPhoto;
        NSString *urlString = [NSString stringWithFormat:@"%@?action=task&id=%@",urlStr,self.saleList.Id];
        ctrl.urlString = urlString;
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }else if (indexPath.row == 1){
        DownPhotoController *ctrl = [[DownPhotoController alloc]init];
        ctrl.cleanTaskId = self.saleList.Id;
        NSString *url = kDownloadPhoto;
        NSString *urlString = [NSString stringWithFormat:@"%@?id=%@",url,self.saleList.Id];
        ctrl.urlString = urlString;
        [self.navigationController pushViewController:ctrl animated:YES];
    }else if (indexPath.row == 2){
        //地址
        //如果点击了地址
        ZYFSaleList *sale = [self.cleanData firstObject];
        
        ZYFMapController *ctrl = [[ZYFMapController alloc]init];
        ctrl.delegate = self;
        ctrl.sale = sale;
        ctrl.text = [self getPositionCellString];
        for (ZYFAttributes *attr in sale.attrArray) {
            if ([attr.myKey isEqualToString:@"new_longitude"]) {
                //经度
                ctrl.longitude = [attr.myValueString floatValue];
            }else if ([attr.myKey isEqualToString:@"new_latitude"]){
                //纬度
                ctrl.latitude = [attr.myValueString floatValue];
            }
        }
        [self.navigationController pushViewController:ctrl animated:YES];
        
    }
}

-(NSString *)getPositionCellString
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell.detailTextLabel.text;
}

#pragma  mark -- MapControllerDelegate
-(void)mapController:(ZYFMapController *)ctrl updateAdress:(NSString *)address
{
    [self getPositionCellString];
}


@end
