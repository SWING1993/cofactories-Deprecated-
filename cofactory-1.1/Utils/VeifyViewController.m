//
//  VeifyViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/20.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "VeifyViewController.h"

@interface VeifyViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,retain)NSArray*cellArray;

@property (nonatomic, assign) NSInteger imageType;

@property (nonatomic, retain) NSMutableArray*imageArray;

@property (nonatomic, strong) UICollectionView *collectionView;

////@property (nonatomic, strong) NSMutableArray *collectionImage;
//
//@property (nonatomic, strong) UIImageView*imageView1;
//
//@property (nonatomic, strong) UIImageView*imageView2;
//
//@property (nonatomic, strong) UIImageView*imageView3;


@end

@implementation VeifyViewController {

    UITextField*textField1;
    UITextField*textField2;
    UITextField*textField3;

    UIImageView*imageView1;
    UIImageView*imageView2;
    UIImageView*imageView3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"企业认证";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    self.cellArray = @[@"公司名称:",@"法人姓名:",@"身份证号:",@"营业执照",@"身份证照片",@"公司形象",];
    self.imageArray = [[NSMutableArray alloc]initWithCapacity:0];


    textField1=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenW-110, 34)];
    textField1.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField1.borderStyle=UITextBorderStyleNone;
    textField1.font = kFont;
    textField1.placeholder=@"输入公司名称";

    textField2=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenW-110, 34)];
    textField2.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField2.borderStyle=UITextBorderStyleNone;
    textField2.font = kFont;
    textField2.placeholder=@"输入法人姓名";

    textField3=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenW-110, 34)];
    textField3.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField3.borderStyle=UITextBorderStyleNone;
    textField3.keyboardType=UIKeyboardTypeASCIICapable;
    textField3.font = kFont;
    textField3.placeholder=@"输入身份证号码";

    imageView1 = [[UIImageView alloc]init];
//    imageView1.userInteractionEnabled = YES;
    imageView1.image = [UIImage imageNamed:@"添加图片"];
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    imageView1.clipsToBounds = YES;


    imageView2 = [[UIImageView alloc]init];
//    imageView2.userInteractionEnabled = YES;
    imageView2.image = [UIImage imageNamed:@"添加图片"];
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    imageView2.clipsToBounds = YES;


    imageView3 = [[UIImageView alloc]init];
//    imageView3.userInteractionEnabled = YES;
    imageView3.contentMode = UIViewContentModeScaleAspectFill;
    imageView3.image = [UIImage imageNamed:@"添加图片"];
    imageView3.clipsToBounds = YES;


    UIView * tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    blueButton*ReviseBtn=[[blueButton alloc]initWithFrame:CGRectMake(20, 15, kScreenW-40, 35)];;
    [ReviseBtn setTitle:@"提交认证" forState:UIControlStateNormal];
    [ReviseBtn addTarget:self action:@selector(RevisePasswordBtn) forControlEvents:UIControlEventTouchUpInside];
    [tableFooterView addSubview:ReviseBtn];
    self.tableView.tableFooterView = tableFooterView;

    //backBtn
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goback {
    NSArray*navArr = self.navigationController.viewControllers;
    [self.navigationController popToViewController:navArr[0] animated:YES];
}

