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
        DLog(@"未登录");
        [ViewController goLogin];
    }else{
        [ViewController goMain];
        DLog(@"已登录");
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

    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    AppDelegate *app =[UIApplication sharedApplication].delegate;
    app.window.rootViewController = tabBarController;
    
    HomeViewController *VC1 = [[HomeViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:VC1];
    nav1.navigationBar.barStyle=UIBarStyleBlack;
    
    CooperationViewController *VC2 = [[CooperationViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:VC2];
    nav2.navigationBar.barStyle=UIBarStyleBlack;

    MessageViewController *VC3 = [[MessageViewController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:VC3];
    nav3.navigationBar.barStyle=UIBarStyleBlack;

    MeViewController *VC4 = [[MeViewController alloc] init];
    UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:VC4];
    nav4.navigationBar.barStyle=UIBarStyleBlack;

    
        //获取消息
        [HttpClient getSystemMessageWithBlock:^(NSDictionary *responseDictionary) {
            if ([responseDictionary[@"statusCode"] intValue]==200) {
                NSArray *array=responseDictionary[@"responseArray"];
                NSInteger messageCount = array.count;
                NSString *badgeValue = [NSString stringWithFormat:@"%ld",(long)messageCount];
                NSLog(@"badgeValue==%@",badgeValue);
                if ([badgeValue isEqualToString:@"0"] ) {
                    VC3.tabBarItem.badgeValue = nil;
                }else{
                    VC3.tabBarItem.badgeValue = badgeValue;
                }
            };
        }];

    VC1.title = @"聚工厂";
    VC2.title = @"合作商";
    VC3.title = @"消息";
    VC4.title = @"我";
    NSArray *viewControllersArray = @[nav1,nav2,nav3,nav4];
    [tabBarController setViewControllers:viewControllersArray];
    app.window.rootViewController = tabBarController;
    
    UITabBar *tabbar = tabBarController.tabBar;
    UITabBarItem *item1 = tabbar.items[0];
    UITabBarItem *item2 = tabbar.items[1];
    UITabBarItem *item3 = tabbar.items[2];
    UITabBarItem *item4 = tabbar.items[3];
    
    item1.selectedImage = [[UIImage imageNamed:@"tabHomeSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item1.image = [[UIImage imageNamed:@"tabHome"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.selectedImage = [[UIImage imageNamed:@"tabpatSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item2.image = [[UIImage imageNamed:@"tabpat"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.selectedImage = [[UIImage imageNamed:@"tabmesSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item3.image = [[UIImage imageNamed:@"tabmes"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.selectedImage = [[UIImage imageNamed:@"tabuserSelected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item4.image = [[UIImage imageNamed:@"tabuser"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
