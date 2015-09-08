//
//  MessageDetailViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()


@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kScreenW, kScreenH-(kNavigationBarHeight+kStatusBarHeight)) style:UITableViewStylePlain];
    self.tableView.rowHeight=150;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //static NSString*CellIdentifier=@"cellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    
    UILabel*timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenW, 20)];
    timeLabel.font=[UIFont boldSystemFontOfSize:14];
    timeLabel.textColor=[UIColor grayColor];
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.text = _timeString;
    [cell addSubview:timeLabel];
    
    UIFont*font=[UIFont systemFontOfSize:14];
    UILabel*messageLabel=[[UILabel alloc]init];
    messageLabel.font=font;
    messageLabel.numberOfLines=0;
    messageLabel.textColor=[UIColor blackColor];
    messageLabel.text = _messageStr;
    CGSize size = [messageLabel.text sizeWithFont:font constrainedToSize:CGSizeMake(280, 100000) lineBreakMode:NSLineBreakByWordWrapping];
    messageLabel.frame=CGRectMake(20, 5, kScreenW-90, size.height+20);
    
    UIImageView *messageBgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 25, size.width+30, size.height+30)];
    messageBgView.image=[UIImage imageNamed:@"消息框"];
    messageBgView.contentMode=UIViewContentModeScaleToFill;
    [messageBgView addSubview:messageLabel];
    [cell addSubview:messageBgView];

    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    UIFont*font=[UIFont systemFontOfSize:14];

    CGSize size = [_messageStr sizeWithFont:font constrainedToSize:CGSizeMake(280, 100000) lineBreakMode:NSLineBreakByWordWrapping];

    return size.height+80.0f;
}

- (void)dealloc
{
    DLog(@"释放内存");
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
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
