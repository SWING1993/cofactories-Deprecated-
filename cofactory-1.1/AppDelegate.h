//
//  AppDelegate.h
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import <UIKit/UIKit.h>
// 引用 IMKit 头文件。
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RCIMConnectionStatusDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

