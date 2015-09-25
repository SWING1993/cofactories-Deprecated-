//
//  CompeteMaterialViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/23.
//  Copyright © 2015年 聚工科技. All rights reserved.
//
#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/3
#define kMargin (kScreenW - 60) / 3
#import "CompeteMaterialViewController.h"
#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface CompeteMaterialViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,JKImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UITextFieldDelegate>{
    NSMutableArray *_contentArray;
    NSArray *_imageArray;
    UITextField *_commentsTextField;
    UITextField *priceTextField;
    UIButton *priceButton;
    UIButton *leftButton, *rightButton;
    NSString *stateString, *price;
    
    
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *collectionImage;
@property (nonatomic, strong) JKAssets  *asset;

@end

@implementation CompeteMaterialViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"投标";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认投标" style:UIBarButtonItemStyleBordered target:self action:@selector(confirmBid)];
    
    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.leftBarButtonItem = setButton;
    
    stateString = @"现货";
    
    _imageArray = @[@"公司名称",@"公司类型",@"公司规模"];
    _collectionImage = [@[] mutableCopy];
 
    [self.view addSubview:self.collectionView];
    [self creatUI];
    [self creatCommentsTextField];
    [self creatAddImageButton];



}

- (void)buttonClicked{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)creatUI{

    for (int i = 0; i < 2; i++) {
        NSArray *array = @[@"价        格:", @"货源状态:"];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, i *(30 + 20) + 20, kMargin, 30)];
        titleLabel.text = array[i];
        [self.view addSubview:titleLabel];
        
    }
    
    priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(20 *2 + kMargin, 20, kMargin, 30)];
    priceTextField.layer.borderWidth = 0.5;
    priceTextField.layer.borderColor = [UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0].CGColor;
    priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    priceTextField.font = kFont;
    priceTextField.placeholder = @"填写价格";
    priceTextField.delegate = self;
    [self.view addSubview:priceTextField];
    
    priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    priceButton.frame = CGRectMake(CGRectGetMaxX(priceTextField.frame), 20, kMargin, 30);
    priceButton.tag = 100;
    priceButton.titleLabel.font = kFont;
    [priceButton setTitle:@"面议" forState:UIControlStateNormal];
    [priceButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    priceButton.layer.borderColor = [UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0].CGColor;
    priceButton.layer.borderWidth = 0.5;
    [priceButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:priceButton];
    
    for (int i = 0; i < 2; i++) {
        NSArray *array = @[@"现货", @"预定"];
        UIButton *stateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        stateButton.frame = CGRectMake(20 *2 + kMargin + i *kMargin, 70, kMargin, 30);
        stateButton.tag = 101 + i;
        stateButton.titleLabel.font = kFont;
        [stateButton setTitle:array[i] forState:UIControlStateNormal];
        [stateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        stateButton.layer.borderColor = [UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0].CGColor;
        stateButton.layer.borderWidth = 0.5;
        [stateButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:stateButton];
        if (stateButton.tag == 101) {
            leftButton = stateButton;
            [leftButton setTitleColor:[UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0] forState:UIControlStateNormal];
        } else if (stateButton.tag == 102){
            rightButton = stateButton;
            [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }

    }
    
}

- (void)clickButton:(UIButton *)button {
    switch (button.tag) {
        case 100:
        {
            [priceTextField resignFirstResponder];
            priceTextField.text = nil;
            [priceButton setTitleColor:[UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0] forState:UIControlStateNormal];
            
            price = @"-1";
        }
            break;
        case 101:
        {
            [leftButton setTitleColor:[UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0] forState:UIControlStateNormal];
            [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            stateString = @"现货";
        }
            break;
        case 102:
        {
            [rightButton setTitleColor:[UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0] forState:UIControlStateNormal];
            [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            stateString = @"预定";
        }
            break;
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    price = nil;
    [priceTextField becomeFirstResponder];
    [priceButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    price = priceTextField.text;
}
- (void)creatCommentsTextField{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(40, 120, kScreenW-80, 20)];
    label.textColor = [UIColor colorWithRed:70/255.0 green:126/255.0 blue:220/255.0 alpha:1.0];
    label.text = @"添加备注";
    label.font = kFont;
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
    button.titleLabel.font = kFont;
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
        [Tools showHudTipStr:@"订单图片最多能上传9张"];
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
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确认投标?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 10;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 10 ) {
        
        if (buttonIndex == 1) {
            
            if (![price isEqualToString:@"-1"]) {
                price = priceTextField.text;
            } else {
                price = @"-1";
            }
            DLog(@"%@", price);
            DLog(@"%@", _commentsTextField.text);
            DLog(@"%@", stateString);

            if (price.length == 0) {
                [Tools showString:@"请完善价格"];
                
            } else if (_commentsTextField.text.length == 0) {
                [Tools showString:@"请完善备注"];
            } else {
                [HttpClient registMaterialBidWithOid:self.oid price:price status:stateString comment:_commentsTextField.text completionBlock:^(int statusCode) {
                    DLog(@"%d", statusCode);
                    if (statusCode == 200) {
                        [Tools showSuccessWithStatus:@"投标成功"];
                        if (![self.collectionImage count]==0) {
                            [self.collectionImage enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                
                                NSData*imageData = UIImageJPEGRepresentation(obj, 0.1);
                                UIImage*newImage = [[UIImage alloc]initWithData:imageData];
                                NSString *oidString = [NSString stringWithFormat:@"%ld",self.oid];
                                [HttpClient uploadMaterialImageWithImage:newImage oid:oidString type:@"bidBuy" andblock:^(NSDictionary *dictionary) {
                                    if ([dictionary[@"statusCode"] intValue]==200) {
                                        [Tools showSuccessWithStatus:@"投标成功"];
                                        double delayInSeconds = 1.0f;
                                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                        });
                                        
                                        DLog(@"图片上传成功");
                                    }else{
                                        
                                        DLog(@"图片上传失败%@",dictionary);
                                    }
                                    
                                }];
                            }];
                        }else{
                            DLog(@"没有图片");
                            [self dismissViewControllerAnimated:YES completion:nil];
                        }
                        
                    }else{
                        [Tools showErrorWithStatus:@"订单投标失败"];
                    }
                    
                }];
            }
            
            
            

        }
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
