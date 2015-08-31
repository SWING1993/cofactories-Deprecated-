//
//  CooperationInfoViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#define ImageViewHeight 250

#import "Header.h"
#import "CooperationInfoViewController.h"

@interface CooperationInfoViewController () <UIAlertViewDelegate>

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
    UIButton*favoriteBtn;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.title=@"公司信息";

    self.cellImageArray1=@[[UIImage imageNamed:@"set_人名"],[UIImage imageNamed:@"set_号码"],[UIImage imageNamed:@"set_职务 "],[UIImage imageNamed:@"set_收藏"]];
    self.cellImageArray2=@[[UIImage imageNamed:@"set_名称"],[UIImage imageNamed:@"set_公司地址"],[UIImage imageNamed:@"set_公司规模"],[UIImage imageNamed:@"set_公司业务类型"],[UIImage imageNamed:@"set_号码"],[UIImage imageNamed:@"set_公司相册"],[UIImage imageNamed:@"set_标签"]];
    self.cellImageArray3=@[[UIImage imageNamed:@"空闲"],[UIImage imageNamed:@"货车2"],[UIImage imageNamed:@"认证2"],];
    self.cellImageArray4=@[[UIImage imageNamed:@"空闲2"],[UIImage imageNamed:@"货车"],[UIImage imageNamed:@"认证"]];

    [self createHeaderView];
}

- (void)createHeaderView {
    // 表头视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, ImageViewHeight)];

    UIImageView*BGImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, ImageViewHeight-50)];
    BGImage.image=[UIImage imageNamed:@"headerView"];
    headerView.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:BGImage];

    UIImageView*leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW/2+30, ImageViewHeight-50)];
    [headerView addSubview:leftImage];

    [HttpClient getFactoryPhotoWithUid:[NSString stringWithFormat:@"%d",self.factoryModel.uid] type:@"employee" andBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"statusCode"] intValue]== 200) {
            NSMutableArray*employee = [[NSMutableArray alloc]initWithCapacity:0];
            NSDictionary*responseDictionary = dictionary[@"responseDictionary"];
            NSDictionary*factory=responseDictionary[@"factory"];
            employee =factory[@"employee"];
            if ([employee firstObject]) {
                leftImage.contentMode=UIViewContentModeScaleAspectFill;
                leftImage.layer.borderWidth=0.5f;
                leftImage.layer.borderColor=[UIColor blackColor].CGColor;
                leftImage.clipsToBounds=YES;
                NSString*urlString =[NSString stringWithFormat:@"%@%@",PhotoAPI,[employee firstObject]];//图片测试
                [leftImage sd_setImageWithURL:[NSURL URLWithString:urlString]];
            }

        }
    }];

    [HttpClient getFactoryPhotoWithUid:[NSString stringWithFormat:@"%d",self.factoryModel.uid] type:@"environment" andBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"statusCode"] intValue]== 200) {
            NSMutableArray*environment = [[NSMutableArray alloc]initWithCapacity:0];
            NSDictionary*responseDictionary = dictionary[@"responseDictionary"];
            NSDictionary*factory=responseDictionary[@"factory"];
            environment=factory[@"environment"];
            if ([environment firstObject]) {
                UIImageView*rightImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2+30, 0, kScreenW-kScreenW/2-30, (ImageViewHeight-50)/2)];
                rightImage1.contentMode=UIViewContentModeScaleAspectFill;
                rightImage1.clipsToBounds=YES;
                rightImage1.layer.borderWidth=0.5f;
                rightImage1.layer.borderColor=[UIColor blackColor].CGColor;
                NSString*urlString =[NSString stringWithFormat:@"%@%@",PhotoAPI,[environment firstObject]];//图片测试
                [rightImage1 sd_setImageWithURL:[NSURL URLWithString:urlString]];
                [headerView addSubview:rightImage1];

            }
        }
    }];

    [HttpClient getFactoryPhotoWithUid:[NSString stringWithFormat:@"%d",self.factoryModel.uid] type:@"equipment" andBlock:^(NSDictionary *dictionary) {
        if ([dictionary[@"statusCode"] intValue]== 200) {
            NSMutableArray*equipment = [[NSMutableArray alloc]initWithCapacity:0];
            NSDictionary*responseDictionary = dictionary[@"responseDictionary"];
            NSDictionary*factory=responseDictionary[@"factory"];
            equipment=factory[@"equipment"];

            if ([equipment firstObject]) {
                UIImageView*rightImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2+30, (ImageViewHeight-50)/2, kScreenW-kScreenW/2-30, (ImageViewHeight-50)/2)];
                rightImage2.contentMode=UIViewContentModeScaleAspectFill;
                rightImage2.clipsToBounds=YES;
                rightImage2.layer.borderWidth=0.5f;
                rightImage2.layer.borderColor=[UIColor blackColor].CGColor;
                NSString*urlString =[NSString stringWithFormat:@"%@%@",PhotoAPI,[equipment firstObject]];//图片测试
                [rightImage2 sd_setImageWithURL:[NSURL URLWithString:urlString]];
                [headerView addSubview:rightImage2];
            }
        }
    }];

    UIImageView*headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, ImageViewHeight-80, 60, 60)];
    headerImage.layer.cornerRadius=60/2.0f;
    headerImage.layer.masksToBounds=YES;
    headerImage.layer.borderWidth=0.3f;
    headerImage.layer.borderColor=[UIColor blackColor].CGColor;
    headerImage.contentMode=UIViewContentModeScaleAspectFill;
    NSString* imageUrlString = [NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,self.factoryModel.uid];
    [headerImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"消息头像"]];
    [headerView addSubview:headerImage];
    [headerView bringSubviewToFront:headerImage];

    factoryNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, ImageViewHeight-45, kScreenW-100, 20)];
    factoryNameLabel.font=[UIFont boldSystemFontOfSize:18];
    factoryNameLabel.text=self.factoryModel.factoryName;
    [headerView addSubview:factoryNameLabel];

    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-140, ImageViewHeight-25, 130, 20)];
    infoLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    infoLabel.textColor=[UIColor grayColor];
    [headerView addSubview:infoLabel];
    self.tableView.tableHeaderView = headerView;
    self.tableView.showsVerticalScrollIndicator=NO;
}

