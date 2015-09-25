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

    blueButton*_codeBtn;

//    BOOL _wasKeyboardManagerEnabled;

}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    _wasKeyboardManagerEnabled = [[IQKeyboardManager sharedManager] isEnabled];
//    [[IQKeyboardManager sharedManager] setEnable:NO];
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [[IQKeyboardManager sharedManager] setEnable:_wasKeyboardManagerEnabled];
//}


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

    tablleHeaderView*tableHeaderView = [[tablleHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, tableHeaderView_height)];
    self.tableView.tableHeaderView = tableHeaderView;

    //返回Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;

    [self createUI];
}

- (void)createUI {

    if (!_usernameTF) {
        _usernameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _usernameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
        _usernameTF.placeholder=@"手机号";
    }


    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _passwordTF.secureTextEntry=YES;
        _passwordTF.placeholder=@"新密码";
    }


    if (!_codeTF) {
        _codeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-118, 44)];
        _codeTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _codeTF.keyboardType = UIKeyboardTypeNumberPad;
        _codeTF.placeholder=@"验证码";

    }

    if (!_codeBtn) {
        _codeBtn=[[blueButton alloc]initWithFrame:CGRectMake(kScreenW-100, 7, 90, 30)];
//        _codeBtn.layer.cornerRadius=5.0f;
//        _codeBtn.layer.masksToBounds=YES;
//        _codeBtn.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
//        _codeBtn.layer.borderWidth = 1.0f;
        _codeBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [_codeBtn setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_codeBtn addTarget:self action:@selector(sendCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    }

    blueButton*nextBtn=[[blueButton alloc]initWithFrame:CGRectMake(20, 44*3+20+120, kScreenW-40, 35)];
    [nextBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:nextBtn];

}

- (void)buttonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)nextBtn {
    if (_passwordTF.text.length<6) {
        [Tools showHudTipStr:@"密码长度应该是6位及以上！"];

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

                    [Tools showHudTipStr:@"没有这个用户！"];

                }
                    break;
                case 403:
                {
                    [Tools showHudTipStr:@"验证码错误"];


                }
                    break;

                default:
                    [Tools showHudTipStr:@"您的网络状态不太顺畅哦！"];

                    break;
            }
        }];
    }
}

- (void)sendCodeBtn{
    [_codeBtn setEnabled:NO];

    if (_usernameTF.text.length==11) {
        [HttpClient postVerifyCodeWithPhone:_usernameTF.text andBlock:^(int statusCode) {
            switch (statusCode) {
                case 0:{
                    [Tools showHudTipStr:@"您的网络状态不太顺畅哦！"];
                    [_codeBtn setEnabled:YES];

                }
                    break;
                case 200:{
                    [Tools showSuccessWithStatus:@"发送成功，十分钟内有效"];
                    seconds = 60;
                    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                }
                    break;
                case 400:{
                    [Tools showHudTipStr:@"手机格式不正确"];
                    [_codeBtn setEnabled:YES];


                }
                    break;
                case 409:{

                    [Tools showHudTipStr:@"需要等待冷却"];
                    [_codeBtn setEnabled:YES];


                }
                    break;
                case 502:{
                    [Tools showHudTipStr:@"发送错误"];
                    [_codeBtn setEnabled:YES];


                }
                    break;

                default:
                    [Tools showHudTipStr:@"您的网络状态不太顺畅哦！"];
                    [_codeBtn setEnabled:YES];
                    break;
            }
        }];

    }else{

        [Tools showHudTipStr:@"您输入的是一个无效的手机号码"];
        [_codeBtn setEnabled:YES];
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
            [cell addSubview:_passwordTF];
        }
        if (indexPath.row == 2) {
            [cell addSubview:_codeTF];
            [cell addSubview:_codeBtn];
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


- (void)dealloc {
    DLog(@"找回密码dealloc");
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

@end
