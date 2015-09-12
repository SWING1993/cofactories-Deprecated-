
//
//  SearchFactoryOrderVC.m
//  cofactory-1.1
//
//  Created by gt on 15/9/11.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "SearchFactoryOrderVC.h"
#import "DOPDropDownMenu.h"
#import "searchOrderListTVC.h"
#import "SearchOrderDetailsVC.h"

@interface SearchFactoryOrderVC ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableView;
    NSArray *_dataArray;
    NSArray *_classifyArray;
    NSArray *_amountArray;
    NSArray *_workingTimeArray;
    NSString *_typeString;
    NSString *_workingTime;
    NSNumber *_min;
    NSNumber *_max;
}
@end

static NSString *const cellIdentifer = @"cell";

@implementation SearchFactoryOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _classifyArray = @[@"不限类型",@"针织",@"梭织"];
    _amountArray = @[@"不限数量",@"500件以内",@"500-1000件",@"1000-2000件",@"2000-5000件",@"5000件以上"];
    _workingTimeArray = @[@"不限时间",@"3天",@"5天",@"5天以上"];
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
    [HttpClient searchOrderWithRole:-1 FactoryServiceRange:nil Time:nil AmountMin:nil AmountMax:nil Page:@1 andBlock:^(NSDictionary *responseDictionary) {
        DLog(@"+++++responseDictionary==%@",responseDictionary[@"statusCode"]);
        if ([responseDictionary[@"statusCode"] compare:@200] == NSOrderedSame) {
            _dataArray = responseDictionary[@"responseArray"];
            [_tableView reloadData];
        }
    }];
    
    [self creatTableView];
}

- (void)creatTableView{
    
    _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreenW, kScreenH-44-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 130.0f;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[searchOrderListTVC class] forCellReuseIdentifier:cellIdentifer];
    [self.view addSubview:_tableView];
    
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    searchOrderListTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer forIndexPath:indexPath];
    OrderModel *model = _dataArray[indexPath.row];
    if (model.interest == 0) {
        cell.labels.hidden = YES;
        cell.interestCountLabel.hidden = YES;
    }if (model.interest > 0) {
        cell.labels.hidden = NO;
        cell.interestCountLabel.hidden = NO;
        cell.interestCountLabel.text = [NSString stringWithFormat:@"%d",model.interest];
    }
    if (model.status == 0) {
        cell.statusImage.hidden = YES;
    }if (model.status == 1) {
        cell.statusImage.hidden = NO;
    }
    NSMutableArray *arr = [Tools WithTime:model.createTime];
    cell.timeLabel.text = arr[0];
    [cell.orderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/order/%d.png",PhotoAPI,model.oid]] placeholderImage:[UIImage imageNamed:@"placeholder232"]];
    cell.workingTimeLabel.text = [NSString stringWithFormat:@"期限 :  %@",model.workingTime];
    cell.orderTypeLabel.text = [NSString stringWithFormat:@"订单类型 :  %@",model.serviceRange];
    cell.amountLabel.text = [NSString stringWithFormat:@"订单数量 :  %d%@",model.amount,@"件"];
    [cell.orderDetailsBtn addTarget:self action:@selector(orderDetailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderDetailsBtn.tag = indexPath.row+1;
    
    return cell;
}


#pragma mark - DOPDropDownMenu
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return _classifyArray.count;
    }else if (column == 1){
        return _amountArray.count;
    }else {
        return _workingTimeArray.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return _classifyArray[indexPath.row];
    } else if (indexPath.column == 1){
        return _amountArray[indexPath.row];
    } else {
        return _workingTimeArray[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    switch (indexPath.column) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    _typeString = @"不限类型";
                    break;
                    
                case 1:
                    _typeString = @"针织";
                    break;
                    
                case 2:
                    _typeString = @"梭织";
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    _min = @0;
                    _max = @100000;
                    break;
                case 1:
                    _min = @0;
                    _max = @500;
                    break;
                case 2:
                    _min = @500;
                    _max = @1000;
                    break;
                case 3:
                    _min = @1000;
                    _max = @2000;
                    break;
                case 4:
                    _min = @2000;
                    _max = @5000;
                    break;
                case 5:
                    _min = @5000;
                    _max = @1000000;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 2:
            switch (indexPath.row) {
                case 0:
                    _workingTime = nil;
                    break;
                case 1:
                    _workingTime = @"3天";
                    break;
                case 2:
                    _workingTime = @"5天";
                    break;
                case 3:
                    _workingTime = @"5天以上";
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    DLog(@"\n%@,,\n%@,,\n%@,,\n%@",_typeString,_min,_max,_workingTime);
    
    [HttpClient searchOrderWithRole:-1 FactoryServiceRange:_typeString Time:_workingTime AmountMin:_min AmountMax:_max Page:@1 andBlock:^(NSDictionary *responseDictionary) {
        DLog(@"+++++responseDictionary==%@",responseDictionary[@"statusCode"]);
        if ([responseDictionary[@"statusCode"] compare:@200] == NSOrderedSame) {
            _dataArray = responseDictionary[@"responseArray"];
            [_tableView reloadData];
        }
    }];
}

- (void)orderDetailsBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([Tools isTourist]) {
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"请您登录后查看订单详情" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        OrderModel *model = _dataArray [button.tag-1];
        SearchOrderDetailsVC *vc = [[SearchOrderDetailsVC alloc]init];
        vc.model = model;
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"";
        backItem.tintColor=[UIColor whiteColor];
        self.navigationItem.backBarButtonItem = backItem;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
