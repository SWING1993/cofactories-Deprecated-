//
//  Header.h
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

//ios系统版本
#define ios8x [[[UIDevice currentDevice] systemVersion] floatValue] >=8.0f
#define ios7x ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)
#define ios6x [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f
#define iosNot6x [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f

#define kStatusBarHeight 20

#define kNavigationBarHeight 44

#define iphone4x_3_5 ([UIScreen mainScreen].bounds.size.height==480.0f)

#define iphone5x_4_0 ([UIScreen mainScreen].bounds.size.height==568.0f)

#define iphone6_4_7 ([UIScreen mainScreen].bounds.size.height==667.0f)

#define iphone6Plus_5_5 ([UIScreen mainScreen].bounds.size.height==736.0f || [UIScreen mainScreen].bounds.size.height==414.0f)

//屏幕宽高
#define kScreenW [[UIScreen mainScreen] bounds].size.width
#define kScreenH [[UIScreen mainScreen] bounds].size.height

//屏幕frame,bounds,size
#define kScreenFrame [UIScreen mainScreen].bounds
#define kScreenBounds [UIScreen mainScreen].bounds
#define kScreenSize [UIScreen mainScreen].bounds.size

#define kBannerHeight 180
#define kStatusBarHeight 20
#define kNavigationBarHeight 44
#define CellIdentifier @"Cell"

#import "HttpClient.h"

#import "Tools.h"

#import "MobClick.h"

#import "UMessage.h"

#import "MBProgressHUD.h"

#import "UIButton+WebCache.h"

#import "UIImageView+WebCache.h"

//#import "UMFeedback.h"

#import "AppDelegate.h"
#import "ViewController.h"


//HomeVC
#import "HomeViewController.h"
#import "HomeEditViewController.h"//主页编辑
#import "PushHelperViewController.h"//推送助手
#import "StatusViewController.h"//设置状态
#import "SearchViewController.h"//找合作商
#import "SetaddressViewController.h"//设置位置
#import "ModifyFactoryNameViewController.h"//设置工厂名称




//合作商
#import "CooperationViewController.h"
#import "CooperationInfoViewController.h"//合作商详情页


//MeVC
#import "MeViewController.h"
#import "SetViewController.h" //设置VC
#import "RevisePasswordViewController.h"//修改密码
#import "AboutViewController.h"//关于
#import "ModifyNameViewController.h"//设置name
#import "ModifyJobViewController.h"//设置job
#import "SetaddressViewController.h"//工厂位置
#import "SetMapViewController.h"//map
#import "ModifySizeViewController.h"//修改公司size
#import "ModifyServiceRangeViewController.h"//修改公司业务类型
#import "PhotoViewController.h"//公司相册
#import "UploadImageViewController.h"//上传图片
#import "FavoriteViewController.h"//我的收藏
#import "DescriptionViewController.h"//公司简介






#import "MessageViewController.h"


//登录注册VC
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ResetPasswordViewController.h" //找回密码




