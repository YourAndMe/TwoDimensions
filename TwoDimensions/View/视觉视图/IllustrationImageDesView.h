//
//  IllustrationImageDesView.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-19.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IllustrationImageDesView : UIView
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UILabel *picTitle;
@property(nonatomic,strong)UIImageView *upRow;
@property(nonatomic,strong)UIImageView *describImagBack;
@property(nonatomic,strong)UIScrollView *imagDesScr;
@property(nonatomic,strong)UILabel *imagDesLab;
- (id)initWithFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)btnDown;
@end
