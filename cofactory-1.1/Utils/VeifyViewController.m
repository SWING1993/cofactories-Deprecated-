//
//  VeifyViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/20.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "VeifyViewController.h"

@interface VeifyViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,retain)NSArray*cellArray;

@property (nonatomic, assign) int imageType;

@property (nonatomic, retain) NSMutableArray*imageArray;


@end

@implementation VeifyViewController {

    UITextField*textField1;
    UITextField*textField2;
    UITextField*textField3;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"企业认证";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    self.cellArray = @[@"公司名称:",@"法人姓名:",@"身份证号:",@"营业执照:",@"身份证照片:",@"公司形象:",];
    self.imageArray = [[NSMutableArray alloc]initWithCapacity:0];


    textField1=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenW-110, 34)];
    textField1.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField1.borderStyle=UITextBorderStyleRoundedRect;
    textField1.placeholder=@"输入公司名称";

    textField2=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenW-110, 34)];
    textField2.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField2.borderStyle=UITextBorderStyleRoundedRect;
    textField2.placeholder=@"输入法人姓名";

    textField3=[[UITextField alloc]initWithFrame:CGRectMake(100, 5, kScreenW-110, 34)];
    textField3.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField3.borderStyle=UITextBorderStyleRoundedRect;
    textField3.keyboardType=UIKeyboardTypeASCIICapable;
    textField3.placeholder=@"输入身份证号码";

    UIButton*ReviseBtn=[[UIButton alloc]initWithFrame:CGRectMake(20, 280, kScreenW-40, 35)];
    [ReviseBtn setTitle:@"提交认证" forState:UIControlStateNormal];
    [ReviseBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [ReviseBtn addTarget:self action:@selector(RevisePasswordBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:ReviseBtn];
}

- (void)RevisePasswordBtn {
    if (textField1.text.length!=0&&textField2.text.length!=0&&textField3.text.length!=0) {
        if (textField3.text.length!=18) {
            UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"身份证信息不完整" message:nil
                                                             delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }else{

            [HttpClient submitVerifyDetailWithLegalPerson:textField2.text idCard:textField3.text andBlock:^(int statusCode) {
                NSLog(@"%d",statusCode);
                switch (statusCode) {
                    case 200:
                    {
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"认证提交成功" message:nil
                                                                         delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                    }
                        break;
                    case 400:
                    {
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"未登录" message:nil
                                                                         delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                    }
                        break;
                    case 409:
                    {
                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"已经认证或者正在认证，不能修改。" message:nil
                                                                         delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alertView show];
                    }
                        break;


                    default:
                        break;
                }
            }];
        }
    }else{
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"认证信息不完整" message:nil
                                                         delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
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
            cell.textLabel.text=self.cellArray[indexPath.row+3];
            switch (indexPath.row) {
                case 0:
                {
                    if (self.imageType==0) {
                        UIImageView *cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-54, 0, 44, 44)];
                        cellImage.image=[self.imageArray lastObject];
                        [cell addSubview:cellImage];
                    }

                }
                    break;
                case 1:
                {
                    if (self.imageType==1) {
                        UIImageView *cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-54, 0, 44, 44)];
                        cellImage.image=[self.imageArray lastObject];
                        [cell addSubview:cellImage];
                    }

                }
                    break;
                case 2:
                {
                    if (self.imageType==2) {
                        UIImageView *cellImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-54, 0, 44, 44)];
                        cellImage.image=[self.imageArray lastObject];
                        [cell addSubview:cellImage];
                    }

                }
                    break;

                default:
                    break;
            }

        }
            break;

        default:
            break;
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
    if (indexPath.section==1) {
        self.imageType = indexPath.row;
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
        [actionSheet showInView:self.view];
    }
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
    UIImage*image;
    image = info[UIImagePickerControllerEditedImage];
    [self.imageArray addObject:image];
    [picker dismissViewControllerAnimated:YES completion:^{
        NSIndexPath *te=[NSIndexPath indexPathForRow:self.imageType inSection:1];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationNone];
        [self updatePortrait];
    }];
}

- (void)updatePortrait {
    switch (self.imageType) {
        case 0:
        {
            [HttpClient uploadVerifyImage:[self.imageArray lastObject] type:@"idCard" andblock:^(NSDictionary *dictionary) {
                if ([dictionary[@"statusCode"] intValue]==200) {
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"上传成功" message:nil
                delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                };
            }];
        }
            break;

        case 1:
        {
            [HttpClient uploadVerifyImage:[self.imageArray lastObject] type:@"license" andblock:^(NSDictionary *dictionary) {
                if ([dictionary[@"statusCode"] intValue]==200) {
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"上传成功" message:nil
                                                                     delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                };
            }];

        }
            break;

        case 2:
        {
            [HttpClient uploadVerifyImage:[self.imageArray lastObject] type:@"photo" andblock:^(NSDictionary *dictionary) {
                if ([dictionary[@"statusCode"] intValue]==200) {
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"上传成功" message:nil
                                                                     delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                };
            }];
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
