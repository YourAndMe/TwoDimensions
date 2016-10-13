//
//  DetailInfomationView.h
//  TwoDimensions
//
//  Created by mac on 15-1-13.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailInfomationView : UIView

//作者
@property(nonatomic,strong)UILabel *authorLab;
//时间
@property(nonatomic,strong)UILabel *timeLab;
//题目
@property(nonatomic,strong)UILabel *titleLab;
//简介
@property(nonatomic,strong)UILabel *detailLab;
//简介的滚动视图
@property(nonatomic,strong)UIScrollView *scr;
//右侧按钮
@property(nonatomic,strong)UIButton *btn;
//简介的按钮
@property(nonatomic,strong)UIButton *detailLabBtn;

- (id)initWithFrame:(CGRect)frame andTarget:(id)target andAction:(SEL)btnAction;
@end
