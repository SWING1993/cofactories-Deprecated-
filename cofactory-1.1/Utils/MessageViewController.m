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

@interface MessageViewController ()

@property (nonatomic,retain)NSMutableArray*messageArray;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.messageArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kScreenW, kScreenH-(kNavigationBarHeight+kStatusBarHeight)) style:UITableViewStyleGrouped];
    self.tableView.rowHeight=60;
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭

    [HttpClient getSystemMessageWithBlock:^(NSDictionary *responseDictionary) {
        if ([responseDictionary[@"statusCode"] intValue]==200) {

//            NSLog(@"%@",responseDictionary);

            self.messageArray=responseDictionary[@"responseArray"];

            [self.tableView reloadData];

        };
    }];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.messageArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString*CellIdentifier=@"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    MessageModel*model = self.messageArray[indexPath.row];

    UIImageView*headerImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 44, 44)];
    headerImage.image=[UIImage imageNamed:@"消息头像"];
    headerImage.layer.cornerRadius=44/2.0f;
    [cell addSubview:headerImage];

    UILabel*headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenW, 20)];
    //headerLabel.backgroundColor=[UIColor greenColor];
    headerLabel.font=[UIFont boldSystemFontOfSize:14];
    headerLabel.text = @"消息";
    headerLabel.textAlignment=NSTextAlignmentCenter;
    [cell addSubview:headerLabel];
    
    UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenW-95, 5, 85, 20)];
//    timeLabel.backgroundColor=[UIColor redColor];
    timeLabel.font=[UIFont boldSystemFontOfSize:14];
    timeLabel.textColor=[UIColor lightGrayColor];
    timeLabel.text = model.time1;
    [cell addSubview:timeLabel];
    
    UILabel*messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(64, 30, kScreenW-70, 20)];
    //messageLabel.backgroundColor=[UIColor greenColor];
    messageLabel.font=[UIFont boldSystemFontOfSize:14];
    messageLabel.textColor=[UIColor lightGrayColor];
    messageLabel.text = model.message;
    [cell addSubview:messageLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
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
