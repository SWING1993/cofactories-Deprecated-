//
//  ModifyJobViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/17.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "ModifyJobViewController.h"

@interface ModifyJobViewController () {

    UITextField*jobTF;
}


@end

@implementation ModifyJobViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"职务";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    //    self.navigationController.navigationBarHidden=YES;

    //设置Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked)];
    self.navigationItem.rightBarButtonItem = setButton;

    self.tableView=[[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;

    jobTF=[[UITextField alloc]initWithFrame:CGRectMake(15, 0, kScreenW-30, 44)];
    jobTF.font = kFont;
    jobTF.text=self.placeholder;
    jobTF.clearButtonMode=YES;
    jobTF.placeholder=@"输入职位";

}
- (void)buttonClicked {

    if ([jobTF.text isEqualToString:@""]) {
        UIAlertView*alertView =[[UIAlertView alloc]initWithTitle:@"职位不能为空" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        MBProgressHUD *hud = [Tools createHUD];
        hud.labelText = @"正在修改职位";
        [HttpClient modifyUserProfileWithName:nil job:jobTF.text id_card:nil andBlock:^(int statusCode) {
            if (statusCode == 200) {
                hud.labelText = @"职位修改成功";
                [hud hide:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                hud.labelText = @"职位修改失败";
                [hud hide:YES];
                UIAlertView*alertView =[[UIAlertView alloc]initWithTitle:@"职位不能为空" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.tableView endEditing:YES];
//}


#pragma mark - Table view data source

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
    [cell addSubview:jobTF];
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
