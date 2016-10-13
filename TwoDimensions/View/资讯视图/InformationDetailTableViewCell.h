//
//  InformationDetailTableViewCell.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-12.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationDetailTableViewCell : UITableViewCell
//左侧图片
@property(nonatomic,strong)UIImageView *picImage;
//信息标题
@property(nonatomic,strong)UILabel *titleLab;
//信息描述
@property(nonatomic,strong)UILabel *desLab;
//作者
@property(nonatomic,strong)UILabel *authorLab;
//发布时间
@property(nonatomic,strong)UILabel *timeLab;
@property(nonatomic,strong)UIView *backLab;
@end
