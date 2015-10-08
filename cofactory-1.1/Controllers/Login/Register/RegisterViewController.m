//
//  RegisterViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "RegisterViewController.h"
#import "RegisterViewController2.h"

#define PROVINCE_COMPONENT  0


@interface RegisterViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource> {

}

@property(nonatomic,copy)NSString*statusCode;

@property(nonatomic,retain) NSArray*factoryTypeList;
@property (nonatomic,strong) UIPickerView *factoryTypePicker;
@property (nonatomic,strong) UIToolbar*factoryTypeToolbar;

@end

@implementation RegisterViewController{

    UITextField*_usernameTF;//账号
    UITextField*_passwordTF;//密码1
    UITextField*inviteCodeTF;
    UITextField*_authcodeTF;//验证码
    NSTimer*timer;
    NSInteger seconds;
    UIButton*authcodeBtn;

    UITextField*_typeTF;//公司类型
    NSString *_factoryName;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"注册";
    self.factoryTypeList=@[@"服装厂",@"加工厂",@"代裁厂",@"锁眼钉扣厂",@"面辅料商"];

    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-64, kScreenH) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor = [UIColor whiteColor];

    tablleHeaderView*tableHeaderView = [[tablleHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, tableHeaderView_height)];
    self.tableView.tableHeaderView = tableHeaderView;

    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];

    blueButton*nextBtn=[[blueButton alloc]initWithFrame:CGRectMake(20, 15, kScreenW-40, 35)];;
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:nextBtn];
    self.tableView.tableFooterView = tableFooterView;
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
        _passwordTF.placeholder=@"密码(6位及以上)";
        _passwordTF.secureTextEntry=YES;
    }

    if (!inviteCodeTF) {
        inviteCodeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        inviteCodeTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        inviteCodeTF.keyboardType = UIKeyboardTypeNumberPad;
        inviteCodeTF.placeholder=@"邀请码(可不填)";
    }

    if (!_typeTF) {
        _typeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _typeTF.placeholder=@"工厂类型";
        _typeTF.inputView = [self fecthPicker];
        _typeTF.inputAccessoryView = [self fecthToolbar];
        _typeTF.delegate =self;

    }
    if (!_authcodeTF) {
        _authcodeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-118, 44)];
        _authcodeTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _authcodeTF.keyboardType = UIKeyboardTypeNumberPad;
        _authcodeTF.placeholder=@"验证码";
    }

    if (!authcodeBtn) {
        authcodeBtn=[[blueButton alloc]initWithFrame:CGRectMake(kScreenW-100, 7, 90, 30)];

        authcodeBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [authcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [authcodeBtn addTarget:self action:@selector(sendCodeBtn) forControlEvents:UIControlEventTouchUpInside];

    }

}

