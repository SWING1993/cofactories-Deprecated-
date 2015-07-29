//
//  ModifySizeViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/17.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "ModifySizeViewController.h"

@interface ModifySizeViewController () <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    UITextField*SizeTF;
    NSString *_tmpPickerName;

}

@property (nonatomic,strong) UIPickerView *orderPicker;
@property (nonatomic,strong) UIToolbar    *pickerToolbar;

@end

@implementation ModifySizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"公司规模";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];

    //确定Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;

    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    SizeTF=[[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 44)];
    SizeTF.text=self.placeholder;
    SizeTF.clearButtonMode=YES;
    SizeTF.inputView = [self fecthPicker];
    SizeTF.inputAccessoryView = [self fecthToolbar];
    SizeTF.placeholder=@"选择公司规模";
    SizeTF.delegate =self;

}
- (void)buttonClicked {
    if ([SizeTF.text isEqualToString:@""]) {
        UIAlertView*alertView =[[UIAlertView alloc]initWithTitle:@"公司规模不能为空" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        MBProgressHUD *hud = [Tools createHUD];
        hud.labelText = @"正在修改";

        NSLog(@"%@===%@",[[Tools RangeSizeWith:SizeTF.text] firstObject],[[Tools RangeSizeWith:SizeTF.text] lastObject]);

        [HttpClient updateFactoryProfileWithFactoryName:nil factoryAddress:nil factoryServiceRange:nil factorySizeMin:[[Tools RangeSizeWith:SizeTF.text] firstObject] factorySizeMax:[[Tools RangeSizeWith:SizeTF.text] lastObject] factoryLon:nil factoryLat:nil factoryFree:nil  factoryDescription:nil andBlock:^(int statusCode) {
            if (statusCode == 200) {
                hud.labelText = @"修改成功";
                [hud hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                hud.labelText = @"修改失败";
                [hud hide:YES];
            }

        }];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell addSubview:SizeTF];
    return cell;
}


- (UIPickerView *)fecthPicker{
    if (!self.orderPicker) {
        self.orderPicker = [[UIPickerView alloc] init];
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
#pragma mark - UIPickerView datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.cellPickList.count;
}



- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.cellPickList objectAtIndex:row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _tmpPickerName = [self pickerView:pickerView titleForRow:row forComponent:component];
}
-(void)ensure{

    if (_tmpPickerName) {
        SizeTF.text = _tmpPickerName;
        _tmpPickerName = nil;
    }
    [SizeTF endEditing:YES];
}
-(void)cancel{

    _tmpPickerName = nil;
    [SizeTF endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
