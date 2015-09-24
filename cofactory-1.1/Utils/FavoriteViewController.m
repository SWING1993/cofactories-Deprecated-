//
//  FavoriteViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "FavoriteViewController.h"

@interface FavoriteViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain)NSMutableArray * modelArray;
@property (nonatomic, retain) UITableView *tableView;


@end

@implementation FavoriteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [HttpClient listFavoriteWithBlock:^(NSDictionary *responseDictionary) {
        self.modelArray=responseDictionary[@"responseArray"];
        if (self.modelArray.count == 0) {
            [Tools showErrorWithStatus:@"您暂无收藏！"];
        }else{
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"我的收藏";
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)  style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight=100;
    [self.view addSubview:self.tableView];

    //下拉刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 2.0;
    //列出合作商
    [HttpClient listFavoriteWithBlock:^(NSDictionary *responseDictionary) {
        self.modelArray=responseDictionary[@"responseArray"];
    }];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        DLog(@"下拉刷新结束");
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    });
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        FactoryModel*factoryModel=self.modelArray[indexPath.section];

        UIImageView*headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
        NSString* imageUrlString = [NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,factoryModel.uid];
        [headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"placeholder232"]];
        headerImage.clipsToBounds=YES;
        headerImage.contentMode=UIViewContentModeScaleAspectFill;
        headerImage.layer.cornerRadius=80/2.0f;
        headerImage.layer.masksToBounds=YES;
        headerImage.layer.borderWidth=0.3f;
        headerImage.layer.borderColor=[UIColor blackColor].CGColor;

        [cell addSubview:headerImage];

        for (int i=0; i<3; i++) {
            UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, (10+30*i), kScreenW-170, 20)];
            cellLabel.font=kLargeFont;
            switch (i) {
                case 0:
                {
                    cellLabel.text=factoryModel.factoryName;
                    cellLabel.textColor=[UIColor orangeColor];

                }
                    break;
                case 1:
                {
                    cellLabel.text=factoryModel.legalPerson;

                }
                    break;
                case 2:
                {
                    cellLabel.text=factoryModel.phone;

                }
                    break;

                default:
                    break;
            }
            [cell addSubview:cellLabel];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    FactoryModel*factoryModel=self.modelArray[indexPath.section];
    CooperationInfoViewController*infoVC = [[CooperationInfoViewController alloc]init];
    infoVC.factoryModel=factoryModel;
    infoVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:infoVC animated:YES];
}


#pragma mark--删除表单元格

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        FactoryModel*factoryModel=self.modelArray[indexPath.section];

        DLog(@"%d",factoryModel.uid);
        [HttpClient deleteFavoriteWithUid:[NSString stringWithFormat:@"%d",factoryModel.uid] andBlock:^(int statusCode) {
            DLog(@"%d",statusCode);
            if (statusCode==200) {
                self.modelArray = [[NSMutableArray alloc]initWithCapacity:0];
                [HttpClient listFavoriteWithBlock:^(NSDictionary *responseDictionary) {
                    self.modelArray=responseDictionary[@"responseArray"];
                    [self.tableView reloadData];
                    DLog(@"%@",responseDictionary);
                }];
            }else{
                UIAlertView*alertVierw = [[UIAlertView alloc]initWithTitle:@"删除出错" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertVierw show];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
