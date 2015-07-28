//
//  SetViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "SetViewController.h"

@interface SetViewController () <UIAlertViewDelegate>

@end

@implementation SetViewController {
    UITextField*inviteCodeTF;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    
    inviteCodeTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, kScreenW/2-10, 34)];
    inviteCodeTF.borderStyle=UITextBorderStyleRoundedRect;
    inviteCodeTF.keyboardType=UIKeyboardTypeNumberPad;
    inviteCodeTF.placeholder=@"邀请码";
    //设置Btn
    UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(quitButtonClicked)];
    self.navigationItem.rightBarButtonItem = quitButton;
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

}

- (void)quitButtonClicked{

    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"确定退出" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [HttpClient logout];
        [ViewController goLogin];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.font=[UIFont systemFontOfSize:16];
        cell.detailTextLabel.textColor=[UIColor blackColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        switch (indexPath.section) {
            case 0:{
                cell.textLabel.text=@"修改密码";

            }
                break;
                
            case 1:{
                cell.textLabel.text=@"意见反馈";

            }
                break;
            case 2:{
                [cell addSubview:inviteCodeTF];
                UIButton*OKBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-70, 5, 60, 34)];
                [OKBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
                [OKBtn setTitle:@"确定" forState:UIControlStateNormal];
                [OKBtn addTarget:self action:@selector(OKBtn) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:OKBtn];
            }
                break;
                
            default:
                break;
        }

    }
        return cell;
}
- (void)OKBtn {

    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"邀请码提交成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
    [HttpClient registerWithInviteCode:inviteCodeTF.text andBlock:^(NSDictionary *responseDictionary) {
        NSLog(@"%@",responseDictionary);
    }];
    
//    [HttpClient registerWithUsername:nil InviteCode:inviteCodeTF.text password:nil factoryType:nil verifyCode:nil factoryName:nil lon:nil lat:@000 factorySizeMin:@000 factorySizeMax:@000 factoryAddress:nil factoryServiceRange:nil andBlock:^(NSDictionary *responseDictionary) {
//        NSLog(@"%@",responseDictionary);
//    }];


}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.01f)];
    //view.backgroundColor = [UIColor colorWithHex:0xf0efea];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            RevisePasswordViewController*reviseVC = [[RevisePasswordViewController alloc]init];
            [self.navigationController pushViewController:reviseVC animated:YES];

        }
            break;
        case 1:{
            FeedbackViewController*feedbackVC = [[FeedbackViewController alloc]init];
            feedbackVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:feedbackVC animated:YES];
        }
            break;
        case 2:{
//            AboutViewController*aboutVC = [[AboutViewController alloc]init];
//            aboutVC.hidesBottomBarWhenPushed=YES;
//            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
                    
        default:
            break;
    }
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
