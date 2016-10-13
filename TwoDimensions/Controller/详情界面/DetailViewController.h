//
//  DetailViewController.h
//  TwoDimensions
//
//  Created by wzcMac on 15-1-8.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
@property(nonatomic,strong)NSString *IDPic;
@property(nonatomic,strong)NSArray *picIdArr;
@property(nonatomic,strong)NSString *detailType;
@property(nonatomic,strong)NSString *isID;//是否是杂志或小说
@property(nonatomic,strong)NSString *novelAndMagaID;//杂志或小说ID
@end
