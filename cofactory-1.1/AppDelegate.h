//
//  AppDelegate.h
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

#define PGY_APPKEY @"5a53ca291f9b941c3c009f04fe23d2cc"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BMKMapManager *mapManager;


@end

