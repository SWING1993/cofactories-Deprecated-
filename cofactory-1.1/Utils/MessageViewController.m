//
//  MessageViewController.m
//  聚工厂
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "MessageViewController.h"
#import "MessageDetailViewController.h"

@interface MessageViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)NSMutableArray*messageArray;
@property (nonatomic, retain) UITableView *tableView;


@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.messageArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight=60;
    [self.view addSubview:self.tableView];

    //下拉刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

    [refreshControl beginRefreshing];

    [HttpClient getSystemMessageWithBlock:^(NSDictionary *responseDictionary) {
        if ([responseDictionary[@"statusCode"] intValue]==200) {
            self.messageArray=responseDictionary[@"responseArray"];
            [self.tableView reloadData];
            [refreshControl endRefreshing];
        };
    }];
    
    self.tabBarItem.badgeValue = nil;//22

}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 2.0;
    //列出合作商
    [HttpClient getSystemMessageWithBlock:^(NSDictionary *responseDictionary) {
        if ([responseDictionary[@"statusCode"] intValue]==200) {
            self.messageArray=responseDictionary[@"responseArray"];
        };
    }];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"下拉刷新结束");
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    });
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.messageArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        MessageModel*model = self.messageArray[indexPath.section];

        UIImageView*headerImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 44, 44)];
        headerImage.image=[UIImage imageNamed:@"消息头像"];
        headerImage.layer.cornerRadius=44/2.0f;
        [cell addSubview:headerImage];

        UILabel*headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenW, 20)];
        headerLabel.font=[UIFont boldSystemFontOfSize:14];
        headerLabel.text = @"消息";
        headerLabel.textAlignment=NSTextAlignmentCenter;
        [cell addSubview:headerLabel];

        UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenW-135, 5, 125, 20)];
        timeLabel.font=[UIFont boldSystemFontOfSize:14];
        timeLabel.textColor=[UIColor lightGrayColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.text = model.time1;
        [cell addSubview:timeLabel];

        UILabel*messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(64, 30, kScreenW-70, 20)];
        messageLabel.font=[UIFont boldSystemFontOfSize:14];
        messageLabel.textColor=[UIColor lightGrayColor];
        messageLabel.text = model.message;
        [cell addSubview:messageLabel];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MessageModel*model = self.messageArray[indexPath.section];
    MessageDetailViewController*messageDetailVC = [[MessageDetailViewController alloc]init];
    messageDetailVC.hidesBottomBarWhenPushed=YES;
    messageDetailVC.timeString=model.time2;
    messageDetailVC.messageStr=model.message;
    [self.navigationController pushViewController:messageDetailVC animated:YES];

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
