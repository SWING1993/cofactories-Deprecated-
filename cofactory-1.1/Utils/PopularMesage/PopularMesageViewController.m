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
}

@end

static NSString *const cellIdetifier1 = @"cellIdentifier1";
static NSString *const cellIdetifier2 = @"cellIdentifier2";

@implementation PopularMesageViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"流行资讯";
    
    _titleImageArray = @[@{@"title":@"时尚服装咨询师-LIJO",@"image":@"1.png"},@{@"title":@"15-16秋冬童装新款解析-Wild",@"image":@"2.png"}];
    [self creatSearchBar];
    [self creatTableView];
    [self creatTableViewHeadView];
    [self netWork];
    [self netWorker];
//    [self tapBackground];
//    [self creatScrollViewAndPageControl];
}

- (void)netWorker {
    [HttpClient getHeaderInfomationWithBlock:^(NSDictionary *responseDictionary) {
        self.headerInformationArray = [NSMutableArray arrayWithArray:responseDictionary[@"responseArray"]];
        [_tableView reloadData];
    }];

}
- (void)netWork {
        [HttpClient getInfomationWithKind:@"cat=man" andBlock:^(NSDictionary *responseDictionary) {
        self.informationArray = [NSMutableArray arrayWithArray:responseDictionary[@"responseArray"]];
        [_tableView reloadData];
    }];
}

//-(void)tapBackground //退出键盘
//{
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce)];//定义一个手势
//    [tap setNumberOfTouchesRequired:1];//触击次数这里设为1
//    [_tableView addGestureRecognizer:tap];//添加手势到tableView中
//}
//-(void)tapOnce//手势方法
//{
//    [_searchBar resignFirstResponder];
//}
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

- (void)creatTableViewHeadView{
    _tableViewHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 230)];
    
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
    NSArray *imageArray = @[@"新功能.png",@"面辅料.png",@"时尚资讯x.png"];
    PageView *bannerView = [[PageView alloc] initWithFrame:CGRectMake(0, 50, kScreenW, 180) andImageArray:imageArray isNetWork:NO];
    [_tableViewHeadView addSubview:bannerView];
}

//- (void)creatHeadView{
//    _tableViewHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 220)];
//    _tableViewHeadView.backgroundColor = [UIColor colorWithRed:42/255.0 green:41/255.0 blue:42/255.0 alpha:1.0];
//    NSArray *array = @[@"男装",@"女装",@"童装"];
//    for (int i=0; i<3; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(20+i*((kScreenW-280)/2.0+80), 5, 80, 30);
//        button.titleLabel.textColor = [UIColor whiteColor];
//        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//        [button setTitle:array[i] forState:UIControlStateNormal];
//        button.tag = i;
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_tableViewHeadView addSubview:button];
//    }
//    _tableView.tableHeaderView = _tableViewHeadView;
//    
//    NSArray *imageArray = @[@"新功能.png",@"面辅料.png",@"时尚资讯x.png"];
//    PageView *bannerView = [[PageView alloc] initWithFrame:CGRectMake(0, 40, kScreenW, 180) andImageArray:imageArray isNetWork:NO];
//    [_tableViewHeadView addSubview:bannerView];
//
//
//}

- (void)dealloc{
    _tableView.delegate =nil;
    _tableView.dataSource = nil;
}
#pragma mark - tableView
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
    }
    
    PopularMesageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifier2 forIndexPath:indexPath];
    InformationModel *information = [[InformationModel alloc] init];
    information = self.informationArray[indexPath.row];
    cell.information = information;
    

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
        InformationModel *information = self.headerInformationArray[indexPath.row];
        infoVC.urlString = information.urlString;
        infoVC.oid = information.oid;
        
        [self.navigationController pushViewController:infoVC animated:YES];
        
    }else{
        PopularMessageInfoVC * infoVC = [[PopularMessageInfoVC alloc]init];
        InformationModel *information = self.informationArray[indexPath.row];
        infoVC.urlString = information.urlString;
        infoVC.oid = information.oid;
        [self.navigationController pushViewController:infoVC animated:YES];
    }
}

#pragma mark - others
- (void)buttonClick:(UIButton *)button{
    // 控制下划线Label与按钮的同步
    [UIView animateWithDuration:0.2 animations:^{
        _lineLabel.frame = CGRectMake(button.frame.origin.x, 40, button.frame.size.width, 2);
    }];

    NSArray *kindArray = @[@"cat=man", @"cat=woman", @"cat=child"];
    [HttpClient getInfomationWithKind:kindArray[button.tag] andBlock:^(NSDictionary *responseDictionary) {
        self.informationArray = [NSMutableArray arrayWithArray:responseDictionary[@"responseArray"]];
        [_tableView reloadData];
    }];

    DLog(@"%zi",button.tag);
}

- (void)cancelSearchClick{
    
    [_searchBar endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
     [HttpClient getInfomationWithKind:[NSString stringWithFormat:@"s=%@", searchBar.text] andBlock:^(NSDictionary *responseDictionary) {
         self.searchArray = [NSMutableArray arrayWithArray:responseDictionary[@"responseArray"]];
         if (self.searchArray.count == 0) {
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"搜索结果为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
             [alertView show];
             
         } else {
             PMSearchViewController *PMSearchVC = [[PMSearchViewController alloc] init];
             PMSearchVC.searchArray = [NSMutableArray arrayWithArray:self.searchArray];
             [self.navigationController pushViewController:PMSearchVC animated:YES];
         }
     }];
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
