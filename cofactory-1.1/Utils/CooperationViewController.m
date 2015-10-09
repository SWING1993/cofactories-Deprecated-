//
//  CooperationViewController.m
//  聚工厂
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "CooperationViewController.h"
#import "Header.h"


@interface CooperationViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)NSMutableArray*modelArray;
@property (nonatomic, retain) UITableView *tableView;


@end

@implementation CooperationViewController {


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //列出合作商
    [HttpClient listPartnerWithBlock:^(NSDictionary *responseDictionary) {
        self.modelArray = responseDictionary[@"responseArray"];
        if (self.modelArray.count == 0) {
            [Tools showErrorWithStatus:@"您尚未添加合作商！"];
        }else{
            [self.tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"合作商";
    self.view.backgroundColor=[UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets=NO;

    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-44) style:UITableViewStylePlain];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight=100;
    [self.view addSubview:self.tableView];

    self.modelArray = [[NSMutableArray alloc]initWithCapacity:0];

    //下拉刷新
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    [refreshControl beginRefreshing];
    //列出合作商
    [HttpClient listPartnerWithBlock:^(NSDictionary *responseDictionary) {
        self.modelArray = responseDictionary[@"responseArray"];
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    }];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 2.0;
    //列出合作商
    [HttpClient listPartnerWithBlock:^(NSDictionary *responseDictionary) {
        self.modelArray = responseDictionary[@"responseArray"];
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
        headerImage.layer.borderWidth=0.3f;
        headerImage.layer.borderColor=[UIColor blackColor].CGColor;
        NSString* imageUrlString = [NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,factoryModel.uid];
        [headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"消息头像"]];
        headerImage.clipsToBounds=YES;
        headerImage.contentMode=UIViewContentModeScaleAspectFill;
        headerImage.layer.cornerRadius=80/2.0f;
        headerImage.layer.masksToBounds=YES;
        [cell addSubview:headerImage];

        UIButton*callBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-55, 30, 30, 30)];
        callBtn.tag=indexPath.section;
        [callBtn setBackgroundImage:[UIImage imageNamed:@"PHONE"] forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:callBtn];

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
                    cellLabel.text=factoryModel.name;

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

- (void)callBtn:(UIButton *)sender {
    UIButton*button = (UIButton *)sender;
    FactoryModel*factoryModel=self.modelArray[button.tag];

    NSString *str = [NSString stringWithFormat:@"telprompt://%@", factoryModel.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 5.0f;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0.01f;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    FactoryModel*factoryModel=self.modelArray[indexPath.section];
    CooperationInfoViewController*infoVC = [[CooperationInfoViewController alloc]init];
    infoVC.factoryModel=factoryModel;
    infoVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (void)dealloc
{
    DLog(@"释放内存");
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
