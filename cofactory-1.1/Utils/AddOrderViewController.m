//
//  AddOrderViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/23.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "AddOrderViewController.h"

#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>


@interface AddOrderViewController () <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource, UINavigationControllerDelegate,JKImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


//@property (nonatomic, weak) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) NSArray *pickList;
@property (nonatomic, assign) int type;

//@property (nonatomic, strong) UIImage *image;

@property (nonatomic,strong) UIPickerView *orderPicker;
@property (nonatomic,strong) UIToolbar *pickerToolbar;

@property (nonatomic,strong) UIPickerView *servicePicker;
@property (nonatomic,strong) UIToolbar *serviceToolbar;

@property (nonatomic,copy) NSString*oid;

@property (nonatomic, strong) JKAssets  *asset;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *collectionImage;

@end

@implementation AddOrderViewController {
    UITextField*dateTextField;
    UITextField*numberTextField;
    UITextField*ServiceRangeTextField;
    UITextField*commentTextField;


    NSString*ServiceRangeString;
    NSString*numberString;

    UILabel *_lineLabel;
    UIButton*addImageBtn;
    UIButton*blurBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 20);
    [btn setTitle:@"发布订单" forState:UIControlStateNormal];
    [btn setUserInteractionEnabled:YES];
    [btn addTarget:self action:@selector(pushOrderBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * setButton = [[UIBarButtonItem alloc]initWithCustomView:btn];

//    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"发布订单" style:UIBarButtonItemStylePlain target:self action:@selector(pushOrderBtn:)];
    self.navigationItem.rightBarButtonItem = setButton;

    self.title=@"加工厂订单";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;


    NSArray*btnTitleArray = @[@"加工厂",@"代裁厂",@"锁眼钉扣厂"];
    UIView*headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    headerView.backgroundColor=[UIColor whiteColor];
    for (int i=0; i<3; i++) {
        UIButton*typeBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW-240)/4+i*((kScreenW-240)/4+80), 10, 80 , 30)];
        if (i==0) {
            //设置与按钮同步的下划线Label
            _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeBtn.frame.origin.x, 40, 80,2 )];
            _lineLabel.backgroundColor = [UIColor redColor];
            [headerView addSubview:_lineLabel];
        }
        typeBtn.tag=i;
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:16.0f];
        [typeBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [typeBtn addTarget:self action:@selector(clickTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:typeBtn];
    }
    self.tableView.tableHeaderView=headerView;

    //@"完成期限",@"完成期限",
    self.listData = @[@[@"订单类型", @"完成期限", @"订单数量",@"订单备注", @"上传订单照片"], @[ @"订单数量",@"订单备注", @"上传订单照片"], @[ @"订单数量" ,@"订单备注",@"上传订单照片"]];
    self.pickList =@[@[@"针织", @"梭织"],@[@"3天", @"5天", @"5天以上"]];
    self.type = 0;

    ServiceRangeTextField=[[UITextField alloc]initWithFrame:CGRectMake(kScreenW/2-60, 7, kScreenW/2+50, 30)];
    ServiceRangeTextField.text=@"针织";
    ServiceRangeTextField.inputView = [self fecthSizePicker];
    ServiceRangeTextField.inputAccessoryView = [self fecthToolbar];
    ServiceRangeTextField.font=[UIFont systemFontOfSize:15.0f];
    ServiceRangeTextField.delegate=self;
    ServiceRangeTextField.borderStyle=UITextBorderStyleRoundedRect;

    dateTextField=[[UITextField alloc]initWithFrame:CGRectMake(kScreenW/2-60, 7, kScreenW/2+50, 30)];
    dateTextField.inputView = [self fecthServicePicker];
    dateTextField.inputAccessoryView = [self fecthServiceToolbar];
    dateTextField.delegate =self;
    dateTextField.text=@"3天";
    dateTextField.font=[UIFont systemFontOfSize:15.0f];
    dateTextField.borderStyle=UITextBorderStyleRoundedRect;


    numberTextField=[[UITextField alloc]initWithFrame:CGRectMake(kScreenW/2-60, 7, kScreenW/2+50, 30)];
    numberTextField.keyboardType=UIKeyboardTypeNumberPad;
    numberTextField.placeholder=@"输入订单数量";
    numberTextField.font=[UIFont systemFontOfSize:15.0f];
    numberTextField.borderStyle=UITextBorderStyleRoundedRect;

    commentTextField=[[UITextField alloc]initWithFrame:CGRectMake(kScreenW/2-60, 7, kScreenW/2+50, 30)];
    commentTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    commentTextField.placeholder=@"输入订单备注";
    commentTextField.font=[UIFont systemFontOfSize:15.0f];
    commentTextField.borderStyle=UITextBorderStyleRoundedRect;

    addImageBtn = [[UIButton alloc]init];
    addImageBtn.frame=CGRectMake(20, 7, kScreenW/2-40, 30);
    [addImageBtn setTitle:@"添加订单图片" forState:UIControlStateNormal];
    [addImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addImageBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    addImageBtn.layer.masksToBounds = YES;
    addImageBtn.layer.cornerRadius = 3;
    addImageBtn.backgroundColor = [UIColor colorWithHexString:@"0x28303b"];
    [addImageBtn addTarget:self action:@selector(addImageBtn) forControlEvents:UIControlEventTouchUpInside];

    blurBtn = [[UIButton alloc]init];
    blurBtn.frame=CGRectMake(kScreenW/2+20, 7, kScreenW/2-40, 30);
    [blurBtn setTitle:@"订单图片模糊化" forState:UIControlStateNormal];
    blurBtn.layer.masksToBounds = YES;
    blurBtn.layer.cornerRadius = 3;
    [blurBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    blurBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    blurBtn.backgroundColor = [UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:0.3];
    [blurBtn addTarget:self action:@selector(imageBlurBtn) forControlEvents:UIControlEventTouchUpInside];
    if ([self.collectionImage count]==0) {
        blurBtn.enabled = NO;
    }
    self.collectionImage = [[NSMutableArray alloc]initWithCapacity:9];
}

- (void)pushOrderBtn:(id)sender {
    UIButton*button = (UIButton *)sender;
    [button setUserInteractionEnabled:NO];

    int amount = [numberTextField.text intValue];
    if (self.type==0) {
        if (ServiceRangeTextField.text.length==0 ||numberTextField.text.length==0 || numberTextField.text.length==0) {
            UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单信息不完整" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [button setUserInteractionEnabled:YES];

        }else{
            [HttpClient addOrderWithAmount:amount factoryType:1 factoryServiceRange:ServiceRangeTextField.text workingTime:dateTextField.text comment:commentTextField.text andBlock:^(NSDictionary *responseDictionary) {
                int statusCode = [responseDictionary[@"statusCode"] intValue];
                if (statusCode==200) {
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单发布成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    [button setUserInteractionEnabled:YES];

                    NSDictionary*data = responseDictionary[@"data"];
                    self.oid = data[@"oid"];
                    if (![self.collectionImage count]==0) {
                        [self.collectionImage enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

                            NSData*imageData = UIImageJPEGRepresentation(obj, 0.1);
                            UIImage*newImage = [[UIImage alloc]initWithData:imageData];
                            if (idx==0) {
                                [HttpClient uploadOrderImageWithImage:newImage oid:self.oid type:@"head" andblock:^(NSDictionary *dictionary) {
                                    if ([dictionary[@"statusCode"] intValue]==200) {
                                        DLog(@"图片上传成功");
                                    }else{
                                        DLog(@"图片上传失败%@",dictionary);
                                    }
                                }];
                            }else{
                                [HttpClient uploadOrderImageWithImage:newImage oid:self.oid type:@"content" andblock:^(NSDictionary *dictionary) {
                                    if ([dictionary[@"statusCode"] intValue]==200) {
                                        DLog(@"图片上传成功");
                                    }else{
                                        DLog(@"图片上传失败%@",dictionary);
                                    }
                                }];
                            }
                        }];
                    }else{
                        [button setUserInteractionEnabled:YES];
                        DLog(@"没有图片");
                    }
                }else{
                    [button setUserInteractionEnabled:YES];

                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单发布失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }];
        }
    }else {

        if (numberTextField.text.length==0 || numberTextField.text.length==0) {
            UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单信息不完整" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            [button setUserInteractionEnabled:YES];

        }else{

            [HttpClient addOrderWithAmount:amount factoryType:self.type+1 factoryServiceRange:nil workingTime:dateTextField.text comment:commentTextField.text andBlock:^(NSDictionary *responseDictionary) {
                int statusCode = [responseDictionary[@"statusCode"] intValue];
                if (statusCode==200) {
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单发布成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    [button setUserInteractionEnabled:YES];

                    NSDictionary*data = responseDictionary[@"data"];
                    self.oid = data[@"oid"];

                    if (![self.collectionImage count]==0) {
                        [self.collectionImage enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

                            NSData*imageData = UIImageJPEGRepresentation(obj, 0.1);
                            UIImage*newImage = [[UIImage alloc]initWithData:imageData];
                            if (idx==0) {
                                [HttpClient uploadOrderImageWithImage:newImage oid:self.oid type:@"head" andblock:^(NSDictionary *dictionary) {
                                    if ([dictionary[@"statusCode"] intValue]==200) {
                                        DLog(@"图片上传成功");
                                    }else{
                                        DLog(@"图片上传失败%@",dictionary);
                                    }
                                }];
                            }else{
                                [HttpClient uploadOrderImageWithImage:newImage oid:self.oid type:@"content" andblock:^(NSDictionary *dictionary) {
                                    if ([dictionary[@"statusCode"] intValue]==200) {
                                        DLog(@"图片上传成功");
                                    }else{
                                        DLog(@"图片上传失败%@",dictionary);
                                    }
                                }];
                            }
                        }];
                    }else{
                        [button setUserInteractionEnabled:YES];

                        DLog(@"没有图片");
                    }
                }else{
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单发布失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    [button setUserInteractionEnabled:YES];

                }
            }];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    DLog(@"oid=%@",self.oid);
    OrderListViewController*orderListVC = [[OrderListViewController alloc]init];
    orderListVC.isHistory=NO;
    [self.navigationController pushViewController:orderListVC animated:YES];
}

- (void)clickTypeBtn:(UIButton *)sender {
    UIButton*button=(UIButton *)sender;

    // 控制下划线Label与按钮的同步
    [UIView animateWithDuration:0.2 animations:^{
        _lineLabel.frame = CGRectMake(button.frame.origin.x, 40, button.frame.size.width, 2);
    }];
    switch (button.tag) {
        case 0:
        {
            self.type=0;
            self.title=@"加工厂订单";
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            self.type=1;
            self.title=@"代裁厂订单";
            [self.tableView reloadData];
        }
            break;
        case 2:
        {
            self.type=2;
            self.title=@"锁眼钉扣订单";
            [self.tableView reloadData];
        }
            break;

        default:
            break;
    }
}

//sizePicker
- (UIPickerView *)fecthSizePicker{
    if (!self.orderPicker) {
        self.orderPicker = [[UIPickerView alloc] init];
        self.orderPicker.tag=1;
        self.orderPicker.delegate = self;
        self.orderPicker.dataSource = self;
        [self.orderPicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.orderPicker;
}

- (UIToolbar *)fecthToolbar{
    if (!self.pickerToolbar) {
        self.pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(ensure)];
        self.pickerToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.pickerToolbar;
}

-(void)cancel{

    ServiceRangeString = nil;
    [ServiceRangeTextField endEditing:YES];
}

-(void)ensure{

    if (ServiceRangeString) {
        ServiceRangeTextField.text = ServiceRangeString;
        ServiceRangeString = nil;
    }
    [ServiceRangeTextField endEditing:YES];
}

//service
- (UIPickerView *)fecthServicePicker {
    if (!self.servicePicker) {
        self.servicePicker = [[UIPickerView alloc] init];
        self.servicePicker.tag=2;
        self.servicePicker.delegate = self;
        self.servicePicker.dataSource = self;
        [self.servicePicker selectRow:0 inComponent:0 animated:NO];
    }
    return self.servicePicker;
}

- (UIToolbar *)fecthServiceToolbar {

    if (!self.serviceToolbar) {
        self.serviceToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(serviceCancel)];
        UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(serviceEnsure)];
        self.serviceToolbar.items = [NSArray arrayWithObjects:left,space,right,nil];
    }
    return self.serviceToolbar;
}

-(void)serviceCancel {

    numberString = nil;
    [dateTextField endEditing:YES];
}

-(void)serviceEnsure {

    if (numberString) {
        dateTextField.text = numberString;
        numberString = nil;
    }
    [dateTextField endEditing:YES];
}

#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 1) {
        return [self.pickList[0] count];
    }else{
        return [self.pickList[1] count];
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag==1) {
        return [self.pickList[0] objectAtIndex:row];

    }else{
        return [self.pickList[1] objectAtIndex:row];
    }
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag==1) {
        ServiceRangeString = [self pickerView:pickerView titleForRow:row forComponent:component];
    }else{
        numberString = [self pickerView:pickerView titleForRow:row forComponent:component];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.listData[self.type] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.textLabel.font=[UIFont systemFontOfSize:15.0f];
//        NSMutableArray*cellArr=[[NSMutableArray alloc]initWithCapacity:0];
        NSArray*cellArr=self.listData[self.type];
        cell.textLabel.text=cellArr[indexPath.section];

        if (self.type==0) {
            switch (indexPath.section) {
                case 0:
                {
                    [cell addSubview:ServiceRangeTextField];
                }
                    break;
                    
                case 1:
                {
                    [cell addSubview:dateTextField];
                }
                    break;
                    
                case 2:
                {
                    [cell addSubview:numberTextField];
                }
                    break;
                    
                case 3:
                {
                    [cell addSubview:commentTextField];
                }
                    break;
                    
                case 4:
                {
                    cell.textLabel.text = nil;
                    [cell addSubview:addImageBtn];
                    [cell addSubview:blurBtn];
                    if ([self.collectionImage count]==0) {
                        
                    }else {
                        [cell addSubview:self.collectionView];
                    }
                }
                    break;

                default:
                    break;
            }
        }
        if (self.type==1 || self.type==2) {
            switch (indexPath.section) {
                case 0:
                {
                    [cell addSubview:numberTextField];
                }
                    break;
                case 1:
                {
                    [cell addSubview:commentTextField];
                }
                    break;
                case 2:
                {
                    cell.textLabel.text = nil;
                    [cell addSubview:addImageBtn];
                    [cell addSubview:blurBtn];

                    if ([self.collectionImage count]==0) {

                    }else {
                        [cell addSubview:self.collectionView];
                    }
                }
                    break;

                default:
                    break;
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type==0) {
        if (indexPath.section==4) {
            if ([self.collectionImage count]==0) {
                return 44;
            }
            if (0<[self.collectionImage count] && [self.collectionImage count]<4) {
                return kScreenW/3+50;
            }
            if (3<[self.collectionImage count] && [self.collectionImage count]<7) {
                return 2*kScreenW/3+50;
            }
            if (6<[self.collectionImage count] && [self.collectionImage count]<10) {
                return kScreenW+50;
            }
        }
    }
    if (self.type==1 || self.type==2) {
        if (indexPath.section==2) {
            if ([self.collectionImage count]==0) {
                return 44;
            }
            if (0<[self.collectionImage count] && [self.collectionImage count]<4) {
                return kScreenW/3+50;
            }
            if (3<[self.collectionImage count] && [self.collectionImage count]<7) {
                return 2*kScreenW/3+50;
            }
            if (6<[self.collectionImage count] && [self.collectionImage count]<10) {
                return kScreenW+50;
            }
        }
    }
    return 44;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.tableView endEditing:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addImageBtn {

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
                    [self.collectionImage addObject:image];
                    if (idx == [assets count] - 1) {
                        [self collectionView];
                        [self.collectionView reloadData];
                        [self.tableView reloadData];
                        blurBtn.enabled = YES;

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

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, kScreenW, kScreenW) collectionViewLayout:layout];
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
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [cell addSubview:imageView];

    UIButton*deleteBtn = [[UIButton alloc]init];
    deleteBtn.frame = CGRectMake(imageView.frame.size.width-25, 0, 25, 25);
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
    deleteBtn.tag = indexPath.row;
    [deleteBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:deleteBtn];
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
    [self.tableView reloadData];
    if ([self.collectionImage count]==0) {
        blurBtn.enabled = NO;
        [blurBtn setTitle:@"订单图片模糊化" forState:UIControlStateNormal];

    }
}


- (void)imageBlurBtn {

    blurBtn.enabled = NO;
    [blurBtn setTitle:@"订单图片已模糊" forState:UIControlStateNormal];

    NSMutableArray*blurImageArray = [[NSMutableArray alloc]initWithCapacity:9];
    [self.collectionImage enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [blurImageArray addObject:[Tools imageBlur:obj]];
        if (idx == [self.collectionImage count] - 1) {
            [self.collectionImage removeAllObjects];
            self.collectionImage = blurImageArray;
            [self.collectionView reloadData];
        }
    }];
}



@end
