//
//  HomeViewController.m
//  聚工厂
//
//  Created by Mr.song on 15/7/9.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "ModelsHeader.h"
#import "HomeViewsHeader.h"
#import "HomeViewController.h"

//编辑View
#import "HomeEditViewController.h"

#define kStatusBarHeight 20
#define kNavigationBarHeight 44
//#define kBannerHeight 150
#define kButtonViewHeight 74
#define kRowInset 5
#define CellIdentifier @"Cell"
#define FooterCellIdentifier @"FooterCell"

@interface HomeViewController ()

@property (nonatomic, strong) HomeItemModel *homeItemModel;

- (void)pushClicked:(id)sender;
- (void)findClicked:(id)sender;
- (void)postClicked:(id)sender;
- (void)statusClicked:(id)sender;
- (void)authClicked:(id)sender;

@end

@implementation HomeViewController {
    int status;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    // 初始化模型
    self.homeItemModel = [[HomeItemModel alloc] init];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kScreenW, kScreenH-(kNavigationBarHeight+kStatusBarHeight)) style:UITableViewStyleGrouped];
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
    self.tableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示

    //网络获取itemArray
    [HttpClient listMenuWithBlock:^(NSDictionary *responseDictionary) {
        NSArray*arr=responseDictionary[@"responseArray"];
        if (arr.count==0) {
            [self getListMenu];
        }
        for (int i=0; i<arr.count; i++) {
            NSInteger x = [arr[i] integerValue];
            [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[x]];
            [self.tableView reloadData];
        }
    }];
    
    // 表头视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight + kButtonViewHeight)];
    PageView *bannerView = [[PageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight) andImageArray:nil];
    [headerView addSubview:bannerView];

    // 按钮功能区
    ButtonView *buttonView = [[ButtonView alloc] initWithFrame:CGRectMake(0, kBannerHeight, kScreenW, kButtonViewHeight)];
    [headerView addSubview:buttonView];
    // 添加 target
    [buttonView.pushHelperButton addTarget:self action:@selector(pushClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView.findCooperationButton addTarget:self action:@selector(findClicked:) forControlEvents:UIControlEventTouchUpInside];

    //    if ([[Config getUserType] intValue] == 0) {
//        // 服装厂
//        [buttonView.postButton addTarget:self action:@selector(postClicked:) forControlEvents:UIControlEventTouchUpInside];
//    } else {
//        // 配套工厂
//        [buttonView.postButton addTarget:self action:@selector(statusClicked:) forControlEvents:UIControlEventTouchUpInside];
//    }

    [buttonView.postButton addTarget:self action:@selector(postClicked:) forControlEvents:UIControlEventTouchUpInside];

    [buttonView.authenticationButton addTarget:self action:@selector(statusClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = headerView;

}

- (void)getListMenu {

    NSLog(@"ListMenu为0，初始化");

//    @"服装厂",@"加工厂",@"代裁厂",@"锁眼钉扣厂"
//     获取用户model
    [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {
        UserModel*userModel=responseDictionary[@"model"];
        switch (userModel.factoryType) {
            case 0:{
                //服装厂
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[5]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[6]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[7]];
                [self.tableView reloadData];

            }
                break;
            case 1:{
                //加工厂
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[0]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[5]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[6]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[7]];
                [self.tableView reloadData];

            }
                break;
            case 2:{
                //代裁厂
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[0]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[6]];
                [self.tableView reloadData];


            }
                break;
            case 3:{
                //锁眼钉扣厂
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[0]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[7]];
                [self.tableView reloadData];
            }
                break;

            default:
                break;
        }

    }];


}


- (void)pushClicked:(id)sender {
    PushHelperViewController*pushHelerVC = [[PushHelperViewController alloc]init];
    pushHelerVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pushHelerVC animated:YES];
}
- (void)findClicked:(id)sender {
    FactoryListViewController *factoryListVC= [[FactoryListViewController alloc]init];
    factoryListVC.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
    factoryListVC.factoryType = 10;
    [self.navigationController pushViewController:factoryListVC animated:YES];
}
- (void)postClicked:(id)sender {

    PushOrderViewController*pushOrderVC = [[PushOrderViewController alloc]init];
    pushOrderVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pushOrderVC animated:YES];

}

