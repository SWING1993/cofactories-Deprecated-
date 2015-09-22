//
//  SearchSupplymaterialViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/19.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "SearchSupplymaterialViewController.h"
#import "userInformationCell.h"
#import "MaterialInfoCell.h"
@interface SearchSupplymaterialViewController () {
    NSArray *titleArray1;
    NSArray *titleArray2;
}

@end

static NSString *searchCellIdentifier = @"SearchCell";
static NSString *userCellIdentifier = @"userCell";
@implementation SearchSupplymaterialViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatTableView];
    [self creatCancleButton];
    [self creatHeaderView];
    
    
    [self creatToolBar];
    
    //注册cell
    [self.tableView registerClass:[MaterialInfoCell class] forCellReuseIdentifier:searchCellIdentifier];
    [self.tableView registerClass:[userInformationCell class] forCellReuseIdentifier:userCellIdentifier];
    
    titleArray1 = @[@"类型:", @"名称:", @"价格:", @"门幅:", @"产品用途:", @"面料说明:"];
    titleArray2 = @[@"类型:", @"名称:", @"价格:", @"面料说明:"];

}

- (void)creatHeaderView {
    self.tableViewHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.85 *kScreenW)];
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.85 *kScreenW)];
    self.photoView.image = [UIImage imageNamed:@"没有上传图片"];
    [self.tableViewHeadView addSubview:self.photoView];
    
//    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenW, kScreenW - 20, 40)];
//    self.numberLabel.text = @"采购数量：300米";
    
    [self.tableViewHeadView addSubview:self.numberLabel];
    
    
    
    self.tableView.tableHeaderView = self.tableViewHeadView;
}


- (void)creatCancleButton {
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(20, 30, 30, 30);
    [cancleButton setImage:[UIImage imageNamed:@"nav_back_icon"] forState:UIControlStateNormal];
    cancleButton.layer.cornerRadius = 15;
    cancleButton.layer.masksToBounds = YES;
    [cancleButton addTarget:self action:@selector(pressCancleButton) forControlEvents:UIControlEventTouchUpInside];
    
    cancleButton.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.430];
    [self.view addSubview:cancleButton];

}

- (void)creatToolBar {
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, kScreenH - 40, kScreenW, 40)];
    //UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
    UIButton *phoneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
//    phoneBtn.backgroundColor = [UIColor redColor];
    [phoneBtn setTitle: @"电话" forState:UIControlStateNormal];
    [phoneBtn setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(pressphoneBtn:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:phoneBtn];
    [self.view addSubview:toolBar];
    
}


- (void)creatTableView {
//    [self.navigationController.navigationBar setHidden:YES];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenW, kScreenH - 20) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:self.tableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        userInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellIdentifier forIndexPath:indexPath];
        return cell;
    }
    MaterialInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier forIndexPath:indexPath];
        cell.nameLabel.text = titleArray1[indexPath.row];
    InformationModel *information = [[InformationModel alloc] init];
    information.title = @"克，和口袋上印有电子吉他图案的白色燕尾衬衫，非常符合潮流。女孩则穿着紫红色的低腰紧身连衣裙，以及功能性面料制成的纯白色裤子";
    cell.info = information;
    
    
    
    
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    } else
    return [MaterialInfoCell heightOfCell:@"克，和口袋上印有电子吉他图案的白色燕尾衬衫，非常符合潮流。女孩则穿着紫红色的低腰紧身连衣裙，以及功能性面料制成的纯白色裤子"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 1;
}




- (void)pressCancleButton {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)pressphoneBtn:(UIButton *)button {
    DLog(@"打电话");
    
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
