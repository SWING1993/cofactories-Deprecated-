//
//  RegisterViewController2.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "RegisterViewController2.h"
#import "AddressViewController.h"

@interface RegisterViewController2 ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{

    UIButton*_beforeBtn;
    UILabel*_label;
    UITextField*_typeTF;
    NSString *_tmpPickerName;

}

@property(nonatomic,retain)NSArray*cellPickList;
@property (nonatomic,strong) UIPickerView *orderPicker;
@property (nonatomic,strong) UIToolbar    *pickerToolbar;

@end

@implementation RegisterViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"身份";

    self.cellPickList=@[@"服装厂",@"加工厂",@"代裁厂",@"锁眼钉扣厂"];
    
    [self createUI];
}

- (void)createUI {

    UIImageView*bgView = [[UIImageView alloc]initWithFrame:kScreenBounds];
    bgView.image=[UIImage imageNamed:@"登录bg"];
    [self.view addSubview:bgView];
    
    UIView*TFView=[[UIView alloc]initWithFrame:CGRectMake(10, 100, kScreenW-20, 50)];
    TFView.alpha=0.9f;
    TFView.backgroundColor=[UIColor whiteColor];
    TFView.layer.borderWidth=2.0f;
    TFView.layer.borderColor=[UIColor whiteColor].CGColor;
    TFView.layer.cornerRadius=5.0f;
    TFView.layer.masksToBounds=YES;
    [self.view addSubview:TFView];
    
    
    UILabel*usernameLable = [[UILabel alloc]initWithFrame:CGRectMake(5, 14, 60, 20)];
    usernameLable.text=@"工厂类型";
    usernameLable.font=[UIFont boldSystemFontOfSize:15];
    usernameLable.textColor=[UIColor blackColor];
    [TFView addSubview:usernameLable];
    
    _typeTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 5, kScreenW-90, 40)];
    _typeTF.text = self.cellPickList[0];
    _typeTF.placeholder=@"请选择工厂类型";
    _typeTF.inputView = [self fecthPicker];
    _typeTF.inputAccessoryView = [self fecthToolbar];
    _typeTF.delegate =self;
    [TFView addSubview:_typeTF];
    
    UIButton*nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 170, kScreenW-20, 35)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btnImageSelected"] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius=5.0f;
    nextBtn.layer.masksToBounds=YES;
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextStepButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

}
- (void)nextStepButton {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_typeTF.text forKey:@"type"];
    [userDefaults synchronize];
    //NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@",[userDefaults stringForKey:@"type"]);
    if (![[userDefaults stringForKey:@"type"]isEqualToString:@""]) {
        AddressViewController*addressVC3 = [[AddressViewController alloc]init];
        [self.navigationController pushViewController:addressVC3 animated:YES];
    }else{
     
        UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"请选择您的工厂类型" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (UIPickerView *)fecthPicker{
    if (!self.orderPicker) {
        self.orderPicker = [[UIPickerView alloc] init];
        self.orderPicker.delegate = self;
        self.orderPicker.dataSource = self;
        [self.orderPicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.orderPicker;
}

- (UIToolbar *)fecthToolbar{
    
    if (!self.pickerToolbar) {
        self.pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensure)];
        self.pickerToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.pickerToolbar;
}
#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.cellPickList.count;
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.cellPickList objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _tmpPickerName = [self pickerView:pickerView titleForRow:row forComponent:component];
}
-(void)ensure{

    if (_tmpPickerName) {
        _typeTF.text = _tmpPickerName;
        _tmpPickerName = nil;
    }
    [_typeTF endEditing:YES];

}
-(void)cancel{
    
    _tmpPickerName = nil;
    [_typeTF endEditing:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
