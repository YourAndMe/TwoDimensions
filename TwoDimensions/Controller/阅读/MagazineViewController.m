//
//  MagazineViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-9.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "MagazineViewController.h"
#import "Nav.h"
#import "SecondMenuBtn.h"
#import "ScrollViewsReuse.h"
#import "NetWorkBlock.h"
#import "DetailInfomationView.h"
#import "Model.h"
#import "InformationDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MyMbd.h"
#import "DetailViewController.h"
#import "MagazineDetailViewController.h"
#import "MagazeneAndNovelDetailViewController.h"
#import "CollectionWriteAndReadDB.h"

@interface MagazineViewController ()<MJRefreshBaseViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    SecondMenuBtn *secondBtn;
    DetailInfomationView *detailInfoPage;
    NSString *sa;
    NSString *actions;
    int _flag;
    int countPage;
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    Model *modelHere;
    CollectionWriteAndReadDB *WAndR;
}
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
@property (nonatomic, strong) NSMutableArray *novelDataArr;
@property(nonatomic,strong)NSMutableArray *pageArr;//记录每个table中的页数
@property(nonatomic,strong)NSMutableArray *tgDataArr;//存储特稿数据
@property(nonatomic,strong)NSMutableArray *zlDataArr;//存储专栏数据
@property(nonatomic,strong)NSMutableArray *refreshDataArr;//存储上下拉对象
@property(nonatomic,strong)NSMutableArray *infoIdArr;//每条信息的ID
@end

