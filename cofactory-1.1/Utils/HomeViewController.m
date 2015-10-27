//
//  HomeViewController.m
//  聚工厂
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "HomeViewController.h"
#import "ActivityCell.h"
#import "FindFactoryCell.h"
#import "FindOrderCell.h"
#import "LastmachineCell.h"
#import "SearchFactoryOrderVC.h"
#import "PopularMesageViewController.h"
#import "PurchaseVC.h"
#import "ActivityViewController.h"
#import "ProviderViewController.h"
#import "IMChatListViewController.h"

//面辅料 供应
#import "SupplyViewController.h"

#define kButtonViewHeight 74
#define kBannerHeight kScreenW*0.535
#define kMargin [[UIScreen mainScreen] bounds].size.width / 375

static NSString *ActivityCellIdentifier = @"ActivityCell";
static NSString *FactoryCellIdentifier = @"FactoryCell";
static NSString *OrderCellIdentifier = @"OrderCell";
static NSString *LastCellIdentifier = @"LastCell";

@interface HomeViewController () <UIAlertViewDelegate> 

//记录工厂类型
@property (nonatomic, assign) int factoryType;

//记录认证状态
@property (nonatomic, assign) int status;

//记录空闲忙碌
@property (nonatomic, copy) NSString* factoryFreeStatus;

//记录自备货车
@property (nonatomic, assign) int hasTruck;

//记录空闲时间
@property (nonatomic, copy) NSString* factoryFreeTime;


- (void)pushClicked:(id)sender;
- (void)findClicked:(id)sender;
- (void)postClicked:(id)sender;
- (void)statusClicked:(id)sender;
- (void)authClicked:(id)sender;

@end

@implementation HomeViewController {
    UIView *headerView;
}
- (void)viewWillAppear:(BOOL)animated {
    //设置代理（融云）
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    
    //工厂类型
    [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [responseDictionary[@"statusCode"]integerValue];
        DLog(@"getUserProfile状态码 == %ld",(long)statusCode);
        if (statusCode == 200) {
            UserModel*userModel=responseDictionary[@"model"];
            [super viewWillAppear:animated];
            
            self.factoryFreeStatus=userModel.factoryFreeStatus;
            self.hasTruck=userModel.hasTruck;
            self.factoryFreeTime=userModel.factoryFreeTime;
            //self.factoryType =userModel.factoryType;
            
            DLog(@"刷新工厂=%@  自备货车%d  空闲时间%@",userModel.factoryFreeStatus,self.hasTruck,self.factoryFreeTime);
            
            // 存储用户相关信息
            NSNumber *MyUid = [NSNumber numberWithInt:userModel.uid];
            [[NSUserDefaults standardUserDefaults] setObject:MyUid forKey:@"selfuid"];
            [[NSUserDefaults standardUserDefaults] setObject:@(userModel.factoryType) forKey:@"factoryType"];

            [[NSUserDefaults standardUserDefaults] setObject:userModel.factoryName forKey:@"factoryName"];
            [[NSUserDefaults standardUserDefaults] setObject:userModel.factoryAddress forKey:@"factoryAddress"];
            [[NSUserDefaults standardUserDefaults] setObject:userModel.factorySize forKey:@"factorySize"];
            [[NSUserDefaults standardUserDefaults] setObject:userModel.phone forKey:@"factoryPhone"];
            [[NSUserDefaults standardUserDefaults] setObject:userModel.name forKey:@"userName"];            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.tableView reloadData];
        }
        
        if (statusCode == 401 || statusCode == 404) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"您的登录信息已过期，请重新登录！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 401;
            [alertView show];
        }
    }];
    
    
}




#pragma mark - RCIMUserInfoDataSource

