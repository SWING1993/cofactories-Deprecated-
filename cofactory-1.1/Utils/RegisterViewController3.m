//
//  RegisterViewController3.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "ModelsHeader.h"
#import "RegisterViewController3.h"


@interface RegisterViewController3 ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    UIButton*selectBtn;

    NSString *_sizePickerName;

    NSString*_servicePickerName;

    UITextField*_factoryNameTF;//公司名称

    UITextField*_factorySizeTF;//工厂规模

    UITextField*_factoryServiceRangeTF;//业务类型

    UITextField*inviteCodeTF;
}
@property(nonatomic,retain)NSArray*cellPickList;
@property(nonatomic,retain)NSArray*cellServicePickList;

@property (nonatomic,strong) UIPickerView *orderPicker;
@property (nonatomic,strong) UIToolbar *pickerToolbar;

@property (nonatomic,strong) UIPickerView *servicePicker;
@property (nonatomic,strong) UIToolbar *serviceToolbar;



@end

@implementation RegisterViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"公司详情";

    NSArray*serviceListArr=@[@[@"童装",@"成人装"],@[@"针织",@"梭织"]];

    FactoryRangeModel*rangeModel = [[FactoryRangeModel alloc]init];

//    NSArray*cellListArr=@[@[@"10万件-30万件", @"30万件-50万件", @"50万件-100万件", @"100万件-200万件", @"200万件以上"],@[@"2人-4人", @"4人-10人", @"10人-20人", @"20人以上"],@[@"2人-4人", @"4人-10人"],@[@"2人-4人", @"4人-10人"]];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"服装厂"]) {
        self.cellServicePickList=serviceListArr[0];
        self.cellPickList=rangeModel.allFactorySize[0];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"加工厂"]) {
        self.cellServicePickList=serviceListArr[1];
        self.cellPickList=rangeModel.allFactorySize[1];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"代裁厂"]) {
        self.cellPickList=rangeModel.allFactorySize[2];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"锁眼钉扣厂"]) {
        self.cellPickList=rangeModel.allFactorySize[3];
    }
    [self createUI];

    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回登录" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;

}

- (void)buttonClicked {
    NSArray*navArr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:navArr[0] animated:YES];
}

