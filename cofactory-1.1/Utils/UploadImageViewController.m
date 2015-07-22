//
//  UploadImageViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "UploadImageViewController.h"

@interface UploadImageViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource, UICollectionViewDelegate> {

    UICollectionView *CollectionView;

}

@property (nonatomic,retain)NSMutableArray*imageArray;

@end

@implementation UploadImageViewController {
    dispatch_queue_t _serialQueue;

}

//get
- (dispatch_queue_t)serialQueue
{
    if (!_serialQueue) {

        NSLog(@"创建窜行队列");
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列
    }
    return _serialQueue;
}



//static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {

    [super viewDidLoad];

    //cdn.cofactories.com


    self.view.backgroundColor = [UIColor whiteColor];


    UIButton*uploadBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 74, kScreenW-40, 35)];
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    uploadBtn.titleLabel.font=[UIFont systemFontOfSize:16.0f];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadBtn setTitle:@"上传图片" forState:UIControlStateNormal];
    [uploadBtn addTarget:self action:@selector(uploadBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:uploadBtn];

    UILabel*titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, kScreenW-40, 20)];
    titleLabel.font=[UIFont systemFontOfSize:15.0f];
    titleLabel.text=@"温馨提示：请上传3到10张图片以完成信息完整度";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];


    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.minimumLineSpacing = 20;
//    layout.minimumInteritemSpacing = 10;
    layout.itemSize = CGSizeMake(kScreenW/4-10, kScreenW/4-10);
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);

    CollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 140, kScreenW, kScreenH-140) collectionViewLayout:layout];
    CollectionView.backgroundColor=[UIColor clearColor];
    CollectionView.delegate=self;
    CollectionView.dataSource=self;
    CollectionView.showsHorizontalScrollIndicator=NO;
    [CollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [self.view addSubview:CollectionView];

    [self getImage];
}

- (void)getImage {

    [HttpClient getFactoryPhotoWithUid:self.userUid type:self.type andBlock:^(NSDictionary *dictionary) {

        if ([dictionary[@"statusCode"] intValue]== 200) {

            self.imageArray = [[NSMutableArray alloc]initWithCapacity:0];

            NSDictionary*responseDictionary = dictionary[@"responseDictionary"];

            NSDictionary*factory=responseDictionary[@"factory"];

            if ([self.type isEqualToString:@"employee"]) {
                self.imageArray=factory[@"employee"];
            }
            if ([self.type isEqualToString:@"environment"]) {
                self.imageArray=factory[@"environment"];
            }
            if ([self.type isEqualToString:@"equipment"]) {
                self.imageArray=factory[@"equipment"];
            }

            [CollectionView reloadData];

            NSLog(@"self.imageArray=%@",self.imageArray);
        }
    }];


    dispatch_async([self serialQueue], ^{//把block中的任务放入串行队列中执行，这是第一个任务
                sleep(3);//假装这个viewController创建}
        [CollectionView reloadData];

      });
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

        [HttpClient uploadImageWithImage:image type:self.type andblock:^(NSDictionary *dictionary) {
//            NSLog(@"-----%@",dictionary[@"statusCode"]);
            if ([dictionary[@"statusCode"] intValue]==200) {
                [self getImage];
            }
        }];

    }];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    UIImageView*photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW/4-10, kScreenW/4-10)];

    NSString*urlString =[NSString stringWithFormat:@"cdn.cofactories.com%@",self.imageArray[indexPath.row]];

//    [photoView sd_setImageWithURL:[NSURL URLWithString:urlString]];
    

    [photoView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"placeholder232"] ];
//    NSLog(@"%@",urlString);

    photoView.contentMode=UIViewContentModeScaleAspectFill;
    photoView.clipsToBounds=YES;
    [cell addSubview:photoView];

    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
