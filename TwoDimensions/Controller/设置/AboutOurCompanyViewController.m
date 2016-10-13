//
//  AboutOurCompanyViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-20.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "AboutOurCompanyViewController.h"
#import "DetailNav.h"

@interface AboutOurCompanyViewController ()

@end

@implementation AboutOurCompanyViewController

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
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
	// Do any additional setup after loading the view.
}
-(void)makeUI
{
    //导航条
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:@[] andRightAction:nil andTarget:self andTitleName:@"关于我们"];
    [self.view addSubview:detailNav];
    
    //logo
    UIImageView *logoImag = [[UIImageView alloc] initWithFrame:CGRectMake(33.5, 74, self.view.frame.size.width-67, 61)];
    logoImag.image = [UIImage imageNamed:@"二次元logo@2x.png"];
    [self.view addSubview:logoImag];
    
    //版本号
    UILabel *banBLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 145, self.view.frame.size.width-20, 20)];
    banBLabel.text = @"版本号 : 2.0.3";
    banBLabel.font = [UIFont boldSystemFontOfSize:16];
    banBLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:banBLabel];
    
    //UID
    UILabel *UIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 175, self.view.frame.size.width-20, 20)];
    UIDLabel.text = @"UID : 12858583";
    UIDLabel.font = [UIFont boldSystemFontOfSize:16];
    UIDLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:UIDLabel];
    
    //AM
    UILabel *AMLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 205, self.view.frame.size.width-20, 20)];
    AMLabel.text = @"A M : 1.0.0";
    AMLabel.font = [UIFont boldSystemFontOfSize:16];
    AMLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:AMLabel];
    
    //评论输入框
    UIImageView *textBack = [[UIImageView alloc] initWithFrame:CGRectMake(113.5, 235, self.view.frame.size.width-227, 68)];
    textBack.image = [UIImage imageNamed:@"公司logo@2x.png"];
    [self.view addSubview:textBack];
    
    //email
    UILabel *EmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 313, self.view.frame.size.width-20, 20)];
    EmailLabel.text = @"E-MAILL : support@palmtrends.com";
    EmailLabel.font = [UIFont boldSystemFontOfSize:14];
    EmailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:EmailLabel];

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