-(void)createUI{
    UIImageView*bgView = [[UIImageView alloc]initWithFrame:kScreenBounds];
    bgView.image=[UIImage imageNamed:@"登录bg"];
    [self.view addSubview:bgView];

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"服装厂"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"加工厂"]) {

        UIView*TFView=[[UIView alloc]initWithFrame:CGRectMake(10, 100, kScreenW-20, 150)];
        TFView.alpha=0.9f;
        TFView.backgroundColor=[UIColor whiteColor];
        TFView.layer.borderWidth=2.0f;
        TFView.layer.borderColor=[UIColor whiteColor].CGColor;
        TFView.layer.cornerRadius=5.0f;
        TFView.layer.masksToBounds=YES;
        [self.view addSubview:TFView];

        UILabel*usernameLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 40, 20)];
        usernameLable.text=@"公司";
        usernameLable.font=[UIFont boldSystemFontOfSize:18];
        usernameLable.textColor=[UIColor blackColor];
        [TFView addSubview:usernameLable];

        _factoryNameTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 5, kScreenW-70, 40)];
        _factoryNameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _factoryNameTF.placeholder=@"请填写公司名称";
        [TFView addSubview:_factoryNameTF];

        UILabel*factorySizeLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 64, 40, 20)];
        factorySizeLable.text=@"规模";
        factorySizeLable.font=[UIFont boldSystemFontOfSize:18];
        factorySizeLable.textColor=[UIColor blackColor];
        [TFView addSubview:factorySizeLable];

        _factorySizeTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 55, kScreenW-70, 40)];
        _factorySizeTF.placeholder=@"请选择公司规模";
        _factorySizeTF.inputView = [self fecthSizePicker];
        _factorySizeTF.inputAccessoryView = [self fecthToolbar];
        _factorySizeTF.text = self.cellPickList[0];
        _factorySizeTF.delegate =self;
        [TFView addSubview:_factorySizeTF];

        //_factoryServiceRangeTF

        UILabel*factoryServiceRangeLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 114, 40, 20)];
        factoryServiceRangeLable.text=@"业务";
        factoryServiceRangeLable.font=[UIFont boldSystemFontOfSize:18];
        factoryServiceRangeLable.textColor=[UIColor blackColor];
        [TFView addSubview:factoryServiceRangeLable];

        _factoryServiceRangeTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 105, kScreenW-70, 40)];
        _factoryServiceRangeTF.placeholder=@"请选择公司业务类型";
        _factoryServiceRangeTF.inputView = [self fecthServicePicker];
        _factoryServiceRangeTF.inputAccessoryView = [self fecthServiceToolbar];
        _factoryServiceRangeTF.text =self.cellServicePickList[0];
        _factoryServiceRangeTF.delegate =self;
        [TFView addSubview:_factoryServiceRangeTF];

        inviteCodeTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 270, kScreenW-20, 35)];
        inviteCodeTF.keyboardType=UIKeyboardTypeNumberPad;
        inviteCodeTF.placeholder=@"请填写邀请码，没有可忽略。";
        [self.view addSubview:inviteCodeTF];


        UIButton*registerBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 320, kScreenW-20, 35)];
        [registerBtn setBackgroundImage:[UIImage imageNamed:@"btnImageSelected"] forState:UIControlStateNormal];
        registerBtn.layer.cornerRadius=5.0f;
        registerBtn.layer.masksToBounds=YES;
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:registerBtn];

    }else{

        UIView*TFView=[[UIView alloc]initWithFrame:CGRectMake(10, 100, kScreenW-20, 100)];
        TFView.alpha=0.9f;
        TFView.backgroundColor=[UIColor whiteColor];
        TFView.layer.borderWidth=2.0f;
        TFView.layer.borderColor=[UIColor whiteColor].CGColor;
        TFView.layer.cornerRadius=5.0f;
        TFView.layer.masksToBounds=YES;
        [self.view addSubview:TFView];

        UILabel*usernameLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 15, 40, 20)];
        usernameLable.text=@"公司";
        usernameLable.font=[UIFont boldSystemFontOfSize:18];
        usernameLable.textColor=[UIColor blackColor];
        [TFView addSubview:usernameLable];

        _factoryNameTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 5, kScreenW-70, 40)];
        _factoryNameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _factoryNameTF.placeholder=@"请填写公司名称";
        [TFView addSubview:_factoryNameTF];

        UILabel*passwordLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 63, 40, 20)];
        passwordLable.text=@"规模";
        passwordLable.font=[UIFont boldSystemFontOfSize:18];
        passwordLable.textColor=[UIColor blackColor];
        [TFView addSubview:passwordLable];

        _factorySizeTF = [[UITextField alloc]initWithFrame:CGRectMake(50, 55, kScreenW-70, 40)];
        _factorySizeTF.placeholder=@"请选择公司规模";
        _factorySizeTF.inputView = [self fecthSizePicker];
        _factorySizeTF.inputAccessoryView = [self fecthToolbar];
        _factorySizeTF.text = _sizePickerName;
        _factorySizeTF.delegate =self;
        [TFView addSubview:_factorySizeTF];

        inviteCodeTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 220, kScreenW-20, 35)];
        inviteCodeTF.placeholder=@"邀请码";
        inviteCodeTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        inviteCodeTF.borderStyle=UITextBorderStyleRoundedRect;
        inviteCodeTF.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:inviteCodeTF];


        UIButton*registerBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 270, kScreenW-20, 35)];
        [registerBtn setBackgroundImage:[UIImage imageNamed:@"btnImageSelected"] forState:UIControlStateNormal];
        registerBtn.layer.cornerRadius=5.0f;
        registerBtn.layer.masksToBounds=YES;
        [registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:registerBtn];
    }
}



