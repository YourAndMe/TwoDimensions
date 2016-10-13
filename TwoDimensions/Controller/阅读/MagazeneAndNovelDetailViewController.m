//
//  MagazeneAndNovelDetailViewController.m
//  TwoDimensions
//
//  Created by wzcMac on 15-1-15.
//  Copyright (c) 2015年 wzcMac. All rights reserved.
//

#import "MagazeneAndNovelDetailViewController.h"
#import "DetailNav.h"
#import "MagazineUpView.h"
#import "UIImageView+WebCache.h"
#import "MyMbd.h"
#import "NetWorkBlock.h"
#import "Model.h"
#import "MagazineDownTableViewCell.h"
#import "DetailViewController.h"
#import "OperationDB.h"
#import "FMDatabase.h"
#import "CollectionWriteAndReadDB.h"

@interface MagazeneAndNovelDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSIndexPath *index;
    OperationDB *opDB;
    CollectionWriteAndReadDB *WAndR;
}
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,retain)NSMutableArray *statusArr;//记录分组的显示状态
@property(nonatomic,strong)NSMutableArray *infoIdArr;//每条信息的ID

@end

@implementation MagazeneAndNovelDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArr = [NSMutableArray arrayWithCapacity:0];
        self.statusArr = [NSMutableArray arrayWithCapacity:0];
        self.infoIdArr = [NSMutableArray arrayWithCapacity:0];
        index = [NSIndexPath indexPathForRow:100000 inSection:100000];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self makeUI];
    [self loadData];
	// Do any additional setup after loading the view.
}

-(void)makeUI
{
    DetailNav *detailNav = [[DetailNav alloc] initWithFrame:CGRectMake(0, 20, 320, 44) andLeftImage:@"back_btn_n.png" andLeftImageHeightLight:@"back_btn_h.png" andLeftAction:@selector(leftBtnDown) andRightImage:nil andRightAction:nil andTarget:self andTitleName:self.titleName];
    [self.view addSubview:detailNav];
    
    [self loadUpView];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 155+64, self.view.frame.size.width, self.view.frame.size.height-155) style:UITableViewStyleGrouped];
    table.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    table.dataSource = self;
    table.delegate = self;
    [self.view addSubview:table];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    opDB = [[OperationDB alloc] init];
    
}

