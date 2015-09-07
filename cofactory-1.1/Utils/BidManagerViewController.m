//
//  BidManagerViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/7.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "BidManagerViewController.h"
#import "BidManagerTableViewCell.h"

static NSString *const cellIdentifer = @"bidCellIdentifer";

@interface BidManagerViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
}

@end

@implementation BidManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"投标管理";
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"确认中标" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBid)];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)  style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[BidManagerTableViewCell class] forCellReuseIdentifier:cellIdentifer];
    _tableView.rowHeight = 100;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.bidFactoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BidManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
    BidManagerModel *model = self.bidFactoryArray[indexPath.row];
    [cell getDataWithBidManagerModel:model];
    return cell;
}

- (void)confirmBid{
    DLog(@"confirmBid");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
