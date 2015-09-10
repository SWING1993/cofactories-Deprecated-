//
//  HomeViewController.m
//  聚工厂
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "HomeViewsHeader.h"
#import "HomeViewController.h"
#import "ActivityCell.h"
#import "FindFactoryCell.h"
#import "FindOrderCell.h"


//编辑View
//#import "HomeEditViewController.h"

#define kStatusBarHeight 20
#define kNavigationBarHeight 44
//#define kBannerHeight 150
#define kButtonViewHeight 74
#define kBannerHeight kScreenW*0.535
#define kMargin [[UIScreen mainScreen] bounds].size.width / 375


#define kRowInset 5
#define CellIdentifier @"Cell"
#define FooterCellIdentifier @"FooterCell"
#define ActivityCellIdentifier @"ActivityCell"
#define FactoryCellIdentifier @"FactoryCell"
#define OrderCellIdentifier @"OrderCell"
@interface HomeViewController () <UIAlertViewDelegate>

@property (nonatomic, strong) HomeItemModel *homeItemModel;

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

@implementation HomeViewController
- (void)viewWillAppear:(BOOL)animated {
    
    //工厂空闲忙碌状态
    [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {
        
        UserModel*userModel=responseDictionary[@"model"];
        DLog(@"%@",userModel);
        self.factoryFreeStatus=userModel.factoryFreeStatus;
        self.hasTruck=userModel.hasTruck;
        self.factoryFreeTime=userModel.factoryFreeTime;
        DLog(@"刷新工厂=%@  自备货车%d  空闲时间%@",userModel.factoryFreeStatus,self.hasTruck,self.factoryFreeTime);
    }];
    
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    DLog(@"游客=%d",[Tools isTourist]);
    DLog(@"%@",Kidentifier);
    
    if ([Kidentifier isEqualToString:@"com.cofactory.iosapp"]) {
        //个人开发者 关闭检测更新
        DLog(@"个人开发者 关闭检测更新");
    }else
    {
        //企业账号 开启检测更新
        DLog(@"企业账号 开启检测更新")
        [[PgyManager sharedPgyManager] checkUpdate];
    }
    
    //抽奖
    [HttpClient drawAccessWithBlock:^(int statusCode) {
        DLog(@"%d",statusCode);
        if (statusCode==200) {
            UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"您已达到抽奖资格，您想要抽奖吗" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag=100;
            [alertView show];
        }
    }];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // 初始化模型
    self.homeItemModel = [[HomeItemModel alloc] init];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kScreenW, kScreenH-(kNavigationBarHeight+kStatusBarHeight)) style:UITableViewStyleGrouped];
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
    self.tableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示
    
    //网络获取itemArray
