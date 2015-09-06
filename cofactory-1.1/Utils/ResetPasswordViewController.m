//
//  ResetPasswordViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/20.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController () <UIAlertViewDelegate>

@end

@implementation ResetPasswordViewController {
    UITextField*_usernameTF;//账号
    UITextField*_passwordTF;//密码
    UITextField*_codeTF;//验证码

    NSTimer*timer;

    NSInteger seconds;

    UIButton*_codeBtn;

    BOOL _wasKeyboardManagerEnabled;

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"找回密码";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-64, kScreenH) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor = [UIColor whiteColor];

    UIView*tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    tableHeaderView.backgroundColor=[UIColor clearColor];
    UIImageView*logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2-40, 10, 80, 80)];
    logoImage.image=[UIImage imageNamed:@"login_logo"];
    logoImage.layer.cornerRadius = 80/2.0f;
    logoImage.layer.masksToBounds = YES;
    [tableHeaderView addSubview:logoImage];

    self.tableView.tableHeaderView = tableHeaderView;

    //确定Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.leftBarButtonItem = setButton;

    [self createUI];
}

- (void)createUI {

    _usernameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
    _usernameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
    _usernameTF.placeholder=@"手机号";


    _passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
    _passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordTF.secureTextEntry=YES;
    _passwordTF.placeholder=@"新密码";

    _codeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-118, 44)];
    _codeTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.placeholder=@"验证码";

    _codeBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW-100, 7, 90, 30)];
    _codeBtn.layer.cornerRadius=5.0f;
    _codeBtn.layer.masksToBounds=YES;
    _codeBtn.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
    _codeBtn.layer.borderWidth = 1.0f;
    _codeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_codeBtn addTarget:self action:@selector(sendCodeBtn) forControlEvents:UIControlEventTouchUpInside];

    UIButton*nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 44*3+20+120, kScreenW-40, 35)];
    nextBtn.layer.cornerRadius=5.0f;
    nextBtn.layer.masksToBounds=YES;
    nextBtn.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
    nextBtn.layer.borderWidth = 1.0f;

    [nextBtn setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [nextBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:nextBtn];

}

- (void)buttonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextBtn {
    if (_passwordTF.text.length<6) {
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"密码长度应该大于5位" message:nil
                                                         delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    else{
        [HttpClient postResetPasswordWithPhone:_usernameTF.text code:_codeTF.text password:_passwordTF.text andBlock:^(int statusCode) {
            switch (statusCode) {
                case 200:
                {
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"密码重置成功" message:nil
                                                                     delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    alertView.tag = 10086;
                    [alertView show];

                }
                    break;
                case 400:
                {
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"没有这个用户" message:nil
                                                                     delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];

                }
                    break;
                case 403:
                {
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"验证码错误" message:nil
                                                                     delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    
                }
                    break;
                    
                    
                default:
                    break;
            }
        }];
    }
}

- (void)sendCodeBtn{
    if (_usernameTF.text.length==11) {
        [HttpClient postVerifyCodeWithPhone:_usernameTF.text andBlock:^(int statusCode) {
            switch (statusCode) {
                case 0:{
                    [Tools showHudTipStr:@"网络错误"];
                }
                    break;
                case 200:{
                    [Tools showHudTipStr:@"发送成功，十分钟内有效"];

                    seconds = 60;
                    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                }
                    break;
                case 400:{
                    [Tools showHudTipStr:@"手机格式不正确"];

                }
                    break;
                case 409:{

                    [Tools showHudTipStr:@"需要等待冷却"];

                }
                    break;
                case 502:{
                    [Tools showHudTipStr:@"发送错误"];

                }
                    break;

                default:
                    break;
            }
        }];

    }else{

        UIAlertView*userAlert=[[UIAlertView alloc]initWithTitle:@"手机号码错误" message:@"您输入的是一个无效的手机号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [userAlert show];
    }


}


//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        seconds = 60;
        [_codeBtn setTitle:@"重新获取" forState: UIControlStateNormal];
        [_codeBtn setEnabled:YES];
    }else{
        seconds--;
        NSString *title = [NSString stringWithFormat:@"倒计时%lds",(long)seconds];
        [_codeBtn setEnabled:NO];
        [_codeBtn setTitle:title forState:UIControlStateNormal];
    }
}

//如果登陆成功，停止验证码的倒数，
- (void)releaseTImer {
    if (timer) {
        if ([timer respondsToSelector:@selector(isValid)]) {
            if ([timer isValid]) {
                [timer invalidate];
                seconds = 60;
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10086) {
        if (buttonIndex == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }

}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.tableView endEditing:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.row == 0) {
            [cell addSubview:_usernameTF];
        }
        if (indexPath.row == 1) {
            [cell addSubview:_codeTF];
            [cell addSubview:_codeBtn];
        }
        if (indexPath.row == 2) {
            [cell addSubview:_passwordTF];
        }
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}



@end
