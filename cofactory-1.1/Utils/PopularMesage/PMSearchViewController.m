//
//  PMSearchViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "PMSearchViewController.h"
#import "PopularMesageTableViewCell.h"
#import "PopularMessageInfoVC.h"
#import "MJRefresh.h"
static NSString *searchCellIdentifier = @"searchCell";

@interface PMSearchViewController () {
    NSInteger _refrushCount;
}

@end

@implementation PMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    self.tableView.tableFooterView = [UIView new];
    //注册cell
    [self.tableView registerClass:[PopularMesageTableViewCell class] forCellReuseIdentifier:searchCellIdentifier];
    _refrushCount = 1;
    self.searchArray = [NSMutableArray arrayWithCapacity:0];
    [self netWork];
    [self setupRefresh];
    
}


- (void)netWork {
    
    [HttpClient getInfomationWithKind:[NSString stringWithFormat:@"s=%@", self.searchText] page:_refrushCount andBlock:^(NSDictionary *responseDictionary){
        NSArray *jsonArray = responseDictionary[@"responseArray"];
        for (NSDictionary *dictionary in jsonArray) {
            InformationModel *information = [[InformationModel alloc] initModelWith:dictionary];
            
            [self.searchArray addObject:information];
        }
        [self.tableView reloadData];
    }];
}

- (void)setupRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"加载中。。。";
}

- (void)footerRereshing
{
    _refrushCount++;
    DLog(@"???????????%ld",_refrushCount);
    
    [self netWork];
    [self.tableView footerEndRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PopularMesageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
    InformationModel *information = self.searchArray[indexPath.row];
    cell.information = information;
    
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InformationModel *information = self.searchArray[indexPath.row];
    PopularMessageInfoVC *popularMessageVC = [[PopularMessageInfoVC alloc] init];
    popularMessageVC.urlString = information.urlString;
    popularMessageVC.oid = information.oid;
    popularMessageVC.name = information.title;
    
    [self.navigationController pushViewController:popularMessageVC animated:YES];
}

@end
