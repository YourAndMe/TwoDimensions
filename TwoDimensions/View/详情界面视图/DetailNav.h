//
//  DetailNav.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-8.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailNav : UIView
@property(nonatomic,strong)UILabel *titleLab;

- (id)initWithFrame:(CGRect)frame andLeftImage:(NSString*)leftImage andLeftImageHeightLight:(NSString*)hightImage andLeftAction:(SEL)leftAction andRightImage:(NSArray*)rightImageArr andRightAction:(SEL)rightAction andTarget:(id)target andTitleName:(NSString*)name;
@end
