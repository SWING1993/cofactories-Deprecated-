//
//  DescriptionViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/18.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "DescriptionViewController.h"

@interface DescriptionViewController () {

    UITextView*descriptionTV;

}

@end

@implementation DescriptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"公司简介";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.rowHeight=100.0f;

    descriptionTV=[[UITextView alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 100)];
    descriptionTV.font=[UIFont systemFontOfSize:15.0f];
    descriptionTV.text=self.placeholder;

    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;
}

- (void)buttonClicked{

    if ([descriptionTV.text isEqualToString:@""]) {
        UIAlertView*alertView =[[UIAlertView alloc]initWithTitle:@"公司简介不能为空" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        MBProgressHUD *hud = [Tools createHUD];
        hud.labelText = @"正在修改姓名";
        [HttpClient updateFactoryProfileWithFactoryName:nil factoryAddress:nil factoryServiceRange:nil factorySizeMin:nil factorySizeMax:nil factoryLon:nil factoryLat:nil factoryFree:nil factoryDescription:descriptionTV.text andBlock:^(int statusCode) {
            if (statusCode == 200) {
                hud.labelText = @"公司简介修改成功";
                [hud hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                hud.labelText = @"公司简介修改失败";
                [hud hide:YES];
            }
        }];
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
    [cell addSubview:descriptionTV];
    return cell;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
