//
//  RegisterViewController3.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "RegisterViewController3.h"


@interface RegisterViewController3 ()
@end

@implementation RegisterViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    self.title=@"注册信息";


    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回首页" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;

    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH) style:UITableViewStyleGrouped];
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



    UIView*tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    tableFooterView.backgroundColor = [UIColor clearColor];

    UIButton*registerBtn=[[UIButton alloc]init];
    registerBtn.frame = CGRectMake(10, 9, kScreenW-20, 35);

//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"服装厂"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"加工厂"]) {
//        registerBtn.frame = CGRectMake(10, 130+44*9, kScreenW-20, 35);
//    }else{
//        registerBtn.frame = CGRectMake(10, 130+44*8, kScreenW-20, 35);
//    }
    registerBtn.layer.cornerRadius=5.0f;
    registerBtn.layer.masksToBounds=YES;
    registerBtn.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
    registerBtn.layer.borderWidth = 1.0f;
    [registerBtn setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];

    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:registerBtn];

    self.tableView.tableFooterView = tableFooterView;
}

- (void)buttonClicked {
    NSArray*navArr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:navArr[0] animated:YES];

    //删除注册信息
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [defs dictionaryRepresentation];
    for (id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"服装厂"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"加工厂"]) {
        return 9;

    }else{
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        switch (indexPath.row) {
            case 0:
            {
                cell.textLabel.text = @"工厂类型";
                cell.detailTextLabel.text = [userDefaults objectForKey:@"type"];
            }
                break;
            case 1:
            {
                cell.textLabel.text = @"手机号";
                cell.detailTextLabel.text = [userDefaults objectForKey:@"phone"];

            }
                break;
            case 2:
            {

                cell.textLabel.text = @"密码";
                cell.detailTextLabel.text = [userDefaults objectForKey:@"password"];
            }
                break;
            case 3:
            {
                cell.textLabel.text = @"邀请码";
                if ([[userDefaults objectForKey:@"inviteCode"]isEqualToString:@""]) {
                    cell.detailTextLabel.text = @"尚未填写";
                }else{
                    cell.detailTextLabel.text = [userDefaults objectForKey:@"inviteCode"];
                }
            }
                break;
            case 4:
            {
                cell.textLabel.text = @"验证码";
                cell.detailTextLabel.text = [userDefaults objectForKey:@"code"];
            }
                break;


            case 5:
            {
                cell.textLabel.text = @"工厂名称";
                cell.detailTextLabel.text = [userDefaults objectForKey:@"factoryName"];
            }
                break;
            case 6:
            {
                cell.textLabel.text = @"工厂地址";
                cell.detailTextLabel.text = [userDefaults objectForKey:@"factoryAddress"];
            }
                break;

            case 7:
            {
                cell.textLabel.text = @"工厂规模";
                cell.detailTextLabel.text = [userDefaults objectForKey:@"factorySize"];
            }
                break;


            case 8:
            {
                cell.textLabel.text = @"工厂业务";
                cell.detailTextLabel.text = [userDefaults objectForKey:@"factoryServiceRange"];
            }
                break;


            default:
                break;
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


- (void)clickRegisterBtn{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];


    //工厂身份
    int factoryType = 0;
    if ([[userDefaults objectForKey:@"type"]isEqualToString:@"服装厂"]) {
        factoryType=0;
    }if ([[userDefaults objectForKey:@"type"]isEqualToString:@"加工厂"]) {
        factoryType=1;
    }if ([[userDefaults objectForKey:@"type"]isEqualToString:@"代裁厂"]) {
        factoryType=2;
    }if ([[userDefaults objectForKey:@"type"]isEqualToString:@"锁眼钉扣厂"]) {
        factoryType=3;
    }
    
    //手机号
    NSString*phone = [userDefaults objectForKey:@"phone"];

    //密码
    NSString*password = [userDefaults objectForKey:@"password"];

    //验证码
    NSString*verifyCode=[userDefaults objectForKey:@"code"];

    NSString*inviteCode = [userDefaults objectForKey:@"inviteCode"];

    //工厂地址
    NSString*factoryAddress=[userDefaults objectForKey:@"factoryAddress"];

    //经纬度
    double lon=[[userDefaults objectForKey:@"lon"] doubleValue];
    double lat=[[userDefaults objectForKey:@"lat"] doubleValue];

    //工厂名称
    NSString*factoryName=[userDefaults objectForKey:@"factoryName"];

    //工厂规模
    NSString*factorySize = [userDefaults objectForKey:@"factorySize"];

    //业务类型
    NSString*factoryServiceRange=[userDefaults objectForKey:@"factoryServiceRange"];


    [HttpClient registerWithUsername:phone  InviteCode:inviteCode password:password factoryType:factoryType verifyCode:verifyCode factoryName:factoryName lon:lon lat:lat factorySizeMin:[[Tools RangeSizeWith:factorySize] firstObject] factorySizeMax:[[Tools RangeSizeWith:factorySize] lastObject] factoryAddress:factoryAddress factoryServiceRange:factoryServiceRange andBlock:^(NSDictionary *responseDictionary) {
        int statusCode =[responseDictionary[@"statusCode"]intValue];
        if (statusCode == 200) {
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"注册成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 10086;
            [alertView show];
        }else{
            DLog(@"注册反馈%@",responseDictionary);
            NSString*message=responseDictionary[@"message"];
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10086) {
        [self login];
    }
}


//注册成功 登录
- (void)login{
    [HttpClient loginWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"password"] andBlock:^(int statusCode) {
        DLog(@"%d",statusCode);
        switch (statusCode) {

            case 200:{
                //注册成功 登录成功
                [ViewController goMain];
                //删除注册信息
                NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
                NSDictionary * dict = [defs dictionaryRepresentation];
                for (id key in dict) {
                    [defs removeObjectForKey:key];
                }
                [defs synchronize];
            }
                break;

            default:
                [Tools showHudTipStr:@"网络错误"];
                break;
        }
    }];
}

- (void)dealloc {
    DLog(@"注册2dealloc");

    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
