//
//  PurchaseFabricOrAccessoryVC.m
//  cofactory-1.1
//
//  Created by gt on 15/9/18.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "PurchaseFabricOrAccessoryVC.h"
#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MeViewController.h"

@interface PurchaseFabricOrAccessoryVC ()<JKImagePickerControllerDelegate,UIAlertViewDelegate>{
    UITextField    *_nameTF;
    UITextField    *_commentTF;
    UITextField    *_amountTF;
    NSMutableArray *_viewFramArray;
    NSMutableArray *_buttonFramArray;
    NSInteger       _selectedIndex;
    NSArray        *_buttonTitleArray;
    UIScrollView   *_scrollView;
    NSMutableArray *_imageViewArray;
    UIButton       *_addButton;
    CGRect          _unitRect;
    FactoryModel   *_userModel;
    BOOL           flag, changeFlag;

}
@property (strong,nonatomic) UIImageView *selectedImage;
@property (nonatomic, strong) JKAssets  *asset;
@property (nonatomic, strong) FactoryRangeModel * factoryRangeModel;
@property (nonatomic, retain) NSString * factoryTypeString;

@end

@implementation PurchaseFabricOrAccessoryVC

- (void)viewWillAppear:(BOOL)animated {
    [self netWork];
    self.factoryRangeModel = [[FactoryRangeModel alloc]init];
    self.factoryTypeString = self.factoryRangeModel.serviceList[kFactoryType];
    DLog(@"++++++++++++%@", self.factoryTypeString);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发布采购" style:UIBarButtonItemStylePlain target:self action:@selector(publishButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    if ([self.materiaType isEqualToString:@"面料"]) {
        self.navigationItem.title = @"找面料";
    }if ([self.materiaType isEqualToString:@"辅料"] ) {
        self.navigationItem.title = @"找辅料";
    }
    _viewFramArray = [@[] mutableCopy];
    _buttonFramArray = [@[] mutableCopy];
    _imageViewArray = [@[] mutableCopy];
    _selectedIndex = -1;
    [self creatUI];
    [self singleSelect];
    [self creatAddButton];
}

- (void)creatUI{
    
    NSArray *labelTitleArray = @[@"产品名称",@"规格备注",@"采购数量"];
    NSArray *placeholderArray = @[@"请填写产品名称",@"请填写规格备注",@"请填写采购数量"];
    for (int i=0; i<3; i++) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10+i*50, kScreenW, 40)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        if (i == 2) {
            NSValue *value = [NSValue valueWithCGRect:view.frame];
            [_viewFramArray addObject:value];
        }
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 75, 30)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = [NSString stringWithFormat:@"%@ :",labelTitleArray[i]];
        [view addSubview:label];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(77, 5, view.bounds.size.width-90, 30)];
        textField.placeholder = placeholderArray[i];
        textField.font = [UIFont systemFontOfSize:14.0f];
        [view addSubview:textField];
        
        switch (i) {
            case 0:
                _nameTF = textField ;
                break;
            case 1:
                _commentTF = textField ;
                break;
            case 2:
                _amountTF = textField ;
                _amountTF.keyboardType = UIKeyboardTypeNumberPad;
                break;
                
            default:
                break;
        }
    }
}
- (void)netWork {
    //解析工厂信息
    NSNumber *uid = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"selfuid"];
    [HttpClient getUserProfileWithUid:[uid intValue] andBlock:^(NSDictionary *responseDictionary) {
        _userModel = (FactoryModel *)responseDictionary[@"model"];
    }];
    
}

