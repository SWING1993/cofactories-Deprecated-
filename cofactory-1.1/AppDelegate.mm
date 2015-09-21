//
//  AppDelegate.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "AppDelegate.h"

#import "ZWIntroductionViewController.h"
#import "UMSocial.h"
#import "UMFeedback.h"
#import "UMessage.h"


#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000
#define  kNavTitleFontSize 18

@interface AppDelegate ()
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:kScreenBounds];
    self.window.backgroundColor = [UIColor whiteColor];

    if ([Kidentifier isEqualToString:@"com.cofactory.iosapp"]) {
        //个人开发者 关闭蒲公英
        DLog(@"个人开发者 关闭蒲公英");

        // 初始化百度地图 SDK
        _mapManager = [[BMKMapManager alloc] init];
        BOOL ret = [_mapManager start:appStoreMapApi  generalDelegate:nil];

        if (!ret) {
            DLog(@"百度地图SDK错误");
        }
        // 友盟分享
        [UMSocialData setAppKey:appStoreUMENGAppKey];
        //[UMSocialData openLog:YES];
        // 友盟用户反馈
        [UMFeedback setAppkey:appStoreUMENGAppKey];
        // 注册友盟统计 SDK
        [MobClick startWithAppkey:appStoreUMENGAppKey reportPolicy:BATCH channelId:nil];// 启动时发送 Log AppStore分发渠道
        [MobClick setAppVersion:kVersion_Coding];

        // 注册友盟推送服务 SDK
        //set AppKey and LaunchOptions
        [UMessage startWithAppkey:appStoreUMENGAppKey launchOptions:launchOptions];
        
    }else
    {
        //企业账号 开启蒲公英
        DLog(@"企业账号 开启蒲公英")
        //  关闭用户手势反馈，默认为开启。
        [[PgyManager sharedPgyManager] setEnableFeedback:NO];
        //  设置用户反馈界面的颜色，颜色会影响到Title以及工具栏的背景颜色和录音按钮的边框颜色，默认为黑色。
        [[PgyManager sharedPgyManager] setThemeColor:[UIColor colorWithHexString:@"0x28303b"]];
        //  启动SDK
        //  设置三指拖动激活摇一摇需在此调用之前
        
        [[PgyManager sharedPgyManager] startManagerWithAppId:PGY_APPKEY];

        // 初始化百度地图 SDK
        _mapManager = [[BMKMapManager alloc] init];
        BOOL ret = [_mapManager start:mapApi  generalDelegate:nil];

        if (!ret) {
            DLog(@"百度地图SDK错误");
        }
        // 友盟分享
        [UMSocialData setAppKey:UMENGAppKey];
        //[UMSocialData openLog:YES];
        // 友盟用户反馈
        [UMFeedback setAppkey:UMENGAppKey];
        // 注册友盟统计 SDK
        [MobClick startWithAppkey:UMENGAppKey reportPolicy:BATCH channelId:nil];// 启动时发送 Log AppStore分发渠道
        // Version 标识
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [MobClick setAppVersion:version];

        // 注册友盟推送服务 SDK
        //set AppKey and LaunchOptions
        [UMessage startWithAppkey:UMENGAppKey launchOptions:launchOptions];
    }


//    [UMessage setAutoAlert:NO];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序

        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;

        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];

        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];

    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else

    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];

#endif
    //for log
    [UMessage setLogEnabled:YES];


    //设置导航条样式

    [self customizeInterface];

    ViewController *mainVC = [[ViewController alloc] init];
    self.window.rootViewController = mainVC;


//    if ([Tools isTourist]) {
//        NSArray *coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
//        NSArray *backgroundImageNames = @[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
//        self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
//
//        NSArray *cofactoryImageNames = @[@"引导页1", @"引导页2", @"引导页3"];
//
//        self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:cofactoryImageNames backgroundImageNames:nil];
//        [self.window addSubview:self.introductionView.view];
//
//        __weak AppDelegate *weakSelf = self;
//        self.introductionView.didSelectedEnter = ^() {
//            [weakSelf.introductionView.view removeFromSuperview];
//            weakSelf.introductionView = nil;
//            // enter main view , write your code ...
//            ViewController *mainVC = [[ViewController alloc] init];
//            weakSelf.window.rootViewController = mainVC;
//        };
//    }else{
//        ViewController *mainVC = [[ViewController alloc] init];
//        self.window.rootViewController = mainVC;
//    }

    [_window makeKeyAndVisible];
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [HttpClient registerDeviceWithDeviceId:[NSString stringWithFormat:@"%@", deviceToken] andBlock:^(int statusCode) {
                DLog(@"deviceTokenStatus %d  deviceToken = %@", statusCode,deviceToken);
    }];
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
//    DLog(@"%@",userInfo);
    [UMessage setAutoAlert:NO];

    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        NSDictionary*aps = userInfo[@"aps"];
        NSString*message = aps[@"alert"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"通知消息"
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];

        [alertView show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [BMKMapView didForeGround];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)customizeInterface {
    //设置Nav的背景色和title色
    
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    [navigationBarAppearance setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTintColor:[UIColor whiteColor]];//返回按钮的箭头颜色
    NSDictionary *textAttributes = @{
                                     NSFontAttributeName: [UIFont boldSystemFontOfSize:kNavTitleFontSize],
                                     NSForegroundColorAttributeName: [UIColor whiteColor],
                                     };
    [navigationBarAppearance setTitleTextAttributes:textAttributes];

    [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextField的光标颜色
    [[UITextView appearance] setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];//设置UITextView的光标颜色
//    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:kColorTableSectionBg] forBarPosition:0 barMetrics:UIBarMetricsDefault];
}

//禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
