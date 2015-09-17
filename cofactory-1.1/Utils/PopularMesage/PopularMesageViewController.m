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

//资讯详情页
#import "PopularMessageInfoVC.h"


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
}

@end

static NSString *const cellIdetifier1 = @"cellIdentifier1";
static NSString *const cellIdetifier2 = @"cellIdentifier2";

@implementation PopularMesageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"流行资讯";
    
    _titleImageArray = @[@{@"title":@"麻烦了柯达阿里付款说明",@"image":@"bb"},@{@"title":@"麻烦了柯达阿里付款说明",@"image":@"bb"}];
    [self creatSearchBar];
    [self creatTableView];
    [self creatHeadView];
    [self creatScrollViewAndPageControl];
}

- (void)creatSearchBar{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(30, 20, kScreenW-160, 30)];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    _searchBar.placeholder = @"搜索标题或作者";
    self.navigationItem.titleView = _searchBar;
    
    for(id button in [_searchBar.subviews[0] subviews])
    {
        if([button isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)button;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(cancelSearchClick) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    
}

- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[PMSectionOneTableViewCell class] forCellReuseIdentifier:cellIdetifier1];
    [_tableView registerClass:[PopularMesageTableViewCell class] forCellReuseIdentifier:cellIdetifier2];
    [self.view addSubview:_tableView];
}

- (void)creatHeadView{
    _tableViewHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 220)];
    _tableViewHeadView.backgroundColor = [UIColor colorWithRed:42/255.0 green:41/255.0 blue:42/255.0 alpha:1.0];
    NSArray *array = @[@"男装",@"女装",@"童装"];
    for (int i=0; i<3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20+i*((kScreenW-280)/2.0+80), 5, 80, 30);
        button.titleLabel.textColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button setTitle:array[i] forState:UIControlStateNormal];
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewHeadView addSubview:button];
    }
    _tableView.tableHeaderView = _tableViewHeadView;
    
}

- (void)creatScrollViewAndPageControl{
    
    _scrollViewImageArray = @[@"服装平台.jpg",@"时尚资讯.jpg",@"面辅料.jpg",@"加工订单可外包.jpg"];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, kScreenW, 180)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [_tableViewHeadView addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(kScreenW*_scrollViewImageArray.count, 180);
    _scrollView.delegate = self;
    
    for (int i = 0; i<_scrollViewImageArray.count; i++)
    {
        NSString *imgStr = _scrollViewImageArray[i];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW*i, 0, kScreenW, 180)];
        image.image = [UIImage imageNamed:imgStr];
        [_scrollView addSubview:image];
        
    }
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((kScreenW-100)/2.0, 205, 100, 10)];
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.numberOfPages = _scrollViewImageArray.count;
    [_tableViewHeadView addSubview:_pageControl];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    
}

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PMSectionOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier1 forIndexPath:indexPath];
        [cell getDataWithDictionary:_titleImageArray[indexPath.row]];
        return cell;
    }
    
    PopularMesageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier2 forIndexPath:indexPath];
    
    return cell;
    
}

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
    }return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PopularMessageInfoVC * infoVC = [[PopularMessageInfoVC alloc]init];
        [self.navigationController pushViewController:infoVC animated:YES];
        
    }else{
        
    }
}

#pragma mark - others
- (void)changeImage
{
    _count ++;
    
    _scrollView.contentOffset = CGPointMake((_count-1)*kScreenW, 0);
    
    if (_count > _scrollViewImageArray.count-1)
    {
        _count = 0;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x/kScreenW;
}

- (void)buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    DLog(@"%zi",button.tag);
}

- (void)cancelSearchClick{
    [_searchBar endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    DLog(@"333%@",searchBar.text);
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
