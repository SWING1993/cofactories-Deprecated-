//
//  SetMapViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/17.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import <BaiduMapAPI/BMapKit.h>
#import "SetMapViewController.h"

@interface SetMapViewController () <BMKMapViewDelegate,BMKPoiSearchDelegate> {
    BMKMapView *_mapView;
    BMKGeoCodeSearch *_searcher;
}

@property (nonatomic,assign)double longitude;
@property (nonatomic,assign)double latitude;

@end

@implementation SetMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title=@"精确位置";
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    //没有地图选点之前的经纬度
    self.longitude=self.centerLocation.longitude;
    self.latitude=self.centerLocation.latitude;

    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-150)];
    [_mapView setCenterCoordinate:self.centerLocation];
    [self.view addSubview:_mapView];

    UIButton*nextBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, kScreenH-130, kScreenW-20, 35)];
    [nextBtn setTitle:@"保存位置" forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"btnBlue"] forState:UIControlStateNormal];
    nextBtn.layer.cornerRadius=5.0f;
    nextBtn.layer.masksToBounds=YES;
    [nextBtn addTarget:self action:@selector(clickNextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];

}

- (void)clickNextBtn {

    //经纬度
    NSNumber* lon = [[NSNumber alloc]initWithDouble:self.longitude];
    NSNumber* lat = [[NSNumber alloc]initWithDouble:self.latitude];


    MBProgressHUD *hud = [Tools createHUD];
    hud.labelText = @"正在修改公司位置";
    [HttpClient updateFactoryProfileWithFactoryName:nil factoryAddress:self.addressStr factoryServiceRange:nil factorySizeMin:nil factorySizeMax:nil factoryLon:lon factoryLat:lat factoryFree:nil  factoryDescription:nil andBlock:^(int statusCode) {
        if (statusCode == 200) {
            hud.labelText = @"公司位置修改成功";
            [hud hide:YES];

            NSArray*navArr = self.navigationController.viewControllers;
            [self.navigationController popToViewController:navArr[0] animated:YES];

        } else {
            hud.labelText = @"公司位置修改失败";
            [hud hide:YES];
        }
    }];
}
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
