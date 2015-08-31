//
//  SetViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "SetViewController.h"
#import "UMSocial.h"
#import "UMFeedback.h"


@interface SetViewController () <UIAlertViewDelegate,UMSocialUIDelegate>

@end

@implementation SetViewController {
    UITextField*inviteCodeTF;
    UIButton*quitButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";

    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    
    inviteCodeTF=[[UITextField alloc]initWithFrame:CGRectMake(10, 7, kScreenW/2-10, 30)];
    inviteCodeTF.borderStyle=UITextBorderStyleRoundedRect;
    inviteCodeTF.keyboardType=UIKeyboardTypeNumberPad;
    inviteCodeTF.placeholder=@"邀请码";

    //设置Btn
//    UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(quitButtonClicked)];
//    self.navigationItem.rightBarButtonItem = quitButton;

    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    quitButton=[[UIButton alloc]initWithFrame:CGRectMake(50, 7, kScreenW-100, 30)];
//    quitButton.layer.cornerRadius=5.0f;
//    quitButton.tag=1;
//    quitButton.layer.masksToBounds=YES;
//    [quitButton setBackgroundImage:[UIImage imageNamed:@"btnImageSelected"] forState:UIControlStateNormal];
    [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [quitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //loginBtn.alpha=0.8f;
    [quitButton addTarget:self action:@selector(quitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:loginBtn];


}

- (void)quitButtonClicked{

    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"确定退出" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex==1) {
        [HttpClient logout];
        [ViewController goLogin];
    }
}

- (void)OKBtn {
    if (inviteCodeTF.text.length!=0) {
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"邀请码提交成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        [HttpClient registerWithInviteCode:inviteCodeTF.text andBlock:^(NSDictionary *responseDictionary) {
            DLog(@"%@",responseDictionary);
        }];
    }else{
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"请您填写邀请码后再提交" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }

}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.tableView endEditing:YES];
//}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
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
                cell.textLabel.text=@"分享给好友";
            }
                break;

            case 3:{
                cell.textLabel.text=@"关于聚工厂";

            }
                break;


            case 4:{
                [cell addSubview:inviteCodeTF];
                UIButton*OKBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-70, 7, 60, 30)];
                [OKBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
                [OKBtn setTitle:@"提交" forState:UIControlStateNormal];
                [OKBtn addTarget:self action:@selector(OKBtn) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:OKBtn];
            }
                break;

            case 5:{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [cell addSubview:quitButton];
            }
                break;

            default:
                break;
        }
    }
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 7.0f;
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
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            RevisePasswordViewController*reviseVC = [[RevisePasswordViewController alloc]init];
            UINavigationController*reviseNav = [[UINavigationController alloc]initWithRootViewController:reviseVC];
            reviseNav.navigationBar.barStyle=UIBarStyleBlack;
            [self presentViewController:reviseNav animated:YES completion:nil];

        }
            break;

        case 1:{
            // 模态弹出友盟反馈
            [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];

            //蒲公英反馈
            //[self showFeedbackView];

        }
            break;
        case 2:{
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:@"55a0778367e58e452400710a"
                                              shareText:@"推荐一款非常好用的app——聚工厂，大家快来试试。下载链接：https://itunes.apple.com/cn/app/ju-gong-chang/id1015359842?mt=8"
                                             shareImage:[UIImage imageNamed:@"icon.png"]
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToQQ,UMShareToRenren,UMShareToDouban,UMShareToEmail,UMShareToSms,UMShareToFacebook,UMShareToTwitter,nil]
                                               delegate:self];
        }
            break;

        case 3:{
            AboutViewController*aboutVC = [[AboutViewController alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];

        }
            break;


                    
        default:
            break;
    }
}

//友盟实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        DLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


/**
 *  通过代码调用来显示用户反馈界面
 */
- (void)showFeedbackView
{
    [[PgyManager sharedPgyManager] showFeedbackView];
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
