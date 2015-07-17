//
//  AddressViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/12.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "AddressViewController.h"
#import "MapViewController.h"


@interface AddressViewController ()<BMKGeoCodeSearchDelegate>{
    UITextField*_addressTF;
    BMKGeoCodeSearch *_searcher;
}

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"工厂地址";

    // 初始化检索对象
    _searcher = [[BMKGeoCodeSearch alloc] init];
    _searcher.delegate = self;
    
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
    usernameLable.text=@"工厂地址";
    usernameLable.font=[UIFont boldSystemFontOfSize:15];
    usernameLable.textColor=[UIColor blackColor];
    [TFView addSubview:usernameLable];
    
    _addressTF = [[UITextField alloc]initWithFrame:CGRectMake(70, 5, kScreenW-90, 40)];
    _addressTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _addressTF.placeholder=@"请输入工厂地址";
    [TFView addSubview:_addressTF];
    
    UIButton*mapBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 170, kScreenW-20, 35)];
    [mapBtn setBackgroundImage:[UIImage imageNamed:@"btnImageSelected"] forState:UIControlStateNormal];
//    mapBtn.alpha=0.8f;
    mapBtn.backgroundColor=[UIColor redColor];
    mapBtn.layer.cornerRadius=5.0f;
    mapBtn.layer.masksToBounds=YES;
    [mapBtn setTitle:@"确定精确位置" forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(clickMapBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapBtn];
    
}

- (void)clickMapBtn {
    if (_addressTF.text.length!=0) {
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
        geoCodeSearchOption.address = _addressTF.text;
        if ([_searcher geoCode:geoCodeSearchOption]) {
            NSLog(@"geo检索发送正常");

        } else {
            NSLog(@"geo检索发送失败");
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"检索发送失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }else{
        UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"请您填写公司地址" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

#pragma mark - <BMKGeoCodeSearchDelegate>
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        // 正常结果
    
        //NSLog(@"%lf %lf", result.location.latitude, result.location.longitude);
        MapViewController*mapVC = [[MapViewController alloc]init];
        mapVC.addressStr=_addressTF.text;
        mapVC.centerLocation = result.location;
        [self.navigationController pushViewController:mapVC animated:YES];
    } else {
        UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"抱歉，未找到结果" message:@"请重新填写地址" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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
