//
//  SetaddressViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "SetaddressViewController.h"

@interface SetaddressViewController () <BMKGeoCodeSearchDelegate> {
    UITextField*addressTF;
    BMKGeoCodeSearch *_searcher;
}

@end

@implementation SetaddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"公司地址";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];

    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    _searcher = [[BMKGeoCodeSearch alloc] init];
    _searcher.delegate = self;

    addressTF=[[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 44)];
    addressTF.text=self.placeholder;
    addressTF.clearButtonMode=YES;
    addressTF.placeholder=@"输入公司地址";

    //确定Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;
}

- (void)buttonClicked {
    if ([addressTF.text isEqualToString:@""]) {
        UIAlertView*alertView =[[UIAlertView alloc]initWithTitle:@"公司地址不能为空" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc] init];
        geoCodeSearchOption.address = addressTF.text;
        if ([_searcher geoCode:geoCodeSearchOption]) {
            NSLog(@"geo检索发送正常");

        } else {
            NSLog(@"geo检索发送失败");
            UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"检索发送失败" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
        }

    }
}

#pragma mark - <BMKGeoCodeSearchDelegate>
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        // 正常结果

        //NSLog(@"%lf %lf", result.location.latitude, result.location.longitude);
        SetMapViewController*mapVC = [[SetMapViewController alloc]init];
        mapVC.addressStr=addressTF.text;
        mapVC.centerLocation = result.location;
        [self.navigationController pushViewController:mapVC animated:YES];
    } else {
        UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"抱歉，未找到结果" message:@"请重新填写地址" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    [cell addSubview:addressTF];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
