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

@interface SearchSupplyFactoryViewController ()

@end

static NSString *searchCellIdentifier = @"SearchCell";

@implementation SearchSupplyFactoryViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isMe) {
        
        self.title = @"查看面辅料";
        [HttpClient searchMaterialWithKeywords:@"" type:@"" page:1 completionBlock:^(NSDictionary *responseDictionary) {
            DLog("responseDictionary==%@",responseDictionary);
            self.historyArray = responseDictionary[@"responseObject"];
            [self.tableView reloadData];
        }];
        
        
    }else{
        self.title = @"历史发布";
        [self network];
    }
    //注册cell
    [self.tableView registerClass:[SearchSupplyViewCell class] forCellReuseIdentifier:searchCellIdentifier];

}


- (void)network {
    [HttpClient checkMaterialHistoryPublishWithPage:1 completionBlock:^(NSDictionary *responseDictionary) {
        DLog(@"%@", responseDictionary[@"responseObject"]);
        self.historyArray = [NSMutableArray arrayWithArray:responseDictionary[@"responseObject"]];
        [self.tableView reloadData];
    }];

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
        [self.navigationController pushViewController:searchSupplymaterialVC animated:YES];
    }
}

@end
