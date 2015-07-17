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

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kScreenW, kScreenH-(kNavigationBarHeight+kStatusBarHeight)) style:UITableViewStyleGrouped];
    self.tableView.rowHeight=54;
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString*CellIdentifier=@"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
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
    
    UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenW-90, 5, 80, 20)];
    //headerLabel.backgroundColor=[UIColor redColor];
    timeLabel.font=[UIFont boldSystemFontOfSize:14];
    timeLabel.textColor=[UIColor lightGrayColor];
    //timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.text = @"2015-10-31 ➤";
    [cell addSubview:timeLabel];
    
    UILabel*messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(64, 30, kScreenW-70, 20)];
    //messageLabel.backgroundColor=[UIColor greenColor];
    messageLabel.font=[UIFont boldSystemFontOfSize:14];
    messageLabel.textColor=[UIColor lightGrayColor];
    messageLabel.text = @"聚工厂验证码：123456 有效期十分钟，请您抓紧时间，机不可失，失不再来";
    [cell addSubview:messageLabel];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageDetailViewController*messageDetailVC = [[MessageDetailViewController alloc]init];
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
