//
//  AccessoryListModel.h
//  telecom
//
//  Created by SD0025A on 16/4/5.
//  Copyright © 2016年 ZhongYun. All rights reserved.
//

#import "JSONModel.h"

@interface AccessoryListModel :JSONModel
@property (nonatomic,copy) NSString *attachmentName;//附件名称
@property (nonatomic,copy) NSString *attachmentType;//附件类型
@property (nonatomic,copy) NSString *uploadTime;//上传时间
@property (nonatomic,copy) NSString *uploadUserName;//上传人
@property (nonatomic,copy) NSString *attachmentDes;//描述
@property (nonatomic,assign) int isDelete;
@property (nonatomic,strong) NSString *attachmentId;
- (CGFloat)configHeight;
@end
/*

 attachmentName
 attachmentType
 uploadTime
 uploadUserName
  attachmentDes
 isDelete
 */