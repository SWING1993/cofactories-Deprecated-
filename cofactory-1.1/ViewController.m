//
//  ViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "HttpClient.h"
#import "ViewController.h"

@interface ViewController ()

@end
//static 

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![HttpClient getToken]) {
        NSLog(@"未登录");
        [ViewController goLogin];
    }else{
        [ViewController goMain];

        NSLog(@"已登录");
    }
}
//加载注册界面
+ (void)goLogin {
    
    LoginViewController *loginView =[[LoginViewController alloc]init];
    UINavigationController *loginNav =[[UINavigationController alloc]initWithRootViewController:loginView];
    loginNav.navigationBar.barStyle=UIBarStyleBlack;
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    app.window.rootViewController =loginNav;
}
//加载主界面
+(void)goMain {

    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"toursit"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    // HomeViewController 初始化
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [homeViewController setTitle:@"聚工厂"];
    homeNavigationController.navigationBar.barStyle=UIBarStyleBlack;
    homeNavigationController.tabBarItem.image =[UIImage imageNamed:@"tabHome"];
    homeNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabHomeSelected"];

    // CooperationViewController 初始化
    CooperationViewController *cooperationViewController = [[CooperationViewController alloc] init];
    UINavigationController *cooperationNavigationController = [[UINavigationController alloc] initWithRootViewController:cooperationViewController];
    [cooperationViewController setTitle:@"合作商"];
    cooperationNavigationController.navigationBar.barStyle=UIBarStyleBlack;
    cooperationNavigationController.tabBarItem.image =[UIImage imageNamed:@"tabpat"];
    cooperationNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabpatSelected"];



    // MessageViewController 初始化
    MessageViewController *messageViewController = [[MessageViewController alloc] init];
    UINavigationController *messageNavigationController = [[UINavigationController alloc] initWithRootViewController:messageViewController];
    [messageViewController setTitle:@"消息"];
    messageNavigationController.navigationBar.barStyle=UIBarStyleBlack;
    messageViewController.tabBarItem.image =[UIImage imageNamed:@"tabmes"];
    messageViewController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabmesSelected"];
    //获取消息
    [HttpClient getSystemMessageWithBlock:^(NSDictionary *responseDictionary) {
        if ([responseDictionary[@"statusCode"] intValue]==200) {
            NSArray *array=responseDictionary[@"responseArray"];
            NSInteger messageCount = array.count;
            NSString *badgeValue = [NSString stringWithFormat:@"%ld",(long)messageCount];
            NSLog(@"badgeValue==%@",badgeValue);
            if ([badgeValue isEqualToString:@"0"] ) {
                messageViewController.tabBarItem.badgeValue = nil;
            }else{
                messageViewController.tabBarItem.badgeValue = badgeValue;
            }
        };
    }];

    // MeViewController 初始化
    MeViewController *meViewController = [[MeViewController alloc] init];
    UINavigationController *meNavigationController = [[UINavigationController alloc] initWithRootViewController:meViewController];
    [meViewController setTitle:@"我"];
    meNavigationController.navigationBar.barStyle=UIBarStyleBlack;
    meNavigationController.tabBarItem.image =[UIImage imageNamed:@"tabuser"];
    meNavigationController.tabBarItem.selectedImage=[UIImage imageNamed:@"tabuserSelected"];

    // tabbarcontroller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[homeNavigationController, cooperationNavigationController, messageNavigationController, meNavigationController];
    tabBarController.selectedIndex=0;
    //tabBarController.tabBar.tintColor=[UIColor colorWithRed:60.0/255 green:255.0/255 blue:109.0/255 alpha:1];
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    app.window.rootViewController =tabBarController;
}

// 游客登录 加载主界面
+(void)TouristLogin {

    // HomeViewController 初始化
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    UINavigationController *homeNavigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [homeViewController setTitle:@"聚工厂"];
    homeNavigationController.navigationBar.barStyle=UIBarStyleBlack;
    homeNavigationController.tabBarItem.image =[UIImage imageNamed:@"tabHome"];
    homeNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabHomeSelected"];

    // CooperationViewController 初始化
    CooperationViewController *cooperationViewController = [[CooperationViewController alloc] init];
    UINavigationController *cooperationNavigationController = [[UINavigationController alloc] initWithRootViewController:cooperationViewController];
    [cooperationViewController setTitle:@"合作商"];
    cooperationNavigationController.navigationBar.barStyle=UIBarStyleBlack;
    cooperationNavigationController.tabBarItem.image =[UIImage imageNamed:@"tabpat"];
    cooperationNavigationController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabpatSelected"];

    // MessageViewController 初始化
    MessageViewController *messageViewController = [[MessageViewController alloc] init];
    UINavigationController *messageNavigationController = [[UINavigationController alloc] initWithRootViewController:messageViewController];
    [messageViewController setTitle:@"消息"];
    messageNavigationController.navigationBar.barStyle=UIBarStyleBlack;
    messageViewController.tabBarItem.image =[UIImage imageNamed:@"tabmes"];
    messageViewController.tabBarItem.selectedImage =[UIImage imageNamed:@"tabmesSelected"];

    // MeViewController 初始化
    MeViewController *meViewController = [[MeViewController alloc] init];
    UINavigationController *meNavigationController = [[UINavigationController alloc] initWithRootViewController:meViewController];
    [meViewController setTitle:@"我"];
    meNavigationController.navigationBar.barStyle=UIBarStyleBlack;
    meNavigationController.tabBarItem.image =[UIImage imageNamed:@"tabuser"];
    meNavigationController.tabBarItem.selectedImage=[UIImage imageNamed:@"tabuserSelected"];

    // tabbarcontroller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[homeNavigationController, cooperationNavigationController, messageNavigationController, meNavigationController];
    tabBarController.selectedIndex=0;
    //tabBarController.tabBar.tintColor=[UIColor colorWithRed:60.0/255 green:255.0/255 blue:109.0/255 alpha:1];
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    app.window.rootViewController =tabBarController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
