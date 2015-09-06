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

    NSString *_sizePickerName;

    NSString*_servicePickerName;

    UITextField*_factoryNameTF;//公司名称

    UITextField*_factorySizeTF;//工厂规模

    UITextField*_factoryServiceRangeTF;//业务类型

}
@property(nonatomic,retain)NSArray*cellPickList;
@property(nonatomic,retain)NSArray*cellServicePickList;

@property (nonatomic,strong) UIPickerView *orderPicker;
@property (nonatomic,strong) UIToolbar *pickerToolbar;

@property (nonatomic,strong) UIPickerView *servicePicker;
@property (nonatomic,strong) UIToolbar *serviceToolbar;


@end

@implementation RegisterViewController2
{
    //BOOL _wasKeyboardManagerEnabled;
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

    self.title=@"身份";


    NSArray*serviceListArr=@[@[@"童装",@"成人装"],@[@"针织",@"梭织"]];

    FactoryRangeModel*rangeModel = [[FactoryRangeModel alloc]init];

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
}

- (void)createUI {

    _factoryNameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
    _factoryNameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _factoryNameTF.placeholder=@"公司名称";


    UIButton*nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 170-64, kScreenW-20, 35)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btnImageSelected"] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius=5.0f;
    nextBtn.layer.masksToBounds=YES;
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextStepButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

}





- (void)nextStepButton {



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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.row == 0) {
            [cell addSubview:_factoryNameTF];
        }
        if (indexPath.row == 1) {
        }
        if (indexPath.row == 2) {
        }
        if (indexPath.row == 3) {

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

@end