- (void)authClicked:(id)sender {
    StatusViewController*statusVC = [[StatusViewController alloc]init];
    statusVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:statusVC animated:YES];
    
}
- (void)statusClicked:(id)sender {

    //认证信息
    [HttpClient getVeifyInfoWithBlock:^(NSDictionary *dictionary) {
        NSDictionary*VeifyDic=dictionary[@"responseDictionary"];
        status = [VeifyDic[@"status"] intValue];
        NSLog(@"%d",status);

        //未认证
        if (status==0) {
            VeifyViewController*veifyVC = [[VeifyViewController alloc]init];
            veifyVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:veifyVC animated:YES];

        }
        //认证中
        if (status==1) {
            VeifyingViewController*veifyingVC = [[VeifyingViewController alloc]init];
            veifyingVC.hidesBottomBarWhenPushed=YES;
            veifyingVC.VeifyDic=VeifyDic;
            veifyingVC.title=@"认证资料已提交";
            [self.navigationController pushViewController:veifyingVC animated:YES];
        }
        //认证成功
        if (status==2) {
            VeifyEndViewController*endVC = [[VeifyEndViewController alloc]init];
            endVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:endVC animated:YES];

        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.homeItemModel.itemArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.homeItemModel.itemArray.count) {
        HomeFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:FooterCellIdentifier];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeFooterCell" owner:nil options:nil];
            cell = [nib objectAtIndex:0];
        }
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            // 添加前置颜色
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, cell.frame.size.height)];
            bgView.backgroundColor = self.homeItemModel.colorArray[indexPath.section % self.homeItemModel.colorArray.count];
            [cell.contentView addSubview:bgView];
            // accessoryView 设置
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            // 设置字体
            cell.textLabel.font = [UIFont boldSystemFontOfSize:14.0f];

            UILabel*moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-2*cell.frame.size.height+10, 11, 45, 22)];
            moreLabel.text=@"更多";
            moreLabel.backgroundColor=self.homeItemModel.colorArray[indexPath.section % self.homeItemModel.colorArray.count];
            moreLabel.font=[UIFont boldSystemFontOfSize:13.0f];
            moreLabel.textColor=[UIColor whiteColor];
            moreLabel.textAlignment=NSTextAlignmentCenter;
            moreLabel.layer.cornerRadius=10.0f;
            moreLabel.layer.masksToBounds=YES;
            [cell addSubview:moreLabel];

        }
        
        cell.textLabel.text = self.homeItemModel.itemArray[indexPath.section];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kRowInset;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, kRowInset)];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 0.5)];
    //view.backgroundColor = [UIColor colorWithHex:0xf0efea];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section != self.homeItemModel.itemArray.count) {
        NSInteger index = [self.homeItemModel.allItemArray indexOfObject:self.homeItemModel.itemArray[indexPath.section]];
        switch (index) {
            case 0:
            {
                // 各类营销活动

                /*
                 ActivityViewController *webViewController = [[ActivityViewController alloc] init];
                 UINavigationController *webNavigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
                 webViewController.url = [NSString stringWithFormat:@"http://cofactories.bangbang93.com/activity/draw.html#%@", [HttpClient getAccessToken]];
                 webViewController.hidesBottomBarWhenPushed = YES;
                 [self.navigationController pushViewController:webNavigationController animated:YES];
                 */
            }
                break;
            case 1:
            {
                // 找服装厂外发加工订单
                /*  OrderListViewController *orderDetailViewController =[[OrderListViewController alloc] initWithStyle:UITableViewStyleGrouped];
                 orderDetailViewController.orderListIndex = 4;
                 orderDetailViewController.title = @"外发加工";
                 orderDetailViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
                 [self.navigationController pushViewController:orderDetailViewController animated:YES];
                 */

            }
                break;
            case 2:{
                // 找服装厂外发代裁订单
                /*
                 OrderListViewController *orderDetailViewController =[[OrderListViewController alloc] initWithStyle:UITableViewStyleGrouped];
                 orderDetailViewController.orderListIndex = 5;
                 orderDetailViewController.title = @"外发代裁";
                 orderDetailViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
                 [self.navigationController pushViewController:orderDetailViewController animated:YES];
                 */
            }
                break;
            case 3:{
                // 找服装厂外发锁眼钉扣订单
                /*
                 OrderListViewController *orderDetailViewController =[[OrderListViewController alloc] initWithStyle:UITableViewStyleGrouped];
                 orderDetailViewController.orderListIndex = 6;
                 orderDetailViewController.title = @"外发锁眼钉扣";
                 orderDetailViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
                 [self.navigationController pushViewController:orderDetailViewController animated:YES];
                 */
            }
                break;
            case 4:
            {
                // 找服装厂信息
                FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
                searchViewController.factoryType = 0;
                searchViewController.currentData1Index = 1;
                searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
                [self.navigationController pushViewController:searchViewController animated:YES];
            }
                break;
            case 5:
            {
                // 找加工厂信息
                FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
                searchViewController.factoryType = 1;
                searchViewController.currentData1Index = 2;
                searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
                [self.navigationController pushViewController:searchViewController animated:YES];
            }
                break;
            case 6:
            {
                // 找代裁厂信息
                FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
                searchViewController.factoryType = 2;
                searchViewController.currentData1Index = 3;
                searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
                [self.navigationController pushViewController:searchViewController animated:YES];
            }
                break;
            case 7:
            {
                // 找锁眼钉扣厂信息
                FactoryListViewController *searchViewController = [[FactoryListViewController alloc]init];
                searchViewController.factoryType = 3;
                searchViewController.currentData1Index = 4;
                searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
                [self.navigationController pushViewController:searchViewController animated:YES];
            }
                break;

            default:
                break;
        }
    } else {
        // 编辑自定义项目
        HomeEditViewController *homeEditViewController = [[HomeEditViewController alloc] initWithStyle:UITableViewStylePlain];
        homeEditViewController.homeItemModel = self.homeItemModel;
        homeEditViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:homeEditViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
