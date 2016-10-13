//
//  MagazineUpView.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-15.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MagazineUpView : UIView

//左侧图片
@property(nonatomic,strong)UIImageView *leftPic;
//标题
@property(nonatomic,strong)UILabel *titleNameLab;
//作者
@property(nonatomic,strong)UILabel *authorLab;
//刊登
@property(nonatomic,strong)UILabel *statusLab;
//更新时间
@property(nonatomic,strong)UILabel *updateLab;
//类别
@property(nonatomic,strong)UILabel *typeLab;
//关键字
@property(nonatomic,strong)UILabel *keyWordLab;
//简介
@property(nonatomic,strong)UILabel *describLab;
//滚动视图
@property(nonatomic,strong)UIScrollView *scr;

@end