@implementation MagazineViewController
-(void)dealloc
{
    if (self.refreshDataArr.count == 0) {
        return;
    }
    for (int i=0; i<2; i++) {
        [self.refreshDataArr[i][@"head"] free];
        [self.refreshDataArr[i][@"foot"] free];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataSourceArr = [NSMutableArray arrayWithCapacity:0];
        self.novelDataArr = [NSMutableArray arrayWithCapacity:0];
        self.tgDataArr = [NSMutableArray arrayWithCapacity:0];
        self.zlDataArr = [NSMutableArray arrayWithCapacity:0];
        self.refreshDataArr = [NSMutableArray arrayWithCapacity:0];
        self.infoIdArr = [NSMutableArray arrayWithCapacity:0];
        self.pageArr = [NSMutableArray arrayWithCapacity:0];
        for (int i=0; i<4; i++) {
            [self.pageArr addObject:@"0"];
        }
        sa = @"zazi";
        actions = @"mags_list";
        _flag = 1300;
        countPage = 8;
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
    //布局导航条
    Nav *nav = [[Nav alloc] initWithFrame:CGRectMake(0, 0, 320, 64) andImage:@"回到主页小房子@2x.png" andTarget:self andAction:@selector(backMainPageDown)];
    [self.view addSubview:nav];
    
    //布局二级菜单
    secondBtn = [[SecondMenuBtn alloc] initWithFrame:CGRectMake(0, 62, 320, 33) andTarget:self andAction:@selector(secondBtnDown:) andBtnName:@[@"杂志",@"特稿",@"小说",@"专栏"]];
    [self.view addSubview:secondBtn];
    
    //设置初次进入时，选中的时第一项
    secondBtn.selectImag.hidden = NO;
    secondBtn.selectImag.frame = CGRectMake((1300-1300)*self.view.frame.size.width/4+5, 2, 54, 25);

    detailInfoPage = [[DetailInfomationView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-270, 320, 270-49) andTarget:self andAction:@selector(detailBtnDown:)];
    detailInfoPage.btn.tag = 10000;
    [detailInfoPage.detailLabBtn addTarget:self action:@selector(detailLabBtnDown:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detailInfoPage];
    
    for (int i=0; i<2; i++) {
        ScrollViewsReuse *scro = [[ScrollViewsReuse alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, self.view.frame.size.height-95-270) andData:nil andMainPage:detailInfoPage andAction:@selector(detailLabBtnDown:) andTarget:self];
        scro.boundary = YES;
        scro.hidden = YES;
        scro.tag = 1700+i;
        [self.view addSubview:scro];
    }
    [self makeTable];
    //通知接收，发起页面跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notify:) name:@"pp" object:nil];
    
    //初始化将收藏内容写入数据库的封装对象
    WAndR = [[CollectionWriteAndReadDB alloc] init];
    
    //收听到收藏与否的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"wenzhangYD" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"wenzhangYD-no" object:nil];
    
    //收听到收藏与否的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"xiaoshuoAA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"xiaoshuoAA-no" object:nil];
    
    //收听到收藏与否的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"zazhiArrAA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"zazhiArrAA-no" object:nil];
}
//接收到收藏通知
-(void)notifyYes:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if (_flag == 1301) {
        [WAndR addCollec:articleId andDataArr:self.tgDataArr andFlag:1 andName:@"wenzhangYD"];
    }else if (_flag == 1300){
        [WAndR addCollec:articleId andDataArr:self.dataSourceArr andFlag:1 andName:@"zazhiArrAA"];
    }else if (_flag == 1302){
        [WAndR addCollec:articleId andDataArr:self.novelDataArr andFlag:1 andName:@"xiaoshuoAA"];
    }else{
        [WAndR addCollec:articleId andDataArr:self.zlDataArr andFlag:1 andName:@"wenzhangYD"];
    }
}
//接收到取消收藏通知
-(void)notifyNo:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if (_flag == 1301) {
        [WAndR addCollec:articleId andDataArr:self.tgDataArr andFlag:2 andName:@"wenzhangYD"];
    }else if (_flag == 1300){
        [WAndR addCollec:articleId andDataArr:self.dataSourceArr andFlag:2 andName:@"zazhiArrAA"];
    }else if (_flag == 1302){
        [WAndR addCollec:articleId andDataArr:self.novelDataArr andFlag:2 andName:@"xiaoshuoAA"];
    }else{
        [WAndR addCollec:articleId andDataArr:self.zlDataArr andFlag:2 andName:@"wenzhangYD"];
    }
}
-(void)notify:(NSNotification*)noti
{
    MagazeneAndNovelDetailViewController *detail = [noti object];
    if (_flag == 1300) {
        detail.titleName = @"杂志";
        detail.action = @"mag_section_list";
        detail.magaDetail = @"杂志";
    }else{
        detail.titleName = @"小说";
        detail.action = @"novel_section_list";
        detail.magaDetail = @"小说";
    }
    [self presentViewController:detail animated:YES completion:nil];
}
//小说和杂志按钮事件
-(void)detailLabBtnDown:(UIButton*)btn
{
    if (_flag == 1300) {
        [self presentDetailView:self.dataSourceArr andBtnTitle:btn.titleLabel.text andNavName:@"杂志" andFlag:@"mag_section_list"];
    }else{
        [self presentDetailView:self.novelDataArr andBtnTitle:btn.titleLabel.text andNavName:@"小说" andFlag:@"novel_section_list"];
    }
    
}
//找到对应的id，跳转到小说和杂志相应的页面
-(void)presentDetailView:(NSMutableArray*)data andBtnTitle:(NSString*)str andNavName:(NSString*)navStr andFlag:(NSString*)flag
{
    for (int i=0; i<data.count; i++) {
        Model *modelHe = data[i];
        if ([modelHe.idInfo isEqualToString:str]) {
            MagazeneAndNovelDetailViewController *detailView = [[MagazeneAndNovelDetailViewController alloc] init];
            detailView.Id = modelHe.idInfo;
            detailView.action = flag;
            detailView.leftPic = modelHe.icon;
            detailView.titleName = navStr;
            detailView.infoTitleName = modelHe.title;
            detailView.authorName = modelHe.author;
            detailView.statusName = modelHe.status;
            detailView.updateName = modelHe.update;
            detailView.typeName = modelHe.type;
            detailView.keyWordName = modelHe.keyword;
            detailView.describName = modelHe.des;
            [self presentViewController:detailView animated:YES completion:nil];
        }
    }
}
-(void)makeTable
{
    //设置table
    for (int i=0; i<2; i++) {
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, 320, self.view.frame.size.height-95-49) style:UITableViewStylePlain];
        table.delegate =self;
        table.dataSource = self;
        table.hidden = YES;
        table.tag = 1600+i;
        [self.view addSubview:table];
        
        //上下拉刷新
        header = [MJRefreshHeaderView header];
        header.scrollView = table;
        header.delegate = self;
        header.tag = 1621+i%3*2;
        
        footer = [MJRefreshFooterView footer];
        footer.scrollView = table;
        footer.delegate = self;
        footer.tag = 1631+i%3*2;
        [self.refreshDataArr addObject:@{@"head": header,@"foot":footer}];
    }
}

