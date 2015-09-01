//
//  RegisterViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "RegisterViewController.h"
#import "PasswordViewController.h"

@interface RegisterViewController ()<UIAlertViewDelegate> {
    UITextField*_authcodeTF;//验证码

    NSTimer*timer;

    NSInteger seconds;

    UIButton*authcodeBtn;

}

@property(nonatomic,copy)NSString*statusCode;

@end

@implementation RegisterViewController{
    UITextField*_usernameTF;//账号
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
    self.title=@"注册";
    self.view.backgroundColor=[UIColor whiteColor];
    [self createUI];
}

- (void)createUI {
    
    UIImageView*bgView = [[UIImageView alloc]initWithFrame:kScreenBounds];
    bgView.image=[UIImage imageNamed:@"登录bg"];
    [self.view addSubview:bgView];
    
    UIView*TFView=[[UIView alloc]initWithFrame:CGRectMake(10, 100-64, kScreenW-20, 100)];
    TFView.alpha=0.9f;
    TFView.backgroundColor=[UIColor whiteColor];
    TFView.layer.borderWidth=2.0f;
    TFView.layer.borderColor=[UIColor whiteColor].CGColor;
    TFView.layer.cornerRadius=5.0f;
    TFView.layer.masksToBounds=YES;
    [self.view addSubview:TFView];
    
    
    UILabel*usernameLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 14, 60, 20)];
    usernameLable.text=@"手机号";
    usernameLable.font=[UIFont boldSystemFontOfSize:15];
    usernameLable.textColor=[UIColor blackColor];
    [TFView addSubview:usernameLable];
    
    _usernameTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 5, kScreenW-90, 40)];
    _usernameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
    _usernameTF.placeholder=@"请输入手机号";
    [TFView addSubview:_usernameTF];

    UILabel*codeLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 63, 60, 20)];
    codeLable.text=@"验证码";
    codeLable.font=[UIFont boldSystemFontOfSize:15];
    codeLable.textColor=[UIColor blackColor];
    [TFView addSubview:codeLable];

    _authcodeTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 55, kScreenW-190, 40)];
    _authcodeTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _authcodeTF.keyboardType = UIKeyboardTypeNumberPad;
    _authcodeTF.placeholder=@"请输入验证码";
    [TFView addSubview:_authcodeTF];

    authcodeBtn=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW-130, 57, 100, 35)];
    [authcodeBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    authcodeBtn.layer.cornerRadius=5.0f;
    authcodeBtn.layer.masksToBounds=YES;
    authcodeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [authcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [authcodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [authcodeBtn addTarget:self action:@selector(sendCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    [TFView addSubview:authcodeBtn];

    UIButton*nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 220-64, kScreenW-20, 35)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btnImageSelected"] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius=5.0f;
    nextBtn.layer.masksToBounds=YES;
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"注册" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
}

//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        seconds = 60;
        [authcodeBtn setTitle:@"重新获取" forState: UIControlStateNormal];
        [authcodeBtn setEnabled:YES];
    }else{
        seconds--;
        NSString *title = [NSString stringWithFormat:@"倒计时%lds",(long)seconds];
        [authcodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [authcodeBtn setEnabled:NO];
        [authcodeBtn setTitle:title forState:UIControlStateNormal];
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

            DLog(@"验证码code%d",statusCode);
//            if (statusCode==200) {
//                [Tools showHudTipStr:@"发送成功，十分钟内有效"];
//                seconds = 60;
//                timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
//            }
//
//            if (statusCode == 400) {
//                [Tools showHudTipStr:@"手机格式不正确"];
//            }
//
//            if (statusCode == 409) {
//                [Tools showHudTipStr:@"需要等待冷却"];
//            }
//            else {
//                [Tools showHudTipStr:@"网络错误"];
//            }
        }];

    }else{

        UIAlertView*userAlert=[[UIAlertView alloc]initWithTitle:@"手机号码错误" message:@"您输入的是一个无效的手机号码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [userAlert show];
    }


}


- (void)nextBtn {

    MBProgressHUD *hud = [Tools createHUD];
    hud.labelText = @"正在验证...";
    [HttpClient validateCodeWithPhone:_usernameTF.text code:_authcodeTF.text andBlock:^(int statusCode) {
        DLog(@"验证码code%d",statusCode);

        if (statusCode == 0) {
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"网络错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [hud hide:YES];
        }
        if (statusCode == 200) {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_usernameTF.text forKey:@"phone"];
            [userDefaults setObject:_authcodeTF.text forKey:@"code"];
            [userDefaults synchronize];
            hud.labelText = @"验证成功";
            [hud hide:YES];
            PasswordViewController*passwordVC =[[PasswordViewController alloc]init];
            [self.navigationController pushViewController:passwordVC animated:YES];

        }
        else {
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"验证码过期或者无效" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [hud hide:YES];
        }
    }];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
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
