//
//  RegisterViewController2.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "RegisterViewController2.h"
#import "MapViewController.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface RegisterViewController2 ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,BMKGeoCodeSearchDelegate>{

    BMKGeoCodeSearch *_searcher;

    NSString *_sizePickerName;

    NSString*_servicePickerName;

    NSString *addressString;


    UITextField*_factoryNameTF;//公司名称


    UITextField*_factoryAddressTF;

    UITextField*_factoryAddressTF2;


    UITextField*_factorySizeTF;//工厂规模

    UITextField*_factoryServiceRangeTF;//业务类型

}
@property(nonatomic,retain)NSArray*cellPickList;
@property(nonatomic,retain)NSArray*cellServicePickList;

@property (nonatomic,strong) UIPickerView *sizePicker;
@property (nonatomic,strong) UIToolbar *sizePickerToolbar;

@property (nonatomic,strong) UIPickerView *servicePicker;
@property (nonatomic,strong) UIToolbar *serviceToolbar;


@property (nonatomic,strong) UIPickerView *addressPicker;
@property (nonatomic,strong) UIToolbar *addressToolbar;

@end

@implementation RegisterViewController2
{
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;

    NSString *selectedProvince;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 初始化检索对象
    _searcher = [[BMKGeoCodeSearch alloc] init];
    _searcher.delegate = self;

    self.title=@"注册";

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


    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"Areas" ofType:@"plist"];
    areaDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];

    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {

        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }

        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];

    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }

    province = [[NSArray alloc] initWithArray: provinceTmp];

    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];

    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [[NSArray alloc] initWithArray: [cityDic allKeys]];


    NSString *selectedCity = [city objectAtIndex: 0];
    district = [[NSArray alloc] initWithArray: [cityDic objectForKey: selectedCity]];

    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-64, kScreenH) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor = [UIColor whiteColor];

    tablleHeaderView*tableHeaderView = [[tablleHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, tableHeaderView_height)];
    self.tableView.tableHeaderView = tableHeaderView;


    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    blueButton*nextBtn=[[blueButton alloc]initWithFrame:CGRectMake(20, 15, kScreenW-40, 35)];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextStepButton) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:nextBtn];
    self.tableView.tableFooterView = tableFooterView;


    [self createUI];
}


- (void)createUI {

    if (!_factoryNameTF) {
        _factoryNameTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _factoryNameTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _factoryNameTF.placeholder=@"公司名称";
    }


    if (!_factoryAddressTF) {
        _factoryAddressTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _factoryAddressTF.clearButtonMode=UITextFieldViewModeWhileEditing;
        _factoryAddressTF.placeholder=@"公司地址";
        _factoryAddressTF.inputView = [self fecthAddressPicker];
        _factoryAddressTF.inputAccessoryView = [self fecthAddressToolbar];
        _factoryAddressTF.delegate =self;

    }

    if (!_factoryAddressTF2) {
        _factoryAddressTF2 = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _factoryAddressTF2.clearButtonMode=UITextFieldViewModeWhileEditing;
        _factoryAddressTF2.placeholder=@"公司详细街道";
    }

    if (!_factorySizeTF) {
        _factorySizeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _factorySizeTF.placeholder=@"公司规模";
        _factorySizeTF.inputView = [self fecthSizePicker];
        _factorySizeTF.inputAccessoryView = [self fecthToolbar];
        _factorySizeTF.delegate =self;
    }


    if (!_factoryServiceRangeTF) {

        _factoryServiceRangeTF = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-15, 44)];
        _factoryServiceRangeTF.placeholder=@"公司业务类型";
        _factoryServiceRangeTF.inputView = [self fecthServicePicker];
        _factoryServiceRangeTF.inputAccessoryView = [self fecthServiceToolbar];
        _factoryServiceRangeTF.delegate =self;
    }
}





- (void)nextStepButton {

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"服装厂"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"加工厂"]) {

        if (_factoryAddressTF.text.length==0 || _factoryNameTF.text.length == 0 || _factorySizeTF.text.length==0 || _factoryServiceRangeTF.text.length == 0) {
            [Tools showHudTipStr:@"注册信息不完整"];
        }else{
            [self geoCodeSearch];

        }

    }

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"代裁厂"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"锁眼钉扣厂"]) {

        if (_factoryAddressTF.text.length==0 || _factoryNameTF.text.length == 0 || _factorySizeTF.text.length==0) {
            [Tools showHudTipStr:@"注册信息不完整"];
        }else{
            [self geoCodeSearch];

        }
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"面辅料商"]) {

        if (_factoryAddressTF.text.length==0 || _factoryNameTF.text.length == 0 ) {
            [Tools showHudTipStr:@"注册信息不完整"];
        }else{
            [self geoCodeSearch];
        }

    }

}
- (void)geoCodeSearch {
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
    geoCodeSearchOption.address = _factoryAddressTF.text;
    if ([_searcher geoCode:geoCodeSearchOption]) {
        DLog(@"百度地图检索发送正常");

        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_factoryNameTF.text forKey:@"factoryName"];
        [userDefaults setObject:[NSString stringWithFormat:@"%@%@",_factoryAddressTF.text,_factoryAddressTF2.text] forKey:@"factoryAddress"];
        [userDefaults setObject:_factorySizeTF.text forKey:@"factorySize"];
        if (_factoryServiceRangeTF.text.length>0) {
            DLog(@"业务类型存在");
            [userDefaults setObject:_factoryServiceRangeTF.text forKey:@"factoryServiceRange"];
        }

        [userDefaults synchronize];

    } else {
        [Tools showHudTipStr:@"百度地图检索发送失败"];
    }
}

