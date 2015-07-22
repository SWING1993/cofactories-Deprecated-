//
//  CooperationInfoViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "CooperationInfoViewController.h"

@interface CooperationInfoViewController ()


//公司规模数组
@property(nonatomic,retain)NSArray*sizeArray;

//公司业务类型数组
@property (nonatomic,retain)NSArray*serviceRangeArray;



//单元格imageArray
@property (nonatomic,retain)NSArray*cellImageArray1;
@property (nonatomic,retain)NSArray*cellImageArray2;
@property (nonatomic,retain)NSArray*cellImageArray3;
@property (nonatomic,retain)NSArray*cellImageArray4;



@end

@implementation CooperationInfoViewController {
    UILabel*factoryNameLabel;

    UILabel*infoLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];

    NSLog(@"%d",self.factoryModel.authStatus);

      // 表头视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight)];

    UIImageView*BGImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight-50)];
    BGImage.image=[UIImage imageNamed:@"bb"];
    headerView.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:BGImage];


    UIImageView*headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, kBannerHeight-80, 60, 60)];
    headerImage.backgroundColor=[UIColor blueColor];
    headerImage.layer.cornerRadius=60/2.0f;
    headerImage.layer.masksToBounds=YES;
    NSString *imageUrlString = [NSString stringWithFormat:@"http://cofactories.bangbang93.com/storage_path/factory_avatar/%d",self.factoryModel.uid];
    [headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"placeholder88"]];
    [headerView addSubview:headerImage];



    factoryNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, kBannerHeight-45, kScreenW-100, 20)];
    factoryNameLabel.font=[UIFont boldSystemFontOfSize:18];
    factoryNameLabel.text=self.factoryModel.factoryName;
    [headerView addSubview:factoryNameLabel];



    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-140, kBannerHeight-25, 130, 20)];
    infoLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    infoLabel.textColor=[UIColor grayColor];
    [headerView addSubview:infoLabel];

    self.tableView.tableHeaderView = headerView;

    self.cellImageArray1=@[[UIImage imageNamed:@"set_人名"],[UIImage imageNamed:@"set_号码"],[UIImage imageNamed:@"set_职务 "],[UIImage imageNamed:@"set_收藏"]];
    self.cellImageArray2=@[[UIImage imageNamed:@"set_名称"],[UIImage imageNamed:@"set_公司地址"],[UIImage imageNamed:@"set_公司规模"],[UIImage imageNamed:@"set_公司相册"],[UIImage imageNamed:@"set_公司业务类型"]];
    self.cellImageArray3=@[[UIImage imageNamed:@"空闲"],[UIImage imageNamed:@"货车"],[UIImage imageNamed:@"认证"],];
    self.cellImageArray4=@[[UIImage imageNamed:@"空闲2"],[UIImage imageNamed:@"货车2"],[UIImage imageNamed:@"认证2"]];
}

- (void)callBtn {

    NSLog(@"拨打电话");

}

- (void)favoriteBtn {

    NSLog(@"添加收藏");
    NSString * Uid = [NSString stringWithFormat:@"%d",self.factoryModel.uid];
    [HttpClient addFavoriteWithUid:Uid andBlock:^(int statusCode) {
        switch (statusCode) {
            case 201:
            {
                UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"收藏成功" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
                break;
            case 400:
            {
                UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"未登录" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
                break;
            case 401:
            {
                UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"收藏失败需要重新登录" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
                break;
                
            default:
                break;
        }    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    if (section==1) {
        return 5;
    }else{
        if (self.factoryModel.factoryType==GarmentFactory||self.factoryModel.factoryType==ProcessingFactory) {
            return 1;
        }else{
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.font=[UIFont systemFontOfSize:14.0f];
        cell.detailTextLabel.textColor=[UIColor blackColor];

        UIImageView*cellImage= [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
        UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, kScreenW-40, 30)];
        cellLabel.font=[UIFont systemFontOfSize:15.0f];

        if (indexPath.section == 0) {


            UIButton*callBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, kScreenW/2-20, 40)];
            callBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            callBtn.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 20, 40);
            [callBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [callBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
            [callBtn setImage:[UIImage imageNamed:@"set_号码"] forState:UIControlStateNormal];
            callBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0 ,0 ,kScreenW/2-60);
            [callBtn addTarget:self action:@selector(callBtn) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:callBtn];


            UIButton*favoriteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2+10, 10, kScreenW/2-20, 40)];
            favoriteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            favoriteBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -20, 20, 20);
            [favoriteBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [favoriteBtn setTitle:@"收藏工厂" forState:UIControlStateNormal];
            [favoriteBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            favoriteBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0 ,0 ,kScreenW/2-60);
            [favoriteBtn addTarget:self action:@selector(favoriteBtn) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:favoriteBtn];

        }

        if (indexPath.section == 1) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cellImage.image=self.cellImageArray2[indexPath.row];

            switch (indexPath.row) {
                case 0:{
                    cellLabel.text=@"公司名称";
                    cell.detailTextLabel.text=self.factoryModel.factoryName;

                }
                    break;
                case 1:{
                    cellLabel.text=@"公司地址";
                    cell.detailTextLabel.text=self.factoryModel.factoryAddress;

                }
                    break;
                case 2:{
                    cellLabel.text=@"公司规模";
                    cell.detailTextLabel.text=self.factoryModel.factorySize;

                }
                    break;
                case 3:{
                    cellLabel.text=@"业务类型";
                    cell.detailTextLabel.text=self.factoryModel.factoryServiceRange;
                }
                    break;
                case 4:{
                    cellLabel.text=@"公司电话";
                    cell.detailTextLabel.text=self.factoryModel.phone;
                }
                    break;

                default:
                    break;
            }
        }
        if (indexPath.section == 2) {

            for (int i = 0; i<3; i++) {
                UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenW-90)/4+i*((kScreenW-90)/4+30), 5, 30 , 30)];
                imageView.image = self.cellImageArray3[i];
                [cell addSubview:imageView];


                UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-240)/4+i*((kScreenW-240)/4+80), 40, 80, 20)];
                cellLabel.backgroundColor = [UIColor grayColor];
                cellLabel.font = [UIFont systemFontOfSize:14.0f];
                cellLabel.text = @"测试";
                cellLabel.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:cellLabel];

            }
        }
        if (indexPath.section == 3) {

            [cell setAccessoryType:UITableViewCellAccessoryNone];
            UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenW, 20)];
            titleLabel.text=@"公司简介";
            //            titleLabel.backgroundColor=[UIColor redColor];
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.font=[UIFont systemFontOfSize:16.0f];
            [cell addSubview:titleLabel];

            UIFont*font=[UIFont systemFontOfSize:14];
            CGSize size = [self.factoryModel.factoryDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 100000) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel*descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 , 30, kScreenW-40, size.height)];
            descriptionLabel.text=self.factoryModel.factoryDescription;
            descriptionLabel.font=[UIFont systemFontOfSize:14.0f];
            descriptionLabel.numberOfLines=0;
            [cell addSubview:descriptionLabel];
        }
        
        [cell addSubview:cellLabel];
        [cell addSubview:cellImage];
    }
    cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0) {
        return 60;
    }if (indexPath.section==2) {
        return 65;
    }
    if (indexPath.section==3) {
        UIFont*font=[UIFont systemFontOfSize:14];
        CGSize size = [self.factoryModel.factoryDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 100000) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height+40;
    }else{
        return 44;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
