//
//  ShareSettingViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-20.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "ShareSettingViewController.h"
#import "DetailNav.h"
#import "BindingWBViewController.h"

@interface ShareSettingViewController ()

@end

@implementation ShareSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
	// Do any additional setup after loading the view.
}
-(void)makeUI
{
    //导航条
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:@[] andRightAction:nil andTarget:self andTitleName:@"分享设置"];
    [self.view addSubview:detailNav];
    //三个分享
    NSArray *sharePic = @[@"新浪@2x.png",@"腾讯@2x.png",@"人人@2x.png"];
    NSArray *shareName = @[@"新浪微博",@"腾讯微博",@"人人网"];
    for (int i=0; i<3; i++) {
        UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(9, 84+67*i, self.view.frame.size.width-18, 57)];
        back.image = [UIImage imageNamed:@"分享设置底@2x.png"];
        [self.view addSubview:back];
        back.userInteractionEnabled = YES;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 37, 37)];
        icon.image = [UIImage imageNamed:sharePic[i]];
        [back addSubview:icon];
        
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(57, 10, 150, 37)];
        titleLab.textAlignment = NSTextAlignmentLeft;
        titleLab.text = shareName[i];
        titleLab.textColor = [UIColor grayColor];
        titleLab.font = [UIFont boldSystemFontOfSize:16];
        [back addSubview:titleLab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(back.frame.size.width-83, 15.5, 73, 26);
        [btn setImage:[UIImage imageNamed:@"绑定1@2x.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"绑定2@2x.png"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 4900+i;
        [back addSubview:btn];
    }
}
//绑定按钮点击事件
-(void)btnDown:(UIButton*)btn
{
    BindingWBViewController *binding = [[BindingWBViewController alloc] init];
    switch (btn.tag) {
        case 4900:
        {
            binding.wbName = @"新浪微博";
            binding.sname = @"sina";
            break;
        }
        case 4901:
        {
            binding.wbName = @"腾讯微博";
            binding.sname = @"qq";
            break;
        }
        case 4902:
        {
            binding.wbName = @"人人网";
            binding.sname = @"renren";
            break;
        }
        default:
            break;
    }
    [self presentViewController:binding animated:YES completion:nil];
}
//导航条左侧按钮点击事件
-(void)leftBtnDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
