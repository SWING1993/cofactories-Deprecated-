//
//  VeifyingViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/22.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "VeifyingViewController.h"

@interface VeifyingViewController ()

@end

@implementation VeifyingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    UIButton*VeifyBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 160, kScreenW-40, 35)];
    [VeifyBtn setTitle:@"重新认证" forState:UIControlStateNormal];
    [VeifyBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [VeifyBtn addTarget:self action:@selector(VeifyBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:VeifyBtn];

    DLog(@"%@",self.VeifyDic);

}
- (void)VeifyBtn {
    VeifyViewController*veifyVC = [[VeifyViewController alloc]init];
    [self.navigationController pushViewController:veifyVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:15.0f];
    cell.detailTextLabel.textColor=[UIColor blackColor];
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text=@"法人姓名";
            cell.detailTextLabel.text=self.VeifyDic[@"legalPerson"];
        }
            break;
        case 1:
        {
            cell.textLabel.text=@"身份证号";
            cell.detailTextLabel.text=self.VeifyDic[@"idCard"];
        }
            break;
        case 2:
        {
            cell.textLabel.text=@"提交时间";
            cell.detailTextLabel.text=[[Tools WithTime:self.VeifyDic[@"updatedAt"]] firstObject];
        }
            break;

        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
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