-(void)detailBtnDown:(UIButton*)btn
{
    if (btn.tag == 10000) {
        MagazineDetailViewController *detail = [[MagazineDetailViewController alloc] init];
        detail.titleName = @"杂志";
        detail.flagTag = @"zz";
        [self presentViewController:detail animated:YES completion:nil];
    }else{
        MagazineDetailViewController *detail = [[MagazineDetailViewController alloc] init];
        detail.titleName = @"小说";
        detail.flagTag = @"xs";
        [self presentViewController:detail animated:YES completion:nil];
    }
    
}

-(void)loadData
{
    MyMbd *mb = [[MyMbd alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mb];
    
    __weak MagazineViewController *tempMagazine = self;
    NetWorkBlock *net = [NetWorkBlock alloc];
    [net requestNetWithUrl:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=%@&sa=%@&offset=%d&count=%d&e=8c8a161c0f3feec349e68a73b8a41191&uid=12858666&pid=10070&mobile=iPhone6,2&platform=i",actions,sa,[self.pageArr[_flag-1300] intValue]*15,countPage] andInterface:@"" andBodyOfRequestForKeyArr:nil andValueArr:nil andBlock:^(id result) {
        
        MyMbd *mb = (MyMbd*)[tempMagazine.view viewWithTag:12345];
        [mb removeFromSuperview];
        
        for (int i=0; i<2; i++) {
            MJRefreshHeaderView *_header = (MJRefreshHeaderView*)[tempMagazine.view viewWithTag:1621+i%3*2];
            MJRefreshFooterView *_footer = (MJRefreshFooterView*)[tempMagazine.view viewWithTag:1631+i%3*2];
            [_header endRefreshing];
            [_footer endRefreshing];
        }
        
        NSArray *arr = result[@"list"];
        if (_flag == 1300) {
            [tempMagazine.dataSourceArr removeAllObjects];
        }else if(_flag == 1301 && [tempMagazine.pageArr[_flag-1300] intValue] == 0) {
            [tempMagazine.infoIdArr removeAllObjects];
            [tempMagazine.tgDataArr removeAllObjects];
        }else if(_flag == 1302) {
            [tempMagazine.novelDataArr removeAllObjects];
        }else if(_flag == 1303 && [tempMagazine.pageArr[_flag-1300] intValue] == 0){
            [tempMagazine.infoIdArr removeAllObjects];
            [tempMagazine.zlDataArr removeAllObjects];
        }
        for (NSDictionary *temp in arr) {
            Model *model = [[Model alloc] initWithDic:temp];//kvc赋值
            model.idInfo = temp[@"id"];
            if (_flag == 1300) {
                [tempMagazine.dataSourceArr addObject:model];
            }else if(_flag == 1301) {
                [tempMagazine.infoIdArr addObject:temp[@"id"]];
                [tempMagazine.tgDataArr addObject:model];
            }else if(_flag == 1302) {
                [tempMagazine.novelDataArr addObject:model];
            }else {
                [tempMagazine.infoIdArr addObject:temp[@"id"]];
                [tempMagazine.zlDataArr addObject:model];
            }
        }
        if (_flag == 1300) {
            [tempMagazine hiddenScroll];
            [tempMagazine hiddenTable];
            ScrollViewsReuse *scro = (ScrollViewsReuse*)[tempMagazine.view viewWithTag:1700];
            scro.hidden = NO;
            scro.dataArr = tempMagazine.dataSourceArr;
            scro.boundary = NO;
            [scro.carousel reloadData];
        }else if(_flag == 1301) {
            [tempMagazine hiddenTable];
            UITableView *table2 = (UITableView*)[tempMagazine.view viewWithTag:1600];
            table2.hidden = NO;
            [table2 reloadData];
        }else if(_flag == 1302) {
            [tempMagazine hiddenScroll];
            [tempMagazine hiddenTable];
            ScrollViewsReuse *scro = (ScrollViewsReuse*)[tempMagazine.view viewWithTag:1701];
            scro.hidden = NO;
            scro.dataArr = tempMagazine.novelDataArr;
            scro.boundary = NO;
            [scro.carousel reloadData];
        }else {
            [tempMagazine hiddenTable];
            UITableView *table4 = (UITableView*)[tempMagazine.view viewWithTag:1601];
            table4.hidden = NO;
            [table4 reloadData];
        }
        
        
    } andType:YES];
}
//隐藏Scroll
-(void)hiddenScroll
{
    for (int i=0; i<2; i++) {
        ScrollViewsReuse *scroll = (ScrollViewsReuse*)[self.view viewWithTag:1700+i];
        scroll.hidden = YES;
    }
}
//隐藏table
-(void)hiddenTable
{
    for (int i=0; i<2; i++) {
        UITableView *table = (UITableView*)[self.view viewWithTag:1600+i];
        table.hidden = YES;
    }
}
//二级菜单按钮点击事件
-(void)secondBtnDown:(UIButton*)btn
{
    [UIView animateWithDuration:0.5 animations:^{
        secondBtn.selectImag.hidden = NO;
        secondBtn.selectImag.frame = CGRectMake((btn.tag-1300)*self.view.frame.size.width/4+5, 2, 54, 25);
    }];
    _flag = btn.tag;
    switch (btn.tag) {
        case 1300:
        {
            detailInfoPage.btn.tag = 10000;
            sa = @"zazi";
            actions = @"mags_list";
            countPage = 8;
            [self loadData];
            break;
        }
        case 1301:
        {
            sa = @"tegao";
            actions = @"list";
            countPage = 15;
            [self loadData];
            break;
        }
        case 1302:
        {
            detailInfoPage.btn.tag = 10001;
            sa = nil;
            actions = @"novel_list";
            countPage = 8;
            [self loadData];
            break;
        }
        case 1303:
        {
            sa = @"zhuanlan";
            actions = @"list";
            countPage = 15;
            [self loadData];
            break;
        }
        default:
            break;
    }
}

