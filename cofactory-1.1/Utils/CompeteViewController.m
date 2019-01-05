//
//  CompeteViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/6.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//
#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/3

#import "CompeteViewController.h"
#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface CompeteViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,JKImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>{
    NSMutableArray *_contentArray;
    NSArray *_imageArray;
    UITextField *_commentsTextField;
    FactoryModel   *_userModel;
    BOOL infoFlag;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionImage;
@property (nonatomic, strong) JKAssets  *asset;
@property (nonatomic, strong) FactoryRangeModel * factoryRangeModel;
@property (nonatomic, retain) NSString * factoryTypeString;

@end

@implementation CompeteViewController
- (void)viewWillAppear:(BOOL)animated {
    [self netWork];
    self.factoryRangeModel = [[FactoryRangeModel alloc]init];
    self.factoryTypeString = self.factoryRangeModel.serviceList[kFactoryType];
    DLog(@"++++++++++++%@", self.factoryTypeString);
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationItem.title = @"订单投标";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认投标" style:UIBarButtonItemStylePlain target:self action:@selector(confirmBid)];
    
    _imageArray = @[@"公司名称",@"公司类型",@"公司规模"];
    _collectionImage = [@[] mutableCopy];
    _contentArray = [@[] mutableCopy];
    [_contentArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"factoryName"]];
    [_contentArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"factoryAddress"]];
    [_contentArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"factorySize"]];
    
    [self.view addSubview:self.collectionView];
    [self creatUI];
    [self creatCommentsTextField];
    [self creatAddImageButton];
}

- (void)creatUI{
    for (int i=0; i<3; i++) {
        UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(50+i*((kScreenW-90-100)/2.0+30),20 ,30 ,30 )];
        view.image = [UIImage imageNamed:_imageArray[i]];
        [self.view addSubview:view];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*kScreenW/3.0,70 ,kScreenW/3.0 ,20 )];
        label.textColor = [UIColor grayColor];
        label.textAlignment = 1;
        label.text = _contentArray[i];
        label.font = [UIFont systemFontOfSize:14.0f];
        [self.view addSubview:label];
    }
}
- (void)netWork {
    //解析工厂信息
    NSNumber *uid = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"selfuid"];
    [HttpClient getUserProfileWithUid:[uid intValue] andBlock:^(NSDictionary *responseDictionary) {
        _userModel = (FactoryModel *)responseDictionary[@"model"];
    }];
    
}

- (void)creatCommentsTextField{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 120, kScreenW-80, 20)];
    label.textColor = [UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0];
    label.text = @"添加备注";
    label.font = [UIFont systemFontOfSize:18.0f];
    label.textAlignment = 1;
    [self.view addSubview:label];
    
    _commentsTextField = [[UITextField alloc]initWithFrame:CGRectMake(40, 150, kScreenW-80, 40)];
    _commentsTextField.layer.masksToBounds=YES;
    _commentsTextField.layer.borderWidth = 2.0f;
    _commentsTextField.layer.borderColor = [UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0].CGColor;
    _commentsTextField.layer.cornerRadius = 5;
    [self.view addSubview:_commentsTextField];
}

- (void)creatAddImageButton{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake((kScreenW-100)/2.0, 220, 100, 30);
    [button setTitleColor:[UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0] forState:UIControlStateNormal];
    button.titleLabel.textAlignment = 1;
    button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 2.0f;
    button.layer.borderColor = [UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0].CGColor;
    button.layer.cornerRadius = 5;
    [button setTitle:@"添加图片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addImageView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)addImageView:(id)sender{
    if ([self.collectionImage count]== 9) {
        [Tools showErrorWithStatus:@"订单图片最多能上传9张"];
    }else {
        JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.showsCancelButton = YES;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.minimumNumberOfSelection = 0;
        imagePickerController.maximumNumberOfSelection = 9-[self.collectionImage count];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
        DLog(@"1");
    }];
}

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
                    [self.collectionImage addObject:image];
                    if (idx == [assets count] - 1) {
                        [self collectionView];
                        [self.collectionView reloadData];
                        DLog(@"self.collectionImage %lu",(unsigned long)[self.collectionImage count]);
                    }
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 270, kScreenW, kScreenH-270) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.collectionImage count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIImageView*imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    imageView.image = self.collectionImage[indexPath.row];
    imageView.backgroundColor = [UIColor redColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [cell addSubview:imageView];
    
    UIButton*deleteBtn = [[UIButton alloc]init];
    deleteBtn.frame = CGRectMake(imageView.frame.size.width-25, 0, 25, 25);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
    deleteBtn.tag = indexPath.row;
    [deleteBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:deleteBtn];
    
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.collectionImage count]];
    [self.collectionImage enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image = self.collectionImage[idx]; // 图片
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.row;
    browser.photos = photos;
    [browser show];
    
}

