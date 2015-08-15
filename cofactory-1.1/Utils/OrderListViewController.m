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
}
@property (nonatomic, retain)NSMutableArray*orderModerArr;
@end

@implementation OrderListViewController {
    int oid;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.isHistory==YES) {
        self.title=@"历史订单";
        self.orderModerArr=[[NSMutableArray alloc]initWithCapacity:0];
        [HttpClient listHistoryOrderWithBlock:^(NSDictionary *responseDictionary) {
            if ([responseDictionary[@"statusCode"] intValue]==200) {
                self.orderModerArr=responseDictionary[@"responseArray"];
                [_tableView reloadData];
            }
        }];
    }else{
        self.title=@"进行中的订单";
        self.orderModerArr=[[NSMutableArray alloc]initWithCapacity:0];
        [HttpClient listOrderWithBlock:^(NSDictionary *responseDictionary) {
            if ([responseDictionary[@"statusCode"] intValue]==200) {
                self.orderModerArr=responseDictionary[@"responseArray"];
                [_tableView reloadData];
            }
        }];
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
    
    if (model.type==1) {
        cell.orderTypeLabel.text = [NSString stringWithFormat:@"订单类型 :  %@",model.serviceRange];
        
        cell.workingTimeLabel.hidden = NO;
        cell.workingTimeLabel.text = [NSString stringWithFormat:@"期限 :  %@天",model.workingTime];
        
    }else
    {
        cell.workingTimeLabel.hidden = YES;
    }
    
    //gt123
    NSMutableArray *arr = [Tools WithTime:model.createTime];
    cell.timeLabel.text = arr[0];
    [cell.orderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,model.uid]] placeholderImage:[UIImage imageNamed:@"消息头像"]];//gt123
    cell.amountLabel.text = [NSString stringWithFormat:@"订单数量 :  %d%@",model.amount,@"件"];
    
    if (model.interest == 0) {
        cell.labels.hidden = YES;
        cell.interestCountLabel.hidden = YES;
    }if (model.interest > 0) {
        cell.labels.hidden = NO;
        cell.interestCountLabel.hidden = NO;
        cell.interestCountLabel.text = [NSString stringWithFormat:@"%d",model.interest];
    }

    if (self.isHistory == YES) {
        cell.statusImage.hidden = NO;
    }if (self.isHistory == NO) {
        cell.statusImage.hidden = YES;
    }
    
    [cell.orderDetailsBtn addTarget:self action:@selector(orderDetailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderDetailsBtn.tag = indexPath.row;
    return cell;
}



#pragma mark--订单详情按钮绑定方法

- (void)orderDetailsBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    OrderModel*model = self.orderModerArr[button.tag];
    OrderDetailViewController *VC = [[OrderDetailViewController alloc]init];
    VC.model=model;
    if (self.isHistory==YES)
    {
        VC.isHistory =YES;
    }else{
        VC.isHistory = NO;
    }
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:VC animated:YES];
}



@end
