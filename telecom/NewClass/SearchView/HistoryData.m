//
//  HistoryData.m
//  telecom
//
//  Created by 郝威斌 on 15/6/4.
//  Copyright (c) 2015年 ZhongYun. All rights reserved.
//

#import "HistoryData.h"
#import "HIstoryObj.h"

@implementation HistoryData

-(NSString *)getDocPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *myPath = [paths objectAtIndex:0];
    NSLog(@"沙盒路径 %@",myPath);
    
    NSString *path = [myPath stringByAppendingPathComponent:@"hao.sql"];
    NSLog(@"数据库路径 %@",path);
    
    return path;
}


//判断当前库是否可以打开
-(BOOL)initData
{
    NSString *pathForData = [self getDocPath];
    
    /*
     1. sqlite3_open(数据库文件路径，数据库); 打开数据库
     2. sqlite3_close(数据库)；   关闭数据库
     3. SQLITE_OK (可操作状态 OK)
     */
    
    if (sqlite3_open([pathForData UTF8String], &mySql) != SQLITE_OK) {
        
        sqlite3_close(mySql);
        return NO;
    }
    return YES;
}



//建表
-(BOOL)creatDataTable
{
    //声明结构语句   |   保存结果对象
    sqlite3_stmt *stmt;
    
    /*
     create table if not exists 表名 (字段1 类型, 字段2 类型, 字段3 类型)
     */
    
    //创建建立数据表的sql 语句
    NSString *creatSQL = @"create table if not exists GroupTable (Name text,PassWord int)";
    
    //准备当前数据库
    if (sqlite3_prepare_v2(mySql, [creatSQL UTF8String], -1, &stmt, nil)) {
        return NO;
    }
    
    //执行结构语句
    sqlite3_step(stmt);
    
    //释放结构语句
    sqlite3_finalize(stmt);
    return YES;
}


//插入
-(BOOL)insertData:(NSString *)name forPassWord:(int)passWord
{
    sqlite3_stmt *myStmt;
    
    //insert into 表名 (字段1,字段2)   values (?,?)
    //注意事项 sqlite3_bind_text  把实际name 值 绑定到 mystmt
    
    NSString *insertSQL = @"insert into GroupTable(Name,PassWord) values (?,?)";
    
    if (sqlite3_prepare_v2(mySql, [insertSQL UTF8String], -1, &myStmt, nil) != SQLITE_OK) {
        return NO;
    }
    
    sqlite3_bind_text(myStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(myStmt, 2, passWord);
    
    sqlite3_step(myStmt);
    
    //释放结构语句
    sqlite3_finalize(myStmt);
    return YES;
}

//删除
-(BOOL)deleteTestList:(int)rowid
{
    sqlite3_stmt *statement;
    
    //delete from 表名 where rowid = ?
    char *sql = "delete from GroupTable where rowid = ?";
    
    if (sqlite3_prepare_v2(mySql, sql, -1, &statement, nil) != SQLITE_OK) {
        return NO;
    }
    
    sqlite3_bind_int(statement, 1, rowid);
    sqlite3_step(statement);
    sqlite3_finalize(statement);
    return YES;
}


//修改  更新
-(BOOL)updataData:(NSString *)name PassWord:(int)pass Rowid:(int)rowid
{
    NSString *upData = @"update GroupTable set Name = ? , PassWord = ? where rowid = ?";
    sqlite3_stmt *updataStmt;
    
    if (sqlite3_prepare_v2(mySql, [upData UTF8String], -1, &updataStmt, NULL) != SQLITE_OK) {
        return NO;
    }
    sqlite3_bind_text(updataStmt, 1, [name UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(updataStmt, 2, pass);
    sqlite3_bind_int(updataStmt, 3, rowid);
    
    sqlite3_step(updataStmt);
    sqlite3_finalize(updataStmt);
    
    return YES;
    
    
}


//查询
-(NSMutableArray *)selectData
{
    sqlite3_stmt *selectStmt;
    
    NSString *selectSQL = @"select *from GroupTable";
    
    if (sqlite3_prepare_v2(mySql, [selectSQL UTF8String], -1, &selectStmt, nil) != SQLITE_OK) {
        return NO;
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    while (sqlite3_step(selectStmt) == SQLITE_ROW) {
        
        HIstoryObj *testMyobj = [[HIstoryObj alloc]init];
        
        //sqlite3_column_text 查询
        char *dbName = (char *)(sqlite3_column_text(selectStmt, 0));
        
        NSString *name = [NSString stringWithCString:dbName encoding:NSUTF8StringEncoding];
        testMyobj.searchText = name;
        
        [array addObject:testMyobj];
        
        //[array addObject:[NSString stringWithFormat:@"%i",passID]];
        
    }
    
    NSLog(@"%@",array);
    sqlite3_finalize(selectStmt);
    
    return array;
}



@end
