//
//  CollectionWriteAndReadDB.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-21.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "CollectionWriteAndReadDB.h"
#import "OperationDB.h"
#import "Model.h"

@implementation CollectionWriteAndReadDB
//根据flag值对数据库中存储的收藏数据操作，1:将新页面添加到收藏数组，2:将取消页面在收藏数组中删除
-(void)addCollec:(NSString*)ID andDataArr:(NSMutableArray*)arr andFlag:(int)flag andName:(NSString*)title
{
    OperationDB *opDB = [[OperationDB alloc] init];
    NSMutableArray *collectionArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *set = [opDB readModelDataFromDBWithTableName:@"Collected" andDataName:@"Collection.db" andListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"]];
    for (int i=0; i<set.count; i++) {
        if ([set[i][@"pictureId"] isEqualToString:[title substringToIndex:8]]) {
            collectionArr = [NSMutableArray arrayWithArray:set[i][@"indexPathSection"]];
            break;
        }
    }
    NSLog(@"%@",collectionArr);
    if (flag==1) {
        for (int i=0; i<arr.count; i++) {
            Model *modelHere = arr[i];
            if ([title isEqualToString:@"tupianArAA"]) {
                if ([modelHere.gid isEqualToString:ID]) {
                    [collectionArr addObject:modelHere];
                    break;
                }
            }else{
                if ([modelHere.idInfo isEqualToString:ID]) {
                    [collectionArr addObject:modelHere];
                    break;
                }
            }
        }
    }else{
        for (int i=0; i<collectionArr.count; i++) {
            Model *modelHere = collectionArr[i];
            if ([title isEqualToString:@"tupianArAA"]) {
                if ([modelHere.gid isEqualToString:ID]) {
                    [collectionArr removeObjectAtIndex:i];
                    break;
                }
            }else{
                if ([modelHere.idInfo isEqualToString:ID]) {
                    [collectionArr removeObjectAtIndex:i];
                    break;
                }
            }
            
        }
    }
    NSLog(@"%@",collectionArr);
    NSData *collectData = [NSKeyedArchiver archivedDataWithRootObject:collectionArr];
    [self writeToFileWithID:[title substringToIndex:8] andArr:collectData];
}
//对数据库进行操作
-(void)writeToFileWithID:(NSString*)picId andArr:(NSData*)collectArr
{
    OperationDB *opDB = [[OperationDB alloc] init];
    NSMutableArray *set = [opDB readModelDataFromDBWithTableName:@"Collected" andDataName:@"Collection.db" andListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"]];
    if (!set.count) {
        [opDB whiteDataToDBWithListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"] andParameter:@{@"pictureId":picId,@"indexPathSection":collectArr,@"indexPathRow":@"0"} andTabelName:@"Collected" andDataName:@"Collection.db" andCate:1];
    }else{
        int i=0;
        for (; i<set.count; i++) {
            if ([set[i][@"pictureId"] isEqualToString:picId]) {
                [opDB whiteDataToDBWithListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"] andParameter:@{@"pictureId":picId,@"indexPathSection":collectArr,@"indexPathRow":@"0"}  andTabelName:@"Collected" andDataName:@"Collection.db" andCate:2];
                break;
            }
        }
        if (i == set.count && i != 0) {
            [opDB whiteDataToDBWithListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"] andParameter:@{@"pictureId":picId,@"indexPathSection":collectArr,@"indexPathRow":@"0"} andTabelName:@"Collected" andDataName:@"Collection.db" andCate:1];
        }
    }
}
@end
