//
//  LoginViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "LoginViewController.h"

#import "ZFModalTransitionAnimator.h"


@interface LoginViewController () <UIAlertViewDelegate>{
    UITextField*_usernameTF;

    UITextField*_passwordTF;
}

@property (nonatomic, strong) ZFModalTransitionAnimator *animator;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //删除注册信息
    DLog(@"删除NSUserDefaults信息");
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];

    // Do any additional setup after loading the view from its nib.
    self.title=@"登录";
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

    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 80)];
    UIButton*loginBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 15, (kScreenW-40), 35)];
    loginBtn.tag=1;
    loginBtn.layer.cornerRadius=5.0f;
    loginBtn.layer.masksToBounds=YES;
    loginBtn.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
    loginBtn.layer.borderWidth = 1.0f;
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:loginBtn];



    //注册 button
    UIButton*registerBtn=[[UIButton alloc]initWithFrame:CGRectMake((kScreenW-40)/2+40, 60, (kScreenW-40)/2-20, 25)];
    //    registerBtn.backgroundColor = [UIColor redColor];
    registerBtn.tag=0;
    registerBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:registerBtn];

    UIButton*forgetBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 60, (kScreenW-40)/2-20, 25)];
    //    forgetBtn.backgroundColor = [UIColor grayColor];
    forgetBtn.tag=3;
    forgetBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    forgetBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(clickbBtn:) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:forgetBtn];

    self.tableView.tableFooterView = tableFooterView;


    
    [self createUI];
    
}
- (void)createUI {


    if (!_usernameTF) {
        UIImageView*userTFView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 23)];
        userTFView.image = [UIImage imageNamed:@"login_user"];
        _usernameTF.font = [UIFont systemFontOfSize:15.0f];
        _usernameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _usernameTF.leftView = userTFView;
        _usernameTF.leftViewMode = UITextFieldViewModeAlways;
        _usernameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _usernameTF.placeholder=@"手机号";
        _usernameTF.keyboardType = UIKeyboardTypeNumberPad;
    }

    if (!_passwordTF) {
        UIImageView*passTFView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40, 23)];
        passTFView.image = [UIImage imageNamed:@"login_key"];
        _passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _passwordTF.leftView = passTFView;
        _passwordTF.leftViewMode = UITextFieldViewModeAlways;
        _passwordTF.secureTextEntry=YES;
        _passwordTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _passwordTF.placeholder=@"密码";

    }

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
            [button setEnabled:NO];
            if ([_passwordTF.text isEqualToString:@""]||[_usernameTF.text isEqualToString:@""]) {

                [button setEnabled:YES];
                [Tools showHudTipStr:@"请您填写账号以及密码后登陆"];
            }else{
                [HttpClient loginWithUsername:_usernameTF.text password:_passwordTF.text andBlock:^(int statusCode) {
                    DLog(@"%d",statusCode);
                    switch (statusCode) {
                        case 0:{
                            [button setEnabled:YES];
                            [Tools showHudTipStr:@"网络错误！"];

                        }
                            break;
                        case 200:{
                            [button setEnabled:YES];

                            [ViewController goMain];

                        }
                            break;
                        case 400:{
                            [button setEnabled:YES];

                            [Tools showHudTipStr:@"用户名或密码错误！"];

                        }
                            break;
                            
                        default:
                            [button setEnabled:YES];
                            [Tools showHudTipStr:@"网络错误！"];
                            break;
                    }
                }];
            }
            
        }
            break;
        case 2:{

        }
            break;
        case 3:{
            DLog(@"忘记密码");

            ResetPasswordViewController*resetVC = [[ResetPasswordViewController alloc]init];
            
            UINavigationController*resetNav = [[UINavigationController alloc]initWithRootViewController:resetVC];
            resetNav.navigationBar.barStyle=UIBarStyleBlack;
            
            resetNav.modalPresentationStyle = UIModalPresentationCustom;
            self.animator = [[ZFModalTransitionAnimator alloc] initWithModalViewController:resetNav];
            self.animator.dragable = YES;
            self.animator.bounces = NO;
            self.animator.behindViewAlpha = 0.5f;
            self.animator.behindViewScale = 0.5f;
            self.animator.direction = ZFModalTransitonDirectionBottom;
            resetNav.transitioningDelegate = self.animator;
            [self presentViewController:resetNav animated:YES completion:nil];
        }
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
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
    DLog(@"登录dealloc");
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}

@end
