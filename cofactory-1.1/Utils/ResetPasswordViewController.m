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

    //确定Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.leftBarButtonItem = setButton;

    [self createUI];
}

- (void)createUI {

    UIImageView*bgView = [[UIImageView alloc]initWithFrame:kScreenBounds];
    bgView.image=[UIImage imageNamed:@"登录bg"];
    [self.view addSubview:bgView];

    UIView*TFView=[[UIView alloc]initWithFrame:CGRectMake(10, 100-64, kScreenW-20, 150)];
    TFView.alpha=0.9f;
    TFView.backgroundColor=[UIColor whiteColor];
    TFView.layer.borderWidth=2.0f;
    TFView.layer.borderColor=[UIColor whiteColor].CGColor;
    TFView.layer.cornerRadius=5.0f;
    TFView.layer.masksToBounds=YES;
    [self.view addSubview:TFView];


    UILabel*usernameLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 14, 60, 20)];
    usernameLable.text=@"手机号";
    usernameLable.font=[UIFont boldSystemFontOfSize:16.0f];
    usernameLable.textColor=[UIColor blackColor];
    [TFView addSubview:usernameLable];

    _usernameTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 5, kScreenW-80, 40)];
    _usernameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
    _usernameTF.placeholder=@"请输入手机号";
    [TFView addSubview:_usernameTF];

    UILabel*passwordLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 114, 60, 20)];
    passwordLable.text=@"新密码";
    passwordLable.font=[UIFont boldSystemFontOfSize:16.0f];
    passwordLable.textColor=[UIColor blackColor];
    [TFView addSubview:passwordLable];

    _passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 105, kScreenW-80, 40)];
    _passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordTF.secureTextEntry=YES;
    _passwordTF.placeholder=@"请填写新密码";
    [TFView addSubview:_passwordTF];


    UILabel*codeLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 65, 60, 20)];
    codeLable.text=@"验证码";
    codeLable.font=[UIFont boldSystemFontOfSize:15];
    codeLable.textColor=[UIColor blackColor];
    [TFView addSubview:codeLable];

    _codeTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 55, kScreenW-190, 40)];
    _codeTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _codeTF.keyboardType = UIKeyboardTypeNumberPad;
    _codeTF.placeholder=@"请填写验证码";
    [TFView addSubview:_codeTF];

    _codeBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW-130, 57, 100, 35)];
    [_codeBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    _codeBtn.layer.cornerRadius=5.0f;
    _codeBtn.layer.masksToBounds=YES;
    _codeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_codeBtn addTarget:self action:@selector(sendCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    [TFView addSubview:_codeBtn];

    UIButton*nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 270-64, kScreenW-20, 35)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btnImageSelected"] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius=5.0f;
    nextBtn.layer.masksToBounds=YES;
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

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
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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


//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    [self.view endEditing:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
