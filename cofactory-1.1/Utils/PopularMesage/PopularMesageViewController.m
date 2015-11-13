//
//  PopularMesageViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/15.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "MJRefresh.h"
#import "PopularMesageViewController.h"
#import "PopularMesageTableViewCell.h"
#import "PMSectionOneTableViewCell.h"
#import "PageView.h"
#import "PMSearchViewController.h"
//资讯详情页
#import "PopularMessageInfoVC.h"
#define kSearchFrameLong CGRectMake(50, 25, kScreenW-50, 30)
#define kSearchFrameShort CGRectMake(50, 25, kScreenW-100, 30)

@interface PopularMesageViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIScrollViewDelegate>{
    UITableView       *_tableView;
    NSArray           *_dataArray;
    NSArray           *_titleImageArray;
    UIView            *_tableViewHeadView;
    UIScrollView      *_scrollView;
    UIPageControl     *_pageControl;
    NSArray           *_scrollViewImageArray;
    int                _count;
    UISearchBar       *_searchBar;
    UILabel           *_lineLabel;
    UIView            *bigView;
    NSInteger         _refrushCount;
    NSString          *select;
}

@end

static NSString *const cellIdetifier1 = @"cellIdentifier1";
static NSString *const cellIdetifier2 = @"cellIdentifier2";

@implementation PopularMesageViewController

- (void)viewWillAppear:(BOOL)animated {
    [self creatSearchBar];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [Tools showLoadString:@"正在加载中..."];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    [self creatTableView];
    [self creatTableViewHeadView];
    [self netWorker];
    [self setupRefresh];
    _refrushCount = 1;
//    [self creatScrollViewAndPageControl];
    select = @"cat=child";
}


#pragma mark - 网络请求

- (void)netWorker {
    [HttpClient getHeaderInfomationWithKind:@"置顶" andBlock:^(NSDictionary *responseDictionary) {
        NSArray *jsonArray = responseDictionary[@"responseArray"];
        self.headerInformationArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
        for (NSDictionary *dictionary in jsonArray) {
            InformationModel *information = [[InformationModel alloc] initModelWith:dictionary];
            [self.headerInformationArray addObject:information];
        }
        [self netWork];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationRight];
    }];
}

- (void)netWork {
    [HttpClient getInfomationWithKind:@"cat=child" page:1 andBlock:^(NSDictionary *responseDictionary){
        self.informationArray = [NSMutableArray arrayWithCapacity:0];
        NSArray *jsonArray = responseDictionary[@"responseArray"];
        for (NSDictionary *dictionary in jsonArray) {
            InformationModel *information = [[InformationModel alloc] initModelWith:dictionary];
            
            [self.informationArray addObject:information];
        }
        
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationLeft];
            [Tools WSProgressHUDDismiss];
    }];
}

#pragma mark - 创建UI
- (void)creatSearchBar{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _searchBar = [[UISearchBar alloc] initWithFrame:kSearchFrameLong];
    _searchBar.delegate = self;
    [self.navigationController.view addSubview:_searchBar];
    [_searchBar setBackgroundImage:[[UIImage alloc] init] ];
    _searchBar.placeholder = @"搜索标题或作者";
    
}

- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[PMSectionOneTableViewCell class] forCellReuseIdentifier:cellIdetifier1];
    [_tableView registerClass:[PopularMesageTableViewCell class] forCellReuseIdentifier:cellIdetifier2];
    
    [self.view addSubview:_tableView];
}

- (void)creatTableViewHeadView{
    _tableViewHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50 + 0.4*kScreenW)];
    
    NSArray*btnTitleArray = @[@"童装",@"男装",@"女装",@"面料"];
    UIView*headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    headerView.backgroundColor=[UIColor whiteColor];
    for (int i=0; i<4; i++) {
        UIButton*typeBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW-280)/5+i*((kScreenW-280)/5+70), 10, 70 , 30)];
        if (i==0) {
            //设置与按钮同步的下划线Label
            _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeBtn.frame.origin.x, 40, 70,2 )];
            _lineLabel.backgroundColor = [UIColor redColor];
            [_tableViewHeadView addSubview:_lineLabel];
        }
        typeBtn.tag=i;
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:16.0f];
        [typeBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewHeadView addSubview:typeBtn];
    }
    _tableView.tableHeaderView = _tableViewHeadView;
    
    [HttpClient getHeaderInfomationWithKind:@"轮播" andBlock:^(NSDictionary *responseDictionary) {
        NSArray *jsonArray = responseDictionary[@"responseArray"];
        self.photoArray = [[NSMutableArray alloc] initWithCapacity:jsonArray.count];
        self.urlArray = [NSMutableArray arrayWithCapacity:jsonArray.count];
        for (NSDictionary *dictionary in jsonArray) {
            InformationModel *information = [[InformationModel alloc] initModelWith:dictionary];
            NSString* encodedString = [information.photoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self.photoArray addObject:encodedString];
            [self.urlArray addObject:information];
        }
//        DLog(@"^^^^^^^^^^^^%@", self.photoArray);
        PageView *bannerView = [[PageView alloc] initWithFrame:CGRectMake(0, 50, kScreenW, 0.4*kScreenW) andImageArray:self.photoArray pageCount:4 isNetWork:YES netWork:YES];
        [bannerView.imageButton1 addTarget:self action:@selector(bannerViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [bannerView.imageButton2 addTarget:self action:@selector(bannerViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [bannerView.imageButton3 addTarget:self action:@selector(bannerViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [bannerView.imageButton4 addTarget:self action:@selector(bannerViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewHeadView addSubview:bannerView];
    }];
}

- (void)bannerViewClick:(UIButton *)button {
    [self removeSearchBar];
    PopularMessageInfoVC * infoVC = [[PopularMessageInfoVC alloc]init];
    InformationModel *information = self.urlArray[button.tag];
    infoVC.urlString = information.urlString;
    infoVC.oid = information.oid;
    infoVC.name = information.title;
    [self.navigationController pushViewController:infoVC animated:YES];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.headerInformationArray.count;
    }else{
        return self.informationArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PMSectionOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier1 forIndexPath:indexPath];
        //[cell getDataWithDictionary:_titleImageArray[indexPath.row]];
        InformationModel *information = [[InformationModel alloc] init];
        information = self.headerInformationArray[indexPath.row];
        cell.information = information;
        
        return cell;
    } else {
        PopularMesageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier2 forIndexPath:indexPath];
        InformationModel *information = [[InformationModel alloc] init];
        information = self.informationArray[indexPath.row];
        cell.information = information;
        
        
        return cell;
    }
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    } else {
        return 0.0001;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 60;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self removeSearchBar];
    if (indexPath.section == 0) {
        PopularMessageInfoVC * infoVC = [[PopularMessageInfoVC alloc]init];
        InformationModel *information = self.headerInformationArray[indexPath.row];
        infoVC.urlString = information.urlString;
        infoVC.oid = information.oid;
        infoVC.name = information.title;
        [self.navigationController pushViewController:infoVC animated:YES];
        
    }else{
        PopularMessageInfoVC * infoVC = [[PopularMessageInfoVC alloc]init];
        InformationModel *information = self.informationArray[indexPath.row];
        infoVC.urlString = information.urlString;
        infoVC.oid = information.oid;
        infoVC.name = information.title;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}

#pragma mark - UISearchBarDelegate

//点击搜索框改变seachBar的大小，创建取消按钮，添加一层View
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (_searchBar.frame.size.width == kScreenW-50) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleButtonClick)];
        _searchBar.frame = kSearchFrameShort;
        bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        bigView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self.view addSubview:bigView];
    }
}