- (void)singleSelect{
    
    NSValue *value = _viewFramArray[0];
    CGRect rect = value.CGRectValue;
    _buttonTitleArray = @[@"码",@"米",@"千克"];
    for (int i=0; i<3; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(80+i*((kScreenW-160-120)/2.0+40), rect.origin.y+40+30, 40, 40);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 20;
        button.backgroundColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:0.8];
        [button setTitle:_buttonTitleArray[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        button.tag = i+1;
        [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        
        if (i == 0) {
            NSValue *value = [NSValue valueWithCGRect:button.frame];
            [_buttonFramArray addObject:value];
        }
    }
}

- (void)creatAddButton{
    NSValue *value = _buttonFramArray[0];
    _unitRect = value.CGRectValue;
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake((kScreenW-70)/2.0, _unitRect.origin.y+40+30, 70, 70);
    [_addButton setBackgroundImage:[UIImage imageNamed:@"addImageButton.png"] forState:UIControlStateNormal];
    _addButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_addButton addTarget:self action:@selector(addImageClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addButton];
}

- (void)creatScrollView{
    
    if (_scrollView) {
        [_scrollView removeFromSuperview];
    }
    NSValue *value = _buttonFramArray[0];
    CGRect rect = value.CGRectValue;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20+70+10, rect.origin.y+40+30, kScreenW-40-70-10, 70)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(80 * _imageViewArray.count, 70);
    for (int i = 0; i < _imageViewArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:_imageViewArray[i] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(i * 80, 0, 70, 70)];
        [button addTarget:self action:@selector(MJPhotoBrowserClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_scrollView addSubview:button];
        
        UIButton*deleteBtn = [[UIButton alloc]init];
        deleteBtn.frame = CGRectMake(button.frame.size.width-25, 0, 25, 25);
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
        deleteBtn.tag = i;
        [deleteBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:deleteBtn];
    }
    
}

- (void)selectClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    
    if (_selectedIndex != -1) {
        
        UIButton *lastButton = (UIButton *)[self.view viewWithTag:_selectedIndex];
        lastButton.backgroundColor = [UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:0.8];
    }
    
    if (!self.selectedImage) {
        self.selectedImage = [[UIImageView alloc]initWithFrame:CGRectMake(button.frame.origin.x + 13, button.frame.origin.y + 26, 13, 10)];
        self.selectedImage.image = [UIImage imageNamed:@"勾.png"];
        [self.view addSubview:self.selectedImage];
    }
    
    button.backgroundColor = [UIColor colorWithRed:55/255.0 green:102/255.0 blue:211/255.0 alpha:1.0];
    self.selectedImage.frame = CGRectMake(button.frame.origin.x + 13, button.frame.origin.y + 26, 13, 10);
    _selectedIndex = button.tag;
    
}

- (void)addImageClick{
    
    if ([_imageViewArray count]== 9) {
        [Tools showErrorWithStatus:@"图片最多上传9张"];
    }else {
        JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.showsCancelButton = YES;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.minimumNumberOfSelection = 0;
        imagePickerController.maximumNumberOfSelection = 9-[_imageViewArray count];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:nil];
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
                    [_imageViewArray addObject:image];
                    if (idx == [assets count] - 1) {
                        DLog(@"_imageViewArrayCount==%zi",_imageViewArray.count);
                        _addButton.frame = CGRectMake(20, _unitRect.origin.y+40+30, 70, 70);
                        [self creatScrollView];
                    }
                }
            } failureBlock:^(NSError *error) {
                
            }];
            
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        DLog(@"取消");
    }];
}

- (void)MJPhotoBrowserClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[_imageViewArray count]];
    [_imageViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image = _imageViewArray[idx]; // 图片
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = button.tag;
    browser.photos = photos;
    [browser show];
    
}


- (void)goBackClick{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定返回?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)donePublish {
    if ([self.factoryTypeString isEqualToString:@"服装厂"] || [self.factoryTypeString isEqualToString:@"加工厂"]) {
        if (_userModel.factorySize == nil || _userModel.factoryServiceRange == nil || _userModel.factoryAddress == nil) {
            flag = YES;
        }
    }
    if ([self.factoryTypeString isEqualToString:@"代裁厂"]) {
        if (_userModel.factorySize == nil || _userModel.factoryAddress == nil) {
            flag = YES;
        }
    }
    if ([self.factoryTypeString isEqualToString:@"锁眼钉扣厂"]) {
        if  (_userModel.factoryAddress == nil) {
            flag = YES;
        }
    }
}

