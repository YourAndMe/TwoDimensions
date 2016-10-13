//
//  NSString+URLEncoding.m
//  DoubanBook
//
//  Created by zhangcheng on 19/02/2012.
//  Copyright (c) 2012  www.mobiletrain.org. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString(URLEncoding)
- (NSString *)urlEncodeString
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                (CFStringRef)self, 
                NULL, 
                (CFStringRef)@";/?:@&=$+{}<>,",
                kCFStringEncodingUTF8);
    return [result autorelease];
}
@end
