//
//  CommemtContentViewController.m
//  TwoDimensions
//
//  Created by mac on 15-1-19.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "CommemtContentViewController.h"
#import "TMQuiltView.h"
#import "DetailNav.h"
#import "NetWorkBlock.h"
#import "Model.h"
#import "CommentQuiltViewCell.h"
#import "MJRefresh.h"
#import "MyMbd.h"
#import "PublicationCommmentViewController.h"

@interface CommemtContentViewController ()<TMQuiltViewDataSource,TMQuiltViewDelegate,MJRefreshBaseViewDelegate>
{
    TMQuiltView *tm;
    int _page;
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
}
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation CommemtContentViewController
-(void)dealloc
{
    [header free];
    [footer free];
}
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        _page = 0;
    }
    return self;
}
- (void)viewDidLoad {
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
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:nil andRightAction:nil andTarget:self andTitleName:@"评论"];
    [self.view addSubview:detailNav];
    
    //导航条右侧评论条数
    UILabel *countNum = [[UILabel alloc] initWithFrame:CGRectMake(250, 12, 60, 20)];
    countNum.textAlignment = NSTextAlignmentRight;
    countNum.text = [NSString stringWithFormat:@"%@条",self.commentSum];
    countNum.textColor = [UIColor colorWithRed:55/255.0 green:156/255.0 blue:192/255.0 alpha:1];
    countNum.font = [UIFont boldSystemFontOfSize:16];
    countNum.backgroundColor = [UIColor clearColor];
    [detailNav addSubview:countNum];
    
    tm = [[TMQuiltView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-40)];
    tm.dataSource = self;
    tm.delegate = self;
    [self.view addSubview:tm];
    
    //上下拉刷新
    header = [MJRefreshHeaderView header];
    header.scrollView = tm;
    header.delegate = self;
    
    footer = [MJRefreshFooterView footer];
    footer.scrollView = tm;
    footer.delegate = self;
    
    //底部评论输入按钮
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame = CGRectMake(0, self.view.frame.size.height-40, self.view.frame.size.width, 40);
    [downBtn setImage:[UIImage imageNamed:@"评论输入条@2x.png"] forState:UIControlStateNormal];
    [downBtn setImage:[UIImage imageNamed:@"评论输入条@2x.png"] forState:UIControlStateHighlighted];
    [downBtn addTarget:self action:@selector(downBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downBtn];
    
    UILabel *reminder = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 150, 20)];
    reminder.text = @"我来说说...";
    reminder.font = [UIFont boldSystemFontOfSize:14];
    reminder.textColor = [UIColor grayColor];
    reminder.textAlignment = NSTextAlignmentLeft;
    [downBtn addSubview:reminder];
    reminder.userInteractionEnabled = NO;
}
//底部按钮点击事件
-(void)downBtnAction
{
    NSLog(@"进入评论输入页面");
    PublicationCommmentViewController *public = [[PublicationCommmentViewController alloc] init];
    [self presentViewController:public animated:YES completion:nil];
}
//导航条左侧按钮点击事件
-(void)leftBtnDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadData
{
    MyMbd *mb = [[MyMbd alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mb];
    __weak CommemtContentViewController *tempFirst = self;
    NetWorkBlock *net = [NetWorkBlock alloc];
    [net requestNetWithUrl:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=commentlist&offset=%d&count=15&id=%d&e=8c8a161c0f3feec349e68a73b8a41191&uid=12858666&pid=10070&mobile=iPhone6,2&platform=i",_page*15,[self.picID intValue]] andInterface:@"" andBodyOfRequestForKeyArr:nil andValueArr:nil andBlock:^(id result) {
        MyMbd *mb = (MyMbd*)[tempFirst.view viewWithTag:12345];
        [mb removeFromSuperview];
        
        [header endRefreshing];
        [footer endRefreshing];
        
        NSDictionary *arr = result[@"list"];
        if (_page == 0) {
            [tempFirst.dataArr removeAllObjects];
        }
        
        for (NSDictionary *temp in arr) {
            Model *model = [[Model alloc] initWithDic:temp];//kvc赋值
            [tempFirst.dataArr addObject:model];
        }
        [tm reloadData];
    } andType:YES];
}
-(NSInteger)quiltViewNumberOfColumns:(TMQuiltView *)quiltView
{
    return 1;
}
-(NSInteger)quiltViewNumberOfCells:(TMQuiltView *)quiltView
{
    return self.dataArr.count;
}

-(TMQuiltViewCell*)quiltView:(TMQuiltView *)quiltView cellAtIndexPath:(NSIndexPath *)indexPath
{
    CommentQuiltViewCell *cell = [quiltView dequeueReusableCellWithReuseIdentifier:@"hh"];
    if (cell == nil) {
        cell = [[CommentQuiltViewCell alloc] initWithReuseIdentifier:@"hh"];
    }
    for (id temp in cell.subviews) {
        [temp removeFromSuperview];
    }
    [cell requestDataWithIndex:indexPath.row];
    Model *modelHere = self.dataArr[indexPath.row];
    cell.commentBack.frame = CGRectMake(0, 0, self.view.frame.size.width-20, [self getWidthWithNSString:modelHere.content andStrSize:14]+35);
    cell.userName.text = modelHere.name;
    cell.times.text = modelHere.adddate;
    cell.contents.frame = CGRectMake(5, 30, cell.commentBack.frame.size.width-10, [self getWidthWithNSString:modelHere.content andStrSize:14]);
    cell.contents.text = modelHere.content;
    return cell;
}
-(CGFloat)quiltView:(TMQuiltView *)quiltView heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    Model *modelHere = self.dataArr[indexPath.row];
    return [self getWidthWithNSString:modelHere.content andStrSize:14]+35;
}
//计算一定宽度下文字所占的高度
-(float)getWidthWithNSString:(NSString*)str andStrSize:(int)sizeNum
{
    return [str boundingRectWithSize:CGSizeMake(290, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:sizeNum]} context:nil].size.height;
}
#pragma mark 上下拉代理
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == header) {
        _page = 0;
        [self loadData];
    }else{
        _page ++;
        [self loadData];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
