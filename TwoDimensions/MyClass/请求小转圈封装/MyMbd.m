//
//  MyMbd.m
//  LimitFree
//
//  Created by llz on 14-12-15.
//  Copyright (c) 2014年 llz. All rights reserved.
//

#import "MyMbd.h"
#import "MBProgressHUD.h"

@implementation MyMbd

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        MBProgressHUD *mbd = [[MBProgressHUD alloc] initWithView:self];
        mbd.dimBackground = YES;
        mbd.labelText = @"努力加载中...";
        [self addSubview:mbd];
        [mbd show:YES];
        self.tag = 12345;//为了在view中查找到当前类初始化的对象，然后移除小转圈而定义的tag值
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
