//
//  OperationDB.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-16.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "OperationDB.h"

@implementation OperationDB

-(BOOL)whiteDataToDBWithListName:(NSArray *)listName andParameter:(NSDictionary *)parameterName andTabelName:(NSString *)tableName andDataName:(NSString *)dataName andCate:(int)tag
{
    //1、路径
    NSString *document = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    //2、建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:[document stringByAppendingString:[NSString stringWithFormat:@"/%@",dataName]]];//参数是建一个数据库的完整路径
    if(!db)
    {
        NSLog(@"我没建数据库");
        return NO;
    }
    [db open];//打开数据库
    //建表
    NSMutableString *listNa = [NSMutableString stringWithCapacity:0];
    NSMutableString *ques = [NSMutableString stringWithCapacity:0];
    for (int i=0; i<listName.count; i++) {
        
        
        if (i==listName.count-1) {
            [listNa appendFormat:@"%@",listName[i]];
            [ques appendFormat :@":%@",listName[i]];
        }else{
            [listNa appendFormat:@"%@,",listName[i]];
            [ques appendFormat :@":%@,",listName[i]];
        }
    }
    //1、sql建表语句
    NSString *createTable = [NSString stringWithFormat:@"create table %@ (%@)",tableName,listNa];//create是建表关键字，table引导后面的表名，peopleList是表名，(里是这个表的字段名)
    //2、调用sql语句
    BOOL isCreate = [db executeUpdate:createTable];
    if(isCreate == NO)
    {
        NSLog(@"建表失败");
    }
    //任何数据库操作的时候都要有两步组成，一步是写sql语句，一步是调用sql语句
    switch (tag) {
        case 1:
        {//插入
            //1、sql插入语句
            NSString *insertTable = [NSString stringWithFormat:@"insert into %@ values(%@)",tableName,ques];
            //2、调用插入语句，要在插入语句后，写参数，参数个数等于插入语句里？的个数
            BOOL isInsertOk = [db executeUpdate:insertTable withParameterDictionary:parameterName];
            if(isInsertOk == NO)
            {
                NSLog(@"插入失败");
                return NO;
            }
            break;
        }
        case 2:
        {//修改
            //1、sql修改语句
            NSString *updateTable = [NSString stringWithFormat:@"update %@ set %@ = ? where %@ = ?",tableName,listName[1],listName[0]];
            //2、调用修改语句
            BOOL isUpdate = [db executeUpdate:updateTable,parameterName[listName[1]],parameterName[listName[0]]];
            if(isUpdate == NO)
            {
                NSLog(@"修改失败");
                return NO;
            }
            break;
        }
        case 3:
        {//毁表
            //1、sql毁表语句
            NSString *dropTable = [NSString stringWithFormat:@"drop table %@",tableName];//drop是毁表关键字，然后跟table引导表名，表名就是要被毁的那个表
            //2、调用毁表语句
            BOOL isDrop = [db executeUpdate:dropTable];
            if(isDrop == NO)
            {
                NSLog(@"插入失败");
                return NO;
            }
            break;
        }
        default:
            break;
    }
    [db close];//关闭数据库
    return YES;
}

-(NSMutableArray*)readDataFromDBWithTableName:(NSString *)tableName andDataName:(NSString *)dataName andListName:(NSArray *)listName
{
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",dataName]];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if(!db)
    {
        NSLog(@"数据库打开失败");
        return Nil;
    }
    
    [db open];
    NSMutableString *listNa = [NSMutableString stringWithCapacity:0];
    for (int i=0; i<listName.count; i++) {
        if (i==listName.count-1) {
            [listNa appendFormat:@"%@",listName[i]];
        }else{
            [listNa appendFormat:@"%@,",listName[i]];
        }
    }
    //1、sql建表语句
    NSString *createTable = [NSString stringWithFormat:@"create table %@ (%@)",tableName,listNa];//create是建表关键字，table引导后面的表名，peopleList是表名，(里是这个表的字段名)
    //2、调用sql语句
    BOOL isCreate = [db executeUpdate:createTable];
    if(isCreate == NO)
    {
        NSLog(@"建表失败");
    }
    //sql查找语句
    NSString *selectTable = [NSString stringWithFormat:@"select * from %@",tableName];//select是查找关键字，*表示所有，from引导表名，表名后可选择添加where约束，约束参考修改内容
    //调用查找语句，只有查找个别，使用executeQuery，其他的都是executeUpDate
    FMResultSet *set = [db executeQuery:selectTable];//set就是查找到的所有内容
    NSMutableArray *idArr = [NSMutableArray arrayWithCapacity:0];
    while ([set next]) {
        [idArr addObject:@{@"pictureId":[set stringForColumn:@"pictureId"],@"indexPathSection":[set stringForColumn:@"indexPathSection"],@"indexPathRow":[set stringForColumn:@"indexPathRow"]}];
    }
    return idArr;
}
-(NSMutableArray*)readModelDataFromDBWithTableName:(NSString *)tableName andDataName:(NSString *)dataName andListName:(NSArray *)listName
{
    NSString *path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@",dataName]];
    FMDatabase *db = [FMDatabase databaseWithPath:path];
    if(!db)
    {
        NSLog(@"数据库打开失败");
        return Nil;
    }
    
    [db open];
    NSMutableString *listNa = [NSMutableString stringWithCapacity:0];
    for (int i=0; i<listName.count; i++) {
        if (i==listName.count-1) {
            [listNa appendFormat:@"%@",listName[i]];
        }else{
            [listNa appendFormat:@"%@,",listName[i]];
        }
    }
    //1、sql建表语句
    NSString *createTable = [NSString stringWithFormat:@"create table %@ (%@)",tableName,listNa];//create是建表关键字，table引导后面的表名，peopleList是表名，(里是这个表的字段名)
    //2、调用sql语句
    BOOL isCreate = [db executeUpdate:createTable];
    if(isCreate == NO)
    {
        NSLog(@"建表失败");
    }
    //sql查找语句
    NSString *selectTable = [NSString stringWithFormat:@"select * from %@",tableName];//select是查找关键字，*表示所有，from引导表名，表名后可选择添加where约束，约束参考修改内容
    //调用查找语句，只有查找个别，使用executeQuery，其他的都是executeUpDate
    FMResultSet *set = [db executeQuery:selectTable];//set就是查找到的所有内容
    NSMutableArray *idArr = [NSMutableArray arrayWithCapacity:0];
    while ([set next]) {
        NSData *data = [set dataForColumn:@"indexPathSection"];
        [idArr addObject:@{@"pictureId":[set stringForColumn:@"pictureId"],@"indexPathSection":[NSKeyedUnarchiver unarchiveObjectWithData:data],@"indexPathRow":[set stringForColumn:@"indexPathRow"]}];
    }
    return idArr;
}
@end
