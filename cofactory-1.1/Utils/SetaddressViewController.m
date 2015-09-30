//
//  SetaddressViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"

#import "SetaddressViewController.h"

#define PROVINCE_COMPONENT  0
#define CITY_COMPONENT      1
#define DISTRICT_COMPONENT  2

@interface SetaddressViewController () <BMKGeoCodeSearchDelegate,UIPickerViewDataSource,UIPickerViewDelegate> {
    UITextField*addressTF;
    UITextField*addressTF1;
    BMKGeoCodeSearch *_searcher;
}


@property (nonatomic,strong) UIPickerView *addressPicker;
@property (nonatomic,strong) UIToolbar *addressToolbar;

@end

@implementation SetaddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"公司地址";
    self.view.backgroundColor=[UIColor colorWithWhite:0.952 alpha:1.000];

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


    _searcher = [[BMKGeoCodeSearch alloc] init];
    _searcher.delegate = self;

        //确定Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;




    UILabel*label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 35)];
    label1.backgroundColor = [UIColor whiteColor];
    label1.text = @"公司位置:";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:label1];

    addressTF1=[[UITextField alloc]initWithFrame:CGRectMake(80, 10, kScreenW-75, 35)];
    addressTF1.backgroundColor = [UIColor whiteColor];
    addressTF1.inputView = [self fecthAddressPicker];
    addressTF1.inputAccessoryView = [self fecthAddressToolbar];    addressTF1.text=self.placeholder;
    addressTF1.clearButtonMode=YES;
    addressTF1.placeholder=@"选择公司地址";
    [self.view addSubview:addressTF1];


    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 55, 80, 35)];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"详细位置:";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16.0f];
    [self.view addSubview:label];

    addressTF=[[UITextField alloc]initWithFrame:CGRectMake(80, 55, kScreenW-75, 35)];
    addressTF.backgroundColor = [UIColor whiteColor];
    addressTF.text=self.placeholder;
    addressTF.clearButtonMode=YES;
    addressTF.placeholder=@"输入公司详细地址";
    [self.view addSubview:addressTF];

}

- (void)buttonClicked {

    NSInteger provinceIndex = [self.addressPicker selectedRowInComponent: PROVINCE_COMPONENT];
    NSInteger cityIndex = [self.addressPicker selectedRowInComponent: CITY_COMPONENT];
    NSInteger districtIndex = [self.addressPicker selectedRowInComponent: DISTRICT_COMPONENT];

    NSString *provinceStr = [province objectAtIndex: provinceIndex];
    NSString *cityStr = [city objectAtIndex: cityIndex];
    NSString *districtStr = [district objectAtIndex:districtIndex];
    

    addressString = [NSString stringWithFormat: @"%@%@%@%@", provinceStr, cityStr, districtStr,addressTF.text];

    DLog(@"addressString%@",addressString);


    if ([addressString isEqualToString:@""]) {
        [Tools showErrorWithStatus:@"公司地址不能为空！"];
    }else{
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
        geoCodeSearchOption.address = addressString;
        if ([_searcher geoCode:geoCodeSearchOption]) {
            DLog(@"geo检索发送正常");

        } else {
            DLog(@"geo检索发送失败");
            [Tools showErrorWithStatus:@"检索发送失败"];
        }

    }
}

#pragma mark - <BMKGeoCodeSearchDelegate>
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        // 正常结果

        //NSLog(@"%lf %lf", result.location.latitude, result.location.longitude);
        SetMapViewController*mapVC = [[SetMapViewController alloc]init];
        mapVC.addressStr=addressString;
        mapVC.centerLocation = result.location;
        [self.navigationController pushViewController:mapVC animated:YES];
    } else {
        [Tools showErrorWithStatus:@"抱歉，未找到结果。"];

    }
}

//sizePicker
- (UIPickerView *)fecthAddressPicker{
    if (!self.addressPicker) {
        self.addressPicker = [[UIPickerView alloc] init];
        self.addressPicker.backgroundColor = [UIColor whiteColor];
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
    [addressTF1 endEditing:YES];
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

    addressTF1.text = addressString;
    addressString = nil;

    [addressTF1 endEditing:YES];
}



#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;

}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
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


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
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


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    DLog(@"- (void)pickerView:(UIPickerView *)");

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

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == PROVINCE_COMPONENT) {
        return 80;
    }
    else if (component == CITY_COMPONENT) {
        return 100;
    }
    else {
        return 115;
    }

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    if (component == PROVINCE_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 78, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [province objectAtIndex:row];
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
    else if (component == CITY_COMPONENT) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 95, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = [city objectAtIndex:row];
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
