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

#define kBannerHeight kScreenW*0.535
#define kStatusBarHeight 20
#define kNavigationBarHeight 44
#define CellIdentifier @"Cell"



#import "AppDelegate.h"

/*!
 Category
 */
#import "UIBarButtonItem+Common.h"
#import "UIColor+Expanded.h"
#import "UIImage+Common.h"
#import "UIImageView+Common.h"


/*!
 Utils
 */
#import "HttpClient.h"
#import "Tools.h"
#import "MobClick.h"
#import "MBProgressHUD.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "JSDropDownMenu.h"//筛选
#import "ODRefreshControl.h"//下拉刷新
#import "IQKeyboardManager.h"


/*!
 Controller
 */
#import "ViewController.h"
#import "LoginViewController.h"//登录
#import "RegisterViewController.h"//注册
#import "ResetPasswordViewController.h" //找回密码
#import "TouristViewController.h" //游客身份

#import "HomeViewController.h"//HomeVC
#import "HomeEditViewController.h"//主页编辑

//推送助手
#import "PushViewController.h"

//找合作商
#import "FactoryListViewController.h"

//发布订单
#import "PushOrderViewController.h"//推送订单
#import "AddOrderViewController.h"//发布订单
#import "searchOrderListVC.h"//搜索订单
//设置状态
#import "StatusViewController.h"
//订单详情
#import "OrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "OrderDetailViewController.h"

//认证服务
#import "VeifyViewController.h"//认证
#import "VeifyingViewController.h"//认证中
#import "VeifyEndViewController.h"//认证成功
#import "ActivityViewController.h"//营销活动
#import "WebViewController.h"//抽奖

//合作商详情页
#import "CooperationViewController.h"
#import "CooperationInfoViewController.h"

//消息
#import "MessageViewController.h"

//我
#import "MeViewController.h"
#import "SetViewController.h" //设置VC
#import "RevisePasswordViewController.h"//修改密码
#import "AboutViewController.h"//关于
#import "ModifyNameViewController.h"//设置name
#import "ModifyJobViewController.h"//设置job
#import "SetaddressViewController.h"//工厂位置
#import "ModifyFactoryNameViewController.h"//工厂名称
#import "SetMapViewController.h"//地图
#import "ModifySizeViewController.h"//公司规模
#import "ModifyServiceRangeViewController.h"//公司业务类型
#import "PhotoViewController.h"//公司相册
#import "UploadImageViewController.h"//上传图片
#import "FavoriteViewController.h"//我的收藏
#import "DescriptionViewController.h"//公司简介

