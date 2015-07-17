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

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    //@"服装厂",@"加工厂",@"代裁厂",@"锁眼钉扣厂"
    // 获取用户model
    [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {
        UserModel*userModel=responseDictionary[@"model"];
        switch (userModel.factoryType) {
            case 0:{
                NSLog(@"服装厂");
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[5]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[6]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[7]];
                [self.tableView reloadData];

            }
                break;
            case 1:{
                NSLog(@"加工厂");
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[0]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[5]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[6]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[7]];
                [self.tableView reloadData];

            }
                break;
            case 2:{
                NSLog(@"代裁厂");
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[0]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[6]];
                [self.tableView reloadData];


            }
                break;
            case 3:{
                NSLog(@"锁眼钉扣厂");
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[0]];
                [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[7]];
                [self.tableView reloadData];
                }
                break;
                
            default:
                break;
        }

    }];

    //网络获取itemArray
        [HttpClient listMenuWithBlock:^(NSDictionary *responseDictionary) {

            NSLog(@"listDic%@",responseDictionary);
    //        NSLog(@"%@",responseDictionary[@"statusCode"]);
    //        NSLog(@"%@",responseDictionary);
    //        self.homeItemModel.itemArray=responseDictionary[@"responseArray"];
    //        NSLog(@"%@",self.homeItemModel.itemArray);
    
        }];


//    [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {
//        NSLog(@"%@",responseDictionary[@"model"]);
//    }];
//    [HttpClient listFavoriteWithBlock:^(NSDictionary *responseDictionary) {
//        NSLog(@"%@",responseDictionary);
//    }];
//    [HttpClient listMenuWithBlock:^(NSDictionary *responseDictionary) {
//        NSLog(@"%@",responseDictionary[@"message"]);
//    }];
    NSLog(@"%@",[HttpClient getToken]);

    // 初始化模型
    self.homeItemModel = [[HomeItemModel alloc] init];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight+kStatusBarHeight, kScreenW, kScreenH-(kNavigationBarHeight+kStatusBarHeight)) style:UITableViewStyleGrouped];
    self.automaticallyAdjustsScrollViewInsets = YES;// 自动调整视图关闭
    self.tableView.showsVerticalScrollIndicator = NO;// 竖直滚动条不显示
    
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

    [buttonView.postButton addTarget:self action:@selector(statusClicked:) forControlEvents:UIControlEventTouchUpInside];

    [buttonView.authenticationButton addTarget:self action:@selector(authClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableHeaderView = headerView;

}


- (void)pushClicked:(id)sender {
    PushHelperViewController*pushHelerVC = [[PushHelperViewController alloc]init];
    pushHelerVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:pushHelerVC animated:YES];
}
- (void)findClicked:(id)sender {
    SearchViewController *searchViewController = [[SearchViewController alloc] initWithStyle:UITableViewStylePlain];
    searchViewController.hidesBottomBarWhenPushed = YES;// 隐藏底部栏
    [self.navigationController pushViewController:searchViewController animated:YES];
}
- (void)postClicked:(id)sender {
}
- (void)statusClicked:(id)sender {

    StatusViewController*statusVC = [[StatusViewController alloc]init];
    statusVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:statusVC animated:YES];
}
- (void)authClicked:(id)sender {
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
            cell.textLabel.font = [UIFont boldSystemFontOfSize:13.0f];

            UILabel*moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-2*cell.frame.size.height+10, 11, 45, 22)];
            moreLabel.text=@"更多";
            moreLabel.backgroundColor=self.homeItemModel.colorArray[indexPath.section % self.homeItemModel.colorArray.count];
            moreLabel.font=[UIFont boldSystemFontOfSize:12.0f];
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
    //view.backgroundColor = [UIColor colorWithHex:0xf0efea];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 0.5)];
    //view.backgroundColor = [UIColor colorWithHex:0xf0efea];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%d",indexPath.section);
//    NSLog(@"%d",self.homeItemModel.itemArray.count);
//    NSLog(@"%@",self.homeItemModel.itemArray);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == self.homeItemModel.itemArray.count) {
        // 编辑自定义项目
        HomeEditViewController *homeEditViewController = [[HomeEditViewController alloc] initWithStyle:UITableViewStyleGrouped];
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
