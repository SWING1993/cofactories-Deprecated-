//
//  PushOrderViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/22.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "PushOrderViewController.h"

@interface PushOrderViewController ()
@property (nonatomic,copy)NSArray * cellTitleArr;
@property (nonatomic,copy)NSArray * cellImageArr;

@end

@implementation PushOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"订单";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.cellTitleArr=@[@"发布订单",@"进行中的订单",@"历史订单"];
    self.cellImageArr=@[[UIImage imageNamed:@"post"],[UIImage imageNamed:@"current"],[UIImage imageNamed:@"history"]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

        UIImageView*cellImage= [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
        cellImage.image=self.cellImageArr[indexPath.section];
        [cell addSubview:cellImage];

        UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, kScreenW-40, 30)];
        cellLabel.font=[UIFont systemFontOfSize:15.0f];
        cellLabel.text=self.cellTitleArr[indexPath.section];
        [cell addSubview:cellLabel];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            AddOrderViewController*addOrderVC = [[AddOrderViewController alloc]init];
            [self.navigationController pushViewController:addOrderVC animated:YES];

        }
            break;
        case 1:
        {
            OrderListViewController*orderListVC = [[OrderListViewController alloc]init];
            orderListVC.isHistory=NO;
            orderListVC.HiddenJSDropDown=YES;
            [self.navigationController pushViewController:orderListVC animated:YES];
        }
            break;
        case 2:
        {
            OrderListViewController*orderListVC = [[OrderListViewController alloc]init];
            orderListVC.isHistory=YES;
            orderListVC.HiddenJSDropDown=YES;
            [self.navigationController pushViewController:orderListVC animated:YES];
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
@end
