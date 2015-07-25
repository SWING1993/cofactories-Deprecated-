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

@property (nonatomic,retain)NSMutableArray*modelArray;

@end

@implementation CooperationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.modelArray = [[NSMutableArray alloc]initWithCapacity:0];

    //列出合作商
    [HttpClient listPartnerWithBlock:^(NSDictionary *responseDictionary) {
        self.modelArray = responseDictionary[@"responseArray"];
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"合作商";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight=100;

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
        //    headerImage.image=[UIImage imageNamed:@"placeholder232"];
        NSString *imageUrlString = [NSString stringWithFormat:@"http://cofactories.bangbang93.com/storage_path/factory_avatar/%d",factoryModel.uid];
        [headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"placeholder232"]];
        headerImage.clipsToBounds=YES;
        headerImage.contentMode=UIViewContentModeScaleAspectFill;
        headerImage.layer.cornerRadius=80/2.0f;
        headerImage.layer.masksToBounds=YES;
        [cell addSubview:headerImage];


        UIButton*callBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW-55, 30, 40, 40)];
        callBtn.tag=indexPath.section;
        [callBtn setBackgroundImage:[UIImage imageNamed:@"PHONE"] forState:UIControlStateNormal];
        [callBtn addTarget:self action:@selector(callBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:callBtn];

        for (int i=0; i<3; i++) {
            UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, (10+30*i), kScreenW-170, 20)];
            cellLabel.font=[UIFont systemFontOfSize:14.0f];
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

- (void)callBtn:(UIButton *)sender {
    UIButton*button = (UIButton *)sender;
    FactoryModel*factoryModel=self.modelArray[button.tag];

    NSString *str = [NSString stringWithFormat:@"telprompt://%@", factoryModel.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];


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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
