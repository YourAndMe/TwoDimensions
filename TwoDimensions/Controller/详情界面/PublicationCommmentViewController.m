//
//  PublicationCommmentViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-20.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "PublicationCommmentViewController.h"
#import "DetailNav.h"
#import "ShareSettingViewController.h"

@interface PublicationCommmentViewController ()<UITextViewDelegate>
{
    UIScrollView *scr;
    UILabel *labelCount;
    UITextView *textView;
}
@end

@implementation PublicationCommmentViewController

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
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self makeUI];
	// Do any additional setup after loading the view.
}
-(void)makeUI
{
    //导航条
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:@[] andRightAction:nil andTarget:self andTitleName:@"评论"];
    [self.view addSubview:detailNav];
    
    //导航条右侧按钮
    UIButton *countNum = [UIButton buttonWithType:UIButtonTypeCustom];
    countNum.frame = CGRectMake(detailNav.frame.size.width-50, 10, 40, 24);
    [countNum setImage:[UIImage imageNamed:@"发送1@2x.png"] forState:UIControlStateNormal];
    [countNum addTarget:self action:@selector(rightBtnDown) forControlEvents:UIControlEventTouchUpInside];
    [detailNav addSubview:countNum];
    
    //评论输入框
    UIImageView *textBack = [[UIImageView alloc] initWithFrame:CGRectMake(5.5, 74, self.view.frame.size.width-11, 250)];
    textBack.image = [UIImage imageNamed:@"评论输入框@2x.png"];
    [self.view addSubview:textBack];
    textBack.userInteractionEnabled = YES;
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(2, 5, textBack.frame.size.width-4, 240)];
    textView.font = [UIFont systemFontOfSize:16];
    textView.backgroundColor = [UIColor clearColor];
    [textBack addSubview:textView];
    textView.delegate = self;
    
    labelCount = [[UILabel alloc] initWithFrame:CGRectMake(textBack.frame.size.width-50, textBack.frame.size.height-30, 40, 20)];
    labelCount.text = @"1000";
    labelCount.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1];
    labelCount.textAlignment = NSTextAlignmentRight;
    labelCount.clipsToBounds = YES;
    labelCount.layer.cornerRadius = 5;
    [textBack addSubview:labelCount];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, textView.frame.size.width-20, 20)];
    label.text = @"请在这里输入您的评论...";
    [textView addSubview:label];
    label.tag = 2000;
    
    label.userInteractionEnabled = NO;
    
}
#pragma mark textView代理
-(void)textViewDidChange:(UITextView *)textView
{
    UILabel *lab = (UILabel*)[self.view viewWithTag:2000];
    lab.hidden = YES;
    labelCount.text = [NSString stringWithFormat:@"%u",1000-textView.text.length];
    if (textView.text.length == 0) {
        lab.hidden = NO;
    }
}
//导航条左侧按钮点击事件
-(void)leftBtnDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//导航条右侧按钮点击事件
-(void)rightBtnDown
{
    ShareSettingViewController *share = [[ShareSettingViewController alloc] init];
    [self presentViewController:share animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
