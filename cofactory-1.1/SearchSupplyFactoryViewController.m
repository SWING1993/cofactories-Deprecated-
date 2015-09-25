//
//  SearchSupplyFactoryViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "SearchSupplyFactoryViewController.h"
#import "SearchSupplyViewCell.h"
#import "SearchSupplymaterialViewController.h"
#import "LookoverMaterialViewController.h"
#import "MJRefresh.h"

@interface SearchSupplyFactoryViewController () {
    int                _refrushCount;
}

@end

static NSString *searchCellIdentifier = @"SearchCell";

@implementation SearchSupplyFactoryViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.historyArray = [NSMutableArray arrayWithCapacity:0];
    if (_isMe) {
        
        self.title = @"查看面辅料";
        [HttpClient searchMaterialWithKeywords:@"" type:@"" page:1 completionBlock:^(NSDictionary *responseDictionary) {
            
            NSArray *jsonArray = (NSArray *)responseDictionary[@"responseObject"];
            
            for (NSDictionary *dictionary in jsonArray) {
                SupplyHistory *history = [SupplyHistory getModelWith:dictionary];
                [self.historyArray addObject:history];
            }

                [self.tableView reloadData];
        }];
        
        [self setupRefreshIsMe];
        
    }else{
        self.title = @"历史发布";
        [self network];
        [self setupRefresh];
    }
    
    _refrushCount = 1;
    //注册cell
    [self.tableView registerClass:[SearchSupplyViewCell class] forCellReuseIdentifier:searchCellIdentifier];

}


- (void)network {
    [HttpClient checkMaterialHistoryPublishWithPage:1 completionBlock:^(NSDictionary *responseDictionary) {
        
        NSArray *jsonArray = (NSArray *)responseDictionary[@"responseObject"];
       
        for (NSDictionary *dictionary in jsonArray) {
            
            SupplyHistory *history = [SupplyHistory getModelWith:dictionary];
            
            [self.historyArray addObject:history];
        }

        [self.tableView reloadData];
    }];

}
- (void)setupRefreshIsMe
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshingIsMe)];
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"加载中。。。";
}

- (void)footerRereshingIsMe
{
    _refrushCount++;
    DLog(@"???????????%d",_refrushCount);
    [HttpClient searchMaterialWithKeywords:@"" type:@"" page:_refrushCount completionBlock:^(NSDictionary *responseDictionary) {
        
        NSArray *jsonArray = (NSArray *)responseDictionary[@"responseObject"];
        
        for (NSDictionary *dictionary in jsonArray) {
            SupplyHistory *history = [SupplyHistory getModelWith:dictionary];
            [self.historyArray addObject:history];
        }
        
        [self.tableView reloadData];
    }];
    
    [self.tableView footerEndRefreshing];
}
- (void)setupRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshingIsMe)];
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"加载中。。。";
}

- (void)footerRereshing
{
    _refrushCount++;
    DLog(@"???????????%d",_refrushCount);
    [HttpClient checkMaterialHistoryPublishWithPage:_refrushCount completionBlock:^(NSDictionary *responseDictionary) {
        
        NSArray *jsonArray = (NSArray *)responseDictionary[@"responseObject"];
        
        for (NSDictionary *dictionary in jsonArray) {
            
            SupplyHistory *history = [SupplyHistory getModelWith:dictionary];
            
            [self.historyArray addObject:history];
        }
        
        [self.tableView reloadData];
    }];
    
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
    return self.historyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchSupplyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
    SupplyHistory *history = self.historyArray[indexPath.row];
    cell.history = history;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_isMe) {
        SupplyHistory *history = self.historyArray[indexPath.row];
        LookoverMaterialViewController *VC= [[LookoverMaterialViewController alloc]initWithOid:history.oid];
       
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title = @"";
        backItem.tintColor=[UIColor whiteColor];
        self.navigationItem.backBarButtonItem = backItem;
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController pushViewController:VC animated:YES];
    }else{
        
        SearchSupplymaterialViewController *searchSupplymaterialVC = [[SearchSupplymaterialViewController alloc] init];
        SupplyHistory *history = self.historyArray[indexPath.row];
        searchSupplymaterialVC.oid = history.oid;
        searchSupplymaterialVC.type = history.type;
        searchSupplymaterialVC.photoArray = [NSMutableArray arrayWithArray:history.photoArray];
        [self.navigationController pushViewController:searchSupplymaterialVC animated:YES];
    }
}

@end
