//
//  CollectionViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-21.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "CollectionViewController.h"
#import "DetailNav.h"
#import "SecondMenuBtn.h"
#import "OperationDB.h"
#import "InformationDetailTableViewCell.h"
#import "Model.h"
#import "UIImageView+WebCache.h"
#import "DetailViewController.h"
#import "IllustrationCollectionViewCell.h"
#import "MagazineListViewCell.h"
#import "MagazeneAndNovelDetailViewController.h"
#import "CartoonViewController.h"
#import "IllustrationDetailViewController.h"
#import "CollectionWriteAndReadDB.h"

@interface CollectionViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    SecondMenuBtn *secondBtn;
    int _flag;//存储按钮tag值
    Model *modelHere;
    UITableView *table;
    MagazineListViewCell *cellMaga;
    IllustrationCollectionViewCell *cellIll;
    CollectionWriteAndReadDB *WAndR;
}
@property(nonatomic,strong)NSMutableArray *wzDataArr;//存储文章数据
@property(nonatomic,strong)NSMutableArray *tpDataArr;//存储图片数据
@property(nonatomic,strong)NSMutableArray *zzDataArr;//存储杂志数据
@property(nonatomic,strong)NSMutableArray *xsDataArr;//存储小说数据
@property(nonatomic,strong)NSMutableArray *infoIdArr;//每条信息的ID
@end

