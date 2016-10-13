//
//  SingleTag.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-9.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "SingleTag.h"
static SingleTag *single = nil;

@implementation SingleTag
+(id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        single = [SingleTag alloc];
    });
    return single;
}
@end