//导航条左侧按钮点击事件
-(void)leftBtnDown
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadUpView
{
    MagazineUpView *upView = [[MagazineUpView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 155)];
    [self.view addSubview:upView];
    [upView.leftPic setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com/%@",self.leftPic]]];
    float a,b,c,d,e,f,g;
    a = [self getWidthWithNSString:self.infoTitleName andStrSize:18];
    b = [self getWidthWithNSString:self.authorName andStrSize:14];
    c = [self getWidthWithNSString:self.statusName andStrSize:14];
    d = [self getWidthWithNSString:self.updateName andStrSize:14];
    e = [self getWidthWithNSString:self.typeName andStrSize:14];
    f = [self getWidthWithNSString:self.keyWordName andStrSize:14];
    g = [self getWidthWithNSString:self.describName andStrSize:14];
    
    upView.scr.contentSize = CGSizeMake(190, a+b+c+d+e+f+g+30);
    upView.titleNameLab.frame = CGRectMake(0, 0, 190, a);
    upView.authorLab.frame = CGRectMake(0, a+5, 190, b);
    upView.statusLab.frame = CGRectMake(0, a+b+10, 190, c);
    upView.updateLab.frame = CGRectMake(0, a+b+c+15, 190, d);
    upView.typeLab.frame = CGRectMake(0, a+b+c+d+20, 190, e);
    upView.keyWordLab.frame = CGRectMake(0, a+b+c+d+e+25, 190, f);
    upView.describLab.frame = CGRectMake(0, a+b+c+d+e+f+30, 190, g);
    
    upView.titleNameLab.text = self.infoTitleName;
    upView.authorLab.text = [NSString stringWithFormat:@"作者 : %@",self.authorName];
    if ([self.titleName isEqualToString:@"小说"]) {
        if ([self.statusName isEqualToString:@"0"]) {
            upView.statusLab.text = [NSString stringWithFormat:@"状态 : 连载中"];
        }else{
            upView.statusLab.text = [NSString stringWithFormat:@"状态 : 完结"];
        }
    }else{
        upView.statusLab.text = [NSString stringWithFormat:@"刊登于 : %@",self.statusName];
    }
    upView.updateLab.text = [NSString stringWithFormat:@"更新时间 : %@",self.updateName];
    upView.typeLab.text = [NSString stringWithFormat:@"类别 : %@",self.typeName];
    if ([self.keyWordName isEqualToString:@""]) {
        upView.keyWordLab.text = [NSString stringWithFormat:@"关键字 : 暂无"];
    }else{
        upView.keyWordLab.text = [NSString stringWithFormat:@"关键字 : %@",self.keyWordName];
    }
    
    upView.describLab.text = [NSString stringWithFormat:@"简介 : %@",self.describName];
}

-(void)loadData
{
    MyMbd *mb = [[MyMbd alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:mb];
    
    __weak MagazeneAndNovelDetailViewController *tempMagazine = self;
    NetWorkBlock *net = [NetWorkBlock alloc];
    [net requestNetWithUrl:[NSString stringWithFormat:@"http://ecy.cms.palmtrends.com//api_v2.php?action=%@&id=%d&e=8c8a161c0f3feec349e68a73b8a41191&uid=12858666&pid=10070&mobile=iPhone6,2&platform=i",self.action,[self.Id intValue]] andInterface:@"" andBodyOfRequestForKeyArr:nil andValueArr:nil andBlock:^(id result) {
        
        MyMbd *mb = (MyMbd*)[tempMagazine.view viewWithTag:12345];
        [mb removeFromSuperview];
        
        NSArray *arr = result[@"list"];
        [tempMagazine.dataArr removeAllObjects];
        [tempMagazine.infoIdArr removeAllObjects];
        for (NSDictionary *temp in arr) {
            Model *model = [[Model alloc] initWithDic:temp];//kvc赋值
            model.chapterId = temp[@"id"];
            [tempMagazine.dataArr addObject:model];
        }
        for (int i=0; i<tempMagazine.dataArr.count; i++) {
            Model *tModel = tempMagazine.dataArr[i];
            for (int j=0; j<tModel.list.count; j++) {
                [tempMagazine.infoIdArr addObject:tModel.list[j][@"id"]];
            }
        }
        //给状态数组初始化数据，0表示不显示，1表示显示
        for(int i = 0;i<tempMagazine.dataArr.count;i++)
        {
            if (i==0) {
                [self.statusArr addObject:@"1"];
            }else{
                [self.statusArr addObject:@"0"];
            }
        }
        NSMutableArray *set = [opDB readDataFromDBWithTableName:@"Chapter" andDataName:@"record.db" andListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"]];
        int i=0;
        for (; i<set.count; i++) {
            if ([set[i][@"pictureId"] isEqualToString:self.Id]) {
                index = [NSIndexPath indexPathForRow:[set[i][@"indexPathRow"] intValue] inSection:[set[i][@"indexPathSection"] intValue]];
                break;
            }
        }
        [table reloadData];
        
    } andType:YES];
}

#pragma mark table代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //先判断状态数组该段是否为1
    if([self.statusArr[section] isEqualToString:@"1"])
    {//当状态数组中该段为1时，正常返回这段的行数
        Model *modelCout = self.dataArr[section];
        return modelCout.list.count;
    }
    else
    {//当状态数组中该段为0时，这段行数就是0，不显示
        return 0;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MagazineDownTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ff"];
    if (cell == nil) {
        cell = [[MagazineDownTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ff"];
    }
    Model *modelHere = self.dataArr[indexPath.section];
    //复用的时候，如果该行前面的红星显示和文字颜色是蓝色，就将该行的红星隐藏，文字颜色还原
    if (cell.starPic.hidden == NO) {
        cell.starPic.hidden = YES;
        cell.chapterName.textColor = [UIColor whiteColor];
    }
    //复用的时候，如果出现选中的行时，则把选中行的红星显示，文字颜色变蓝
    if (index.section == indexPath.section && index.row == indexPath.row) {
        cell.starPic.hidden = NO;
        cell.chapterName.textColor = [UIColor colorWithRed:56/255.0 green:160/255.0 blue:201/255.0 alpha:1];
    }
    if (indexPath.row == 0) {
        cell.down.hidden = NO;
        cell.starPic.frame = CGRectMake(10, 15, 20, 20);
        cell.chapterName.frame = CGRectMake(35, 15, 275, 20);
        cell.chapterName.text = modelHere.list[indexPath.row][@"title"];
        cell.backgroundColor = [UIColor colorWithRed:40/255.0 green:55/255.0 blue:62/255.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.down.hidden = YES;
        cell.starPic.frame = CGRectMake(10, 5, 20, 20);
        cell.chapterName.frame = CGRectMake(35, 5, 275, 20);
        cell.chapterName.text = modelHere.list[indexPath.row][@"title"];
        cell.backgroundColor = [UIColor colorWithRed:40/255.0 green:55/255.0 blue:62/255.0 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40;
    }else{
        return 30;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0000000001f;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *chinese = @[@"第一章: ",@"第二章:",@"第三章:",@"第四章:",@"第五章:",@"第六章:",@"第七章:",@"第八章:",@"第九章:",@"第十章:",@"第十一章:",@"第十二章:",@"第十三章:",@"第十四章:",@"第十五章:",@"第十六章:",@"第十七章:",@"第十八章:",@"第十九章:",@"第二十章:"];
    Model *model = self.dataArr[section];
    //段头背景
    UIImageView *head = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    head.image = [UIImage imageNamed:@"蓝底@2x.png"];
    head.userInteractionEnabled = YES;
    //星星
    UIImageView *starPicture = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    starPicture.image = [UIImage imageNamed:@"大星星@2x.png"];
    if (index.section == section) {
        starPicture.hidden = NO;
    }else{
        starPicture.hidden = YES;
    }
    starPicture.tag = 11111+section;
    [head addSubview:starPicture];
    //标题
    UILabel *chapterNames = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 275, 20)];
    chapterNames.font = [UIFont boldSystemFontOfSize:18];
    chapterNames.textAlignment = NSTextAlignmentLeft;
    chapterNames.textColor = [UIColor whiteColor];
    chapterNames.text = [NSString stringWithFormat:@"%@%@",chinese[section],model.title];
    [head addSubview:chapterNames];
    //段头按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    [btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor clearColor];
    btn.tag = 22222+section;
    [head addSubview:btn];
    
    return head;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //首先将上次选中的段和行前面的红星隐藏，然后将这次选中的段和行前面的红星显示
    MagazineDownTableViewCell *lastCell = (MagazineDownTableViewCell*)[tableView cellForRowAtIndexPath:index];
    if (lastCell) {
        lastCell.chapterName.textColor = [UIColor whiteColor];
        lastCell.starPic.hidden = YES;
    }
    MagazineDownTableViewCell *cell = (MagazineDownTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell)
    {
        cell.starPic.hidden = NO;
        cell.chapterName.textColor = [UIColor colorWithRed:56/255.0 green:160/255.0 blue:201/255.0 alpha:1];
    }
    UIImageView *starPicture1 = (UIImageView*)[self.view viewWithTag:11111+index.section];
    starPicture1.hidden = YES;
    UIImageView *starPicture = (UIImageView*)[self.view viewWithTag:11111+indexPath.section];
    starPicture.hidden = NO;
    //记住这次选中的段和行
    index = indexPath;
    
    
    NSMutableArray *set = [opDB readDataFromDBWithTableName:@"Chapter" andDataName:@"record.db" andListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"]];
    if (!set.count) {
        [opDB whiteDataToDBWithListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"] andParameter:@{@"pictureId":self.Id,@"indexPathSection":[NSString stringWithFormat:@"%d",indexPath.section],@"indexPathRow":[NSString stringWithFormat:@"%d",indexPath.row]} andTabelName:@"Chapter" andDataName:@"record.db" andCate:1];
    }else{
        int i=0;
        for (; i<set.count; i++) {
            if ([set[i][@"pictureId"] isEqualToString:self.Id]) {
                [opDB whiteDataToDBWithListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"] andParameter:@{@"pictureId":self.Id,@"indexPathSection":[NSString stringWithFormat:@"%d",indexPath.section],@"indexPathRow":[NSString stringWithFormat:@"%d",indexPath.row]}  andTabelName:@"Chapter" andDataName:@"record.db" andCate:2];
                break;
            }
        }
        if (i == set.count && i != 0) {
            [opDB whiteDataToDBWithListName:@[@"pictureId",@"indexPathSection",@"indexPathRow"] andParameter:@{@"pictureId":self.Id,@"indexPathSection":[NSString stringWithFormat:@"%d",indexPath.section],@"indexPathRow":[NSString stringWithFormat:@"%d",indexPath.row]} andTabelName:@"Chapter" andDataName:@"record.db" andCate:1];
        }
    }
    
    //点击章节，进入文章
    Model *modelHere = self.dataArr[indexPath.section];
    DetailViewController *detail = [[DetailViewController alloc] init];
    detail.IDPic = modelHere.list[indexPath.row][@"id"];
    detail.picIdArr = self.infoIdArr;
    detail.isID = @"1";
    detail.novelAndMagaID = self.Id;
    if ([self.magaDetail isEqualToString:@"小说"]) {
        detail.detailType = @"xiaoshuoAA";
    }else if ([self.magaDetail isEqualToString:@"杂志"]){
        detail.detailType = @"zazhiArrAA";
    }else if ([self.magaDetail isEqualToString:@"小说1"]){
        detail.detailType = @"xiaoshuoBB";
    }else if ([self.magaDetail isEqualToString:@"杂志1"]){
        detail.detailType = @"zazhiArrBB";
    }
    [self presentViewController:detail animated:YES completion:nil];
    
    
}
//段头按钮点击事件
-(void)btnDown:(UIButton*)btn
{
    //把statusArr数组对应下标的元素从1-0，从0-1
    NSString *statusStr = self.statusArr[btn.tag - 22222];
    
    [self.statusArr replaceObjectAtIndex:btn.tag - 22222 withObject:[NSString stringWithFormat:@"%d",![statusStr intValue]]];//把数组对应下标的元素转为整形，置反后转成字符串替换原来的
    [table reloadData];//刷新，每次调用这个方法，会整个重新执行一次这个table的所有代理方法
}
//计算一定宽度下文字所占的高度
-(float)getWidthWithNSString:(NSString*)str andStrSize:(int)sizeNum
{
	return [str boundingRectWithSize:CGSizeMake(190, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:sizeNum]} context:nil].size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
