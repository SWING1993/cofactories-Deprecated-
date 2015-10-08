//
//  OrderListViewController.m
//  111111
//
//  Created by 宇宙之神 on 15/7/19.
//  Copyright (c) 2015年 宇宙之神. All rights reserved.
//

#import "OrderListViewController.h"
#import "OrderListTableViewCell.h"
#import "OrderDetailViewController.h"
#import "Header.h"
@interface OrderListViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSInteger _deleteOrderIndex;
}
@property (nonatomic, strong)NSArray *orderModerArr;
@end

@implementation OrderListViewController {
    int oid;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.myOrderEnum == HistoryOrder) {
        self.title=@"历史订单";
        [HttpClient listHistoryOrderWithBlock:^(NSDictionary *responseDictionary) {
            if ([responseDictionary[@"statusCode"] intValue]==200) {
                self.orderModerArr=responseDictionary[@"responseArray"];
                [_tableView reloadData];
            }
        }];
    }if (self.myOrderEnum == GarmentFactoryOrder){
        self.title=@"进行中的订单";
        [HttpClient listOrderWithBlock:^(NSDictionary *responseDictionary) {
            if ([responseDictionary[@"statusCode"] intValue]==200) {
                self.orderModerArr=responseDictionary[@"responseArray"];
                [_tableView reloadData];
            }
        }];
    }if (self.myOrderEnum == ProcessingFactoryOrder) {
        self.title=@"加工厂订单";
        self.orderModerArr = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64)  style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 130.0f;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[OrderListTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)goBack {
    
    if (self.myOrderEnum == ProcessingFactoryOrder) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSArray *navArray = self.navigationController.viewControllers;
        [self.navigationController popToViewController:navArray[1] animated:YES];
    }
}

#pragma mark--表的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderModerArr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    OrderModel*model = self.orderModerArr[indexPath.row];

    if (model.type == 2 || model.type == 3) {
        cell.orderTypeLabel.hidden = YES;
        cell.workingTimeLabel.hidden = YES;

    }else{
        cell.orderTypeLabel.hidden = NO;
        cell.orderTypeLabel.text = [NSString stringWithFormat:@"订单类型 :  %@",model.serviceRange];
        cell.workingTimeLabel.hidden = NO;
        cell.workingTimeLabel.text = [NSString stringWithFormat:@"期限 :  %@天",model.workingTime];
    }
    

    NSMutableArray *arr = [Tools WithTime:model.createTime];
    cell.timeLabel.text = arr[0];
   [cell.orderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/order/%d.png",PhotoAPI,model.oid]] placeholderImage:[UIImage imageNamed:@"placeholder232"]];//gt123
    NSLog(@">>%@",[NSString stringWithFormat:@"%@/order/%d.png",PhotoAPI,model.oid]);
    cell.amountLabel.text = [NSString stringWithFormat:@"订单数量 :  %d%@",model.amount,@"件"];
    
    if (model.interest == 0) {
        cell.labels.hidden = YES;
        cell.interestCountLabel.hidden = YES;
    }if (model.interest > 0) {
        cell.labels.hidden = NO;
        cell.interestCountLabel.hidden = NO;
        cell.interestCountLabel.text = [NSString stringWithFormat:@"%d",model.interest];
    }

    if (self.myOrderEnum == HistoryOrder) {
        cell.statusImage.hidden = NO;
    }if (self.myOrderEnum == GarmentFactoryOrder) {
        cell.statusImage.hidden = YES;
    }
    
    [cell.orderDetailsBtn addTarget:self action:@selector(orderDetailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderDetailsBtn.tag = indexPath.row+1;
    
    if (self.myOrderEnum == HistoryOrder) {
        cell.deleteButton.hidden = YES;
    }if (self.myOrderEnum == GarmentFactoryOrder) {
        cell.deleteButton.hidden = NO;
        [cell.deleteButton addTarget:self action:@selector(deleteOrderClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteButton.tag = indexPath.row+1;
    }
    
    return cell;
}



#pragma mark--订单详情按钮绑、删除按钮定方法

- (void)orderDetailsBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    OrderModel*model = self.orderModerArr[button.tag-1];
    OrderDetailViewController *VC = [[OrderDetailViewController alloc]init];
    VC.model=model;
    if (self.myOrderEnum==HistoryOrder)
    {
        VC.isHistory =YES;
    }if (self.myOrderEnum == GarmentFactoryOrder){
        VC.isHistory = NO;
    }
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:VC animated:YES];
}


- (void)deleteOrderClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    
    _deleteOrderIndex = button.tag-1;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否取消订单" message:@"订单一旦取消不可恢复，是否取消订单?" delegate:self cancelButtonTitle:@"不取消订单" otherButtonTitles:@"取消订单", nil];
    [alert show];
    
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
       
        OrderModel*model = self.orderModerArr[_deleteOrderIndex];

        [HttpClient deleteOrderWithOrderOid:model.oid completionBlock:^(int statusCode) {
            
            if (statusCode == 200) {
                
                [Tools showSuccessWithStatus:@"删除订单成功"];
                [HttpClient listOrderWithBlock:^(NSDictionary *responseDictionary) {
                    if ([responseDictionary[@"statusCode"] intValue]==200) {
                        self.orderModerArr=responseDictionary[@"responseArray"];
                        [_tableView reloadData];
                    }
                }];
            }else{
                
                [Tools showErrorWithStatus:@"删除订单失败"];
 
            }
        }];
    }
}



@end