//sizePicker
- (UIPickerView *)fecthSizePicker{
    if (!self.orderPicker) {
        self.orderPicker = [[UIPickerView alloc] init];
        self.orderPicker.tag=1;
        self.orderPicker.delegate = self;
        self.orderPicker.dataSource = self;
        [self.orderPicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.orderPicker;
}
- (UIToolbar *)fecthToolbar{
    if (!self.pickerToolbar) {
        self.pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensure)];
        self.pickerToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.pickerToolbar;
}

-(void)cancel{

    _sizePickerName = nil;
    [_factorySizeTF endEditing:YES];
}

-(void)ensure{

    if (_sizePickerName) {
        _factorySizeTF.text = _sizePickerName;
        _sizePickerName = nil;
    }
    [_factorySizeTF endEditing:YES];
}


//service
- (UIPickerView *)fecthServicePicker{
    if (!self.servicePicker) {
        self.servicePicker = [[UIPickerView alloc] init];
        self.servicePicker.tag=2;
        self.servicePicker.delegate = self;
        self.servicePicker.dataSource = self;
        [self.servicePicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.servicePicker;
}

- (UIToolbar *)fecthServiceToolbar{

    if (!self.serviceToolbar) {
        self.serviceToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(serviceCancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(serviceEnsure)];
        self.serviceToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.serviceToolbar;
}

-(void)serviceCancel{

    _servicePickerName = nil;
    [_factoryServiceRangeTF endEditing:YES];
}

-(void)serviceEnsure{

    if (_servicePickerName) {
        _factoryServiceRangeTF.text = _servicePickerName;
        _servicePickerName = nil;
    }
    [_factoryServiceRangeTF endEditing:YES];
}


#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        return self.cellPickList.count;
    }else{
        return self.cellServicePickList.count;
    }
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag==2) {
        return [self.cellServicePickList objectAtIndex:row];
    }else{
        return [self.cellPickList objectAtIndex:row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag==1) {
        _sizePickerName = [self pickerView:pickerView titleForRow:row forComponent:component];
    }else{
    _servicePickerName = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
}


- (void)clickRegisterBtn{

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    //账号
    NSString*phone=[userDefaults objectForKey:@"phone"];

    //密码
    NSString*password=[userDefaults objectForKey:@"password"];

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

    //验证码
    NSString*verifyCode=[userDefaults objectForKey:@"code"];

    //工厂地址
    NSString*factoryAddress=[userDefaults objectForKey:@"factoryAddress"];

    //经纬度
    double lon=[[userDefaults objectForKey:@"lon"] doubleValue];
    double lat=[[userDefaults objectForKey:@"lat"] doubleValue];

    //工厂名称
    NSString*factoryName=_factoryNameTF.text;

    //业务类型
    NSString*factoryServiceRange=_factoryServiceRangeTF.text;


    NSNumber*sizeMin=[[Tools RangeSizeWith:_factorySizeTF.text] firstObject];
    NSNumber*sizeMax=[[Tools RangeSizeWith:_factorySizeTF.text] lastObject];

    NSLog(@"Size=(%@-%@) range = %d",sizeMin,sizeMax,factoryType);

    if ([factoryName isEqualToString:@""]||[factoryServiceRange isEqualToString:@""]||[_factorySizeTF.text isEqualToString:@""]) {

        UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"请将公司信息填写完整" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        //注册
        [HttpClient registerWithUsername:phone  InviteCode:inviteCodeTF.text password:password factoryType:factoryType verifyCode:verifyCode factoryName:factoryName lon:lon lat:lat factorySizeMin:[[Tools RangeSizeWith:_factorySizeTF.text] firstObject] factorySizeMax:[[Tools RangeSizeWith:_factorySizeTF.text] lastObject] factoryAddress:factoryAddress factoryServiceRange:factoryServiceRange andBlock:^(NSDictionary *responseDictionary) {
            NSString*message=responseDictionary[@"message"];
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }];
    }
}


//注册成功 登录
- (void)login{
    [HttpClient loginWithUsername:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"] password:[[NSUserDefaults standardUserDefaults] objectForKey:@"phone"] andBlock:^(int statusCode) {
        NSLog(@"%d",statusCode);
        switch (statusCode) {
            case 0:{
//                UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"网络错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
            }
                break;
            case 200:{
                [ViewController goMain];
//                UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"登陆成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
            }
                break;
            case 400:{
//                UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"用户名密码错误" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                [alertView show];
            }
                break;

            default:
                break;
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
