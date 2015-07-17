//
//  MapViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/12.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "MapViewController.h"
#import "RegisterViewController3.h"
#import <BaiduMapAPI/BMapKit.h>

@interface MapViewController ()<BMKMapViewDelegate,BMKPoiSearchDelegate> {
    BMKMapView *_mapView;
}
@property (nonatomic,assign)double longitude;
@property (nonatomic,assign)double latitude;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"精确位置";
    self.view.backgroundColor=[UIColor whiteColor];
    
    //没有地图选点之前的经纬度
    self.longitude=self.centerLocation.longitude;
    self.latitude=self.centerLocation.latitude;
    
    UIImageView*bgView = [[UIImageView alloc]initWithFrame:kScreenBounds];
    bgView.image=[UIImage imageNamed:@"登录bg"];
    [self.view addSubview:bgView];

    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(20, 84, kScreenW-40, kScreenH-284)];
    [_mapView setCenterCoordinate:self.centerLocation];
    [self.view addSubview:_mapView];
    UIButton*nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, kScreenH-164, kScreenW-20, 35)];
    [nextBtn setTitle:@"确定位置" forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btnImageSelected"] forState:UIControlStateNormal];
//    nextBtn.alpha=0.9f;
    nextBtn.layer.cornerRadius=5.0f;
    nextBtn.layer.masksToBounds=YES;
    [nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
}

- (void)clickNextBtn {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.addressStr forKey:@"factoryAddress"];
    [userDefaults setDouble:self.longitude forKey:@"lon"];
    [userDefaults setDouble:self.latitude forKey:@"lat"];
    [userDefaults synchronize];
    NSLog(@"%@-%lf-%lf",self.addressStr,self.longitude,self.latitude);
    RegisterViewController3*registerVC3=[[RegisterViewController3 alloc]init];
    [self.navigationController pushViewController:registerVC3 animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    BMKPointAnnotation *annotatioin = [[BMKPointAnnotation alloc] init];
    annotatioin.coordinate = self.centerLocation;
    annotatioin.title = @"工厂位置";
    [_mapView addAnnotation:annotatioin];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
}



#pragma mark - <BMKMapViewDelegate>
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"%lf %lf", coordinate.longitude, coordinate.latitude);
    self.longitude=coordinate.longitude;
    self.latitude=coordinate.latitude;
    self.centerLocation = coordinate;
    [_mapView removeAnnotations:_mapView.annotations];
    BMKPointAnnotation *annotatioin = [[BMKPointAnnotation alloc] init];
    annotatioin.coordinate = self.centerLocation;
    annotatioin.title = @"工厂位置";
    [_mapView addAnnotation:annotatioin];
}

//- (void)updateAddress:(id)sender {
//    MBProgressHUD *hud = [Config createHUD];
//    hud.labelText = @"正在更新地址...";
//    [[HttpClient sharedInstance] updateFactoryProfile:@{@"factoryAddress": self.address, @"factoryLocation": [NSString stringWithFormat:@"%lf, %lf", self.centerLocation.longitude, self.centerLocation.latitude]} andBlock:^(int statusCode) {
//        NSLog(@"%d", statusCode);
//        if (statusCode == 200) {
//            hud.labelText = @"地址更新成功";
//            [hud hide:YES];
//            [Config setForKey:kFactoryAddress andValue:self.address];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            return;
//        }
//        hud.labelText = @"更新地址失败";
//        [hud hide:YES];
//    }];
//    //创建通知
//    NSNotification *notification =[NSNotification notificationWithName:@"refreshAddress" object:nil userInfo:nil];
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
