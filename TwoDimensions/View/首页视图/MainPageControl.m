//
//  MainPageControl.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-7.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "MainPageControl.h"

@implementation MainPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //页面选择器
        UIImageView *pageControlBackImg = [[UIImageView alloc] initWithFrame:CGRectMake(49.9, 6.5, 221, 7)];
        pageControlBackImg.image = [UIImage imageNamed:@"首页-页数"];
        [self addSubview:pageControlBackImg];
        
        _pageControlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pageControlBtn.frame = CGRectMake(49.9, 0, 20, 20);
        [_pageControlBtn setBackgroundImage:[UIImage imageNamed:@"首页-页数选"] forState:UIControlStateNormal];
        [_pageControlBtn setTitle:@"1" forState:UIControlStateNormal];
        [_pageControlBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _pageControlBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_pageControlBtn];
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
