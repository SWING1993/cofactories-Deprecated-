//
//  MeController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/8/22.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "MeController.h"
#import "TYSlidePageScrollView.h"
#import "MeViewController.h"
#import "TYTitlePageTabBar.h"
#import "UINavigationBar+Awesome.h"

@interface MeController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,TYSlidePageScrollViewDataSource,TYSlidePageScrollViewDelegate>

@property (nonatomic, weak) TYSlidePageScrollView *slidePageScrollView;

//@property (nonatomic ,strong) UIButton *selectBtn;
//用户模型
@property (nonatomic, strong) UserModel*userModel;

@end

#define kNavBarHeight 64

@implementation MeController {
    UILabel*factoryNameLabel;

    UILabel*infoLabel;

    UIButton*headerButton;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.userModel=[[UserModel alloc]init];
    [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {

        self.userModel=responseDictionary[@"model"];

        //更新公司名称label.text
        factoryNameLabel.text=self.userModel.factoryName;

        //更新信息完整度
        int FinishedDegree = self.userModel.factoryFinishedDegree;
        infoLabel.text = [NSString stringWithFormat:@"信息完整度为%d%s",FinishedDegree,"%"];

        [headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,self.userModel.uid]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"消息头像"]];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //    [self.navigationController.navigationBar lt_reset];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.userModel=[[UserModel alloc]init];

    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(saetButtonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;


    [self addSlidePageScrollView];

    [self addHeaderView];



    [self addTableViewWithPage:0 itemNum:0];



    [_slidePageScrollView reloadData];
}
//设置
- (void)saetButtonClicked {

    SetViewController*setVC = [[SetViewController alloc]init];
    setVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:setVC animated:YES];
    
}


- (void)addSlidePageScrollView
{
    TYSlidePageScrollView *slidePageScrollView = [[TYSlidePageScrollView alloc]initWithFrame:self.view.bounds];
    //CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64)];
    slidePageScrollView.pageTabBarIsStopOnTop = NO;
    slidePageScrollView.pageTabBarStopOnTopHeight = kNavBarHeight;
    slidePageScrollView.parallaxHeaderEffect = YES;
    slidePageScrollView.dataSource = self;
    slidePageScrollView.delegate = self;
    [self.view addSubview:slidePageScrollView];
    _slidePageScrollView = slidePageScrollView;
}

- (void)addHeaderView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_slidePageScrollView.frame), 200)];
    imageView.image = [UIImage imageNamed:@"headerView"];
    imageView.clipsToBounds=YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;


    headerButton=[[UIButton alloc]initWithFrame:CGRectMake(kScreenW/2-40, 30, 80, 80)];
    headerButton.layer.cornerRadius=80/2.0f;
    headerButton.layer.masksToBounds=YES;
    headerButton.layer.borderWidth=0.3f;
    headerButton.layer.borderColor=[UIColor blackColor].CGColor;
    [headerButton addTarget:self action:@selector(uploadBtn) forControlEvents:UIControlEventTouchUpInside];


    factoryNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, kScreenW, 20)];
    factoryNameLabel.font=[UIFont boldSystemFontOfSize:17];
    factoryNameLabel.textAlignment = NSTextAlignmentCenter;
    factoryNameLabel.textColor = [UIColor whiteColor];
    
    infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 160, kScreenW, 20)];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.font=[UIFont boldSystemFontOfSize:15.0f];
    infoLabel.textColor=[UIColor whiteColor];

    [imageView addSubview:factoryNameLabel];
    [imageView addSubview:infoLabel];
    [imageView addSubview:headerButton];


    _slidePageScrollView.headerView = imageView;
    _slidePageScrollView.headerView.userInteractionEnabled = YES;

    DLog(@"%@--%@--%@",NSStringFromCGRect(_slidePageScrollView.frame),NSStringFromCGRect(imageView.frame),NSStringFromCGRect(headerButton.frame));

}

- (void)addTableViewWithPage:(NSInteger)page itemNum:(NSInteger)num
{
    MeViewController *tableViewVC = [[MeViewController alloc]init];
    tableViewVC.userModel=self.userModel;

    // don't forget addChildViewController
    [self addChildViewController:tableViewVC];
}

#pragma mark - dataSource

- (NSInteger)numberOfPageViewOnSlidePageScrollView
{
    return self.childViewControllers.count;
}

- (UIScrollView *)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView pageVerticalScrollViewForIndex:(NSInteger)index
{
    MeViewController *tableViewVC = self.childViewControllers[index];
    tableViewVC.userModel=self.userModel;
    return tableViewVC.tableView;
}

#pragma mark - delegate

//- (void)slidePageScrollView:(TYSlidePageScrollView *)slidePageScrollView verticalScrollViewDidScroll:(UIScrollView *)pageScrollView
//{
//    UIColor * color = [UIColor colorWithHexString:@"0x28303b"];
//
//    CGFloat headerContentViewHeight = -(CGRectGetHeight(slidePageScrollView.headerView.frame)+CGRectGetHeight(slidePageScrollView.pageTabBar.frame));
//    // 获取当前偏移量
//    CGFloat offsetY = pageScrollView.contentOffset.y;
//
//    // 获取偏移量差值
//    CGFloat delta = offsetY - headerContentViewHeight;
//
//    CGFloat alpha = delta / (CGRectGetHeight(slidePageScrollView.headerView.frame) - kNavBarHeight);
//
//    [self.navigationController.navigationBar lt_setBackgroundColor:[color colorWithAlphaComponent:alpha]];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uploadBtn{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {

        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"设备没有相机"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
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
        [HttpClient uploadImageWithImage:image type:@"avatar" andblock:^(NSDictionary *dictionary) {
            if ([dictionary[@"statusCode"] intValue]==200) {
                [Tools showHudTipStr:@"头像上传成功,但是头像显示会略有延迟。"];

                [headerButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,self.userModel.uid]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"消息头像"]];
                [headerButton setBackgroundImage:image forState:UIControlStateNormal];
            }
        }];
    }];
}


@end