//倒计时方法验证码实现倒计时60秒，60秒后按钮变换开始的样子
-(void)timerFireMethod:(NSTimer *)theTimer {
    if (seconds == 1) {
        [theTimer invalidate];
        seconds = 60;
        authcodeBtn.titleLabel.text = @"重新获取";
        [authcodeBtn setTitle:@"重新获取" forState: UIControlStateNormal];
        [authcodeBtn setEnabled:YES];
    }else{
        seconds--;
        [authcodeBtn setEnabled:NO];
        NSString *title = [NSString stringWithFormat:@"倒计时%lds",(long)seconds];
        authcodeBtn.titleLabel.text = title;
        [authcodeBtn setTitle:title forState:UIControlStateNormal];
        [authcodeBtn.titleLabel sizeToFit];

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
    [authcodeBtn setEnabled:NO];
    if (_usernameTF.text.length==11) {

        [HttpClient postVerifyCodeWithPhone:_usernameTF.text andBlock:^(int statusCode) {

            switch (statusCode) {
                case 0:{
                    [Tools showErrorWithStatus:@"您的网络状态不太顺畅哦!"];
                    [authcodeBtn setEnabled:YES];

                }
                    break;

                case 200:{
                    [Tools showSuccessWithStatus:@"发送成功，十分钟内有效"];
                    [authcodeBtn setEnabled:NO];
                    seconds = 60;
                    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
                }
                    break;
                    
                case 400:{
                    [Tools showErrorWithStatus:@"手机格式不正确"];
                    [authcodeBtn setEnabled:YES];


                }
                    break;
                case 409:{
                    [Tools showShimmeringString:@"需要等待冷却"];
                    [authcodeBtn setEnabled:YES];

                }
                    break;
                    
                case 502:{
                    [Tools showErrorWithStatus:@"发送错误"];
                    [authcodeBtn setEnabled:YES];

                }
                    break;
                    
                default:
                    [Tools showErrorWithStatus:@"您的网络状态不太顺畅哦！"];
                    [authcodeBtn setEnabled:YES];
                    break;
            }
            DLog(@"验证码code%d",statusCode);
        }];
    }else{
        [Tools showErrorWithStatus:@"您输入的是一个无效的手机号码"];
        [authcodeBtn setEnabled:YES];

    }
}


- (void)nextBtn {
    if (_usernameTF.text.length==0 || _passwordTF.text.length==0 || _authcodeTF.text.length==0 || _typeTF.text.length==0) {

        DLog(@"mo");
        [Tools showErrorWithStatus:@"注册信息不完整"];
    }else{
        if (_passwordTF.text.length<6) {
            [Tools showErrorWithStatus:@"密码长度太短"];
        }else{
            MBProgressHUD *hud = [Tools createHUD];
            hud.labelText = @"正在验证...";
            [HttpClient validateCodeWithPhone:_usernameTF.text code:_authcodeTF.text andBlock:^(int statusCode) {
                DLog(@"验证码code%d",statusCode);

                if (statusCode == 0) {
                    [hud hide:YES];
                    [Tools showErrorWithStatus:@"您的网络状态不太顺畅哦！"];
                }
                if (statusCode == 200) {
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:_usernameTF.text forKey:@"phone"];
                    [userDefaults setObject:_authcodeTF.text forKey:@"code"];
                    [userDefaults setObject:_passwordTF.text forKey:@"password"];
                    [userDefaults setObject:_typeTF.text forKey:@"type"];
                    [userDefaults setObject:inviteCodeTF.text forKey:@"inviteCode"];
                    [userDefaults synchronize];
                    hud.labelText = @"验证成功";
                    [hud hide:YES];
                    RegisterViewController2*Register2VC =[[RegisterViewController2 alloc]init];
                    [self.navigationController pushViewController:Register2VC animated:YES];

                }
                else {
                    [hud hide:YES];
                    [Tools showErrorWithStatus:@"验证码过期或者无效"];
                }
            }];

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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.row == 0) {
            [cell addSubview:_typeTF];
        }

        if (indexPath.row == 1) {
            [cell addSubview:_usernameTF];
        }
        if (indexPath.row == 2) {
            [cell addSubview:_passwordTF];
        }
        if (indexPath.row == 3) {
            [cell addSubview:inviteCodeTF];
        }

        if (indexPath.row == 4) {
            [cell addSubview:_authcodeTF];
            [cell addSubview:authcodeBtn];
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


- (UIPickerView *)fecthPicker {
    if (!self.factoryTypePicker) {
        self.factoryTypePicker = [[UIPickerView alloc] init];
        self.factoryTypePicker.backgroundColor = [UIColor whiteColor];
        self.factoryTypePicker.delegate = self;
        self.factoryTypePicker.dataSource = self;
        [self.factoryTypePicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.factoryTypePicker;
}

- (UIToolbar *)fecthToolbar {

    if (!self.factoryTypeToolbar) {
        self.factoryTypeToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensure)];
        self.factoryTypeToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.factoryTypeToolbar;
}
#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.factoryTypeList.count;
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.factoryTypeList objectAtIndex:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenW, 30)];
    myView.textAlignment = NSTextAlignmentCenter;
    myView.text = [self.factoryTypeList objectAtIndex:row];
    myView.font = kFont;
    myView.backgroundColor = [UIColor clearColor];
    return myView;

}


//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    _factoryName = [self pickerView:pickerView titleForRow:row forComponent:PROVINCE_COMPONENT];
//}
-(void)ensure{

    NSInteger provinceIndex = [self.factoryTypePicker selectedRowInComponent: PROVINCE_COMPONENT];
    _factoryName = [self.factoryTypeList objectAtIndex: provinceIndex];
    _typeTF.text = _factoryName;
    _factoryName = nil;

    [_typeTF endEditing:YES];

}
-(void)cancel{
    _factoryName = nil;
    _typeTF.text = nil;
    [_typeTF endEditing:YES];
}

- (void)dealloc {
    DLog(@"注册1dealloc");

    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.factoryTypePicker.dataSource = nil;
    self.factoryTypePicker.delegate = nil;
}

@end
