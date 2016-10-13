//
//  NetWorkBlock.h
//  Block
//
//  Created by llz on 14-12-25.
//  Copyright (c) 2014年 llz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLOCK)(id result);

@interface NetWorkBlock : NSObject

@property (nonatomic, copy) BLOCK bl;

- (void)requestNetWithUrl:(NSString *)urlStr andInterface:(NSString*)interface andBodyOfRequestForKeyArr:(NSArray*)keyArr andValueArr:(NSArray*)valueArr andBlock:(BLOCK)bl andType:(BOOL)isGet;
@end
