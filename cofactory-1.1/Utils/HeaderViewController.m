//
//  HeaderViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/8/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "HeaderViewController.h"


@interface HeaderViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {

    UIImageView*headerView;
}

@end

@implementation HeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"头像";

    self.view.backgroundColor = [UIColor whiteColor];

    UIButton*uploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, kScreenW+(kScreenH-kScreenW)/2-35-64, kScreenW-60, 35)];
    if (iphone4x_3_5) {
        uploadBtn.frame = CGRectMake(30, kScreenW+(kScreenH-kScreenW)/2-45-64, kScreenW-60, 35);
    }
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadBtn setTitle:@"更换头像" forState:UIControlStateNormal];
    [uploadBtn setBackgroundColor:[UIColor colorWithHexString:@"0x3bbc79"]];
    [uploadBtn addTarget:self action:@selector(clickUploadBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadBtn];

    UIButton*backBtn = [[UIButton alloc]initWithFrame:CGRectMake(30, kScreenW+(kScreenH-kScreenW)/2+35-64, kScreenW-60, 35)];
    if (iphone4x_3_5) {
        backBtn.frame = CGRectMake(30, kScreenW+(kScreenH-kScreenW)/2+20-64, kScreenW-60, 35);
    }
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setBackgroundColor:[UIColor colorWithHexString:@"0x3bbc79"]];
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];



    headerView = [[UIImageView alloc]init];
    headerView.frame = CGRectMake(kScreenW/2-40, 30+64, 80, 80);
    headerView.layer.cornerRadius = 80/2.0f;
    headerView.layer.masksToBounds = YES;
    [headerView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,self.uid]] placeholderImage:[UIImage imageNamed:@"消息头像"]];
    DLog(@"头像地址：%@",[NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,self.uid]);
    [self.view addSubview:headerView];


    double delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.4f];
        [UIView setAnimationDelegate:self];
        headerView.frame = CGRectMake(0, 0, kScreenW, kScreenW);
        headerView.layer.cornerRadius = 0;
        [UIView commitAnimations];
        
    });
}

- (void)clickUploadBtn {


    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    //    [actionSheet setTintColor:[UIColor colorWithHexString:@"0x3bbc79"]];

//    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
//
//    if ([window.subviews containsObject:self.view]) {
//        [actionSheet showInView:self.view];
//        DLog(@"actionSheet showInView:self.view");
//    } else {
//        [actionSheet showInView:window];
//        DLog(@"actionSheet showInView:window");
//    }
    [actionSheet showInView:self.view];

//    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)backBtn {

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4f];
    [UIView setAnimationDelegate:self];
    headerView.frame = CGRectMake(kScreenW/2-40, 30+64, 80, 80);
    headerView.layer.cornerRadius = 80/2.0f;
    [UIView commitAnimations];

    double delayInSeconds = 0.4;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self dismissViewControllerAnimated:YES completion:nil];
    });

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) {

        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [Tools showHudTipStr:@"设备没有相机"];
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
    NSData*imageData = UIImageJPEGRepresentation(image, 0.2);
    UIImage*newImage = [[UIImage alloc]initWithData:imageData];
    [picker dismissViewControllerAnimated:YES completion:^{
        [HttpClient uploadImageWithImage:newImage type:@"avatar" andblock:^(NSDictionary *dictionary) {
            if ([dictionary[@"statusCode"] intValue]==200) {
                [Tools showHudTipStr:@"头像上传成功,但是头像显示会略有延迟。"];
                headerView.image = image;
            }
        }];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
