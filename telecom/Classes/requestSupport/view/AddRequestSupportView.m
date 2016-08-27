//
//  AddRequestSupportView.m
//  telecom
//
//  Created by SD0025A on 16/5/25.
//  Copyright © 2016年 Telecom_Horizon. All rights reserved.
//

#import "AddRequestSupportView.h"
#import "PullDownViewInAddRequest.h"

@implementation AddRequestSupportView

- (IBAction)requestBtn:(XGW_comboboxButton *)sender {
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSDictionary *dict in self.sceneTypeList) {
        [titleArray addObject:dict[@"value"]];
    }
    
    if (self.pullViewOne) {
        self.pullViewOne.hidden = NO;
    }else{
        CGFloat height = titleArray.count*20 >150 ? 150:titleArray.count*20;
        self.pullViewOne = [[PullDownViewInAddRequest alloc] initWithFrame:CGRectMake(self.requestBtn.frame.origin.x, self.requestBtn.ey, self.requestBtn.bounds.size.width, height)];
        
        self.pullViewOne.backgroundColor = COLOR(224, 224, 224);
        self.pullViewOne.titleArray = titleArray;
        self.pullViewOne.titleBtn = self.requestBtn;
        [self.pullViewOne setLabelTitle];
        [self addSubview:self.pullViewOne];
    }
    
    
}
- (IBAction)handleServeBtn:(XGW_comboboxButton *)sender {
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSDictionary *dict in self.oneTypeList) {
        [titleArray addObject:dict[@"value"]];
    }
    
    if (self.pullViewTwo) {
        self.pullViewTwo.hidden = NO;
    }else{
        CGFloat height = titleArray.count*20 >150 ? 150:titleArray.count*20;
        self.pullViewTwo = [[PullDownViewInAddRequest alloc] initWithFrame:CGRectMake(self.handleServeBtn.frame.origin.x, self.handleServeBtn.ey, self.handleServeBtn.bounds.size.width, height)];
        
        self.pullViewTwo.backgroundColor = COLOR(224, 224, 224);
        self.pullViewTwo.titleArray = titleArray;
        self.pullViewTwo.titleBtn = self.handleServeBtn;
        [self.pullViewTwo setLabelTitle];
        [self addSubview:self.pullViewTwo];
    }
    
}
- (IBAction)handleComplaintBtn:(XGW_comboboxButton *)
sender {
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSDictionary *dict in self.twoTypeList) {
        [titleArray addObject:dict[@"value"]];
    }
    
    if (self.pullViewThree) {
        self.pullViewThree.hidden = NO;
    }else{
        CGFloat height = titleArray.count*20 >150 ? 150:titleArray.count*20;
        self.pullViewThree = [[PullDownViewInAddRequest alloc] initWithFrame:CGRectMake(self.handleComplaintBtn.frame.origin.x, self.handleComplaintBtn.ey, self.handleComplaintBtn.bounds.size.width, height)];
        
        self.pullViewThree.backgroundColor = COLOR(224, 224, 224);
        self.pullViewThree.titleArray = titleArray;
        self.pullViewThree.titleBtn = self.handleComplaintBtn;
        [self.pullViewThree setLabelTitle];
        [self addSubview:self.pullViewThree];
    }
    
}
- (IBAction)groupBtn:(XGW_comboboxButton *)sender {
    NSMutableArray *titleArray = [NSMutableArray array];
    self.personBtn.titleLabel.text = nil;
    for (NSDictionary *dict in self.orgList) {
        [titleArray addObject:dict[@"value"]];
    }
    if (self.pullViewFour) {
        self.pullViewFour.hidden = NO;
    }else{
        CGFloat height = titleArray.count*20 >150 ? 150:titleArray.count*20;
        self.pullViewFour = [[PullDownViewInAddRequest alloc] initWithFrame:CGRectMake(self.groupBtn.frame.origin.x, self.groupBtn.ey, 150, height)];
        
        self.pullViewFour.backgroundColor = COLOR(224, 224, 224);
        self.pullViewFour.titleArray = titleArray;
        self.pullViewFour.titleBtn = self.groupBtn;
        [self.pullViewFour setLabelTitle];
        [self addSubview:self.pullViewFour];
    }
    
}
- (IBAction)personBtn:(XGW_comboboxButton *)sender {
    
    if (self.personTitleArray) {
        [self.personTitleArray removeAllObjects];
    }else{
        self.personTitleArray = [NSMutableArray array];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[URL_TYPE] = @"task/SearchAccountByOrg";
    NSLog(@"%@",self.groupBtn.currentTitle);
    if ([self.source isEqualToString:@"1"]) {
        dict[@"orgId"] = @"10000820";
    }else{
        for (NSDictionary *subDict in self.orgList) {
            if ([subDict[@"value"] isEqualToString:self.groupBtn.titleLabel.text]) {
                dict[@"orgId"] = subDict[@"key"];
            }
        }
    }
    httpGET2(dict, ^(id result) {
        NSArray *array = result[@"list"];
        [self.delegate getAccountId:array];
        for (NSDictionary *dict in array) {
            [self.personTitleArray addObject:dict[@"value"]];
        }
        
        if (self.pullViewFive) {
            [self.pullViewFive removeFromSuperview];
            CGFloat height = self.personTitleArray.count*20 >150 ? 150:self.personTitleArray.count*20;
            self.pullViewFive = [[PullDownViewInAddRequest alloc] initWithFrame:CGRectMake(self.personBtn.frame.origin.x, self.personBtn.ey, self.personBtn.size.width,height)];
            
            self.pullViewFive.backgroundColor = COLOR(224, 224, 224);
            self.pullViewFive.titleArray = self.personTitleArray;
            self.pullViewFive.titleBtn = self.personBtn;
            [self.pullViewFive setLabelTitle];
            [self addSubview:self.pullViewFive];

            
        }else{
            CGFloat height = self.personTitleArray.count*20 >150 ? 150:self.personTitleArray.count*20;
            self.pullViewFive = [[PullDownViewInAddRequest alloc] initWithFrame:CGRectMake(self.personBtn.frame.origin.x, self.personBtn.ey, self.personBtn.size.width,height)];
            
            self.pullViewFive.backgroundColor = COLOR(224, 224, 224);
            self.pullViewFive.titleArray = self.personTitleArray;
            self.pullViewFive.titleBtn = self.personBtn;
            [self.pullViewFive setLabelTitle];
            [self addSubview:self.pullViewFive];
        }
        
    }, ^(id result) {
        showAlert(result[@"error"]);
    });
    
}
//开始时间
- (IBAction)beginDateBtn:(UIButton *)sender {
    
    [self.delegate choooseBeginDate];
    
}
//结束时间
- (IBAction)endDateBtn:(UIButton *)sender {
    [self.delegate choooseEndDate];
}

- (IBAction)uploadAction:(UIButton *)sender {
    [self.delegate chooseAddRequestPhoto];
    
}

@end
