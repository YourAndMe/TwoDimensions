//
//  IllustrationNav.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-19.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IllustrationNav : UIView

@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *countLab;

- (id)initWithFrame:(CGRect)frame andLeftImage:(NSArray*)leftImage andLeftImageHeightLight:(NSArray*)hightImage andLeftAction:(SEL)leftAction andRightImage:(NSArray*)rightImageArr andRightAction:(SEL)rightAction andTarget:(id)target andTitleName:(NSString*)name;
@end
