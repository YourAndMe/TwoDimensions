//
//  OperationDB.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-16.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface OperationDB : NSObject

//向指定的数据库的表中存入数据
-(BOOL)whiteDataToDBWithListName:(NSArray *)listName andParameter:(NSDictionary *)parameterName andTabelName:(NSString *)tableName andDataName:(NSString *)dataName andCate:(int)tag;

//从数据中读取数据
-(NSMutableArray*)readDataFromDBWithTableName:(NSString *)tableName andDataName:(NSString *)dataName andListName:(NSArray *)listName;

-(NSMutableArray*)readModelDataFromDBWithTableName:(NSString *)tableName andDataName:(NSString *)dataName andListName:(NSArray *)listName;
@end
