//
//  IMChatListViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/10/14.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "IMChatListViewController.h"
#import "IMChatViewController.h"


@interface IMChatListViewController ()

@end

@implementation IMChatListViewController




//重载函数，onSelectedTableRow 是选择会话列表之后的事件，该接口开放是为了便于您自定义跳转事件。
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    conversationVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:conversationVC animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    self.tabBarItem.badgeValue = @"3";
}

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    DLog(@"=============================");
    int messageCount = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    //[[[[[self tabBarController] viewControllers] objectAtIndex: 2] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%d", messageCount]];
    //self.tabBarController.viewControllers[2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", messageCount];
    DLog(@"tttttttttttt%d", messageCount);
    if (messageCount>0) {
        self.tabBarController.viewControllers[0].tabBarItem.badgeValue = [[NSString alloc]initWithFormat:@"%d",messageCount];
    }else
    {
        self.tabBarController.viewControllers[0].tabBarItem.badgeValue = nil;
    }
    
}

- (void) didTapCellPortrait:(NSString*)userId {
   
    DLog(@"%@", userId);
    
//    CooperationInfoViewController *vc = [CooperationInfoViewController new];
//    vc.factoryModel = _userModel;
//    [self.navigationController.navigationBar setHidden:NO];
//    [self.navigationController pushViewController:vc animated:YES];
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
