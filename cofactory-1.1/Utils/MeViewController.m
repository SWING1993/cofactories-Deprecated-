//
//  MeViewController.m
//  聚工厂
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "MeViewController.h"
#import "SettingTagsViewController.h"

@interface MeViewController ()<UIAlertViewDelegate>


//公司规模数组
@property(nonatomic,retain)NSArray*sizeArray;

//公司业务类型数组
@property (nonatomic,retain)NSArray*serviceRangeArray;


//单元格imageArray
@property (nonatomic,retain)NSArray*cellImageArray1;
@property (nonatomic,retain)NSArray*cellImageArray2;




@end

@implementation MeViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    FactoryRangeModel*rangeModel = [[FactoryRangeModel alloc]init];

    //初始化用户model
    self.userModel=[[UserModel alloc]init];
    [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {

        self.userModel=responseDictionary[@"model"];

        if (self.userModel.factoryType==GarmentFactory) {
            DLog(@"---服装厂");
            self.sizeArray=rangeModel.allFactorySize[0];
            self.serviceRangeArray=rangeModel.allServiceRange[0];
        }
        if (self.userModel.factoryType==ProcessingFactory) {
            DLog(@"---加工厂");
            self.sizeArray=rangeModel.allFactorySize[1];
            self.serviceRangeArray=rangeModel.allServiceRange[1];

        }
        if (self.userModel.factoryType==CuttingFactory) {
            DLog(@"---代裁厂");
            self.sizeArray=rangeModel.allFactorySize[2];
        }
        if (self.userModel.factoryType==LockButtonFactory) {
            DLog(@"---锁眼厂");
            self.sizeArray=rangeModel.allFactorySize[3];
        }

        //刷新tableview
        [self.tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor=[UIColor whiteColor];
//    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];

    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH+240) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    self.cellImageArray1=@[[UIImage imageNamed:@"set_人名"],[UIImage imageNamed:@"set_号码"],[UIImage imageNamed:@"set_职务 "],[UIImage imageNamed:@"set_收藏"],[UIImage imageNamed:@"set_标签"]];
    self.cellImageArray2=@[[UIImage imageNamed:@"set_名称"],[UIImage imageNamed:@"set_公司地址"],[UIImage imageNamed:@"set_公司规模"],[UIImage imageNamed:@"set_公司相册"],[UIImage imageNamed:@"set_公司业务类型"]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        if (self.userModel.factoryType == GarmentFactory) {
            return 4;
        }else{
            return 5;
        }
    }if (section==1) {
        if (self.userModel.factoryType==GarmentFactory||self.userModel.factoryType==ProcessingFactory) {
            return 5;
        }else{
            return 4;
        }
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:14.0f];
    cell.detailTextLabel.textColor=[UIColor blackColor];

    UIImageView*cellImage= [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
    UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, kScreenW-40, 30)];
    cellLabel.font=[UIFont systemFontOfSize:15.0f];

    if (indexPath.section == 0) {
        cellImage.image=self.cellImageArray1[indexPath.row];

        switch (indexPath.row) {
            case 0:{
                cellLabel.text=@"姓名";
                cell.detailTextLabel.text=self.userModel.name;

            }
                break;
            case 1:{
                cellLabel.text=@"电话";
                cell.detailTextLabel.text=self.userModel.phone;
                [cell setAccessoryType:UITableViewCellAccessoryNone];

            }
                break;
            case 2:{
                cellLabel.text=@"职务";
                cell.detailTextLabel.text=self.userModel.job;


            }
                break;
            case 3:{
                cellLabel.text=@"我的收藏";

            }
                break;
            case 4:{
                cellLabel.text=@"个性标签";
                if ([self.userModel.tag isEqualToString:@"0"]||[self.userModel.tag isEqualToString:@"(null)"]) {
                    cell.detailTextLabel.text = @"暂无标签";
                }else{
                    cell.detailTextLabel.text =  self.userModel.tag;
                }
            }
                break;

            default:
                break;
        }
    }
    if (indexPath.section == 1) {

        cellImage.image=self.cellImageArray2[indexPath.row];

        switch (indexPath.row) {
            case 0:{
                cellLabel.text=@"公司名称";
                cell.detailTextLabel.text=self.userModel.factoryName;

            }
                break;
            case 1:{
                cellLabel.text=@"公司地址";

//                cell.detailTextLabel.text=self.userModel.factoryAddress;
                UILabel*label = [[UILabel alloc]init];
                label.frame = CGRectMake(110, 7, kScreenW-145, 30);
                label.font=[UIFont systemFontOfSize:14.0f];

                label.textAlignment = NSTextAlignmentRight;
                label.text =  self.userModel.factoryAddress;
                [cell addSubview:label];

            }
                break;
            case 2:{
                cellLabel.text=@"公司规模";

                if (self.userModel.factoryType==GarmentFactory) {
                    cell.detailTextLabel.text=[Tools SizeWith:self.userModel.factorySize];
                }else {
                    cell.detailTextLabel.text=self.userModel.factorySize;
                }
            }
                break;
            case 3:{
                cellLabel.text=@"公司相册";

            }
                break;
            case 4:{
                cellLabel.text=@"业务类型";
                cell.detailTextLabel.text=self.userModel.factoryServiceRange;
            }
                break;

            default:
                break;
        }
    }
    if (indexPath.section == 2) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, kScreenW, 20)];
        titleLabel.text=@"公司简介";
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.font=[UIFont systemFontOfSize:16.0f];
        [cell addSubview:titleLabel];


        UIFont*font=[UIFont systemFontOfSize:14];

        CGSize size = [self.userModel.factoryDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 100000) lineBreakMode:NSLineBreakByWordWrapping];
        UILabel*descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 , 25, kScreenW-40, size.height)];
        descriptionLabel.text=self.userModel.factoryDescription;
        descriptionLabel.font=[UIFont systemFontOfSize:14.0f];
        descriptionLabel.numberOfLines=0;
        [cell addSubview:descriptionLabel];
    }
    [cell addSubview:cellLabel];
    [cell addSubview:cellImage];
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0.01f;
    }
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==3) {
        return 5.0f;
    }
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.01f)];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==2) {
        UIFont*font=[UIFont systemFontOfSize:14];
        CGSize size = [self.userModel.factoryDescription sizeWithFont:font constrainedToSize:CGSizeMake(280, 100000) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height+40;
    }else{
        return 44;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        if (alertView.tag==99) {
            [ViewController goLogin];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([Tools isTourist]) {
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"您目前的身份是游客，是否进行登录注册" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag=99;
        [alertView show];
    }else{
        switch (indexPath.section) {
            case 0:{
                switch (indexPath.row) {
                    case 0:{
                        ModifyNameViewController*modifyNameVC = [[ModifyNameViewController alloc]init];
                        modifyNameVC.placeholder=self.userModel.name;
                        modifyNameVC.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:modifyNameVC animated:YES];
                    }
                        break;
                    case 1:{

                        //电话 账号

                    }
                        break;
                    case 2:{
                        ModifyJobViewController*modifyJobVC = [[ModifyJobViewController alloc]init];
                        modifyJobVC.placeholder=self.userModel.job;
                        modifyJobVC.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:modifyJobVC animated:YES];
                    }
                        break;
                    case 3:{
                        FavoriteViewController*favoriteVC = [[FavoriteViewController alloc]init];
                        favoriteVC.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:favoriteVC animated:YES];
                    }
                        break;
                    case 4:{
                        SettingTagsViewController*tagsVC = [[SettingTagsViewController alloc]init];
                        if (self.userModel.factoryType==ProcessingFactory) {
                            //加工
                            tagsVC.allTags = @[@"包工",@"包工包料",@"流水线生产",@"整件生产",@"工价低"];
                        }else if (self.userModel.factoryType==CuttingFactory){
                            //代裁厂
                            tagsVC.allTags = @[@"排版好",@"工期快",@"设备齐全",@"节省布料"];
                        }
                        else{
                            //锁眼钉扣
                            tagsVC.allTags = @[@"时间短",@"钉扣类型多"];
                        }
                        tagsVC.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:tagsVC animated:YES];
                    }
                        break;

                    default:
                        break;
                }
            }
                break;
            case 1:{
                switch (indexPath.row) {
                    case 0:{
                        ModifyFactoryNameViewController*modifyFactoryNameVC = [[ModifyFactoryNameViewController alloc]init];
                        modifyFactoryNameVC.placeholder=self.userModel.factoryName;
                        modifyFactoryNameVC.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:modifyFactoryNameVC animated:YES];
                    }
                        break;
                    case 1:{
                        SetaddressViewController*setaddressVC = [[SetaddressViewController alloc]init];
//                        setaddressVC.placeholder=self.userModel.factoryAddress;
                        setaddressVC.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:setaddressVC animated:YES];
                    }
                        break;
                    case 2:{
                        ModifySizeViewController*sizeVC = [[ModifySizeViewController alloc]init];
                        if (self.userModel.factoryType==GarmentFactory) {
                            sizeVC.placeholder=[Tools SizeWith:self.userModel.factorySize];
                        }else {
                            sizeVC.placeholder=self.userModel.factorySize;
                        }
                        sizeVC.cellPickList=self.sizeArray;
                        sizeVC.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:sizeVC animated:YES];
                    }
                        break;
                    case 3:{
                        PhotoViewController*photoVC = [[PhotoViewController alloc]init];
                        photoVC.userUid=[NSString stringWithFormat:@"%d",self.userModel.uid];
                        photoVC.isMySelf = YES;
                        photoVC.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:photoVC animated:YES];
                    }
                        break;
                    case 4:{
                        ModifyServiceRangeViewController*rangeVC = [[ModifyServiceRangeViewController alloc]init];
                        rangeVC.cellPickList=self.serviceRangeArray;
                        rangeVC.placeholder=self.userModel.factoryServiceRange;
                        rangeVC.hidesBottomBarWhenPushed=YES;
                        [self.navigationController pushViewController:rangeVC animated:YES];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
                break;
            case 2:{
                DescriptionViewController*descriptionVC = [[DescriptionViewController alloc]init];
                descriptionVC.placeholder = self.userModel.factoryDescription;
                descriptionVC.hidesBottomBarWhenPushed=YES;
                [self.navigationController pushViewController:descriptionVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}
//- (void)dealloc
//{
//    DLog(@"释放内存");
//    self.tableView.dataSource = nil;
//    self.tableView.delegate = nil;
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
