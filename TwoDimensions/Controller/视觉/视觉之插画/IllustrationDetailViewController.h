//
//  IllustrationDetailViewController.h
//  TwoDimensions
//
//  Created by mac on 15-1-18.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IllustrationDetailViewController : UIViewController
//图片Id
@property(nonatomic,strong)NSString *picId;
@property(nonatomic,strong)NSString *commentCount;
@property(nonatomic,strong)NSString *detailType;
@property(nonatomic,strong)NSString *isID;//是否是漫画
@property(nonatomic,strong)NSString *novelAndMagaID;//漫画ID
@property(nonatomic,strong)NSString *picTitleName;
@end
