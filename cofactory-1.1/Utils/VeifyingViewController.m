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


    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    blueButton*ReviseBtn=[[blueButton alloc]initWithFrame:CGRectMake(20, 15, kScreenW-40, 35)];;
    [ReviseBtn setTitle:@"重新认证" forState:UIControlStateNormal];
    [ReviseBtn addTarget:self action:@selector(VeifyBtn) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:ReviseBtn];
    self.tableView.tableFooterView = tableFooterView;

    DLog(@"%@",self.VeifyDic);
    //backBtn
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goback {
    NSArray*navArr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:navArr[0] animated:YES];
}

- (void)VeifyBtn {
    VeifyViewController*veifyVC = [[VeifyViewController alloc]init];
    [self.navigationController pushViewController:veifyVC animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
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
    switch (indexPath.row) {
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