#pragma mark - <BMKGeoCodeSearchDelegate>
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        // 正常结果

        MapViewController*mapVC = [[MapViewController alloc]init];
        mapVC.addressStr=_factoryAddressTF.text;
        mapVC.centerLocation = result.location;
        [self.navigationController pushViewController:mapVC animated:YES];
    } else {
        UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"抱歉，未找到结果" message:@"请重新填写地址" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
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
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"服装厂"] || [[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"加工厂"]) {
        return 5;
    }if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"type"]isEqualToString:@"面辅料商"]) {
        return 3;
    }else{
        return 4;
    }
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
            [cell addSubview:_factoryAddressTF];
        }
        if (indexPath.row == 2) {
            [cell addSubview:_factoryAddressTF2];

        }
        if (indexPath.row == 3) {
            [cell addSubview:_factorySizeTF];
        }

        if (indexPath.row == 4) {
            [cell addSubview:_factoryServiceRangeTF];
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
    if (!self.sizePicker) {
        self.sizePicker = [[UIPickerView alloc] init];
        self.sizePicker.backgroundColor = [UIColor whiteColor];
        self.sizePicker.tag = 1;
        self.sizePicker.delegate = self;
        self.sizePicker.dataSource = self;
        [self.sizePicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.sizePicker;
}
- (UIToolbar *)fecthToolbar{
    if (!self.sizePickerToolbar) {
        self.sizePickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensure)];
        self.sizePickerToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.sizePickerToolbar;
}

-(void)cancel{

    _sizePickerName = nil;
    [_factorySizeTF endEditing:YES];
}

-(void)ensure{
    NSInteger provinceIndex = [self.sizePicker selectedRowInComponent: PROVINCE_COMPONENT];
    _sizePickerName = [self.cellPickList objectAtIndex: provinceIndex];

    _factorySizeTF.text = _sizePickerName;
    _sizePickerName = nil;
    [_factorySizeTF endEditing:YES];
}


//service
- (UIPickerView *)fecthServicePicker{
    if (!self.servicePicker) {
        self.servicePicker = [[UIPickerView alloc] init];
        self.servicePicker.backgroundColor = [UIColor whiteColor];
        self.servicePicker.tag = 2;
        self.servicePicker.delegate = self;
        self.servicePicker.dataSource = self;
        [self.servicePicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.servicePicker;
}

- (UIToolbar *)fecthServiceToolbar{

    if (!self.serviceToolbar) {
        self.serviceToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
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

    NSInteger provinceIndex = [self.servicePicker selectedRowInComponent: PROVINCE_COMPONENT];
    _servicePickerName = [self.cellServicePickList objectAtIndex: provinceIndex];


    _factoryServiceRangeTF.text = _servicePickerName;
    _servicePickerName = nil;
    [_factoryServiceRangeTF endEditing:YES];
}


//sizePicker
- (UIPickerView *)fecthAddressPicker{
    if (!self.addressPicker) {
        self.addressPicker = [[UIPickerView alloc] init];
        self.addressPicker.backgroundColor = [UIColor whiteColor];
        self.addressPicker.tag = 3;
        self.addressPicker.delegate = self;
        self.addressPicker.dataSource = self;
        [self.addressPicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.addressPicker;
}
- (UIToolbar *)fecthAddressToolbar{
    if (!self.addressToolbar) {
        self.addressToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(addressCancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(addressEnsure)];
        self.addressToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.addressToolbar;
}

-(void)addressCancel{

    addressString = nil;
    [_factoryAddressTF endEditing:YES];
}

-(void)addressEnsure{

    NSInteger provinceIndex = [self.addressPicker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [self.addressPicker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [self.addressPicker selectedRowInComponent: DISTRICT_COMPONENT];

    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];


    addressString = [NSString stringWithFormat: @"%@%@%@", provinceStr, cityStr, districtStr];

    DLog(@"%@",addressString);

    _factoryAddressTF.text = addressString;
    addressString = nil;

    [_factoryAddressTF endEditing:YES];
}


#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    DLog(@"- (NSInteger)numberOfComponentsInPickerView");

    if (pickerView.tag == 3) {
        return 3;
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    DLog(@"- (NSInteger)pickerView:(UIPickerView *)pickerView");

    if (pickerView.tag == 1) {
        return self.cellPickList.count;
    }
    if (pickerView.tag == 3) {
        DLog(@"b");

        if (component == PROVINCE_COMPONENT) {
            return [province count];
        }
        else if (component == CITY_COMPONENT) {
            return [city count];
        }
        else {
            return [district count];
        }

    }
    else{
        return self.cellServicePickList.count;
    }
    DLog(@"[province count]= %lu",(unsigned long)[province count]);
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

    DLog(@"a");
    if (pickerView.tag == 3) {
        if (component == PROVINCE_COMPONENT) {
            return [province objectAtIndex: row];
        }
        else if (component == CITY_COMPONENT) {
            return [city objectAtIndex: row];
        }
        else {
            return [district objectAtIndex: row];
        }
    }

    if (pickerView.tag==1) {
        return [self.cellPickList objectAtIndex:row];
    }else{
        return [self.cellServicePickList objectAtIndex:row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DLog(@"- (void)pickerView:(UIPickerView *)");

    if (pickerView.tag==1) {
        _sizePickerName = [self pickerView:pickerView titleForRow:row forComponent:component];
    }

    if (pickerView.tag==2){
        _servicePickerName = [self pickerView:pickerView titleForRow:row forComponent:component];
    }

    if (pickerView.tag == 3) {
        if (component == PROVINCE_COMPONENT) {
            selectedProvince = [province objectAtIndex: row];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%ld", (long)row]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            NSArray *cityArray = [dic allKeys];
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {

                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }

                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];

            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            city = [[NSArray alloc] initWithArray: array];
            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [city objectAtIndex: 0]]];
            [self.addressPicker selectRow: 0 inComponent: CITY_COMPONENT animated: YES];
            [self.addressPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [self.addressPicker reloadComponent: CITY_COMPONENT];
            [self.addressPicker reloadComponent: DISTRICT_COMPONENT];

        }
        else if (component == CITY_COMPONENT) {
            NSString *provinceIndex = [NSString stringWithFormat: @"%lu", (unsigned long)[province indexOfObject: selectedProvince]];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            NSArray *dicKeyArray = [dic allKeys];
            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {

                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }

                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];

            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: row]]];
            NSArray *cityKeyArray = [cityDic allKeys];
            district = [[NSArray alloc] initWithArray: [cityDic objectForKey: [cityKeyArray objectAtIndex:0]]];
            [self.addressPicker selectRow: 0 inComponent: DISTRICT_COMPONENT animated: YES];
            [self.addressPicker reloadComponent: DISTRICT_COMPONENT];
        }
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    DLog(@"- (CGFloat)pickerView");
    if (pickerView.tag == 3) {
        if (component == PROVINCE_COMPONENT) {
            return 80;
        }
        else if (component == CITY_COMPONENT) {
            return 100;
        }
        else {
            return 115;
        }

    }else
        return kScreenW;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    DLog(@"- (UIView *)pickerView:");
    if (pickerView.tag == 1) {
        UILabel *myView = nil;myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenW, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [self.cellPickList objectAtIndex:row];
        myView.font = kFont;
        myView.textColor = [UIColor blackColor];

        myView.backgroundColor = [UIColor clearColor];

        return myView;

    }
    if (pickerView.tag == 2) {
        UILabel *myView = nil;myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, kScreenW, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [self.cellServicePickList objectAtIndex:row];
        myView.textColor = [UIColor blackColor];
        myView.font = kFont;
        myView.backgroundColor = [UIColor clearColor];

        return myView;
    }

    if (pickerView.tag == 3) {
        UILabel *myView = nil;
        if (component == PROVINCE_COMPONENT) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [province objectAtIndex:row];
            myView.font = [UIFont systemFontOfSize:14];
            myView.textColor = [UIColor blackColor];

            myView.backgroundColor = [UIColor clearColor];
        }
        else if (component == CITY_COMPONENT) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [city objectAtIndex:row];
            myView.textColor = [UIColor blackColor];

            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }
        else {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 110, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = [district objectAtIndex:row];

            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }
        return myView;
    }
    else{
        UILabel *myView = nil;
        return myView;
    }
}

- (void)dealloc {
    DLog(@"注册2dealloc");

    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
    self.sizePicker.dataSource = nil;
    self.sizePicker.delegate = nil;
    self.servicePicker.delegate = nil;
    self.servicePicker.dataSource = nil;
    self.addressPicker.dataSource = nil;
    self.addressPicker.delegate = nil;
}

@end
