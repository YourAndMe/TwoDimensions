//
//  MainPageScrView.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-7.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "MainPageScrView.h"

@implementation MainPageScrView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //图片标题
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 230, 25)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        self.titleLabel.userInteractionEnabled = YES;
        
        //图片简介
        self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, 300, 160)];
        self.desLabel.font = [UIFont systemFontOfSize:16];
        self.desLabel.numberOfLines = 0;
        [self addSubview:self.desLabel];
        self.titleLabel.userInteractionEnabled = YES;
        
        //下面文字按钮
        self.labBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.labBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.labBtn];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
