//
//  AddOrderViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/23.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "AddOrderViewController.h"
#import <Accelerate/Accelerate.h>

@interface AddOrderViewController () <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) IBOutlet UIView *overlayView;

@property (nonatomic, assign) BOOL isBlur;
@property (nonatomic, weak) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) NSArray *listData;
@property (nonatomic, strong) NSArray *pickList;
@property (nonatomic, assign) int type;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic,strong) UIPickerView *orderPicker;
@property (nonatomic,strong) UIToolbar *pickerToolbar;

@property (nonatomic,strong) UIPickerView *servicePicker;
@property (nonatomic,strong) UIToolbar *serviceToolbar;

@property (nonatomic,copy) NSString*oid;

@end

@implementation AddOrderViewController {
    UITextField*dateTextField;
    UITextField*numberTextField;
    UITextField*ServiceRangeTextField;

    NSString*ServiceRangeString;
    NSString*numberString;

    UILabel *_lineLabel;

    UIButton*pushOrderBtn;

}

- (void)viewDidLoad {
    [super viewDidLoad];
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
//        [typeBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        [typeBtn addTarget:self action:@selector(clickTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:typeBtn];
    }
    self.tableView.tableHeaderView=headerView;

    //@"完成期限",@"完成期限",
    self.listData = @[@[@"订单类型", @"完成期限", @"订单数量", @"上传订单照片"], @[ @"订单数量", @"上传订单照片"], @[ @"订单数量", @"上传订单照片"]];
    self.pickList =@[@[@"针织", @"梭织"],@[@"3天", @"5天", @"5天以上"]];
    self.type = 0;


    ServiceRangeTextField=[[UITextField alloc]initWithFrame:CGRectMake(kScreenW/2-30, 7, kScreenW/2+  10, 30)];
    ServiceRangeTextField.text=@"针织";
    ServiceRangeTextField.inputView = [self fecthSizePicker];
    ServiceRangeTextField.inputAccessoryView = [self fecthToolbar];
    ServiceRangeTextField.font=[UIFont systemFontOfSize:15.0f];
    ServiceRangeTextField.delegate=self;
    ServiceRangeTextField.borderStyle=UITextBorderStyleRoundedRect;

    dateTextField=[[UITextField alloc]initWithFrame:CGRectMake(kScreenW/2-30, 7, kScreenW/2+10, 30)];
    dateTextField.inputView = [self fecthServicePicker];
    dateTextField.inputAccessoryView = [self fecthServiceToolbar];
    dateTextField.delegate =self;
    dateTextField.text=@"3天";
    dateTextField.font=[UIFont systemFontOfSize:15.0f];
    dateTextField.borderStyle=UITextBorderStyleRoundedRect;


    numberTextField=[[UITextField alloc]initWithFrame:CGRectMake(kScreenW/2-30, 7, kScreenW/2+10, 30)];
    numberTextField.keyboardType=UIKeyboardTypeNumberPad;
    numberTextField.placeholder=@"请输入订单数量";
    numberTextField.font=[UIFont systemFontOfSize:15.0f];
    numberTextField.borderStyle=UITextBorderStyleRoundedRect;

    pushOrderBtn = [[UIButton alloc]init];
    pushOrderBtn.frame=CGRectMake(30, 260, kScreenW-60, 40);
    [pushOrderBtn setTitle:@"发布订单" forState:UIControlStateNormal];
    [pushOrderBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [pushOrderBtn addTarget:self action:@selector(pushOrderBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView addSubview:pushOrderBtn];

    self.isBlur = NO;
}

- (void)pushOrderBtn {

    int amount = [numberTextField.text intValue];

    if (self.type==0) {
        if (ServiceRangeTextField.text.length==0 ||numberTextField.text.length==0 || numberTextField.text.length==0) {
            UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单信息不完整" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }else{

            [HttpClient addOrderWithAmount:amount factoryType:1 factoryServiceRange:ServiceRangeTextField.text workingTime:dateTextField.text andBlock:^(NSDictionary *responseDictionary) {
                int statusCode = [responseDictionary[@"statusCode"] intValue];
                if (statusCode==200) {
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单发布成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    NSDictionary*data = responseDictionary[@"data"];
                    self.oid = data[@"oid"];
                    if (self.image) {

                        [HttpClient uploadOrderImageWithImage:self.image oid:self.oid andblock:^(NSDictionary *dictionary) {
                            if ([dictionary[@"statusCode"] intValue]==200) {
                                NSLog(@"图片上传成功");
                            }else{
                                NSLog(@"图片上传失败%@",dictionary);
                            }
                        }];
                    }else{
                        NSLog(@"没有图片");
                    }


                }else{
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单发布失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }];
        }
    }else {

        if (numberTextField.text.length==0 || numberTextField.text.length==0) {
            UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单信息不完整" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }else{

            [HttpClient addOrderWithAmount:amount factoryType:self.type+1 factoryServiceRange:nil workingTime:dateTextField.text andBlock:^(NSDictionary *responseDictionary) {
                int statusCode = [responseDictionary[@"statusCode"] intValue];
                if (statusCode==200) {
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单发布成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                    NSDictionary*data = responseDictionary[@"data"];
                    self.oid = data[@"oid"];
                    if (self.image) {

                        [HttpClient uploadOrderImageWithImage:self.image oid:self.oid andblock:^(NSDictionary *dictionary) {
                            if ([dictionary[@"statusCode"] intValue]==200) {
                                NSLog(@"图片上传成功");
                            }else{
                                NSLog(@"图片上传失败%@",dictionary);
                            }
                        }];
                    }else{
                        NSLog(@"没有图片");
                    }

                }else{
                    UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"订单发布失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                    [alertView show];
                }
            }];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    NSLog(@"oid=%@",self.oid);
    OrderListViewController*orderListVC = [[OrderListViewController alloc]init];
    orderListVC.HiddenJSDropDown=YES;
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
            pushOrderBtn.frame=CGRectMake(30, 260, kScreenW-60, 40);
            [self.tableView reloadData];
        }
            break;
        case 1:
        {
            self.type=1;
            self.title=@"代裁厂订单";
            pushOrderBtn.frame=CGRectMake(30, 160, kScreenW-60, 40);

            [self.tableView reloadData];
        }
            break;
        case 2:
        {
            self.type=2;
            self.title=@"锁眼钉扣订单";
            pushOrderBtn.frame=CGRectMake(30, 160, kScreenW-60, 40);
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
        NSMutableArray*cellArr=[[NSMutableArray alloc]initWithCapacity:0];
        cellArr=self.listData[self.type];
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
                    UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-44-30, 0, 44, 44)];
                    imageView.image=self.image;
                    [cell addSubview:imageView];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
                    //[cell addSubview:dateTextField];
                    [cell addSubview:numberTextField];
                }
                    break;
                case 1:
                {
                    //[cell addSubview:numberTextField];
                    UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-44-30, 0, 44, 44)];
                    imageView.image=self.image;
                    [cell addSubview:imageView];
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

                }
                    break;
                case 2:
                {
//                    UIImageView*imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW-44-30, 0, 44, 44)];
//                    imageView.image=self.image;
//                    [cell addSubview:imageView];
//                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == [self.listData[self.type] count] - 1) {
        [self.tableView endEditing:YES];

        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误"
                                                                message:@"设备没有相机"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles: nil];

            [alertView show];
        } else {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            // 使用自定义 overlay
            imagePickerController.showsCameraControls = NO;
            [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
            self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
            imagePickerController.cameraOverlayView = self.overlayView;
            self.overlayView = nil;

            //            imagePickerController.allowsEditing = YES;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];

            self.imagePickerController = imagePickerController;

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
    UIImage *aImage = info[UIImagePickerControllerOriginalImage];
    if (self.isBlur) {
        // 高斯模糊

        self.isBlur=!self.isBlur;
        NSLog(@"高斯模糊");
        //boxSize必须大于0
        int boxSize = (int)(0.5f * 100);
        boxSize -= (boxSize % 2) + 1;
        NSLog(@"boxSize:%i",boxSize);
        //图像处理
        CGImageRef img = aImage.CGImage;
        //需要引入
        /*
         This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
         本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
         */

        //图像缓存,输入缓存，输出缓存
        vImage_Buffer inBuffer, outBuffer;
        vImage_Error error;
        //像素缓存
        void *pixelBuffer;

        //数据源提供者，Defines an opaque type that supplies Quartz with data.
        CGDataProviderRef inProvider = CGImageGetDataProvider(img);
        // provider’s data.
        CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);

        //宽，高，字节/行，data
        inBuffer.width = CGImageGetWidth(img);
        inBuffer.height = CGImageGetHeight(img);
        inBuffer.rowBytes = CGImageGetBytesPerRow(img);
        inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);

        //像数缓存，字节行*图片高
        pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));

        outBuffer.data = pixelBuffer;
        outBuffer.width = CGImageGetWidth(img);
        outBuffer.height = CGImageGetHeight(img);
        outBuffer.rowBytes = CGImageGetBytesPerRow(img);


        // 第三个中间的缓存区,抗锯齿的效果
        void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
        vImage_Buffer outBuffer2;
        outBuffer2.data = pixelBuffer2;
        outBuffer2.width = CGImageGetWidth(img);
        outBuffer2.height = CGImageGetHeight(img);
        outBuffer2.rowBytes = CGImageGetBytesPerRow(img);


        //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);


        if (error) {
            NSLog(@"error from convolution %ld", error);
        }


        //NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
        //颜色空间DeviceRGB
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
        CGContextRef ctx = CGBitmapContextCreate(
                                                 outBuffer.data,
                                                 outBuffer.width,
                                                 outBuffer.height,
                                                 8,
                                                 outBuffer.rowBytes,
                                                 colorSpace,
                                                 CGImageGetBitmapInfo(aImage.CGImage));

        //根据上下文，处理过的图片，重新组件
        CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
        UIImage *returnImage = [UIImage imageWithCGImage:imageRef];

        //clean up
        CGContextRelease(ctx);
        CGColorSpaceRelease(colorSpace);

        free(pixelBuffer);
        free(pixelBuffer2);
        CFRelease(inBitmapData);

        CGColorSpaceRelease(colorSpace);
        CGImageRelease(imageRef);

        [picker dismissViewControllerAnimated:YES completion:^{
            self.image = returnImage;
            [self.tableView reloadData];
        }];
    }else{

        NSLog(@"不经过高斯模糊处理");
        NSData*imageData = UIImageJPEGRepresentation(aImage, 0.3);
        UIImage*newImage = [[UIImage alloc]initWithData:imageData];

        [picker dismissViewControllerAnimated:YES completion:^{
            self.image = newImage;
            [self.tableView reloadData];
        }];
    }
}


#pragma mark - Button Method
- (IBAction)cancelButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cameraButtonClicked:(id)sender {
    [self.imagePickerController takePicture];
}

- (IBAction)switchValueChanged:(id)sender {
    self.isBlur = ((UISwitch *)sender).isOn;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
