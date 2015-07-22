//
//  MapViewController.h
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/12.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController

@property (nonatomic,copy)NSString*addressStr;
@property (nonatomic, assign) CLLocationCoordinate2D centerLocation;


@end
