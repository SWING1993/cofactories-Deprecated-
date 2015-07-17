//
//  MeViewController.m
//  聚工厂
//
//  Created by Mr.song on 15/7/10.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#import "Header.h"
#import "ModelsHeader.h"
#import "MeViewController.h"



@interface MeViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UserModel*userModel;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
//    self.navigationController.navigationBarHidden=YES;

    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(saetButtonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;

    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;



    // 表头视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight)];

    UIImageView*BGImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kBannerHeight-50)];
    BGImage.image=[UIImage imageNamed:@"bb"];
    headerView.backgroundColor=[UIColor whiteColor];
    [headerView addSubview:BGImage];

    [[SDImageCache sharedImageCache] clearDisk];

    UIButton*headerButton=[[UIButton alloc]initWithFrame:CGRectMake(10, kBannerHeight-80, 60, 60)];
    headerButton.backgroundColor=[UIColor blueColor];
    headerButton.layer.cornerRadius=60/2.0f;
    headerButton.layer.masksToBounds=YES;
    [headerButton addTarget:self action:@selector(uploadBtn) forControlEvents:UIControlEventTouchUpInside];


    UILabel*factoryNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, kBannerHeight-45, 80, 20)];
    factoryNameLabel.font=[UIFont boldSystemFontOfSize:18];

    //初始化用户model
    self.userModel=[[UserModel alloc]init];
    [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {
        self.userModel=responseDictionary[@"model"];
        NSLog(@"%@",self.userModel);
        factoryNameLabel.text=self.userModel.factoryName;
        [headerView addSubview:factoryNameLabel];
        [self.tableView reloadData];

        [headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cofactories.bangbang93.com/storage_path/factory_avatar/%d",self.userModel.uid]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"消息头像"]];
        [headerView addSubview:headerButton];
    }];

    UILabel*infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-130, kBannerHeight-25, 120, 20)];
    infoLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    infoLabel.text=@"信息完整度:80%";
    infoLabel.textColor=[UIColor grayColor];
    [headerView addSubview:infoLabel];

    self.tableView.tableHeaderView = headerView;
}

//设置
- (void)saetButtonClicked {

    SetViewController*setVC = [[SetViewController alloc]init];
    setVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setVC animated:YES];

}

- (void)uploadBtn{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Device has no camera"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];

            [alertView show];
        } else {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing = YES;
            imagePickerController.showsCameraControls = YES;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];

            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        return;
    }
    if (buttonIndex == 1) {
        // 相册
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];

        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

#pragma mark <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
//        MBProgressHUD *hud = [Config createHUD];
//        hud.labelText = @"正在上传头像";
//        [[HttpClient sharedInstance] uploadAvatar:UIImageJPEGRepresentation(image, 0.5) andBlock:^(int statusCode) {
//            [hud hide:YES afterDelay:1];
//            //            NSLog(@"%d", statusCode);
//            [((MeHeaderView *)(self.tableView.tableHeaderView)).avatarButton setImage:image forState:UIControlStateNormal];
//        }];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 4;
    }if (section==1) {
        return 5;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:16];
    cell.detailTextLabel.textColor=[UIColor blackColor];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:{
                cell.textLabel.text=@"姓名";
                cell.detailTextLabel.text=self.userModel.name;

            }
                break;
            case 1:{
                cell.textLabel.text=@"电话";
                cell.detailTextLabel.text=self.userModel.phone;

            }
                break;
            case 2:{
                cell.textLabel.text=@"职务";
                cell.detailTextLabel.text=self.userModel.job;

            }
                break;
            case 3:{
                cell.textLabel.text=@"我的收藏";
//                cell.detailTextLabel.text=self.userModel.name;

            }
                break;
                
            default:
                break;
        }
    }
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:{
                cell.textLabel.text=@"公司名称";
                cell.detailTextLabel.text=self.userModel.factoryName;

            }
                break;
            case 1:{
                cell.textLabel.text=@"公司地址";
                cell.detailTextLabel.text=self.userModel.factoryAddress;

            }
                break;
            case 2:{
                cell.textLabel.text=@"公司规模";
                cell.detailTextLabel.text=self.userModel.factorySize;

            }
                break;
            case 3:{
                cell.textLabel.text=@"业务类型";
                cell.detailTextLabel.text=self.userModel.factoryServiceRange;

            }
                break;
            case 4:{
                cell.textLabel.text=@"公司相册";
                //                cell.detailTextLabel.text=self.userModel.name;

            }
                break;

            default:
                break;
        }
    }
    if (indexPath.section == 2) {



    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0.01f;
    }
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
    CGSize size = [[UIScreen mainScreen] bounds].size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 0.01f)];
    //view.backgroundColor = [UIColor colorWithHex:0xf0efea];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section==2) {
        return 200;
    }else{
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.section) {
        case 0:{
            switch (indexPath.row) {
                case 0:{

                }
                    break;
                case 1:{

                }
                    break;
                case 2:{

                }
                    break;
                case 3:{

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

                }
                    break;
                case 1:{
                    NSLog(@"修改地址");
                    SetaddressViewController*setaddressVC = [[SetaddressViewController alloc]init];
                    setaddressVC.hidesBottomBarWhenPushed=YES;
                    [self.navigationController pushViewController:setaddressVC animated:YES];

                }
                    break;
                case 2:{

                }
                    break;
                case 3:{

                }
                    break;

                default:
                    break;
            }

        }
            break;
        case 2:{

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
