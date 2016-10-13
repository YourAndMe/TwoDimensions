//
//  MagazineDetailViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-15.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "MagazineDetailViewController.h"
#import "MagazineListViewCell.h"
#import "NetWorkBlock.h"
#import "Model.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MyMbd.h"
#import "DetailNav.h"
#import "MagazeneAndNovelDetailViewController.h"
#import "CollectionWriteAndReadDB.h"

@interface MagazineDetailViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,MJRefreshBaseViewDelegate>
{
    NSString *sa;
    NSString *actions;
    int countPage;
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    int pageNum;
    NSString *maNoSa;
    NSString *pagaFlag;
    CollectionWriteAndReadDB *WAndR;
}
@property(nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation MagazineDetailViewController
-(void)dealloc
{
    [header free];
    [footer free];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        // Custom initialization
        pageNum = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self makeUI];
    [self loadData];
	// Do any additional setup after loading the view.
}

-(void)makeUI
{
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:nil andRightAction:nil andTarget:self andTitleName:self.titleName];
    [self.view addSubview:detailNav];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, 320, self.view.bounds.size.height-64) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor colorWithRed:40/255.0 green:55/255.0 blue:62/255.0 alpha:1];
    collectionView.tag = 6666;
    [self.view addSubview:collectionView];
    
    [collectionView registerClass:[MagazineListViewCell class] forCellWithReuseIdentifier:@"ee"];
    
    //上下拉刷新
    header = [MJRefreshHeaderView header];
    header.scrollView = collectionView;
    header.delegate = self;
    
    footer = [MJRefreshFooterView footer];
    footer.scrollView = collectionView;
    footer.delegate = self;
    
    [self judegementDrag];
    
    //初始化将收藏内容写入数据库的封装对象
    WAndR = [[CollectionWriteAndReadDB alloc] init];
    
    //收听到收藏与否的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"xiaoshuoBB" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"xiaoshuoBB-no" object:nil];
    
    //收听到收藏与否的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"zazhiArrBB" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"zazhiArrBB-no" object:nil];
}
//接收到收藏通知
-(void)notifyYes:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if ([self.flagTag isEqualToString:@"zz"]) {
        [WAndR addCollec:articleId andDataArr:self.dataArr andFlag:1 andName:@"zazhiArrBB"];
    }else{
        [WAndR addCollec:articleId andDataArr:self.dataArr andFlag:1 andName:@"xiaoshuoBB"];
    }
}
//接收到取消收藏通知
-(void)notifyNo:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if ([self.flagTag isEqualToString:@"zz"]) {
        [WAndR addCollec:articleId andDataArr:self.dataArr andFlag:2 andName:@"zazhiArrBB"];
    }else{
        [WAndR addCollec:articleId andDataArr:self.dataArr andFlag:2 andName:@"xiaoshuoBB"];
    }
}
-(void)judegementDrag
{
    if ([self.flagTag isEqualToString:@"zz"]) {
        maNoSa = @"mag_section_list";
        actions = @"mags_list";
        sa = @"zazi";
        pagaFlag = @"小说1";
        countPage = 18;
    }else{
        maNoSa = @"novel_section_list";
        actions = @"novel_list";
        sa = nil;
        pagaFlag = @"杂志1";
        countPage = 8;
    }
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
    
    __weak MagazineDetailViewController *temp = self;
    NetWorkBlock *net = [NetWorkBlock alloc];
    [net requestNetWithUrl:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=%@&sa=%@&offset=%d&count=%d&e=8c8a161c0f3feec349e68a73b8a41191&uid=12858666&pid=10070&mobile=iPhone6,2&platform=i",actions,sa,pageNum*countPage,countPage] andInterface:@"" andBodyOfRequestForKeyArr:nil andValueArr:nil andBlock:^(id result) {
        MyMbd *mb = (MyMbd*)[temp.view viewWithTag:12345];
        [mb removeFromSuperview];
        
        [header endRefreshing];
        [footer endRefreshing];
        if (pageNum == 0) {
            [temp.dataArr removeAllObjects];
        }
        
        NSArray *arr = result[@"list"];
        for (NSDictionary *tempDic in arr) {
            Model *model = [[Model alloc] initWithDic:tempDic];
            model.idInfo = tempDic[@"id"];
            [temp.dataArr addObject:model];
        }
        UICollectionView *collection = (UICollectionView*)[temp.view viewWithTag:6666];
        [collection reloadData];
        
    } andType:YES];
}
#pragma mark collection代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MagazineListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ee" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    Model *modelHere = self.dataArr[indexPath.row];
    [cell.magazinePic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com/%@",modelHere.icon]]];
    cell.titleLab.text = modelHere.title;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Model *modelHe = self.dataArr[indexPath.row];
    MagazeneAndNovelDetailViewController *detailView = [[MagazeneAndNovelDetailViewController alloc] init];
    detailView.Id = modelHe.idInfo;
    detailView.action = maNoSa;
    detailView.magaDetail = pagaFlag;
    detailView.leftPic = modelHe.icon;
    detailView.titleName = self.titleName;
    detailView.infoTitleName = modelHe.title;
    detailView.authorName = modelHe.author;
    detailView.statusName = modelHe.status;
    detailView.updateName = modelHe.update;
    detailView.typeName = modelHe.type;
    detailView.keyWordName = modelHe.keyword;
    detailView.describName = modelHe.des;
    [self presentViewController:detailView animated:YES completion:nil];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/3.0, 140);
}
#pragma mark 上下拉代理
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView == header) {
        pageNum = 0;
        [self loadData];
    }else{
        pageNum++;
        [self loadData];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
