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
#import "HeaderViewController.h"

@interface MeViewController ()<UIAlertViewDelegate,UIScrollViewDelegate>


//公司规模数组
@property(nonatomic,retain)NSArray*sizeArray;
//公司业务类型数组
@property (nonatomic,retain)NSArray*serviceRangeArray;

//单元格imageArray
@property (nonatomic,retain)NSArray*cellImageArray1;
@property (nonatomic,retain)NSArray*cellImageArray2;

//用户模型
@property (nonatomic, strong) UserModel*userModel;

//身份类型
@property (nonatomic, assign) NSInteger factoryType;


@end

@implementation MeViewController {
    UIImageView *imageBG;
    UIView *BGView;

    UILabel*factoryNameLabel;

    UILabel*infoLabel;

    UIButton*headerButton;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


    NSString *homePath = NSHomeDirectory();

    DLog(@"Home目录：%@",homePath);

    DLog(@"缓存%lu",(unsigned long)[[SDImageCache sharedImageCache] getSize]);

    [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {

        self.userModel=responseDictionary[@"model"];
        //更新公司名称label.text
        factoryNameLabel.text=self.userModel.factoryName;
        //更新信息完整度
        int FinishedDegree = self.userModel.factoryFinishedDegree;
        infoLabel.text = [NSString stringWithFormat:@"信息完整度为%d%s",FinishedDegree,"%"];
        [headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,self.userModel.uid]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"消息头像"]];

        //刷新tableview
        [self.tableView reloadData];
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //初始化用户model
    self.userModel=[[UserModel alloc]init];
    self.factoryType = kFactoryType;
    DLog(@"kFactoryType = %ld",kFactoryType);
    [self getArrayData];

    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    //设置Btn
    UIBarButtonItem*setButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"settingBtn_Nav"] style:UIBarButtonItemStylePlain target:self action:@selector(saetButtonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;


    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH+240) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    self.cellImageArray1=@[[UIImage imageNamed:@"set_人名"],[UIImage imageNamed:@"set_号码"],[UIImage imageNamed:@"set_职务 "],[UIImage imageNamed:@"set_收藏"],[UIImage imageNamed:@"set_标签"]];
    self.cellImageArray2=@[[UIImage imageNamed:@"set_名称"],[UIImage imageNamed:@"set_公司地址"],[UIImage imageNamed:@"set_公司规模"],[UIImage imageNamed:@"set_公司相册"],[UIImage imageNamed:@"set_公司业务类型"]];


    BGView=[[UIView alloc]init];
    BGView.backgroundColor=[UIColor clearColor];
    BGView.frame=CGRectMake(0, 0, kScreenW, 200);

    imageBG=[[UIImageView alloc]init];
    imageBG.frame=CGRectMake(0, 0, kScreenW, 200);
    imageBG.image=[UIImage imageNamed:@"headerView"];

    headerButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2-40, 80-64, 80, 80)];
    headerButton.layer.cornerRadius=80/2.0f;
    headerButton.layer.masksToBounds=YES;
    headerButton.layer.borderWidth=0.3f;
    headerButton.layer.borderColor=[UIColor blackColor].CGColor;
    [headerButton addTarget:self action:@selector(uploadBtn) forControlEvents:UIControlEventTouchUpInside];


    factoryNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 180-60, kScreenW, 20)];
    factoryNameLabel.font=[UIFont boldSystemFontOfSize:16];
    factoryNameLabel.textAlignment = NSTextAlignmentCenter;
    factoryNameLabel.textColor = [UIColor whiteColor];

    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 180-30, kScreenW, 20)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font=[UIFont systemFontOfSize:14.0f];
    infoLabel.textColor=[UIColor whiteColor];

    [BGView addSubview:imageBG];
    [BGView addSubview:headerButton];
    [BGView addSubview:factoryNameLabel];
    [BGView addSubview:infoLabel];

    self.tableView.tableHeaderView = BGView;

}
- (void)getArrayData {
    FactoryRangeModel*rangeModel = [[FactoryRangeModel alloc]init];
    if (self.factoryType == GarmentFactory) {
        DLog(@"---服装厂");
        self.sizeArray=rangeModel.allFactorySize[0];
        self.serviceRangeArray=rangeModel.allServiceRange[0];
    }
    if (self.factoryType == ProcessingFactory) {
        DLog(@"---加工厂");
        self.sizeArray=rangeModel.allFactorySize[1];
        self.serviceRangeArray=rangeModel.allServiceRange[1];

    }
    if (self.factoryType == CuttingFactory) {
        DLog(@"---代裁厂");
        self.sizeArray=rangeModel.allFactorySize[2];
    }
    if (self.factoryType ==LockButtonFactory) {
        DLog(@"---锁眼厂");
        self.sizeArray=rangeModel.allFactorySize[3];
    }
}