- (void)publishButton{
    [self donePublish];
    if (flag) {
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"个人信息不完整" message:@"请完善信息后再继续发布" delegate:self cancelButtonTitle:@"暂不完善" otherButtonTitles:@"去完善", nil];
        alertView.tag = 222;
        [alertView show];
    } else {
        if (_nameTF.text.length == 0 || _commentTF.text.length == 0 || _amountTF.text.length == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请完善采购信息" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            
            if (_selectedIndex == -1) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请勾选采购单位" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show];
            }else{
                
                if (_imageViewArray.count == 0) {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定不上传图片?" message:nil delegate:self cancelButtonTitle:@"我要上传" otherButtonTitles:@"直接发布", nil];
                    alert.tag = 100;
                    [alert show];
                }else{
                    DLog(@"123");
                    int amuont = [_amountTF.text intValue];
                    [HttpClient sendMaterialPurchaseInfomationWithType:self.materiaType name:_nameTF.text description:_commentTF.text amount:@(amuont) unit:_buttonTitleArray[_selectedIndex-1] completionBlock:^(NSDictionary *responseDictionary) {
                        int statusCode = [responseDictionary[@"statusCode"] intValue];
                        DLog("++++>>>>%d",statusCode);
                        if (statusCode == 200) {
                            int index = [responseDictionary[@"responseObject"][@"id"] intValue];
                            [_imageViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                
                                NSData*imageData = UIImageJPEGRepresentation(obj, 0.1);
                                UIImage*newImage = [[UIImage alloc]initWithData:imageData];
                                NSString *oidString = [NSString stringWithFormat:@"%d",index];
                                [HttpClient uploadMaterialImageWithImage:newImage oid:oidString type:@"buy" andblock:^(NSDictionary *dictionary) {
                                    if ([dictionary[@"statusCode"] intValue] == 200) {
                                        [Tools showSuccessWithStatus:@"发布成功"];
                                        double delayInSeconds = 1.0f;
                                        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                                        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                            NSArray *navArray = self.navigationController.viewControllers;
                                            [self.navigationController popToViewController:navArray[1] animated:YES];
                                        });
                                    }
                                    else{
                                        [Tools showErrorWithStatus:@"图片上传失败"];
                                    }
                                    
                                }];
                                
                            }];
                            
                        }else{
                            [Tools showErrorWithStatus:@"发布失败"];
                        }
                    }];
                }
            }
        }

    }
}

- (void)deleteImageView:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    [_imageViewArray removeObjectAtIndex:button.tag];
    if (_imageViewArray.count > 0) {
        [self creatScrollView];
        
    }else{
        [_scrollView removeFromSuperview];
        _addButton.frame = CGRectMake((kScreenW-70)/2.0, _unitRect.origin.y+40+30, 70, 70);
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            int amuont = [_amountTF.text intValue];
            [HttpClient sendMaterialPurchaseInfomationWithType:self.materiaType name:_nameTF.text description:_commentTF.text amount:@(amuont) unit:_buttonTitleArray[_selectedIndex-1] completionBlock:^(NSDictionary *responseDictionary) {
                int statusCode = [responseDictionary[@"statusCode"] intValue];
                if (statusCode == 200) {
                    [Tools showSuccessWithStatus:@"发布成功"];
                    double delayInSeconds = 1.0f;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        NSArray *navArray = self.navigationController.viewControllers;
                        [self.navigationController popToViewController:navArray[1] animated:YES];
                    });
                }else{
                    [Tools showErrorWithStatus:@"发布失败"];
                }
            }];
        }
    } else if (alertView.tag == 222) {
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
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
