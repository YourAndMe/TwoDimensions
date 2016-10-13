//
//  NetWorkBlock.m
//  Block
//
//  Created by llz on 14-12-25.
//  Copyright (c) 2014年 llz. All rights reserved.
//

#import "NetWorkBlock.h"

@implementation NetWorkBlock
- (void)requestNetWithUrl:(NSString *)urlStr andInterface:(NSString*)interface andBodyOfRequestForKeyArr:(NSArray*)keyArr andValueArr:(NSArray*)valueArr andBlock:(BLOCK)bl andType:(BOOL)isGet
{
    self.bl = bl;
    
    NSString *interfaceStr = interface;
    NSArray *keyArrHere = keyArr;
    NSArray *valueArrHere = valueArr;
    
    NSMutableString *reqStr = [NSMutableString stringWithCapacity:0];
    NSMutableString *objectStr = [NSMutableString stringWithCapacity:0];
    
    if(isGet)
    {
        [reqStr appendFormat:@"%@%@",urlStr,interfaceStr];
        
        for(int i = 0;i<keyArrHere.count;i++)
        {
            [reqStr appendFormat:@"%@=%@",keyArrHere[i],valueArrHere[i]];
            if(i<keyArr.count-1)
            {
                [reqStr appendString:@"&"];
            }
        }
    }
    else
    {//post
        [reqStr appendFormat:@"%@%@",urlStr,interfaceStr];
        
        for(int i = 0;i<keyArr.count;i++)
        {
            [objectStr appendFormat:@"%@=%@",keyArr[i],valueArr[i]];
            if(i<keyArr.count-1)
            {
                [objectStr appendString:@"&"];
            }
        }
    }
    NSLog(@"%@",reqStr);
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqStr] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    if(!isGet)
    {//post
        [req setHTTPMethod:@"POST"];
        [req setHTTPBody:[objectStr dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if(connectionError)
        {
            self.bl(@{@"ppqq":connectionError.localizedDescription});
        }
        else
        {
            id dic = [NSJSONSerialization JSONObjectWithData:data options :NSJSONReadingMutableContainers error:nil];
            self.bl(dic);
        }
    }];
}

@end
