//
//  HomeEditViewController.m
//  cofactory-1.1
//
//  Created by Mr.song on 15/7/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"

#define CellIdentifier @"Cell"

@interface HomeEditViewController ()

@end

@implementation HomeEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.editing = YES;
    // 多选
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    for (int i = 0; i < self.homeItemModel.allItemArray.count; ++i) {
        if ([self.homeItemModel.itemArray indexOfObject:self.homeItemModel.allItemArray[i]] != NSNotFound) {
            // 可以删除的项目
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled=NO;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    // 底部提交按钮
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 50)];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 200, 30);
    button.center = footerView.center;
    button.alpha=0.8f;
    [button setTitle:@"保存模块" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"btnGreen"] forState:UIControlStateNormal];
    // 按钮圆角
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 5.0f;
    [button addTarget:self action:@selector(savePreference:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:button];
    self.tableView.tableFooterView = footerView;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeItemModel.allItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.homeItemModel.allItemArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (void)savePreference:(id)sender {
    NSArray *indexPaths = [self.tableView indexPathsForSelectedRows];
    [self.homeItemModel.itemArray removeAllObjects];
//    if (indexPaths == nil) {
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
//    }
    // 上传网络构造字典
    NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:0];
    for (NSIndexPath *indexPath in indexPaths) {
        [self.homeItemModel.itemArray addObject:self.homeItemModel.allItemArray[indexPath.row]];
        [parameters addObject:@(indexPath.row)];
    }


    //更新MenuList  严重BUG  已修复
    MBProgressHUD *hud = [Tools createHUD];
    hud.labelText = @"正在添加模块";
    [HttpClient updateMenuWithMenuArray:parameters andBlock:^(int statusCode) {
        NSLog(@"%d",statusCode);
        if (statusCode == 200) {
            hud.labelText = @"模块更新成功";
            [hud hide:YES];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            hud.labelText = @"模块更新出错";
            [hud hide:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
