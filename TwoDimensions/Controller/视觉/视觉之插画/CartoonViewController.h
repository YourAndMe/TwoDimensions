//
//  CartoonViewController.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-17.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartoonViewController : UIViewController
@property(nonatomic,strong)NSString *titleName;//用来传标题
@property(nonatomic,strong)NSString *action;//类别
@property(nonatomic,strong)NSString *Id;//漫画的Id
@property(nonatomic,strong)NSString *leftPic;
//标题
@property(nonatomic,strong)NSString *infoTitleName;
//作者
@property(nonatomic,strong)NSString *authorName;
//刊登
@property(nonatomic,strong)NSString *statusName;
//更新时间
@property(nonatomic,strong)NSString *updateName;
//类别
@property(nonatomic,strong)NSString *typeName;
//关键字
@property(nonatomic,strong)NSString *keyWordName;
//简介
@property(nonatomic,strong)NSString *describName;
@end