//获取IM用户信息
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion{
    
    //解析工厂信息
    [HttpClient getUserProfileWithUid:[userId intValue] andBlock:^(NSDictionary *responseDictionary) {
        FactoryModel *userModel = (FactoryModel *)responseDictionary[@"model"];
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (intm 64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = userId;
        user.name = userModel.factoryName;
        user.portraitUri = [NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI,userId];
        return completion(user);
        //        });
        
    }];
    
}



- (void)bannerViewClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    DLog(@"%zi",button.tag);
    switch (button.tag) {
        case 0:
        {
            [MobClick event:@"news"];
            PopularMesageViewController *vc = [[PopularMesageViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 1:
        {
            if (self.factoryType == 5) {
                [MobClick event:@"materials_2"];
                
                ProviderViewController*supplyVC = [[ProviderViewController alloc]init];
                supplyVC.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
                backItem.title=@"返回";
                self.navigationItem.backBarButtonItem = backItem;
                [self.navigationController pushViewController:supplyVC animated:YES];
            }else{
                [MobClick event:@"materials_buys"];

                PurchaseVC *VC =[PurchaseVC new];
                VC.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
                backItem.title=@"返回";
                backItem.tintColor=[UIColor whiteColor];
                self.navigationItem.backBarButtonItem = backItem;
                self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
            break;
            
        case 2:
        {
            if (self.factoryType == 1) {
                [MobClick event:@"order"];

                PushOrderViewController*pushOrderVC = [[PushOrderViewController alloc]init];
                pushOrderVC.factoryType = self.factoryType;
                pushOrderVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:pushOrderVC animated:YES];
                
            }else{
                [MobClick event:@"jgc_out_order"];

                SearchFactoryOrderVC *vc = [[SearchFactoryOrderVC alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case 3:
        {
            ActivityViewController *vc = [[ActivityViewController alloc]init];
            vc.url = @"http://activity.cofactories.com/";
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self goUpdata];

    //获取融云的token
    [HttpClient getIMTokenWithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [responseDictionary[@"statusCode"]integerValue];
        DLog(@"融云====%ld", (long)statusCode);
        NSString *token = responseDictionary[@"IMToken"];
        DLog(@"融云token====%@", token);
        
        // 快速集成第二步，连接融云服务器
        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
            // Connect 成功
            DLog(@" Connect 成功");
        }
                                      error:^(RCConnectErrorCode status) {
                                          // Connect 失败
                                          DLog(@" Connect 失败")
                                      }
                             tokenIncorrect:^() {
                                 // Token 失效的状态处理
                             }];
        
    }];

    
    self.view.backgroundColor=[UIColor whiteColor];

    //工厂类型
    NSNumber * factoryTypeNumber = [[NSNumber alloc]initWithInteger:kFactoryType];
    self.factoryType = [factoryTypeNumber intValue];
    
    
    // 初始化模型
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kScreenW, kScreenH-(kNavigationBarHeight+kStatusBarHeight)) style:UITableViewStyleGrouped];
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
    self.tableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示
    
    // 表头视图
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight + kButtonViewHeight)];
    NSArray *imageArray = @[@"服装平台.png",@"面辅料.png",@"新功能.png", @"活动策划bbbb.png"];
    PageView *bannerView = [[PageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight) andImageArray:imageArray pageCount:4 isNetWork:YES];
    [bannerView.imageButton1 addTarget:self action:@selector(bannerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [bannerView.imageButton2 addTarget:self action:@selector(bannerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [bannerView.imageButton3 addTarget:self action:@selector(bannerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [bannerView.imageButton4 addTarget:self action:@selector(bannerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:bannerView];
    
    if (self.factoryType==0) {
        ButtonView*buttonView = [[ButtonView alloc]initWithFrame:CGRectMake(0, kBannerHeight, kScreenW, kButtonViewHeight) withString:@"订单管理"];
        [headerView addSubview:buttonView];
        [buttonView.pushHelperButton addTarget:self action:@selector(pushClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView.findCooperationButton addTarget:self action:@selector(findClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView.postButton addTarget:self action:@selector(postClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView.authenticationButton addTarget:self action:@selector(statusClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.factoryType==1 || self.factoryType==2 || self.factoryType== 3) {
        
        ButtonView*buttonView = [[ButtonView alloc]initWithFrame:CGRectMake(0, kBannerHeight, kScreenW, kButtonViewHeight) withString:@"设置状态"];
        [headerView addSubview:buttonView];
        [buttonView.pushHelperButton addTarget:self action:@selector(pushClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView.findCooperationButton addTarget:self action:@selector(findClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView.postButton addTarget:self action:@selector(authClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView.authenticationButton addTarget:self action:@selector(statusClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (self.factoryType==5) {
        ButtonView*buttonView = [[ButtonView alloc]initWithFrame:CGRectMake(0, kBannerHeight, kScreenW, kButtonViewHeight) withString:@"产品供应"];
        [headerView addSubview:buttonView];
        [buttonView.pushHelperButton addTarget:self action:@selector(pushClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView.findCooperationButton addTarget:self action:@selector(findClicked:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView.postButton addTarget:self action:@selector(pushSupply:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView.authenticationButton addTarget:self action:@selector(statusClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.tableView.tableHeaderView = headerView;
    
    //注册cell
    [self.tableView registerClass:[ActivityCell class] forCellReuseIdentifier:ActivityCellIdentifier];
    [self.tableView registerClass:[FindFactoryCell class] forCellReuseIdentifier:FactoryCellIdentifier];
    [self.tableView registerClass:[FindOrderCell class] forCellReuseIdentifier:OrderCellIdentifier];
    [self.tableView registerClass:[LastmachineCell class] forCellReuseIdentifier:LastCellIdentifier];
    
}

#pragma mark - 抽奖 检测更新

/*
- (void)goUpdata {
    DLog(@"%@",Kidentifier);
    if ([Kidentifier isEqualToString:@"com.cofactory.iosapp"]) {
        //个人开发者
        [HttpClient upDataWithBlock:^(NSDictionary *upDateDictionary) {
            NSInteger  statusCode = [upDateDictionary[@"statusCode"] integerValue];
            if (statusCode == 200) {
                double latestVersion = [upDateDictionary[@"latestVersion"] doubleValue];
                DLog(@"appStore最新版本号：%@",upDateDictionary[@"latestVersion"]);
                if (latestVersion > [kVersion_Cofactories doubleValue]) {
                    DLog(@"发现新版本")
                    NSString * releaseNotes = upDateDictionary[@"releaseNotes"];
                    UIAlertView * upDataAlertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"发现新版本%.2f！",latestVersion] message:releaseNotes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去更新", nil];
                    upDataAlertView.tag = 200;
                    [upDataAlertView show];

                }
            }
        }];
    }else
    {
        //企业账号
        //DLog(@"企业账号 开启检测更新")
    }
}
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag==100) {
        if (buttonIndex==1) {
            WebViewController*webVC = [[WebViewController alloc]init];
            UINavigationController*webNav=[[UINavigationController alloc]initWithRootViewController:webVC];
            webNav.navigationBar.barStyle=UIBarStyleBlack;
            [self presentViewController:webNav animated:YES completion:nil];
        }
    }
    if (alertView.tag == 200) {
        if (buttonIndex == 1) {
            NSString *str = kAppUrl;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
    if (alertView.tag == 401) {
        [ViewController goLogin];
    }
}



#pragma mark - buttonView 点击事件

#pragma mark - 流行资讯
- (void)pushClicked:(id)sender {
    
    [MobClick event:@"news"];
    
    PopularMesageViewController *vc = [[PopularMesageViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 找合作商
- (void)findClicked:(id)sender {
   
    [MobClick event:@"find"];
    FactoryListViewController *factoryListVC= [[FactoryListViewController alloc]init];
    factoryListVC.selectedFactoryIndex = 0;
    factoryListVC.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
    [self.navigationController pushViewController:factoryListVC animated:YES];
}

#pragma mark - 面辅料供应
- (void)pushSupply:(id)sender {
    
    [MobClick event:@"materials_1"];

    ProviderViewController*supplyVC = [[ProviderViewController alloc]init];
    supplyVC.hidesBottomBarWhenPushed = YES;
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:supplyVC animated:YES];
}

#pragma mark - 发布订单
- (void)postClicked:(id)sender {
    
    [MobClick event:@"order"];
    PushOrderViewController*pushOrderVC = [[PushOrderViewController alloc]init];
    pushOrderVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pushOrderVC animated:YES];
}

#pragma mark - 设置状态
- (void)authClicked:(id)sender {
    
    [MobClick event:@"config"];

    if (self.factoryType==1) {
        StatusViewController*statusVC = [[StatusViewController alloc]init];
        statusVC.factoryFreeTime=self.factoryFreeTime;
        statusVC.factoryType=self.factoryType;
        statusVC.hasTruck=self.hasTruck;
        statusVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:statusVC animated:YES];
    }else{
        StatusViewController*statusVC = [[StatusViewController alloc]init];
        statusVC.factoryFreeStatus=self.factoryFreeStatus;
        statusVC.factoryType=self.factoryType;
        statusVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:statusVC animated:YES];
    }
}

#pragma mark - 认证服务
- (void)statusClicked:(id)sender {
    
    UIButton*button = (UIButton *)sender;
    [button setUserInteractionEnabled:NO];
    [MobClick event:@"verify"];

    //认证信息
    [HttpClient getVeifyInfoWithBlock:^(NSDictionary *dictionary) {
        NSDictionary*VeifyDic=dictionary[@"responseDictionary"];
        self.status = [VeifyDic[@"status"] intValue];
        DLog(@"认证状态%d", self.status);
        [button setUserInteractionEnabled:YES];
        
        //未认证
        if ( self.status==0) {
            [MobClick event:@"verify"];
            VeifyViewController*veifyVC = [[VeifyViewController alloc]init];
            veifyVC.hidesBottomBarWhenPushed=YES;
            veifyVC.title=@"未认证";
            [self.navigationController pushViewController:veifyVC animated:YES];
        }
        //认证中
        if ( self.status==1) {
            [MobClick event:@"verify"];
            VeifyingViewController*veifyingVC = [[VeifyingViewController alloc]init];
            veifyingVC.hidesBottomBarWhenPushed=YES;
            veifyingVC.VeifyDic=VeifyDic;
            veifyingVC.title=@"认证资料已提交";
            [self.navigationController pushViewController:veifyingVC animated:YES];
        }
        //认证成功
        if ( self.status==2) {
            [MobClick event:@"verify"];
            VeifyEndViewController*endVC = [[VeifyEndViewController alloc]init];
            endVC.hidesBottomBarWhenPushed=YES;
            endVC.title=@"认证成功";
            [self.navigationController pushViewController:endVC animated:YES];
        }
    }];
}


- (void)findFactory:(UIButton *)button {
    switch (button.tag) {
        case 1000:
        {
            [MobClick event:@"fzc"];
            // 找服装厂信息
            FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
            searchViewController.selectedFactoryIndex = 100;
            searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:searchViewController animated:YES];
        }
            break;
        case 1001:
        {
            [MobClick event:@"sydk"];
            // 找锁眼钉扣厂信息
            FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
            searchViewController.selectedFactoryIndex = 3;
            searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:searchViewController animated:YES];
        }
            break;
        case 1002:
        {
            [MobClick event:@"jgc"];
            // 找加工厂信息
            FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
            searchViewController.selectedFactoryIndex = 1;

            searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:searchViewController animated:YES];
        }
            
            break;
        case 1003:
        {
            [MobClick event:@"dcc"];
            // 找代裁厂信息
            FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
            searchViewController.selectedFactoryIndex = 2;
            searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:searchViewController animated:YES];
        }
            
            break;
        case 1004:
        {
            [MobClick event:@"fzc_order"];

            // 找服装厂外发加工订单
            searchOrderListVC *orderDetailViewController =[[searchOrderListVC alloc]init];
            orderDetailViewController.orderListType = 1;
            orderDetailViewController.title = @"外发加工";
            orderDetailViewController.userType = self.factoryType;
            orderDetailViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:orderDetailViewController animated:YES];
        }
            
            break;
        case 1005:
        {
            [MobClick event:@"dcc_order"];

            // 找服装厂外发代裁订单
            
            searchOrderListVC *orderDetailViewController =[[searchOrderListVC alloc] init];
            orderDetailViewController.orderListType = 2;
            orderDetailViewController.title = @"外发代裁";
            orderDetailViewController.userType = self.factoryType;
            orderDetailViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:orderDetailViewController animated:YES];
        }
            
            break;
        case 1006:
        {
            [MobClick event:@"sydk_order"];

            //找服装厂外发锁眼钉扣订单
            
            searchOrderListVC *orderDetailViewController =[[searchOrderListVC alloc] init];
            orderDetailViewController.orderListType = 3;
            orderDetailViewController.title = @"外发锁眼钉扣";
            orderDetailViewController.userType = self.factoryType;
            orderDetailViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:orderDetailViewController animated:YES];
        }
            
            break;
        case 1007:
        {

            [MobClick event:@"materials_2"];

            //我想供应
            if (self.factoryType == 5) {
                ProviderViewController *providerVC = [[ProviderViewController alloc] init];
                providerVC.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
                backItem.title=@"返回";
                self.navigationItem.backBarButtonItem = backItem;
                [self.navigationController pushViewController:providerVC animated:YES];
                
            }else{
                [Tools showShimmeringString:@"面辅料专区，非面辅料请至首页上方发布订单！"];
            }
            
            DLog(@"我想供应");
            
        }
            break;
        case 1008:
        {
            [MobClick event:@"materials_buys"];

            if (self.factoryType == 5) {
                [Tools showShimmeringString:@"采购商专区，供应商请发布供应！"];
            }else{
                //我想采购
                PurchaseVC *VC =[PurchaseVC new];
                VC.hidesBottomBarWhenPushed = YES;
                UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
                backItem.title=@"返回";
                backItem.tintColor=[UIColor whiteColor];
                self.navigationItem.backBarButtonItem = backItem;
                self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                [self.navigationController pushViewController:VC animated:YES];
                
            }
        }
            break;
        case 1009:
        {
            [MobClick event:@"jgc_out_order"];
            //加工厂订单外发
            if (self.factoryType == 1) {
                //加工厂订单外发
                PushOrderViewController*pushOrderVC = [[PushOrderViewController alloc]init];
                pushOrderVC.factoryType = self.factoryType;
                pushOrderVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:pushOrderVC animated:YES];
                
            }else{
                [Tools showShimmeringString:@"加工厂专区，非加工厂请至首页上方发布订单！"];
            }
            
            DLog(@"加工厂订单外发");
        }
            break;
        case 1010:
        {
            [MobClick event:@"find_jgc_other"];
            //寻找加工厂订单
            SearchFactoryOrderVC *vc = [[SearchFactoryOrderVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
            
        default:
            break;
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1){
        FindFactoryCell *cell = [tableView dequeueReusableCellWithIdentifier:FactoryCellIdentifier forIndexPath:indexPath];
        [cell.clothingButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.clothingButton.tag = 1000;
        [cell.fastenerButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.fastenerButton.tag = 1001;
        [cell.machineButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.machineButton.tag = 1002;
        [cell.cutButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.cutButton.tag = 1003;
        return cell;
    } else if (indexPath.section == 2){
        FindOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCellIdentifier forIndexPath:indexPath];
        
        [cell.fastenerButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.fastenerButton.tag = 1004;
        [cell.machineButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.machineButton.tag = 1005;
        [cell.cutButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.cutButton.tag = 1006;
        
        return cell;
    } else if(indexPath.section == 3){
        LastmachineCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCellIdentifier forIndexPath:indexPath];
        cell.leftButton.layer.borderWidth = 0.3;
        cell.leftButton.layer.borderColor = [UIColor grayColor].CGColor;
        [cell.leftButton setImage:[UIImage imageNamed:@"面辅料供应"] forState:UIControlStateNormal];
        [cell.leftButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.leftButton.tag = 1007;
        [cell.rightButton setImage:[UIImage imageNamed:@"面辅料采购"] forState:UIControlStateNormal];
        [cell.rightButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.rightButton.tag = 1008;
        return cell;
    } else {
        LastmachineCell *cell = [tableView dequeueReusableCellWithIdentifier:LastCellIdentifier forIndexPath:indexPath];
        cell.leftButton.layer.borderWidth = 0.3;
        cell.leftButton.layer.borderColor = [UIColor grayColor].CGColor;
        [cell.leftButton setImage:[UIImage imageNamed:@"加工厂订单外发"] forState:UIControlStateNormal];
        [cell.leftButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.leftButton.tag = 1009;
        [cell.rightButton setImage:[UIImage imageNamed:@"寻找加工厂订单"] forState:UIControlStateNormal];
        [cell.rightButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.rightButton.tag = 1010;
        return cell;
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 38 *kMargin;
    } else if (indexPath.section == 1) {
        return 3*kScreenW / 7;
    } else if (indexPath.section == 2) {
        return kScreenW / 3;
    } else {
        return kScreenW / 3 - 0.09*kScreenW;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else if (section == 3 || section == 4) {
        return 0.09*kScreenW;
    }
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW / 3)];
        photoView.image = [UIImage imageNamed:@"面辅料专区"];
        return photoView;
    } else if (section == 4) {
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW / 3)];
        photoView.image = [UIImage imageNamed:@"加工厂专区"];
        return photoView;
    } else {
        CGSize size = [[UIScreen mainScreen] bounds].size;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 0.5)];
        return view;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    DLog(@"释放内存");
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}



@end
