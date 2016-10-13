//
//  MyTabBarViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-9.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "MyTabBarViewController.h"
#import "InformationViewController.h"
#import "MagazineViewController.h"
#import "IllustrationViewController.h"
#import "BenefitViewController.h"
#import "MicroblogViewController.h"
#import "SingleTag.h"

@interface MyTabBarViewController ()
{
    UIImageView *selectedImag;
}
@end

@implementation MyTabBarViewController

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
    self.tabBar.hidden = YES;
    [self makeVC];
    [self makeUI];
    [self selectBtnCurrent];
	// Do any additional setup after loading the view.
}

-(void)makeVC
{
    UINavigationController *infoNav = [[UINavigationController alloc] initWithRootViewController:[[InformationViewController alloc] init]];
    UINavigationController *magaNav = [[UINavigationController alloc] initWithRootViewController:[[MagazineViewController alloc] init]];
    UINavigationController *beneNav = [[UINavigationController alloc] initWithRootViewController:[[BenefitViewController alloc] init]];
    UINavigationController *illuNav = [[UINavigationController alloc] initWithRootViewController:[[IllustrationViewController alloc] init]];
    UINavigationController *micrNav = [[UINavigationController alloc] initWithRootViewController:[[MicroblogViewController alloc] init]];
    NSArray *navArr = @[infoNav,magaNav,beneNav,illuNav,micrNav];
    self.viewControllers = navArr;
}

-(void)makeUI
{
    UIImageView *backImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49, self.view.frame.size.width, 49)];
    backImg.image = [UIImage imageNamed:@"菜单栏底@2x.png"];
    [self.view addSubview:backImg];
    backImg.userInteractionEnabled = YES;
    
    selectedImag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    selectedImag.image = [UIImage imageNamed:@"菜单选择效果.png"];
    selectedImag.hidden = YES;
    [backImg addSubview:selectedImag];
    
    NSArray *titleArr = @[@"01-资讯@2x.png",@"02-阅读@2x.png",@"03-生活@2x.png",@"04-视觉@2x.png",@"05-微博@2x.png"];
    for (int i=0; i<titleArr.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(64*i, 0, 64, 49);
        [btn addTarget:self action:@selector(upBtnDown:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        btn.backgroundColor = [UIColor clearColor];
        [backImg addSubview:btn];
        
        UIImageView *btnImg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 15, 48, 19)];
        btnImg.image = [UIImage imageNamed:titleArr[i]];
        [btn addSubview:btnImg];
    }
}

-(void)selectBtnCurrent
{
    SingleTag *btnTag = [SingleTag shareInstance];
    int BtnTag = [btnTag.tag intValue];
    [UIView animateWithDuration:0.5 animations:^{
        selectedImag.hidden = NO;
        selectedImag.frame = CGRectMake((BtnTag-1000)*self.view.frame.size.width/5+5, 10, 54, 29);
        self.selectedIndex = BtnTag - 1000;
    }];
}

-(void)upBtnDown:(UIButton*)btn
{
    [UIView animateWithDuration:0.5 animations:^{
        selectedImag.hidden = NO;
        selectedImag.frame = CGRectMake((btn.tag-1000)*self.view.frame.size.width/5+5, 10, 54, 29);
        self.selectedIndex = btn.tag - 1000;
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
