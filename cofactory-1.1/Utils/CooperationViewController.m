//
//  CooperationViewController.m
//  聚工厂
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "CooperationViewController.h"
#import "Header.h"

@interface CooperationViewController ()
@end

@implementation CooperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"合作商";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight=100;

    //列出合作商
    [HttpClient listPartnerWithBlock:^(NSDictionary *responseDictionary) {
        NSLog(@"合作商%@",responseDictionary);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }

    UIImageView*headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
    headerImage.image=[UIImage imageNamed:@"placeholder232"];
    headerImage.clipsToBounds=YES;
    headerImage.contentMode=UIViewContentModeScaleAspectFill;
    headerImage.layer.cornerRadius=80/2.0f;
    headerImage.layer.masksToBounds=YES;
    [cell addSubview:headerImage];

    for (int i=0; i<3; i++) {
        UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, (10+30*i), kScreenW-170, 20)];
        cellLabel.font=[UIFont systemFontOfSize:14.0f];
        switch (i) {
            case 0:
            {
                cellLabel.text=@"公司：杭州聚工科技有限公司";
                cellLabel.textColor=[UIColor orangeColor];

            }
                break;
            case 1:
            {
                cellLabel.text=@"联系人：么么哒";

            }
                break;
            case 2:
            {
                cellLabel.text=@"电话：180371891860";

            }
                break;
                
            default:
                break;
        }
        [cell addSubview:cellLabel];
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
    CooperationInfoViewController*infoVC = [[CooperationInfoViewController alloc]init];
    infoVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:infoVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
