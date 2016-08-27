//
//  HistoryData.h
//  telecom
//
//  Created by 郝威斌 on 15/6/4.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@interface HistoryData : NSObject
{
    sqlite3 *mySql;
    sqlite3 *mySql1;
}


//获取沙盒路径
-(NSString *)getDocPath;

//打开数据库
-(BOOL)initData;

//建表
-(BOOL)creatDataTable;

//增 插入数据
-(BOOL)insertData:(NSString *)name forPassWord:(int)passWord;

//删除
-(BOOL)deleteTestList:(int)rowid;

//修改 更新
-(BOOL)updataData:(NSString *)name PassWord:(int)pass Rowid:(int)rowid;

//查询
-(NSMutableArray *)selectData;
@end
