//
//  MaterialBidViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "MaterialBidViewController.h"
#import "MaterialBidTableViewCell.h"
#import "MaterialBidManagerModel.h"
#import "OrderPhotoViewController.h"
#import "PurchasePublicHistoryModel.h"

@interface MaterialBidViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    UITableView    *_tableView;
    NSMutableArray *_mutableArray;
}

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation MaterialBidViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.title = @"投标管理";
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认中标" style:UIBarButtonItemStylePlain target:self action:@selector(comfirmBidClick)];
    _mutableArray = [@[] mutableCopy];
    [self creatTableView];
}

- (void)creatTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MaterialBidTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    _tableView.rowHeight = 70;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MaterialBidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    MaterialBidManagerModel *model = self.dataArray[indexPath.row];
    [cell getDataWithModel:model];
    
    [cell.commentButton addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.commentButton.tag = indexPath.row+1;

    [cell.photoButton addTarget:self action:@selector(photoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.photoButton.tag = indexPath.row+1;
    
    [cell.selectedButton addTarget:self action:@selector(selectedClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectedButton.tag = indexPath.row+1;
    
    [cell.userButton addTarget:self action:@selector(cooprationClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.userButton.tag = indexPath.row+1;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}

- (void)selectedClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    
    NSLog(@"%zi",button.tag-1);
    
    if (_mutableArray.count>0) {
        UIButton *lastbutton = [_mutableArray firstObject];
        lastbutton.backgroundColor = [UIColor grayColor];
    }
    
    button.backgroundColor = [UIColor colorWithRed:53/255.0 green:100/255.0 blue:215/255.0 alpha:1.0];
    [_mutableArray removeAllObjects];
    [_mutableArray addObject:button];

}

- (void)commentBtnClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    MaterialBidManagerModel *model = self.dataArray[button.tag-1];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"备注" message:model.comment delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
    [alert show];
}

- (void)photoBtnClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    MaterialBidManagerModel *model = self.dataArray[button.tag-1];
    NSArray *photoArray = model.photoArray;
    if (photoArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"厂家未上传图片" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alert show];
    }else{
        OrderPhotoViewController *VC = [[OrderPhotoViewController alloc]initWithPhotoArray:photoArray];
        VC.titleString = @"投标相册";
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (void)cooprationClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    MaterialBidManagerModel *model = self.dataArray[button.tag-1];

    [HttpClient getUserProfileWithUid:model.userID andBlock:^(NSDictionary *responseDictionary) {
        FactoryModel *facModel = (FactoryModel *)responseDictionary[@"model"];
        CooperationInfoViewController *vc = [CooperationInfoViewController new];
        vc.factoryModel = facModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];

}

- (void)comfirmBidClick{
    
    
    if (_mutableArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选取左侧按钮以确认中标厂商!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alert show];
    }else{
        DLog(@"%zi",self.orderModel.orderID);
        UIButton *selectedButton = [_mutableArray firstObject];
        
        DLog(@"%zi",selectedButton.tag);
        MaterialBidManagerModel *model = self.dataArray[selectedButton.tag-1];
        
        DLog(@"%zi",model.userID);
        
       [HttpClient closeMaterialBidOrderWithWinnerID:model.userID orderID:self.orderModel.orderID completionBlock:^(NSDictionary *responseDictionary) {
           DLog(@"%@",responseDictionary);
           NSInteger number = [responseDictionary[@"responseDictionary"] integerValue];
           if (number == 200) {
               [Tools showSuccessWithStatus:@"订单完成"];
               NSArray *navArray = self.navigationController.viewControllers;
               [self.navigationController popToViewController:navArray[1] animated:YES];
           }else{
               [Tools showErrorWithStatus:@"订单关闭失败"];
           }
       }];

    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