//    [HttpClient listMenuWithBlock:^(NSDictionary *responseDictionary) {
//        NSArray*arr=responseDictionary[@"responseArray"];
//        if (arr.count==0) {
//            [self getListMenu];
//        }
//        for (int i=0; i<arr.count; i++) {
//            NSInteger x = [arr[i] integerValue];
//            [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[x]];
//            [self.tableView reloadData];
//        }
//    }];
    
    // 表头视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight + kButtonViewHeight)];
    PageView *bannerView = [[PageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight) andImageArray:nil];
    [headerView addSubview:bannerView];
    
    //工厂类型
    [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {
        UserModel*userModel=responseDictionary[@"model"];
        
        // 存储用户相关信息
        NSNumber *MyUid = [NSNumber numberWithInt:userModel.uid];
        [[NSUserDefaults standardUserDefaults] setObject:MyUid forKey:@"selfuid"];
        [[NSUserDefaults standardUserDefaults] setObject:userModel.factoryName forKey:@"factoryName"];
        [[NSUserDefaults standardUserDefaults] setObject:userModel.factoryAddress forKey:@"factoryAddress"];
        [[NSUserDefaults standardUserDefaults] setObject:userModel.factorySize forKey:@"factorySize"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        self.factoryFreeStatus=userModel.factoryFreeStatus;
        self.factoryType =userModel.factoryType;
        if (self.factoryType==0) {
            ButtonView*buttonView = [[ButtonView alloc]initWithFrame:CGRectMake(0, kBannerHeight, kScreenW, kButtonViewHeight) withString:@"发布订单"];
            [headerView addSubview:buttonView];
            [buttonView.pushHelperButton addTarget:self action:@selector(pushClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buttonView.findCooperationButton addTarget:self action:@selector(findClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buttonView.postButton addTarget:self action:@selector(postClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buttonView.authenticationButton addTarget:self action:@selector(statusClicked:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            ButtonView*buttonView = [[ButtonView alloc]initWithFrame:CGRectMake(0, kBannerHeight, kScreenW, kButtonViewHeight) withString:@"设置状态"];
            [headerView addSubview:buttonView];
            [buttonView.pushHelperButton addTarget:self action:@selector(pushClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buttonView.findCooperationButton addTarget:self action:@selector(findClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buttonView.postButton addTarget:self action:@selector(authClicked:) forControlEvents:UIControlEventTouchUpInside];
            [buttonView.authenticationButton addTarget:self action:@selector(statusClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }];
    self.tableView.tableHeaderView = headerView;
    
    //注册cell
    [self.tableView registerClass:[ActivityCell class] forCellReuseIdentifier:ActivityCellIdentifier];
    [self.tableView registerClass:[FindFactoryCell class] forCellReuseIdentifier:FactoryCellIdentifier];
    [self.tableView registerClass:[FindOrderCell class] forCellReuseIdentifier:OrderCellIdentifier];
}



- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        if (alertView.tag==100) {
            WebViewController*webVC = [[WebViewController alloc]init];
            UINavigationController*webNav=[[UINavigationController alloc]initWithRootViewController:webVC];
            webNav.navigationBar.barStyle=UIBarStyleBlack;
            [self presentViewController:webNav animated:YES completion:nil];
        }if (alertView.tag==5) {
            [ViewController goLogin];
        }
    }
}

- (void)pushClicked:(id)sender {
    if ([Tools isTourist]) {
        //游客
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"请您登录后才使用这项服务,是否登录？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=5;
        [alertView show];
    }else{
        PushViewController*pushHelerVC = [[PushViewController alloc]init];
        pushHelerVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:pushHelerVC animated:YES];
    }
}
- (void)findClicked:(id)sender {
    FactoryListViewController *factoryListVC= [[FactoryListViewController alloc]init];
    factoryListVC.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
    //    factoryListVC.factoryType = 10;
    [self.navigationController pushViewController:factoryListVC animated:YES];
}
- (void)postClicked:(id)sender {
    if ([Tools isTourist]) {
        //游客
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"请您登录后才使用这项服务,是否登录？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=5;
        
        [alertView show];
    }else{
        PushOrderViewController*pushOrderVC = [[PushOrderViewController alloc]init];
        pushOrderVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:pushOrderVC animated:YES];
    }
}

- (void)authClicked:(id)sender {
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
- (void)statusClicked:(id)sender {
    UIButton*button = (UIButton *)sender;
    [button setUserInteractionEnabled:NO];
    
    if ([Tools isTourist]) {
        //游客
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"请您登录后才使用认证服务,是否登录？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=5;
        [alertView show];
        [button setUserInteractionEnabled:YES];
        
    }else{
        //认证信息
        [HttpClient getVeifyInfoWithBlock:^(NSDictionary *dictionary) {
            NSDictionary*VeifyDic=dictionary[@"responseDictionary"];
            self.status = [VeifyDic[@"status"] intValue];
            DLog(@"认证状态%d", self.status);
            [button setUserInteractionEnabled:YES];
            
            //未认证
            if ( self.status==0) {
                VeifyViewController*veifyVC = [[VeifyViewController alloc]init];
                veifyVC.hidesBottomBarWhenPushed=YES;
                veifyVC.title=@"未认证";
                [self.navigationController pushViewController:veifyVC animated:YES];
            }
            //认证中
            if ( self.status==1) {
                VeifyingViewController*veifyingVC = [[VeifyingViewController alloc]init];
                veifyingVC.hidesBottomBarWhenPushed=YES;
                veifyingVC.VeifyDic=VeifyDic;
                veifyingVC.title=@"认证资料已提交";
                [self.navigationController pushViewController:veifyingVC animated:YES];
            }
            //认证成功
            if ( self.status==2) {
                VeifyEndViewController*endVC = [[VeifyEndViewController alloc]init];
                endVC.hidesBottomBarWhenPushed=YES;
                endVC.title=@"认证成功";
                [self.navigationController pushViewController:endVC animated:YES];
            }
        }];
    }
}

- (void)findFactory:(UIButton *)button {
    switch (button.tag) {
        case 1000:
        {
            // 找服装厂信息
            FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
            searchViewController.factoryType = 100;
            searchViewController.currentData1Index = 1;
            searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:searchViewController animated:YES];
        }
            break;
        case 1001:
        {
            // 找锁眼钉扣厂信息
            FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
            searchViewController.factoryType = 3;
            searchViewController.currentData1Index = 3;
            searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:searchViewController animated:YES];
        }
            break;
        case 1002:
        {
            // 找加工厂信息
            FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
            searchViewController.factoryType = 1;
            searchViewController.currentData1Index = 2;
            searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:searchViewController animated:YES];
        }

            break;
        case 1003:
        {
            // 找代裁厂信息
           
            
            FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
            
            searchViewController.factoryType = 2;
            searchViewController.currentData1Index = 4;
            searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:searchViewController animated:YES];
        }

            break;
        case 1004:
        {
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
            //找服装厂外发锁眼钉扣订单
            
            searchOrderListVC *orderDetailViewController =[[searchOrderListVC alloc] init];
            orderDetailViewController.orderListType = 3;
            orderDetailViewController.title = @"外发锁眼钉扣";
            orderDetailViewController.userType = self.factoryType;
            orderDetailViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
            [self.navigationController pushViewController:orderDetailViewController animated:YES];
        }
            
            break;
            
                default:
            break;
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:ActivityCellIdentifier forIndexPath:indexPath];
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
    } else {
        FindOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:OrderCellIdentifier forIndexPath:indexPath];
        
        [cell.fastenerButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.fastenerButton.tag = 1004;
        [cell.machineButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.machineButton.tag = 1005;
        [cell.cutButton addTarget:self action:@selector(findFactory:) forControlEvents:UIControlEventTouchUpInside];
        cell.cutButton.tag = 1006;

        return cell;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 38 *kMargin;
    } else if (indexPath.section == 1) {
        return 3*kScreenW / 7;
    } else {
        return kScreenW / 3;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kRowInset;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 0.5)];
    
    return view;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kRowInset)];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        // 各类营销活动
        NSString*accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"];
        ActivityViewController *webViewController = [[ActivityViewController alloc] init];
        webViewController.url = [NSString stringWithFormat:@"http://app2.cofactories.com/activity/draw.html#%@",accessToken ];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
    }
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
