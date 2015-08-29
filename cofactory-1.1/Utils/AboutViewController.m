//
//  AboutViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"关于聚工厂";
    self.view.backgroundColor=[UIColor whiteColor];


    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight=40;

    UIView*tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    tableHeaderView.backgroundColor=[UIColor whiteColor];
    UIImageView*logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2-40, 10, 80, 80)];
    logoImage.image=[UIImage imageNamed:@"logo"];
    logoImage.layer.cornerRadius = 15;
    logoImage.layer.masksToBounds = YES;
    [tableHeaderView addSubview:logoImage];

    UILabel*logoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, kScreenW, 20)];
    logoLabel.font = [UIFont systemFontOfSize:16];
    logoLabel.text=@"聚工厂 cofactories 1.3";
    logoLabel.textAlignment = NSTextAlignmentCenter;
    [tableHeaderView addSubview:logoLabel];

    self.tableView.tableHeaderView=tableHeaderView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.textColor=[UIColor blackColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text=@"去评分";

        }
            break;
//        case 1:{
//            cell.textLabel.text=@"服务条款";
//
//        }
//            break;
        case 1:{
            cell.textLabel.text=@"检测更新";

        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id1015359842"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

        }
            break;
        case 1:{
            [self checkUpdate];

        }
            break;

        default:
            break;
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

/**
 *  检查更新
 */
- (void)checkUpdate
{
    //  有回调的检查更新
    [[PgyManager sharedPgyManager] checkUpdateWithDelegete:self selector:@selector(updateMethod:)];

}

/**
 *  检查更新回调
 *
 *  @param response 检查更新的返回结果
 */
- (void)updateMethod:(NSDictionary *)response
{
    if (response[@"downloadURL"]) {

        //    无回调的检查更新，如果有新版本，则会提示用户更新，确认更新后会自动安装新版本
        [[PgyManager sharedPgyManager] checkUpdate];

    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"当前版本为最新版本"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"好的"
                                                  otherButtonTitles:nil,
                                  nil];

        [alertView show];

    }

    //    调用checkUpdateWithDelegete后可用此方法来更新本地的版本号，如果有更新的话，在调用了此方法后再次调用将不提示更新信息。
    //    [[PgyManager sharedPgyManager] updateLocalBuildNumber];
}


@end
