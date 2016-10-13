//
//  IllustrationCollectionViewCell.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-12.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IllustrationCollectionViewCell : UICollectionViewCell

//背景图片
@property(nonatomic,strong)UIImageView *backImage;
//图片
@property(nonatomic,strong)UIImageView *picImage;
//标题
@property(nonatomic,strong)UILabel *nameLab;

@end