- (void)callBtn {
//    NSLog(@"拨打电话");
    NSString *str = [NSString stringWithFormat:@"telprompt://%@", self.factoryModel.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [self performSelector:@selector(popAlertViewController) withObject:nil afterDelay:5.0f];
}

- (void)popAlertViewController {
    if ([self.navigationController.topViewController isEqual:self]) {
        // 弹出对话框
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否加入合作商列表以便继续合作" delegate:self cancelButtonTitle:@"不加入" otherButtonTitles:@"加入合作商", nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [HttpClient addPartnerWithUid:self.factoryModel.uid andBlock:^(int statusCode) {
            if (statusCode==201) {
                [Tools showHudTipStr:@"添加成功"];
            }else{
                [Tools showHudTipStr:@"添加失败"];
            }
        }];
    }
}

- (void)favoriteBtn {

    DLog(@"添加收藏");
    NSString * Uid = [NSString stringWithFormat:@"%d",self.factoryModel.uid];
    [HttpClient addFavoriteWithUid:Uid andBlock:^(int statusCode) {
        switch (statusCode) {
            case 201:
            {

                [Tools showHudTipStr:@"收藏成功"];
            }
                break;

            case 400:
            {
                [Tools showHudTipStr:@"未登录"];

            }
                break;

            case 401:
            {
                [Tools showHudTipStr:@"需要重新登录"];

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
        if (self.factoryModel.factoryType == GarmentFactory) {
            return 6;
        }else{
            return 7;
        }
    }else{
        return 1;
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
            [callBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [callBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
            callBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -20, 20, 00);

            [callBtn setImage:[UIImage imageNamed:@"set_号码"] forState:UIControlStateNormal];
            callBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0 ,0 ,kScreenW/2-60);
            [callBtn addTarget:self action:@selector(callBtn) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:callBtn];

            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(kScreenW/2-1.5f, 0, 1.0f, 60)];
            view.backgroundColor=[UIColor lightGrayColor];
            [cell addSubview:view];

            favoriteBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2+10, 10, kScreenW/2-20, 40)];
            favoriteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            favoriteBtn.titleEdgeInsets = UIEdgeInsetsMake(20, -20, 20, 00);
            [favoriteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [favoriteBtn setTitle:@"收藏工厂" forState:UIControlStateNormal];
            [favoriteBtn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
            favoriteBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0 ,0 ,kScreenW/2-60);
            [favoriteBtn addTarget:self action:@selector(favoriteBtn) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:favoriteBtn];

        }

        if (indexPath.section == 1) {
            cellImage.image=self.cellImageArray2[indexPath.row];

            switch (indexPath.row) {
                case 0:{
                    cellLabel.text=@"公司名称";
                    cell.detailTextLabel.text=self.factoryModel.factoryName;

                }
                    break;
                case 1:{
                    cellLabel.text=@"公司地址";
                    UILabel*label = [[UILabel alloc]init];
                    label.frame = CGRectMake(110, 7, kScreenW-125, 30);
                    label.font=[UIFont systemFontOfSize:14.0f];

                    label.textAlignment = NSTextAlignmentRight;
                    label.text =  self.factoryModel.factoryAddress;
                    [cell addSubview:label];

                }
                    break;
                case 2:{
                    cellLabel.text=@"公司规模";
                    if (self.factoryModel.factoryType==GarmentFactory) {
                        cell.detailTextLabel.text=[Tools SizeWith:self.factoryModel.factorySize];
                    }else {
                        cell.detailTextLabel.text=self.factoryModel.factorySize;
                    }

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
                case 5:{
                    cellLabel.text=@"公司相册";
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

                }
                    break;
                case 6:{
                    cellLabel.text=@"公司标签";
                    if ([self.factoryModel.tag isEqualToString:@"0"]||[self.factoryModel.tag isEqualToString:@"(null)"]) {
                        cell.detailTextLabel.text=@"暂无标签";
                    }else{
                        cell.detailTextLabel.text=self.factoryModel.tag;
                    }
                }
                    break;

                default:
                    break;
            }
        }
        if (indexPath.section == 2) {

            for (int i = 0; i<3; i++) {
                UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10+i*((kScreenW-90)/3+30), 5, 30 , 30)];
                UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(40+i*((kScreenW-90)/3+30), 5, 80 , 30)];
                cellLabel.font = [UIFont systemFontOfSize:13.0f];
                if (i==0) {

                    if (self.factoryModel.factoryType==1) {
                        imageView.image = self.cellImageArray3[0];
                        if (self.factoryModel.factoryFreeTime) {
                            NSString*timeString=[[Tools WithTime:self.factoryModel.factoryFreeTime] firstObject];
                            cellLabel.text = [NSString stringWithFormat:@" %@",timeString];
                        }
                    }else{
                        if ([self.factoryModel.factoryFreeStatus isEqualToString:@"空闲"]) {
                            imageView.image = self.cellImageArray3[0];
                            cellLabel.text = @" 空闲";

                        }else{
                            imageView.image = self.cellImageArray4[0];
                            cellLabel.text = @" 忙碌";
                        }
                    }
                }
                if (i==1) {

                    if (self.factoryModel.factoryType==1) {
                        if (self.factoryModel.hasTruck==0) {
                            imageView.image = self.cellImageArray3[1];
                            cellLabel.text = @" 有货车";

                        }else{
                            imageView.image = self.cellImageArray4[1];
                            cellLabel.text = @" 无货车";
                            
                        }
                    }else{
                        imageView.hidden=YES;
                        cellLabel.hidden=YES;

                    }

                }
                if (i==2) {
                    if (self.factoryModel.authStatus==2) {
                        imageView.image = self.cellImageArray4[2];
                        cellLabel.text = @" 已认证";

                    }else{
                        imageView.image = self.cellImageArray3[2];
                        cellLabel.text = @" 未认证";

                    }
                }
                [cell addSubview:imageView];


                if (i==0) {

                    if ([self.factoryModel.factoryFreeStatus isEqualToString:@"空闲"]) {
                    }else{
                    }

                }
                if (i==1) {
                }
                if (i==2) {
                    if (self.factoryModel.authStatus==2) {
                    }else{
                    }
                }
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

            UIFont*font=[UIFont systemFontOfSize:14.0f];
            CGSize size = [self.factoryModel.factoryDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 100000) lineBreakMode:NSLineBreakByWordWrapping];
            UILabel*descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 , 25, kScreenW-40, size.height)];
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
    if (section==3) {
        return 5.0f;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==0) {
        return 60;
    }
    if (indexPath.section==3) {
        UIFont*font=[UIFont systemFontOfSize:14];
        CGSize size = [self.factoryModel.factoryDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 100000) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height+30;
    }else{
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1&&indexPath.row==5) {
        DLog(@"相册");
        PhotoViewController* factoryPhotoVC = [[PhotoViewController alloc]init];
        factoryPhotoVC.userUid = [NSString stringWithFormat:@"%d",self.factoryModel.uid];
        [self.navigationController pushViewController:factoryPhotoVC animated:YES];

    }

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