- (void)RevisePasswordBtn {
    if (textField1.text.length!=0||textField2.text.length!=0||textField3.text.length!=0) {
        if (textField3.text.length!=18) {
            [Tools showErrorWithStatus:@"身份证信息不完整!"];

        }else if ([self.imageArray count]<3) {
            [Tools showErrorWithStatus:@"照片信息不完整!"];
            
        }else{

            [HttpClient submitVerifyDetailWithLegalPerson:textField2.text idCard:textField3.text andBlock:^(int statusCode) {
                DLog(@"%d",statusCode);
                switch (statusCode) {
                    case 200:
                    {
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"认证提交成功" message:nil
                                                                         delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        alertView.tag = 10065;
                        [alertView show];
                    }
                        break;
                    case 400:
                    {
                        [Tools showErrorWithStatus:@"未登录"];
                    }
                        break;
                    case 409:
                    {
                        [Tools showShimmeringString:@"已经认证或者正在认证，不能修改。"];
                    }
                        break;


                    default:
                        [Tools showErrorWithStatus:@"提交失败，尝试修改信息重新提交！"];
                        break;
                }
            }];
        }
    }else{
        [Tools showErrorWithStatus:@"认证信息不完整！"];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10065) {
        if (buttonIndex == 0) {
            NSArray *navArray = self.navigationController.viewControllers;
            [self.navigationController popToViewController:[navArray firstObject] animated:YES];
        }
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];

    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.textLabel.font = kFont;
    switch (indexPath.section) {
        case 0:
        {
            cell.textLabel.text=self.cellArray[indexPath.row];
            switch (indexPath.row) {
                case 0:
                {
                    [cell addSubview:textField1];
                }
                    break;
                case 1:
                {
                    [cell addSubview:textField2];
                }
                    break;
                case 2:
                {
                    [cell addSubview:textField3];
                }
                    break;

                default:
                    break;
            }
        }

            break;
        case 1:
        {

            [cell addSubview:self.collectionView];

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    }else
        return kScreenW/3;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section==1) {
//        self.imageType = indexPath.row;
//        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
//        [actionSheet showInView:self.view];
//    }
//}

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
    UIImage*image;
    image = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image,0.00001);
    UIImage*newImage = [UIImage imageWithData:imageData];
    [self.imageArray addObject:newImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSIndexPath *te=[NSIndexPath indexPathForRow:self.imageType-1 inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:te,nil] ];
//         reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationNone];
//        [self.collectionView reloadData];
        [self updatePortrait];
    }];
}

- (void)updatePortrait {
    switch (self.imageType) {
        case 1:
        {
            DLog(@"license");
            [HttpClient uploadVerifyImage:[self.imageArray lastObject] type:@"license" andblock:^(NSDictionary *dictionary) {
                if ([dictionary[@"statusCode"] intValue]==200) {
                    [Tools showSuccessWithStatus:@"上传成功"];
                }else{
                    [Tools showErrorWithStatus:@"上传失败"];
                }

            }];
        }
            break;

        case 2:
        {
            DLog(@"idCard");
            [HttpClient uploadVerifyImage:[self.imageArray lastObject] type:@"idCard" andblock:^(NSDictionary *dictionary) {
                if ([dictionary[@"statusCode"] intValue]==200) {
                    [Tools showSuccessWithStatus:@"上传成功"];
                }else{
                    [Tools showErrorWithStatus:@"上传失败"];
                }
            }];

        }
            break;

        case 3:
        {
            DLog(@"photo")
            [HttpClient uploadVerifyImage:[self.imageArray lastObject] type:@"photo" andblock:^(NSDictionary *dictionary) {
                if ([dictionary[@"statusCode"] intValue]==200) {
                    [Tools showSuccessWithStatus:@"上传成功"];
                }else{
                    [Tools showErrorWithStatus:@"上传失败"];
                }
            }];
        }
            break;

        default:
            break;
    }
}


#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/3

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 2.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenW/3) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];

        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];

    UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 20)];
    cellLabel.backgroundColor = [UIColor blackColor];
    cellLabel.alpha = 0.8f;
    cellLabel.textAlignment = NSTextAlignmentCenter;
    cellLabel.font = kFont;
    cellLabel.textColor = [UIColor whiteColor];

    switch (indexPath.row) {
        case 0:
        {
            cellLabel.text = self.cellArray[3];

            imageView1.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            if (self.imageType==1) {
                imageView1.image=[self.imageArray lastObject];
            }
            [cell addSubview:imageView1];

        }
            break;
        case 1:
        {
            cellLabel.text = self.cellArray[4];

            imageView2.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);

            if (self.imageType==2) {

                imageView2.image=[self.imageArray lastObject];
            }
            [cell addSubview:imageView2];

        }
            break;
        case 2:
        {
            cellLabel.text = self.cellArray[5];

            imageView3.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);

            if (self.imageType==3) {
                imageView3.image=[self.imageArray lastObject];
            }
            [cell addSubview:imageView3];

        }
            break;

        default:
            break;
    }
    [cell addSubview:cellLabel];

    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.imageType = indexPath.row+1;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
