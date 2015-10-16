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

static NSString *searchCellIdentifier = @"searchCell";

@interface PMSearchViewController ()

@end

@implementation PMSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索结果";
    //注册cell
    [self.tableView registerClass:[PopularMesageTableViewCell class] forCellReuseIdentifier:searchCellIdentifier];

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