@implementation CollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wzDataArr = [NSMutableArray arrayWithCapacity:0];
        self.tpDataArr = [NSMutableArray arrayWithCapacity:0];
        self.zzDataArr = [NSMutableArray arrayWithCapacity:0];
        self.xsDataArr = [NSMutableArray arrayWithCapacity:0];
        self.infoIdArr = [NSMutableArray arrayWithCapacity:0];
        _flag = 1300;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeUI];
    [self loadData];
	// Do any additional setup after loading the view.
}
-(void)makeUI
{
    //导航条
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:@[] andRightAction:nil andTarget:self andTitleName:@"我的收藏"];
    [self.view addSubview:detailNav];
    
    //布局二级菜单
    secondBtn = [[SecondMenuBtn alloc] initWithFrame:CGRectMake(0, 62, 320, 33) andTarget:self andAction:@selector(secondBtnDown:) andBtnName:@[@"文章",@"图片",@"杂志",@"小说"]];
    [self.view addSubview:secondBtn];
    
    //设置初次进入时，选中的时第一项
    secondBtn.selectImag.hidden = NO;
    secondBtn.selectImag.frame = CGRectMake((1300-1300)*self.view.frame.size.width/4+5, 2, 54, 25);
    
    [self makeTable];
    [self makeCollection];
    
    //初始化将收藏内容写入数据库的封装对象
    WAndR = [[CollectionWriteAndReadDB alloc] init];
    //收听到收藏与否的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"wenzhangZX" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"wenzhangZX-no" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"tupianArAA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"tupianArAA-no" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYesBB:) name:@"tupianArBB" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNoBB:) name:@"tupianArBB-no" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"xiaoshuoBB" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"xiaoshuoBB-no" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyYes:) name:@"zazhiArrBB" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyNo:) name:@"zazhiArrBB-no" object:nil];
}
//接收到收藏通知
-(void)notifyYes:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if (_flag == 1300) {
        [WAndR addCollec:articleId andDataArr:self.wzDataArr andFlag:1 andName:@"wenzhangZX"];
    }else if(_flag == 1301) {
        [WAndR addCollec:articleId andDataArr:self.tpDataArr andFlag:1 andName:@"tupianArAA"];
    }else if(_flag == 1302) {
        [WAndR addCollec:articleId andDataArr:self.zzDataArr andFlag:1 andName:@"zazhiArrBB"];
    }else {
        [WAndR addCollec:articleId andDataArr:self.xsDataArr andFlag:1 andName:@"xiaoshuoBB"];
    }
}
//接收到取消收藏通知
-(void)notifyNo:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if (_flag == 1300) {
        [WAndR addCollec:articleId andDataArr:self.wzDataArr andFlag:2 andName:@"wenzhangZX"];
    }else if(_flag == 1301) {
        [WAndR addCollec:articleId andDataArr:self.tpDataArr andFlag:2 andName:@"tupianArAA"];
    }else if(_flag == 1302) {
        [WAndR addCollec:articleId andDataArr:self.zzDataArr andFlag:2 andName:@"zazhiArrBB"];
    }else {
        [WAndR addCollec:articleId andDataArr:self.xsDataArr andFlag:2 andName:@"xiaoshuoBB"];
    }
}
//接收到收藏通知（视觉-漫画）
-(void)notifyYesBB:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if(_flag == 1301) {
        [WAndR addCollec:articleId andDataArr:self.tpDataArr andFlag:1 andName:@"tupianArBB"];
    }
}
//接收到取消收藏通知（视觉-漫画）
-(void)notifyNoBB:(NSNotification*)noti
{
    NSString *articleId = [noti object];
    if(_flag == 1301) {
        [WAndR addCollec:articleId andDataArr:self.tpDataArr andFlag:2 andName:@"tupianArBB"];
    }
}
//导航条左侧按钮点击事件
-(void)leftBtnDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
            table.hidden = NO;
            [self hiddenCollection];
            [table reloadData];
            break;
        }
        case 1301:
        {
            table.hidden = YES;
            [self loadData];
            [self hiddenCollection];
            UICollectionView *collection = (UICollectionView*)[self.view viewWithTag:1500];
            collection.hidden = NO;
            [collection reloadData];
            break;
        }
        case 1302:
        {
            table.hidden = YES;
            [self loadData];
            [self hiddenCollection];
            UICollectionView *collection = (UICollectionView*)[self.view viewWithTag:1501];
            collection.hidden = NO;
            [collection reloadData];
            break;
        }
        case 1303:
        {
            table.hidden = YES;
            [self loadData];
            [self hiddenCollection];
            UICollectionView *collection = (UICollectionView*)[self.view viewWithTag:1502];
            collection.hidden = NO;
            [collection reloadData];
            break;
        }
        default:
            break;
    }
}
//隐藏collection
-(void)hiddenCollection
{
    for (int i=0; i<3; i++) {
        UICollectionView *collection = (UICollectionView*)[self.view viewWithTag:1500+i];
        collection.hidden = YES;
    }
}
-(void)makeTable
{
    //设置table
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 95, 320, self.view.frame.size.height-95) style:UITableViewStylePlain];
    table.delegate =self;
    table.dataSource = self;
    //table.hidden = YES;
    [self.view addSubview:table];
}
-(void)makeCollection
{
    NSArray *idenArr = @[@"xx",@"yy",@"zz"];
    for (int i=0; i<3; i++) {
        //设置collecView的UICollectionViewFlowLayout
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        //实例化collectionView，初始化的时候用布局来初始化它
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 95, 320, self.view.frame.size.height-95) collectionViewLayout:layout];
        collection.dataSource = self;
        collection.delegate = self;
        collection.tag = 1500+i;
        collection.hidden = YES;
        
        [self.view addSubview:collection];
        
        //给collectionView注册复用的cell
        if (i==2 || i ==1) {
            collection.backgroundColor = [UIColor colorWithRed:40/255.0 green:55/255.0 blue:62/255.0 alpha:1];
            [collection registerClass:[MagazineListViewCell class] forCellWithReuseIdentifier:idenArr[i]];
        }else{
            collection.backgroundColor = [UIColor whiteColor];
            [collection registerClass:[IllustrationCollectionViewCell class] forCellWithReuseIdentifier:idenArr[i]];
        }
        
    }
}
-(void)loadData
{
    OperationDB *opDB = [[OperationDB alloc] init];
    NSMutableArray *set = [opDB readModelDataFromDBWithTableName:@"Collected" andDataName:@"Collection.db" andListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"]];
    for (int i=0; i<set.count; i++) {
        if (_flag == 1300) {
            if ([set[i][@"pictureId"] isEqualToString:@"wenzhang"]) {
                self.wzDataArr = [NSMutableArray arrayWithArray:set[i][@"indexPathSection"]];
                [table reloadData];
                break;
            }
        }else if (_flag == 1301){
            if ([set[i][@"pictureId"] isEqualToString:@"tupianAr"]) {
                self.tpDataArr = [NSMutableArray arrayWithArray:set[i][@"indexPathSection"]];
                break;
            }
        }else if (_flag == 1302){
            if ([set[i][@"pictureId"] isEqualToString:@"zazhiArr"]) {
                self.zzDataArr = [NSMutableArray arrayWithArray:set[i][@"indexPathSection"]];
                break;
            }
        }else if (_flag == 1303){
            if ([set[i][@"pictureId"] isEqualToString:@"xiaoshuo"]) {
                self.xsDataArr = [NSMutableArray arrayWithArray:set[i][@"indexPathSection"]];
                break;
            }
        }
        
    }
}
#pragma mark table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.wzDataArr.count;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"a"];
    if (cell == nil) {
        cell = [[InformationDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"a"];
    }
    modelHere = self.wzDataArr[indexPath.row];
    [cell.picImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com/%@",modelHere.icon]]];
    cell.titleLab.text = modelHere.title;
    cell.desLab.text = modelHere.des;
    cell.authorLab.text = [NSString stringWithFormat:@"作者 : %@",modelHere.author];
    cell.timeLab.text = modelHere.adddate;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    modelHere = self.wzDataArr[indexPath.row];
    for (int i=0; i<self.wzDataArr.count; i++) {
        [self.infoIdArr addObject:modelHere.idInfo];
    }
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.IDPic = modelHere.idInfo;
    detail.picIdArr = self.infoIdArr;
    detail.detailType = @"wenzhangZX";
    [self presentViewController:detail animated:YES completion:nil];
}
#pragma mark collection代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag == 1500) {
        return self.tpDataArr.count;
    }else if (collectionView.tag == 1501){
        return self.zzDataArr.count;
    }else{
        return self.xsDataArr.count;
    }
    
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    cellMaga.backgroundColor = [UIColor clearColor];
    if (collectionView.tag == 1500) {
         cellIll = [collectionView dequeueReusableCellWithReuseIdentifier:@"xx" forIndexPath:indexPath];
         modelHere = self.tpDataArr[indexPath.row];
    }else if (collectionView.tag == 1501){
         cellMaga = [collectionView dequeueReusableCellWithReuseIdentifier:@"yy" forIndexPath:indexPath];
         modelHere = self.zzDataArr[indexPath.row];
    }else{
         cellMaga = [collectionView dequeueReusableCellWithReuseIdentifier:@"zz" forIndexPath:indexPath];
         modelHere = self.xsDataArr[indexPath.row];
    }
    if (collectionView.tag == 1501 || collectionView.tag == 1502) {
        [cellMaga.magazinePic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com/%@",modelHere.icon]]];
        cellMaga.titleLab.text = modelHere.title;
        return cellMaga;
    }else{
        [cellIll.picImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com/%@",modelHere.icon]]];
        cellIll.nameLab.text = modelHere.title;
        return cellIll;
    }
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1500) {
        modelHere = self.tpDataArr[indexPath.row];
    }else if (collectionView.tag == 1501){
        modelHere = self.zzDataArr[indexPath.row];
    }else{
        modelHere = self.xsDataArr[indexPath.row];
    }
    if (collectionView.tag == 1501 || collectionView.tag == 1502) {
        MagazeneAndNovelDetailViewController *detailView = [[MagazeneAndNovelDetailViewController alloc] init];
        detailView.Id = modelHere.idInfo;
        if (collectionView.tag == 1501) {
            detailView.action = @"mag_section_list";
        }else{
            detailView.action = @"novel_section_list";
        }
        if (collectionView.tag == 1501) {
            detailView.magaDetail = @"小说1";
        }else{
            detailView.magaDetail = @"杂志1";
        }
        if (collectionView.tag == 1501) {
            detailView.titleName = @"小说";
        }else{
            detailView.titleName = @"杂志";
        }
        detailView.leftPic = modelHere.icon;
        detailView.infoTitleName = modelHere.title;
        detailView.authorName = modelHere.author;
        detailView.statusName = modelHere.status;
        detailView.updateName = modelHere.update;
        detailView.typeName = modelHere.type;
        detailView.keyWordName = modelHere.keyword;
        detailView.describName = modelHere.des;
        [self presentViewController:detailView animated:YES completion:nil];
    }else{
        if (modelHere.gid.length ==0) {
            CartoonViewController *detailView = [[CartoonViewController alloc] init];
            detailView.Id = modelHere.idInfo;
            //detailView.action = flag;
            detailView.leftPic = modelHere.icon;
            detailView.titleName = @"漫画";
            detailView.infoTitleName = modelHere.title;
            detailView.authorName = modelHere.author;
            detailView.statusName = modelHere.status;
            detailView.updateName = modelHere.update;
            detailView.typeName = modelHere.type;
            detailView.keyWordName = modelHere.keyword;
            detailView.describName = modelHere.des;
            [self presentViewController:detailView animated:YES completion:nil];
        }else{
            IllustrationDetailViewController *picDetailView = [[IllustrationDetailViewController alloc] init];
            picDetailView.picId = modelHere.gid;
            picDetailView.commentCount = modelHere.comment_totals;
            picDetailView.detailType = @"tupianArAA";
            [self presentViewController:picDetailView animated:YES completion:nil];
        }
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 1500) {
        return CGSizeMake(160, 170);
    }else{
        return CGSizeMake(self.view.frame.size.width/3.0, 140);
    }
}
//当在收藏页面取消收藏时，刷新收藏页面，重新加载数据
-(void)viewWillAppear:(BOOL)animated
{
    if (_flag == 1300) {
        [self loadData];
        [table reloadData];
    }else if (_flag == 1301){
        [self loadData];
        UICollectionView *collection = (UICollectionView*)[self.view viewWithTag:1500];
        [collection reloadData];
    }else if (_flag == 1302){
        [self loadData];
        UICollectionView *collection = (UICollectionView*)[self.view viewWithTag:1501];
        [collection reloadData];
    }else {
        [self loadData];
        UICollectionView *collection = (UICollectionView*)[self.view viewWithTag:1502];
        [collection reloadData];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
