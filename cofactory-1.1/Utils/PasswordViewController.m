//
//  PasswordViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "PasswordViewController.h"
#import "RegisterViewController2.h"

@interface PasswordViewController (){
    UITextField*_passwordTF1;//密码1
    UITextField*_passwordTF2;//密码2

}

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"密码";
    [self createUI];
}

- (void)createUI{
    UIImageView*bgView = [[UIImageView alloc]initWithFrame:kScreenBounds];
    bgView.image=[UIImage imageNamed:@"登录bg"];
    [self.view addSubview:bgView];
    
    UIView*TFView=[[UIView alloc]initWithFrame:CGRectMake(10, 100, kScreenW-20, 100)];
    TFView.alpha=0.9f;
    TFView.backgroundColor=[UIColor whiteColor];
    TFView.layer.borderWidth=2.0f;
    TFView.layer.borderColor=[UIColor whiteColor].CGColor;
    TFView.layer.cornerRadius=5.0f;
    TFView.layer.masksToBounds=YES;
    [self.view addSubview:TFView];
    
    
    UILabel*passwordLable1 = [[UILabel alloc]initWithFrame:CGRectMake(5, 14, 60, 20)];
    passwordLable1.text=@"密   码";
    passwordLable1.font=[UIFont boldSystemFontOfSize:15];
    passwordLable1.textColor=[UIColor blackColor];
    [TFView addSubview:passwordLable1];
    
    _passwordTF1 = [[UITextField alloc]initWithFrame:CGRectMake(70, 5, kScreenW-90, 40)];
    _passwordTF1.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordTF1.placeholder=@"请输入6-12位密码";
    _passwordTF1.secureTextEntry=YES;
    [TFView addSubview:_passwordTF1];
    
    UILabel*passwordLable2 = [[UILabel alloc]initWithFrame:CGRectMake(5, 63, 60, 20)];
    passwordLable2.text=@"重复输入";
    passwordLable2.font=[UIFont boldSystemFontOfSize:15];
    passwordLable2.textColor=[UIColor blackColor];
    [TFView addSubview:passwordLable2];
    
    _passwordTF2 = [[UITextField alloc]initWithFrame:CGRectMake(70, 55, kScreenW-90, 40)];
    _passwordTF2.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordTF2.secureTextEntry=YES;
    _passwordTF2.placeholder=@"请再次输入您的密码";
    [TFView addSubview:_passwordTF2];


    UIButton* showBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-120, 210, 100, 30)];
    showBtn.titleLabel.font=[UIFont boldSystemFontOfSize:13.0f];
    [showBtn setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [showBtn setImage:[UIImage imageNamed:@"select_highlight"] forState:UIControlStateSelected];
    [showBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [showBtn setTitle:@"显示密码" forState:UIControlStateNormal];
    [showBtn setTitle:@"隐藏密码" forState:UIControlStateSelected];
    [showBtn addTarget:self action:@selector(showPasswordBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showBtn];
    
    UIButton*nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 245, kScreenW-20, 35)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btnImageSelected"] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius=5.0f;
    nextBtn.layer.masksToBounds=YES;
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
}

- (void)showPasswordBtn:(UIButton *)sender {
    UIButton*button = (UIButton *)sender;
    button.selected=!button.selected;
    _passwordTF1.secureTextEntry=!_passwordTF1.secureTextEntry;
    _passwordTF2.secureTextEntry=!_passwordTF2.secureTextEntry;
}

- (void)nextBtn{
        if (_passwordTF1.text.length==0||_passwordTF2.text.length==0) {
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"请填写密码" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }else if(_passwordTF1.text.length<6||_passwordTF2.text.length<6) {
            UIAlertView*passwordAlert=[[UIAlertView alloc]initWithTitle:@"密码长度错误" message:@"密码应该大于6位" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [passwordAlert show];
        }else if (![_passwordTF1.text isEqualToString:_passwordTF2.text]){
            UIAlertView*passwordAlert=[[UIAlertView alloc]initWithTitle:@"两次输入密码不一致" message:@"请重新输入" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [passwordAlert show];
        }
        else{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:_passwordTF2.text forKey:@"password"];
            [userDefaults synchronize];
            RegisterViewController2*RegisterVC=[[RegisterViewController2 alloc]init];
            [self.navigationController pushViewController:RegisterVC animated:YES];
        }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
