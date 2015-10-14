//
//  PopularMesageViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/15.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

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

    
    _titleImageArray = @[@{@"title":@"时尚服装咨询师-LIJO",@"image":@"1.png"},@{@"title":@"15-16秋冬童装新款解析-Wild",@"image":@"2.png"}];
    [Tools showLoadString:@"正在加载中..."];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = @"返回";
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    
    [self creatTableView];
    [self creatTableViewHeadView];
    [self netWork];
//    [self creatScrollViewAndPageControl];
    
}


#pragma mark - 网络请求

- (void)netWorker {
    [HttpClient getHeaderInfomationWithBlock:^(NSDictionary *responseDictionary) {
        self.headerInformationArray = [NSMutableArray arrayWithArray:responseDictionary[@"responseArray"]];
        DLog(@"%@", self.headerInformationArray);
        [Tools WSProgressHUDDismiss];
        [_tableView reloadData];
    }];

}

- (void)netWork {
        [HttpClient getInfomationWithKind:@"cat=man" andBlock:^(NSDictionary *responseDictionary) {
        self.informationArray = [NSMutableArray arrayWithArray:responseDictionary[@"responseArray"]];
            [self netWorker];
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
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [[UIView alloc] init];
    [_tableView registerClass:[PMSectionOneTableViewCell class] forCellReuseIdentifier:cellIdetifier1];
    [_tableView registerClass:[PopularMesageTableViewCell class] forCellReuseIdentifier:cellIdetifier2];
    
    [self.view addSubview:_tableView];
}

- (void)creatTableViewHeadView{
    _tableViewHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50 + 0.4*kScreenW)];
    
    NSArray*btnTitleArray = @[@"男装",@"女装",@"童装"];
    UIView*headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    headerView.backgroundColor=[UIColor whiteColor];
    for (int i=0; i<3; i++) {
        UIButton*typeBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW-240)/4+i*((kScreenW-240)/4+80), 10, 80 , 30)];
        if (i==0) {
            //设置与按钮同步的下划线Label
            _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeBtn.frame.origin.x, 40, 80,2 )];
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
    NSArray *imageArray = @[@"时尚资讯.png",@"童装设计潮流趋势.png",@"男装新潮流.png",@"女装新潮流.png"];
    PageView *bannerView = [[PageView alloc] initWithFrame:CGRectMake(0, 50, kScreenW, 0.4*kScreenW) andImageArray:imageArray pageCount:4 isNetWork:NO];
    [_tableViewHeadView addSubview:bannerView];
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
    
    if (section == 0) {
        return 0.0001;
    }if (section == 1) {
        return 15;
    }
    return 0;
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
    [HttpClient getInfomationWithKind:[NSString stringWithFormat:@"s=%@", searchBar.text] andBlock:^(NSDictionary *responseDictionary) {
        self.searchArray = [NSMutableArray arrayWithArray:responseDictionary[@"responseArray"]];
        if (self.searchArray.count == 0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"搜索结果为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            
        } else {
            [self removeSearchBar];
            PMSearchViewController *PMSearchVC = [[PMSearchViewController alloc] init];
            PMSearchVC.searchArray = [NSMutableArray arrayWithArray:self.searchArray];
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
    // 控制下划线Label与按钮的同步
    [UIView animateWithDuration:0.2 animations:^{
        _lineLabel.frame = CGRectMake(button.frame.origin.x, 40, button.frame.size.width, 2);
    }];
    [Tools showLoadString:@"正在加载中..."];
    NSArray *kindArray = @[@"cat=man", @"cat=woman", @"cat=child"];
    [HttpClient getInfomationWithKind:kindArray[button.tag] andBlock:^(NSDictionary *responseDictionary) {
        self.informationArray = [NSMutableArray arrayWithArray:responseDictionary[@"responseArray"]];
        [self netWorker];
        //[_tableView reloadData];
    }];

    DLog(@"%zi",button.tag);
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
