//
//  Model.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-6.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject<NSCoding>
/**
 首页
 **/
//首页图片地址或资讯信息图片地址或视觉图片地址
@property(nonatomic,strong)NSString *icon;
//首页图片标题或资讯信息标题或视觉图片标题
@property(nonatomic,strong)NSString *title;
//首页图片简介或资讯信息描述
@property(nonatomic,strong)NSString *des;
//首页图片ID
@property(nonatomic,strong)NSString *idPic;
//评论条数
@property(nonatomic,strong)NSString *count;

/**
 资讯
 **/
//消息ID
@property(nonatomic,strong)NSString *idInfo;
//资讯作者
@property(nonatomic,strong)NSString *author;
//资讯时间
@property(nonatomic,strong)NSString *adddate;
//资讯评论数或视觉图片评论数
@property(nonatomic,strong)NSString *comment_totals;

/**
 阅读
 **/
//杂志ID
@property(nonatomic,strong)NSString *magazineId;
//刊登
@property(nonatomic,strong)NSString *status;
//章节ID
@property(nonatomic,strong)NSString *chapterId;
//章节中小标题数组
@property(nonatomic,strong)NSArray *list;

/**
生活
 **/
//活动时间
@property(nonatomic,strong)NSString *start_time;
//活动地点
@property(nonatomic,strong)NSString *location;

/**
 视觉
 **/
//图片ID
@property(nonatomic,strong)NSString *gid;
//类型
@property(nonatomic,strong)NSString *type;
//关键字
@property(nonatomic,strong)NSString *keyword;
//更新时间
@property(nonatomic,strong)NSString *update;
//段号
@property(nonatomic,strong)NSString *order;

/**
评论
 **/
//用户名
@property(nonatomic,strong)NSString *name;
//评论内容
@property(nonatomic,strong)NSString *content;

-(id)initWithDic:(NSDictionary*)dic;
-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