//回到主页按钮点击事件
-(void)backMainPageDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1600) {
        return self.tgDataArr.count;
    }else {
        return self.zlDataArr.count;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    if (cell == nil) {
        cell = [[InformationDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];
    }
    if (tableView.tag == 1600) {
        modelHere = self.tgDataArr[indexPath.row];
    }else {
        modelHere = self.zlDataArr[indexPath.row];
    }
    for (id temp in cell.contentView.subviews) {
        [temp removeFromSuperview];
    }
    if ([modelHere.icon isEqualToString:@""]) {
        cell.picImage.hidden = YES;
        cell.titleLab.frame = CGRectMake(15, 5, 290, 25);
        cell.desLab.frame = CGRectMake(15, 35, 290, 35);
        cell.backLab.frame = CGRectMake(10, 75, 300, 20);
        cell.timeLab.frame = CGRectMake(210, 0, 90, 20);
        cell.titleLab.text = modelHere.title;
        cell.desLab.text = modelHere.des;
        cell.authorLab.text = [NSString stringWithFormat:@"作者 : %@",modelHere.author];
        cell.timeLab.text = modelHere.adddate;
    }else{
        cell.picImage.hidden = NO;
        [cell.picImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com/%@",modelHere.icon]]];
        cell.titleLab.frame = CGRectMake(100, 5, 200, 25);
        cell.desLab.frame = CGRectMake(100, 35, 200, 35);
        cell.backLab.frame = CGRectMake(100, 75, 210, 20);
        cell.timeLab.frame = CGRectMake(120, 0, 90, 20);
        cell.titleLab.text = modelHere.title;
        cell.desLab.text = modelHere.des;
        cell.authorLab.text = [NSString stringWithFormat:@"作者 : %@",modelHere.author];
        cell.timeLab.text = modelHere.adddate;
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1600) {
        modelHere = self.tgDataArr[indexPath.row];
    }else if(tableView.tag == 1601) {
        modelHere = self.zlDataArr[indexPath.row];
    }
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.IDPic = modelHere.idInfo;
    detail.picIdArr = self.infoIdArr;
    detail.detailType = @"wenzhangYD";
    [self presentViewController:detail animated:YES completion:nil];
}
#pragma mark 上下拉代理
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    for (int i=0; i<4; i++) {
        if (refreshView.tag == 1620+i) {
            [self.pageArr replaceObjectAtIndex:i withObject:@"0"];
            [self loadData];
            break;
        }
    }
    for (int i=0; i<4; i++) {
        if (refreshView.tag == 1630+i) {
            int f = [self.pageArr[i] intValue];
            f++;
            [self.pageArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%d",f]];
            [self loadData];
            break;
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
