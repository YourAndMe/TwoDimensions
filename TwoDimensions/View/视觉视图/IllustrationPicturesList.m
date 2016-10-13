//
//  IllustrationPicturesList.m
//  TwoDimensions
//
//  Created by mac on 15-1-18.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "IllustrationPicturesList.h"
#import "UIImageView+WebCache.h"

@implementation IllustrationPicturesList
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scr = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scr.delegate = self;
        [self addSubview:_scr];
        _scr.contentSize = CGSizeMake(3*_scr.frame.size.width, 0);
        _scr.pagingEnabled = YES;
        _scr.contentOffset = CGPointMake(_scr.frame.size.width, 0);
        _scr.alwaysBounceVertical = NO;
        _scr.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

-(void)makeFirstUI
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSNotification *notify = [NSNotification notificationWithName:@"picCurrent" object:[NSString stringWithFormat:@"%d",1]];
    [center postNotification:notify];
    for (int i=1; i<3; i++) {
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scr.frame.size.width, 0, _scr.frame.size.width, _scr.frame.size.height)];
        [img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com%@",self.dataArrr[i-1]]]];
        img.accessibilityLabel = self.dataArrr[i-1];
        img.contentMode = UIViewContentModeScaleAspectFit;
        [_scr addSubview:img];
        img.tag = 3000+i;
    }
    UIImageView *leftImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scr.frame.size.width, _scr.frame.size.height)];
    [leftImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com%@",[self.dataArrr lastObject]]]];
    leftImg.accessibilityLabel = [self.dataArrr lastObject];
    leftImg.contentMode = UIViewContentModeScaleAspectFit;
    [_scr addSubview:leftImg];
    leftImg.tag = 3000;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    UIImageView *middleImg = (UIImageView*)[self viewWithTag:3001];
    UIImageView *rightImg = (UIImageView*)[self viewWithTag:3002];
    UIImageView *leftImg = (UIImageView*)[self viewWithTag:3000];
    //做一个通知,通知当前显示的是第几页
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    if (scrollView.contentOffset.x>_scr.frame.size.width) {
        leftImg.accessibilityLabel = middleImg.accessibilityLabel;
        middleImg.accessibilityLabel = rightImg.accessibilityLabel;
        leftImg.image = middleImg.image;
        middleImg.image = rightImg.image;
        _scr.contentOffset = CGPointMake(_scr.frame.size.width, 0);
        for (int i=0; i<self.dataArrr.count; i++) {
            if ([self.dataArrr[i] isEqualToString:rightImg.accessibilityLabel]) {
                if (i == self.dataArrr.count-1) {
                    rightImg.accessibilityLabel = self.dataArrr[0];
                    [rightImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com%@",self.dataArrr[0]]]];
                    NSNotification *notify = [NSNotification notificationWithName:@"picCurrent" object:[NSString stringWithFormat:@"%d",i+1]];
                    [center postNotification:notify];
                    break;
                }
                rightImg.accessibilityLabel = self.dataArrr[i+1];
                [rightImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com%@",self.dataArrr[i+1]]]];
                NSNotification *notify = [NSNotification notificationWithName:@"picCurrent" object:[NSString stringWithFormat:@"%d",i+1]];
                [center postNotification:notify];
                break;
            }
        }
    }
    if (scrollView.contentOffset.x < _scr.frame.size.width) {
        rightImg.accessibilityLabel = middleImg.accessibilityLabel;
        middleImg.accessibilityLabel = leftImg.accessibilityLabel;
        rightImg.image = middleImg.image;
        middleImg.image = leftImg.image;
        _scr.contentOffset = CGPointMake(_scr.frame.size.width, 0);
        for (int i=0; i<self.dataArrr.count; i++) {
            if ([self.dataArrr[i] isEqualToString:leftImg.accessibilityLabel]) {
                if (i == 0) {
                    leftImg.accessibilityLabel = [self.dataArrr lastObject];
                    [leftImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com%@",[self.dataArrr lastObject]]]];
                    NSNotification *notify = [NSNotification notificationWithName:@"picCurrent" object:[NSString stringWithFormat:@"%d",i+1]];
                    [center postNotification:notify];
                    break;
                }
                leftImg.accessibilityLabel = self.dataArrr[i-1];
                [leftImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com%@",self.dataArrr[i-1]]]];
                NSNotification *notify = [NSNotification notificationWithName:@"picCurrent" object:[NSString stringWithFormat:@"%d",i+1]];
                [center postNotification:notify];
                break;
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
