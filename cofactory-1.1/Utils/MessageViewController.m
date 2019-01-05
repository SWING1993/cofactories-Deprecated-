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
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-44) style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
//    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsVerticalScrollIndicator=NO;

    self.tableView.rowHeight=60;
    [self.view addSubview:self.tableView];

    //下拉刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];

    [refreshControl beginRefreshing];

    [HttpClient getSystemMessageWithBlock:^(NSDictionary *responseDictionary) {
        if ([responseDictionary[@"statusCode"] intValue]==200) {
            //判断网络状态 给用户相应提示
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
        DLog(@"下拉刷新结束");
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    });
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.messageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        MessageModel*model = self.messageArray[indexPath.row];

        UIImageView*headerImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7.5, 45, 45)];
        headerImage.image=[UIImage imageNamed:@"login_logo"];
        headerImage.layer.cornerRadius=44/2.0f;
        [cell addSubview:headerImage];

        UILabel*headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(64, 5, kScreenW-64, 20)];
        headerLabel.font=kFont;
        headerLabel.text = @"系统消息";
        headerLabel.textAlignment=NSTextAlignmentLeft;
        [cell addSubview:headerLabel];

        UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenW-135, 5, 125, 20)];
        timeLabel.font=kSmallFont;
        timeLabel.textColor=[UIColor lightGrayColor];
        timeLabel.textAlignment = NSTextAlignmentRight;
        timeLabel.text = model.time1;
        [cell addSubview:timeLabel];

        UILabel*messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(64, 30, kScreenW-70, 20)];
        messageLabel.font=kSmallFont;
        messageLabel.textColor=[UIColor grayColor];
        messageLabel.text = model.message;
        [cell addSubview:messageLabel];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MessageModel*model = self.messageArray[indexPath.row];
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
