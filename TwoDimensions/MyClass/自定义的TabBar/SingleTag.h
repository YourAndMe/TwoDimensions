//
//  SingleTag.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-9.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleTag : NSObject
@property(nonatomic,strong)NSString *tag;
+(id)shareInstance;
@end
