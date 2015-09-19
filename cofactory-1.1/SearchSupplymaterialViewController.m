//
//  SearchSupplymaterialViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "SearchSupplymaterialViewController.h"

@interface SearchSupplymaterialViewController ()

@end

static NSString *searchCellIdentifier = @"SearchCell";

@implementation SearchSupplymaterialViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self creatCancleButton];
    [self creatHeaderView];
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:searchCellIdentifier];
    


}

- (void)creatHeaderView {
    self.tableViewHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW + 40)];
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW)];
    self.photoView.image = [UIImage imageNamed:@"1"];
    [self.tableViewHeadView addSubview:self.photoView];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenW, kScreenW - 20, 40)];
    self.numberLabel.text = @"采购数量：300米";
    
    [self.tableViewHeadView addSubview:self.numberLabel];
    
    
    
    self.tableView.tableHeaderView = self.tableViewHeadView;
}


- (void)creatCancleButton {
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(20, 30, 30, 30);
    [cancleButton setImage:[UIImage imageNamed:@"nav_back_icon"] forState:UIControlStateNormal];
    cancleButton.layer.cornerRadius = 15;
    cancleButton.layer.masksToBounds = YES;
    [cancleButton addTarget:self action:@selector(pressCancleButton) forControlEvents:UIControlEventTouchUpInside];
    
    cancleButton.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.430];
    [self.view addSubview:cancleButton];

}

- (void)creatTableView {
//    [self.navigationController.navigationBar setHidden:YES];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenW, kScreenH + 40) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}




- (void)pressCancleButton {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
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
