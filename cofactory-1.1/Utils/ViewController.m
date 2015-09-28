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


static NSString * const sampleDescription1 = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
static NSString * const sampleDescription2 = @"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore.";
static NSString * const sampleDescription3 = @"Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem.";
static NSString * const sampleDescription4 = @"Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit.";



@interface ViewController ()

@end
//static 

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (![HttpClient getToken]) {
        DLog(@"未登录");

        //未登录 加载展示页面
        [self showIntroWithCrossDissolve];
//        [ViewController goLogin];

    }else{
        //工厂类型
        [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {

            if ([responseDictionary[@"statusCode"]integerValue]==200) {
                UserModel*userModel=responseDictionary[@"model"];
                // 存储用户相关信息
                if ( kFactoryType != userModel.factoryType) {
                    DLog(@"用户身份与本地不一致，以网络查询为准！");
                    [[NSUserDefaults standardUserDefaults] setInteger:userModel.factoryType forKey:@"factoryType"];
                    if ([[NSUserDefaults standardUserDefaults] synchronize] == YES) {
                        [Tools showSuccessWithStatus:@"用户身份储存成功！"];
                    }else {
                        [Tools showErrorWithStatus:@"用户身份储存失败，尝试重新登录！"];
                    }
                }else{
                    DLog(@"用户身份与本地一致！");
                    //                [Tools showSuccessWithStatus:@"用户身份一致！"];
                }

            }
        }];
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

#pragma mark - EAIntroView delegate

- (void)introDidFinish:(EAIntroView *)introView {
    DLog(@"introDidFinish callback");

    // 展示页面结束 加载登陆注册页面
    [ViewController goLogin];
}


- (void)showIntroWithCrossDissolve {
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"Hello world";
    page1.desc = sampleDescription1;
    page1.bgImage = [UIImage imageNamed:@"01"];
//    page1.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title1"]];

    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"This is page 2";
    page2.desc = sampleDescription2;
    page2.bgImage = [UIImage imageNamed:@"02"];
//    page2.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title2"]];

    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"This is page 3";
    page3.desc = sampleDescription3;
    page3.bgImage = [UIImage imageNamed:@"03"];
//    page3.titleIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title3"]];

    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"This is page 4";
    page4.desc = sampleDescription4;
    page4.bgImage = [UIImage imageNamed:@"04"];
//    page4.titleIconView = [[UIImageView bgalloc] initWithImage:[UIImage imageNamed:@"title4"]];

    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"This is page 5";
    page5.desc = sampleDescription4;
    page5.bgImage = [UIImage imageNamed:@"05"];
    //    page4.titleIconView = [[UIImageView bgalloc] initWithImage:[UIImage imageNamed:@"title4"]];


    EAIntroPage *page6 = [EAIntroPage page];
    page6.title = @"This is page 6";
    page6.desc = sampleDescription4;
    page6.bgImage = [UIImage imageNamed:@"06"];
    //    page4.titleIconView = [[UIImageView bgalloc] initWithImage:[UIImage imageNamed:@"title4"]];


    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4,page5,page6]];
    [intro setDelegate:self];
    [intro showInView:self.view animateDuration:0.1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