#pragma mark - 设置
- (void)saetButtonClicked {
    SetViewController*setVC = [[SetViewController alloc]init];
    setVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setVC animated:YES];
}

#pragma mark - 头像Button
- (void)uploadBtn{
    HeaderViewController*headerVC = [[HeaderViewController alloc]init];
    headerVC.uid=self.userModel.uid;
    UINavigationController*headerNav = [[UINavigationController alloc]initWithRootViewController:headerVC];
    headerNav.navigationBar.barStyle=UIBarStyleBlack;
    headerNav.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:headerNav animated:YES completion:nil];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        if (self.factoryType == GarmentFactory || self.factoryType==materialFactory) {
            return 4;
        }else{
            return 5;
        }
    }if (section==1) {
        if (self.factoryType==GarmentFactory||self.factoryType==ProcessingFactory) {
            return 5;
        }if (self.factoryType==materialFactory) {
            return 3;
        }
        else{
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
    cell.detailTextLabel.font=kFont;
    cell.detailTextLabel.textColor=[UIColor blackColor];

    UIImageView*cellImage= [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 30, 30)];
    UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, kScreenW-40, 30)];
    cellLabel.font=kFont;

    if (indexPath.section == 0) {

//        CGSize itemSize = CGSizeMake(30, 30);
//
//        UIGraphicsBeginImageContext(itemSize);
//
//        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//
//        [self.cellImageArray1[indexPath.row] drawInRect:imageRect];
//
//        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();

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
                UILabel*label = [[UILabel alloc]init];
                label.frame = CGRectMake(110, 7, kScreenW-145, 30);
                label.font=kFont;
                label.textAlignment = NSTextAlignmentRight;
                label.text =  self.userModel.factoryAddress;
                [cell addSubview:label];

            }
                break;
            case 2:{

                cellLabel.text=@"公司相册";

            }
                break;
            case 3:{

                cellLabel.text=@"公司规模";
                cell.detailTextLabel.text=self.userModel.factorySize;
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
        titleLabel.font=kLargeFont;
        [cell addSubview:titleLabel];
        NSString*factoryDescription = [NSString stringWithFormat:@"%@",self.userModel.factoryDescription];
        CGSize size = [Tools getSize:factoryDescription andFontOfSize:14.0f];
        UILabel*descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 , 25, kScreenW-40, size.height)];
        descriptionLabel.text=self.userModel.factoryDescription;
        descriptionLabel.font=kFont;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==2) {
        CGSize size = [Tools getSize:[NSString stringWithFormat:@"%@",self.userModel.factoryDescription] andFontOfSize:14.0f];
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
                    if (self.factoryType==ProcessingFactory) {
                        //加工
                        tagsVC.allTags = @[@"包工",@"包工包料",@"流水线生产",@"整件生产",@"工价低"];
                    }
                    if (self.factoryType==CuttingFactory){
                        //代裁厂
                        tagsVC.allTags = @[@"排版好",@"工期快",@"设备齐全",@"节省布料"];
                    }
                    if (self.factoryType == LockButtonFactory) {
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
                    setaddressVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:setaddressVC animated:YES];
                }
                    break;
                case 2:{
                    PhotoViewController*photoVC = [[PhotoViewController alloc]init];
                    photoVC.userUid=[NSString stringWithFormat:@"%d",self.userModel.uid];
                    photoVC.isMySelf = YES;
                    photoVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:photoVC animated:YES];

                }
                    break;
                case 3:{
                    ModifySizeViewController*sizeVC = [[ModifySizeViewController alloc]init];
                    sizeVC.placeholder=self.userModel.factorySize;
                    sizeVC.cellPickList=self.sizeArray;
                    sizeVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:sizeVC animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark tableHeaderView 拉伸
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset )/2;

    if (yOffset < 0) {

        CGRect rect = imageBG.frame;
        rect.origin.y = yOffset;
        rect.size.height =  200-yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = kScreenW + fabs(xOffset)*2;

        imageBG.frame = rect;
    }
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);

    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}



@end
