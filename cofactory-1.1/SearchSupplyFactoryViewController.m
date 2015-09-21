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

@interface SearchSupplyFactoryViewController ()

@end

static NSString *searchCellIdentifier = @"SearchCell";

@implementation SearchSupplyFactoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"求购信息";
    //注册cell
    [self.tableView registerClass:[SearchSupplyViewCell class] forCellReuseIdentifier:searchCellIdentifier];
    
    
    
    
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
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchSupplyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchSupplymaterialViewController *searchSupplymaterialVC = [[SearchSupplymaterialViewController alloc] init];
    [self.navigationController pushViewController:searchSupplymaterialVC animated:YES];
}

@end
