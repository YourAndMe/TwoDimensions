//
//  CartoonTableViewCell.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-17.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartoonTableViewCell : UITableViewCell
//图片数据源
@property(nonatomic,strong)NSArray *dataPicArr;
//向下三角
@property(nonatomic,strong)UIImageView *down;
//滚动视图
@property(nonatomic,strong)UIScrollView *scr;
//cell中图片布局
-(void)makeScrPicWithAction:(SEL)picBtnDown andTarget:(id)target andIndexSection:(int)sections andLastSel:(int)lastSelec;
@end