//点击搜索出结果
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //搜索完移除view改变searchBar的大小
    [searchBar resignFirstResponder];
    [bigView removeFromSuperview];
    _searchBar.frame = kSearchFrameLong;
    self.searchArray = [NSMutableArray arrayWithCapacity:0];
    [HttpClient getInfomationWithKind:[NSString stringWithFormat:@"s=%@", searchBar.text] page:1 andBlock:^(NSDictionary *responseDictionary){
        NSArray *jsonArray = responseDictionary[@"responseArray"];
        for (NSDictionary *dictionary in jsonArray) {
            InformationModel *information = [[InformationModel alloc] initModelWith:dictionary];
            
            [self.searchArray addObject:information];
        }
//        self.searchArray = [NSMutableArray arrayWithArray:responseDictionary[@"responseArray"]];
        if (self.searchArray.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"搜索结果为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
        } else {
            [self removeSearchBar];
            PMSearchViewController *PMSearchVC = [[PMSearchViewController alloc] init];
//            PMSearchVC.searchArray = [NSMutableArray arrayWithArray:self.searchArray];
            PMSearchVC.searchText = searchBar.text;
            [self.navigationController pushViewController:PMSearchVC animated:YES];
        }
    }];
}


//点击键盘之外的View移除View
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_searchBar isExclusiveTouch]) {
        [_searchBar resignFirstResponder];
        [bigView removeFromSuperview];
        _searchBar.frame = kSearchFrameLong;
    }
}

#pragma mark - Action
- (void)buttonClick:(UIButton *)button{
    NSArray *kindArray = @[@"cat=child", @"cat=man", @"cat=woman", @"cat=fabirrc"];
    select = kindArray[button.tag];
    _refrushCount = 1;
    self.informationArray = [NSMutableArray arrayWithCapacity:0];
    // 控制下划线Label与按钮的同步
    [UIView animateWithDuration:0.2 animations:^{
        _lineLabel.frame = CGRectMake(button.frame.origin.x, 40, button.frame.size.width, 2);
    }];
    [Tools showLoadString:@"正在加载中..."];
    
    [HttpClient getInfomationWithKind:select page:_refrushCount andBlock:^(NSDictionary *responseDictionary) {
        NSArray *jsonArray = responseDictionary[@"responseArray"];
        for (NSDictionary *dictionary in jsonArray) {
            InformationModel *information = [[InformationModel alloc] initModelWith:dictionary];
            
            [self.informationArray addObject:information];
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
        [Tools WSProgressHUDDismiss];
        
    }];
}


//点击取消收回键盘，移除View，改变seachBar的大小
- (void)cancleButtonClick {
    //收回键盘
    [_searchBar resignFirstResponder];
    [bigView removeFromSuperview];
    _searchBar.frame = kSearchFrameLong;
    
}

//返回时移除searchBar
- (void)back {
    [_searchBar removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
//同时移除searchBar和View（在当前页面操作）
- (void)removeSearchBar {
    [_searchBar removeFromSuperview];
    [bigView removeFromSuperview];
}

- (void)dealloc{
    _tableView.delegate =nil;
    _tableView.dataSource = nil;
    
}


- (void)setupRefresh
{
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中。。。";
}

- (void)footerRereshing
{
    _refrushCount++;
    DLog(@"???????????%ld",_refrushCount);

    [HttpClient getInfomationWithKind:select page:_refrushCount andBlock:^(NSDictionary *responseDictionary) {
        NSArray *jsonArray = responseDictionary[@"responseArray"];
        for (NSDictionary *dictionary in jsonArray) {
            InformationModel *information = [[InformationModel alloc] initModelWith:dictionary];
            [self.informationArray addObject:information];
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    }];
    [_tableView footerEndRefreshing];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
