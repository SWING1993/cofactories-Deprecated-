//
//  UploadImageViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "SDPhotoGroup.h"
#import "SDPhotoItem.h"

#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "Header.h"
#import "UploadImageViewController.h"


@interface UploadImageViewController () <UIImagePickerControllerDelegate, UICollectionViewDelegate,JKImagePickerControllerDelegate> {

//    UICollectionView *CollectionView;

    UIView*view;
}

@property (nonatomic,retain)NSMutableArray*imageArray;

@property (nonatomic, strong) JKAssets  *asset;


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

    self.view.backgroundColor = [UIColor whiteColor];

    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];

    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"上传图片" style:UIBarButtonItemStylePlain target:self action:@selector(uploadBtn)];
    self.navigationItem.rightBarButtonItem = setButton;

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
                self.title = @"公司员工";
            }
            if ([self.type isEqualToString:@"environment"]) {
                self.imageArray=factory[@"environment"];
                self.title = @"公司环境";

            }
            if ([self.type isEqualToString:@"equipment"]) {
                self.imageArray=factory[@"equipment"];
                self.title = @"公司设备";

            }
            [self.tableView reloadData];
        }
    }];
    dispatch_async([self serialQueue], ^{//把block中的任务放入串行队列中执行，这是第一个任务
                sleep(5);//假装这个viewController创建}
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

                [self.tableView reloadData];
            }
        }];
      });
}

- (void)uploadBtn {

    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 10;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{

        NSLog(@"1");
    }];
}

//下一步
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{

    [imagePicker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"2");

        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            self.asset=assets[idx];
            ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    UIImage*image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                    NSData*imageData = UIImageJPEGRepresentation(image, 0.5);
                    UIImage*newImage = [[UIImage alloc]initWithData:imageData];
                    [HttpClient uploadImageWithImage:newImage type:self.type andblock:^(NSDictionary *dictionary) {
                        if ([dictionary[@"statusCode"] intValue]==200) {
                            //最后一张图片上传成功  刷新collectionView
                            if (idx == [assets count] - 1) {
                                [Tools showHudTipStr:@"图片上传成功！"];
                                [self getImage];
                            }
                        }else{
                            [Tools showHudTipStr:@"图片上传失败！"];
                        }
                    }];
                }
            } failureBlock:^(NSError *error) {
                
            }];

        }];
    }];
}

//取消
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        NSLog(@"3");
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if ([self.imageArray count]<5) {

            return kScreenW/4+20;
        }
        if ([self.imageArray count]<9) {

            return kScreenW/2+20;
        }if ([self.imageArray count]<11) {

            return 3*kScreenW/4+20;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"photo";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    SDPhotoGroup *photoGroup = [[SDPhotoGroup alloc] init];

    NSMutableArray *temp = [NSMutableArray array];

    [self.imageArray enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
        SDPhotoItem *item = [[SDPhotoItem alloc] init];
//        NSString*urlString =[NSString stringWithFormat:@"http://cdn.cofactories.com%@",self.imageArray[idx]];
                NSString*urlString =[NSString stringWithFormat:@"%@%@",PhotoAPI,self.imageArray[idx]];

        item.thumbnail_pic = urlString;
        [temp addObject:item];
    }];
    photoGroup.photoItemArray = [temp copy];
    [cell.contentView addSubview:photoGroup];
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
