//
//  CooperationViewController.m
//  聚工厂
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "CooperationViewController.h"
#import "Header.h"
#import "IMChatViewController.h"

@interface CooperationViewController () <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic,retain)NSMutableArray*modelArray;
@property (nonatomic, retain) UITableView *tableView;


@end

@implementation CooperationViewController {


}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //列出合作商
    [HttpClient listPartnerWithBlock:^(NSDictionary *responseDictionary) {
        NSInteger statusCode = [responseDictionary[@"statusCode"]integerValue];
        DLog(@"状态码 == %ld",(long)statusCode);
        if (statusCode == 200) {
            self.modelArray = responseDictionary[@"responseArray"];
            if (self.modelArray.count == 0) {
                [Tools showErrorWithStatus:@"您尚未添加合作商！"];
            }else{
                [self.tableView reloadData];
            }
        }
        if (statusCode == 401 || statusCode == 404) {
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"您的登录信息已过期，请重新登录！" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag = 401;
            [alertView show];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 401) {
        [ViewController goLogin];
    }
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

    // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
    IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
    conversationVC.conversationType = ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    FactoryModel*factoryModel=self.modelArray[indexPath.section];
    conversationVC.targetId = [NSString stringWithFormat:@"%d", factoryModel.uid]; // 接收者的 targetId，这里为举例。
    conversationVC.userName = factoryModel.factoryName; // 接受者的 username，这里为举例。
    conversationVC.title = factoryModel.name; // 会话的 title。
    conversationVC.hidesBottomBarWhenPushed=YES;
    // 把单聊视图控制器添加到导航栈。
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:conversationVC animated:YES];
    
//    FactoryModel*factoryModel=self.modelArray[indexPath.section];
//    CooperationInfoViewController*infoVC = [[CooperationInfoViewController alloc]init];
//    infoVC.factoryModel=factoryModel;
//    infoVC.hidesBottomBarWhenPushed=YES;
//    [self.navigationController pushViewController:infoVC animated:YES];
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
