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

@interface MapViewController () <BMKMapViewDelegate,BMKPoiSearchDelegate> {
    BMKMapView *_mapView;
}
@property (nonatomic,assign)double longitude;
@property (nonatomic,assign)double latitude;

@end

@implementation MapViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    _mapView.zoomLevel=14;
    BMKPointAnnotation *annotatioin = [[BMKPointAnnotation alloc] init];
    annotatioin.coordinate = self.centerLocation;
    annotatioin.title = @"公司位置";
    [_mapView addAnnotation:annotatioin];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title=@"确定位置";
    self.view.backgroundColor=[UIColor whiteColor];
    
    //没有地图选点之前的经纬度
    self.longitude=self.centerLocation.longitude;
    self.latitude=self.centerLocation.latitude;
    

    DLog(@"位置：%@",self.addressStr);
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-150)];
    [_mapView setCenterCoordinate:self.centerLocation];
    [self.view addSubview:_mapView];

    blueButton*nextBtn=[[blueButton alloc]initWithFrame:CGRectMake(10, kScreenH-130, kScreenW-20, 35)];
    [nextBtn setTitle:@"确定位置" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

}

- (void)clickNextBtn {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:self.longitude forKey:@"lon"];
    [userDefaults setDouble:self.latitude forKey:@"lat"];
    [userDefaults synchronize];
    DLog(@"%@-%lf-%lf",self.addressStr,self.longitude,self.latitude);
    RegisterViewController3*registerVC3=[[RegisterViewController3 alloc]init];
    [self.navigationController pushViewController:registerVC3 animated:YES];
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
    DLog(@"%lf %lf", coordinate.longitude, coordinate.latitude);
    self.longitude=coordinate.longitude;
    self.latitude=coordinate.latitude;
    self.centerLocation = coordinate;
    [_mapView removeAnnotations:_mapView.annotations];
    BMKPointAnnotation *annotatioin = [[BMKPointAnnotation alloc] init];
    annotatioin.coordinate = self.centerLocation;
    annotatioin.title = @"公司位置";
    [_mapView addAnnotation:annotatioin];
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
