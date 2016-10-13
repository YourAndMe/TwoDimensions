//
//  SecondMenuBtn.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-9.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondMenuBtn : UIView
@property(nonatomic,strong)UIImageView *selectImag;
- (id)initWithFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)btnAction andBtnName:(NSArray*)nameArr;
@end