- (void)deleteCell:(UIButton*)sender {
    DLog(@"%ld",(long)sender.tag);
    [self.collectionImage removeObjectAtIndex:sender.tag];
    [self.collectionView reloadData];
}


- (void)confirmBid{
    [self factoryInfo];
    if (infoFlag) {
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"个人信息不完整" message:@"请完善信息后再继续发布" delegate:self cancelButtonTitle:@"暂不完善" otherButtonTitles:@"去完善", nil];
        alertView.tag = 222;
        [alertView show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认投标?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 10;
        [alert show];
    }
    
    
}

- (void)factoryInfo {
    if ([self.factoryTypeString isEqualToString:@"服装厂"] || [self.factoryTypeString isEqualToString:@"加工厂"]) {
        if (_userModel.factorySize == nil || _userModel.factoryServiceRange == nil || _userModel.factoryAddress == nil) {
            infoFlag = YES;
        } else {
            infoFlag = NO;
        }
    }
    if ([self.factoryTypeString isEqualToString:@"代裁厂"]) {
        if (_userModel.factorySize == nil || _userModel.factoryAddress == nil) {
            infoFlag = YES;
        } else {
            infoFlag = NO;
        }
    }
    if ([self.factoryTypeString isEqualToString:@"锁眼钉扣厂"]) {
        if  (_userModel.factoryAddress == nil) {
            infoFlag = YES;
        } else {
            infoFlag = NO;
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 10 ) {
        
        if (buttonIndex == 1) {
            [HttpClient registBidWithOid:self.oid commit:_commentsTextField.text completionBlock:^(int statusCode) {
                DLog(@"statusCode==%d",statusCode);
                if (statusCode == 200 ) {
                    [Tools showSuccessWithStatus:@"订单投标成功"];
                    if (![self.collectionImage count]==0) {
                        [self.collectionImage enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                            
                            NSData*imageData = UIImageJPEGRepresentation(obj, 0.1);
                            UIImage*newImage = [[UIImage alloc]initWithData:imageData];
                            NSString *oidString = [NSString stringWithFormat:@"%d",self.oid];
                            [HttpClient uploadOrderImageWithImage:newImage oid:oidString type:@"bid" andblock:^(NSDictionary *dictionary) {
                                if ([dictionary[@"statusCode"] intValue]==200) {
                                    DLog(@"图片上传成功");
                                    NSArray *navArray = self.navigationController.viewControllers;
                                    [self.navigationController popToViewController:navArray[1] animated:YES];
                                }
                                else{
                                    DLog(@"图片上传失败%@",dictionary);
                                }
                            }];
                            
                        }];
                    }else{
                        DLog(@"没有图片");
                        NSArray *navArray = self.navigationController.viewControllers;
                        [self.navigationController popToViewController:navArray[1] animated:YES];
                    }
                    
                }else{
                    [Tools showErrorWithStatus:@"订单投标失败"];
                }
            }];
        }
    } else if (alertView.tag == 222){
        if (buttonIndex == 1) {
            DLog(@"去完善资料");
            MeViewController *meVC = [[MeViewController alloc] init];
            meVC.changeFlag = YES;
            [self.navigationController pushViewController:meVC animated:YES];
        } else {
            DLog(@"暂不完善");
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
