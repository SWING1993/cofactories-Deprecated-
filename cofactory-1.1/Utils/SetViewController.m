//
//  SetViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "SetViewController.h"

@interface SetViewController ()

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    //设置Btn
    UIBarButtonItem *quitButton = [[UIBarButtonItem alloc] initWithTitle:@"退出登录" style:UIBarButtonItemStylePlain target:self action:@selector(quitButtonClicked)];
    self.navigationItem.rightBarButtonItem = quitButton;
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

}

- (void)quitButtonClicked{
    [HttpClient logout];
    [ViewController goLogin];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.textColor=[UIColor blackColor];

    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text=@"修改密码";

        }
            break;
        case 1:{
            cell.textLabel.text=@"分享给好友";

        }
            break;
        case 2:{
            cell.textLabel.text=@"意见反馈";

        }
            break;
        case 3:{
            cell.textLabel.text=@"关于聚工厂";

        }
            break;

        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.01f)];
    //view.backgroundColor = [UIColor colorWithHex:0xf0efea];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
//            cell.textLabel.text=@"修改密码";
            RevisePasswordViewController*reviseVC = [[RevisePasswordViewController alloc]init];
            [self.navigationController pushViewController:reviseVC animated:YES];

        }
            break;
        case 1:{

        }
            break;
        case 2:{

        }
            break;
        case 3:{
            AboutViewController*aboutVC = [[AboutViewController alloc]init];
            aboutVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:aboutVC animated:YES];

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

@end
