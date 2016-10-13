//
//  SettingMainPageViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-20.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "SettingMainPageViewController.h"
#import "DetailNav.h"
#import "ArticleWordsViewController.h"
#import "ShareSettingViewController.h"
#import "UserFeedbackViewController.h"
#import "AboutOurCompanyViewController.h"
#import "CollectionViewController.h"

@interface SettingMainPageViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *table;
}
@property(nonatomic,strong)NSArray *picDataArr;//设置页面图片数组
@property(nonatomic,strong)NSArray *titleDataArr;//设置页面名字数组
@end

@implementation SettingMainPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self makeUI];
    [self loadData];
	// Do any additional setup after loading the view.
}
-(void)makeUI
{
    //导航条
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:@[] andRightAction:nil andTarget:self andTitleName:@"设置"];
    [self.view addSubview:detailNav];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(10, 84, self.view.frame.size.width-20, 350)];
    table.dataSource = self;
    table.delegate = self;
    table.clipsToBounds = YES;
    table.layer.cornerRadius = 5;
    table.backgroundColor = [UIColor colorWithRed:156/225.0 green:223/225.0 blue:226/225.0 alpha:1];
    table.scrollEnabled = NO;
    [self.view addSubview:table];
}
//导航条左侧按钮点击事件
-(void)leftBtnDown
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)loadData
{
    self.picDataArr = @[@"文章字号@2x.png",@"我的收藏@2x.png",@"分享设置@2x.png",@"用户反馈@2x.png",@"关于我们@2x.png",@"清除缓存@2x.png",@"回到主页小房子@2x.png"];
    self.titleDataArr = @[@"文章字号",@"我的收藏",@"分享设置",@"用户反馈",@"关于我们",@"清除缓存",@"主页图片显示模式"];
    [table reloadData];
}
#pragma mark table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.picDataArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ll"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ll"];
    }
    //左边图片
    UIImageView *leftPic = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    leftPic.image = [UIImage imageNamed:self.picDataArr[indexPath.row]];
    [cell.contentView addSubview:leftPic];
    //右边题目
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 30)];
    titleLab.font = [UIFont boldSystemFontOfSize:18];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = self.titleDataArr[indexPath.row];
    [cell.contentView addSubview:titleLab];
    cell.backgroundColor = [UIColor clearColor];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {//文章字号
            ArticleWordsViewController *article = [[ArticleWordsViewController alloc] init];
            [self presentViewController:article animated:YES completion:nil];
            break;
        }
        case 1:
        {//我的收藏
            CollectionViewController *collec = [[CollectionViewController alloc] init];
            [self presentViewController:collec animated:YES completion:nil];
            break;
        }
        case 2:
        {//分享设置
            ShareSettingViewController *share = [[ShareSettingViewController alloc] init];
            [self presentViewController:share animated:YES completion:nil];
            break;
        }
        case 3:
        {//用户反馈
            UserFeedbackViewController *feedBack = [[UserFeedbackViewController alloc] init];
            [self presentViewController:feedBack animated:YES completion:nil];
            break;
        }
        case 4:
        {//关于我们
            AboutOurCompanyViewController *about = [[AboutOurCompanyViewController alloc] init];
            [self presentViewController:about animated:YES completion:nil];
            break;
        }
        case 5:
        {//清除缓存
            [self clean];
            break;
        }
        case 6:
        {//主页图片显示模式
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"直线", @"圆圈", @"反向圆圈", @"圆桶", @"反向圆桶", @"封面展示", @"封面展示2", @"纸牌", nil];
            [sheet showInView:self.view];
            break;
        }
        default:
            break;
    }
}
#pragma mark 上推菜单代理

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    [UIView beginAnimations:nil context:nil];
    //做一个通知,通知当前选中的类型
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSNotification *notify = [NSNotification notificationWithName:@"sss" object:[NSString stringWithFormat:@"%ld",(long)buttonIndex]];
    [center postNotification:notify];
    [UIView commitAnimations];
}
//清除缓存
-(void)clean
{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}
//清除缓存成功红弹出提示
-(void)clearCacheSuccess
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"清理成功" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
