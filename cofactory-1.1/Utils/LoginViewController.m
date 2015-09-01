//
//  LoginViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "LoginViewController.h"

@interface LoginViewController () <UIAlertViewDelegate>{
    UITextField*_usernameTF;

    UITextField*_passwordTF;
}

@end

@implementation LoginViewController
{
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
    // Do any additional setup after loading the view from its nib.
    self.title=@"登录";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    [self createUI];
    
}
- (void)createUI{
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
    

    UILabel*usernameLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 14, 40, 20)];
    usernameLable.text=@"账号";
    usernameLable.font=[UIFont boldSystemFontOfSize:16];
    usernameLable.textColor=[UIColor blackColor];
    [TFView addSubview:usernameLable];
    
    _usernameTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 5, kScreenW-80, 40)];
    _usernameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _usernameTF.placeholder=@"请输入账号/手机号";
    _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
    [TFView addSubview:_usernameTF];
    
    UILabel*passwordLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 63, 40, 20)];
    passwordLable.text=@"密码";
    passwordLable.font=[UIFont boldSystemFontOfSize:16];
    passwordLable.textColor=[UIColor blackColor];
    [TFView addSubview:passwordLable];
    
    _passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 55, kScreenW-80, 40)];
    _passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordTF.secureTextEntry=YES;
    _passwordTF.placeholder=@"请输入您的密码";
    [TFView addSubview:_passwordTF];
    
    //button
    UIButton*registerBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 220-64, (kScreenW-20)/2-20, 35)];
    registerBtn.backgroundColor=[UIColor whiteColor];
    registerBtn.alpha=0.9f;
    registerBtn.layer.cornerRadius=5.0f;
    registerBtn.layer.masksToBounds=YES;
    registerBtn.tag=0;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerBtn];
    
    UIButton*loginBtn=[[UIButton alloc]initWithFrame:CGRectMake((kScreenW-20)/2+30, 220-64, (kScreenW-20)/2-20, 35)];
    loginBtn.layer.cornerRadius=5.0f;
    loginBtn.tag=1;
    loginBtn.layer.masksToBounds=YES;
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"btnImageSelected"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //loginBtn.alpha=0.8f;
    [loginBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];

    
    UIButton*touristBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 270-64, kScreenW-20, 40)];
//    touristBtn.alpha=0.8f;
    touristBtn.tag=2;
    touristBtn.layer.cornerRadius=5.0f;
    touristBtn.layer.masksToBounds=YES;
    [touristBtn setTitle:@"游客登录" forState:UIControlStateNormal];
    [touristBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [touristBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [touristBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:touristBtn];
    
    UIButton*forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-80, 315-64, 70, 20)];
    forgetBtn.tag=3;
    forgetBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];

}

- (void)clickbBtn:(UIButton*)sender{
    UIButton*button=(UIButton*)sender;
    switch (button.tag) {
        case 0:{
            RegisterViewController*registerVC = [[RegisterViewController alloc]init];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
            break;
        case 1:{
            if ([_passwordTF.text isEqualToString:@""]||[_usernameTF.text isEqualToString:@""]) {
//                UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"请您填写账号以及密码后登陆" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
                [Tools showHudTipStr:@"请您填写账号以及密码后登陆"];
            }else{
                [HttpClient loginWithUsername:_usernameTF.text password:_passwordTF.text andBlock:^(int statusCode) {
                    DLog(@"%d",statusCode);
                    switch (statusCode) {
                        case 0:{
//                            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"网络错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                            [alertView show];
                            [Tools showHudTipStr:@"网络错误"];

                        }
                            break;
                        case 200:{
//                            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"登陆成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                            [alertView show];
                            [ViewController goMain];

                        }
                            break;
                        case 400:{
//                            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"用户名密码错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                            [alertView show];
                            [Tools showHudTipStr:@"用户名或密码错误"];

                        }
                            break;
                            
                        default:
                            break;
                    }
                }];
            }
            
        }
            break;
        case 2:{
//            [ViewController goMain];
            TouristViewController*touristVC = [[TouristViewController alloc]init];
            UINavigationController*touristNav = [[UINavigationController alloc]initWithRootViewController:touristVC];
            touristNav.navigationBar.barStyle=UIBarStyleBlack;
            [self presentViewController:touristNav animated:YES completion:nil];
        }
            break;
        case 3:{
            DLog(@"忘记密码");
            ResetPasswordViewController*resetVC = [[ResetPasswordViewController alloc]init];
            UINavigationController*resetNav = [[UINavigationController alloc]initWithRootViewController:resetVC];
            resetNav.navigationBar.barStyle=UIBarStyleBlack;
            [self presentViewController:resetNav animated:YES completion:nil];
        }
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [ViewController goMain];
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
