//
//  DetailTabBarView.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-8.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTabBarView : UIView
@property(nonatomic,strong)UILabel *countLab;
- (id)initWithFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)actionBtn;
@end
