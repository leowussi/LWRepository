//
//  JumperConnectionListModel.h
//  telecom
//
//  Created by SD0025A on 16/4/14.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JSONModel.h"

@protocol JumperConnectionCellModel
@end
@interface JumperConnectionListModel : JSONModel
//headView
@property (nonatomic,copy) NSString *kind;
@property (nonatomic,copy) NSString *equipName;
@property (nonatomic,copy) NSString *roomAddr;
@property (nonatomic,strong) NSArray<JumperConnectionCellModel> * infoList;
@end

