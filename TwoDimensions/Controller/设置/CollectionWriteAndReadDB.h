//
//  CollectionWriteAndReadDB.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-21.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionWriteAndReadDB : NSObject
//根据flag值对数据库中存储的收藏数据操作，1:将新页面添加到收藏数组，2:将取消页面在收藏数组中删除
-(void)addCollec:(NSString*)ID andDataArr:(NSMutableArray*)arr andFlag:(int)flag andName:(NSString*)title;
@end
