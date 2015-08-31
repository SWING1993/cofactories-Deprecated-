//
//  UploadImageViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.


#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "Header.h"
#import "UploadImageViewController.h"


@interface UploadImageViewController () <UIImagePickerControllerDelegate, UICollectionViewDelegate,JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate> {

    UIView*view;
}
@property (nonatomic,retain)NSMutableArray*imageArray;

@property (nonatomic, strong) JKAssets  *asset;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation UploadImageViewController {
    dispatch_queue_t _serialQueue;
}

//get
- (dispatch_queue_t)serialQueue
{
    if (!_serialQueue) {

        DLog(@"创建窜行队列");
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列
    }
    return _serialQueue;
}



static NSString * const reuseIdentifier = @"collectionViewCell";

- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    if (self.isMySelf) {
        UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"上传图片" style:UIBarButtonItemStylePlain target:self action:@selector(uploadBtn)];
        self.navigationItem.rightBarButtonItem = setButton;
    }
    [self getImage];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 2.0;
    layout.minimumInteritemSpacing = 2.0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64-44) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = YES;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
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
            [self.collectionView reloadData];
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

                [self.collectionView reloadData];
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

        DLog(@"1");
    }];
}

//下一步
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{

    [imagePicker dismissViewControllerAnimated:YES completion:^{
        DLog(@"2");

        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            self.asset=assets[idx];
            ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    UIImage*image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                    NSData*imageData = UIImageJPEGRepresentation(image, 0.1);
                    UIImage*newImage = [[UIImage alloc]initWithData:imageData];
                    [HttpClient uploadImageWithImage:newImage type:self.type andblock:^(NSDictionary *dictionary) {
                        if ([dictionary[@"statusCode"] intValue]==200) {
                            //最后一张图片上传成功  刷新collectionView
                            if (idx == [assets count] - 1) {
                                [Tools showHudTipStr:@"图片上传成功,但是图片显示要略有延迟，请耐心等待！"];
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
        DLog(@"取消");
    }];
}



#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/4

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.imageArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    UIImageView*imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.imageArray[indexPath.item]]] placeholderImage:[UIImage imageNamed:@"placeholder232"]];
    imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [cell addSubview:imageView];

    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.imageArray count]];
    [self.imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

        MJPhoto *photo = [[MJPhoto alloc] init];
        // photo.image = self.collectionImage[idx]; // 图片
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.imageArray[idx]]];
        [photos addObject:photo];
    }];

    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.row;
    browser.photos = photos;
    [browser show];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
