//
//  searchOrderListVC.m
//  cofactory-1.1
//
//  Created by gt on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "searchOrderListVC.h"
#import "searchOrderListTVC.h"
#import "SearchOrderDetailsVC.h"
#import "Header.h"
#import "MJRefresh.h"
#import "DOPDropDownMenu.h"

@interface searchOrderListVC ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>{
    UITableView     *_tableView;
    NSMutableArray  *_dataArray;
    NSArray         *_orderTypeArray;
    NSArray         *_garmentServiceRangeArray;
    NSMutableArray  *_orderAmountArray;
    NSMutableArray  *_orderWorkingTimeArray;
    NSString        *_typeString;
    NSString        *_serviceRangeString;
    NSNumber        *_minNumber;
    NSNumber        *_maxNumber;
    NSString        *_timeString;
    int              _role;
    int              _refrushCount;
    
}

@end

@implementation searchOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [@[] mutableCopy];
    [self creatTableAndDOPDropDownMenu];
    
    [HttpClient searchOrderWithRole:self.orderListType FactoryServiceRange:nil Time:nil AmountMin:nil AmountMax:nil Page:@1 andBlock:^(NSDictionary *responseDictionary) {
        _dataArray = responseDictionary[@"responseArray"];
        DLog(@"+++++responseDictionary==%@",_dataArray);
        [_tableView reloadData];
    }];
    
    _refrushCount = 1;
    [self setupRefresh];
}

- (void)creatTableAndDOPDropDownMenu{
    _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreenW, kScreenH-44-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 130.0f;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[searchOrderListTVC class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    _orderTypeArray = @[@"不限类型",@"加工厂",@"代裁厂",@"锁眼钉扣厂"];
    _garmentServiceRangeArray = @[@"加工全部类型",@"针织",@"梭织"];
    _orderAmountArray = [@[@"不限时间"] mutableCopy];
    _orderWorkingTimeArray = [@[@"不限期限"] mutableCopy];
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
}

- (void)setupRefresh
{
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中。。。";
}

- (void)footerRereshing
{
    _refrushCount++;
    DLog(@"???????????%d",_refrushCount);
    NSNumber *num = [NSNumber numberWithInt:_refrushCount];
    [HttpClient searchOrderWithRole:_role FactoryServiceRange:_serviceRangeString Time:_timeString AmountMin:_minNumber AmountMax:_maxNumber Page:num andBlock:^(NSDictionary *responseDictionary) {
        
        NSArray *array = responseDictionary[@"responseArray"];
        
        for (int i=0; i<array.count; i++)
        {
            OrderModel *model = array[i];
            
            [_dataArray addObject:model];
        }
        [_tableView reloadData];
    }];
    
    
    [_tableView footerEndRefreshing];
}


#pragma mark--表的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    searchOrderListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    OrderModel *model = _dataArray[indexPath.row];
    [cell getDataWithModel:model orderListType:self.orderListType];
    self.uid = model.uid;
    [cell.orderDetailsBtn addTarget:self action:@selector(orderDetailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderDetailsBtn.tag = indexPath.row+1;
    
    return cell;
}

#pragma mark--订单详情按钮绑定方法
- (void)orderDetailsBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
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

#pragma mark - DOPDropDownMenu
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return _orderTypeArray.count;
    }else if (column == 1){
        return _orderAmountArray.count;
    }else {
        return _orderWorkingTimeArray.count;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return _orderTypeArray[indexPath.row];
    } else if (indexPath.column == 1){
        return _orderAmountArray[indexPath.row];
    } else {
        return _orderWorkingTimeArray[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0) {
        if (row == 1) {
            return _garmentServiceRangeArray.count;
        }else{
            return 0;
        }
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        if (indexPath.row == 1) {
            return _garmentServiceRangeArray[indexPath.item];
        }
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    if (indexPath.column == 0) {
        
        if (indexPath.row == 0) {
            _orderAmountArray = [@[@"不限规模"] mutableCopy];
            _orderWorkingTimeArray = [@[@"不限期限"] mutableCopy];
            
        }else if(indexPath.row == 1){
            
            _orderAmountArray = [@[@"500件以内",@"500-1000件",@"1000-2000件",@"2000-5000件",@"5000件以上"] mutableCopy];
            _orderWorkingTimeArray = [@[@"3天",@"5天",@"5天以上"] mutableCopy];
            
        }else {
            _orderAmountArray = [@[@"500件以内",@"500-1000件",@"1000-2000件",@"2000-5000件",@"5000件以上"] mutableCopy];
            _orderWorkingTimeArray = [@[@"24小时以内",@"1-3天",@"3天以上"] mutableCopy];
            
        }
    }
    
    switch (indexPath.column) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    _typeString = @"不限类型";
                    _serviceRangeString = nil;
                    _role = 0;
                    break;
                case 1:
                    switch (indexPath.item) {
                        case 0:
                            _typeString = @"加工全部类型";
                            _serviceRangeString = nil;
                            break;
                        case 1:
                            _typeString = @"针织";
                            _serviceRangeString = _typeString;
                            break;
                        case 2:
                            _typeString = @"梭织";
                            _serviceRangeString = _typeString;
                            break;
                            
                        default:
                            break;
                    }
                    _role = 1;
                    break;
                case 2:
                    _typeString = @"代裁厂";
                    _serviceRangeString = nil;
                    _role = 2;
                    break;
                case 3:
                    _typeString = @"锁眼钉扣";
                    _serviceRangeString = nil;
                    _role = 3;
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1:
            if ([_typeString isEqualToString:@"不限类型"] || _typeString == nil) {
                _minNumber = nil;
                _maxNumber = nil;
            }else{
                
                switch (indexPath.row) {
                    case 0:
                        _minNumber = @0;
                        _maxNumber = @500;
                        break;
                    case 1:
                        _minNumber = @500;
                        _maxNumber = @1000;
                        break;
                    case 2:
                        _minNumber = @1000;
                        _maxNumber = @2000;
                        break;
                    case 3:
                        _minNumber = @2000;
                        _maxNumber = @5000;
                        break;
                    case 4:
                        _minNumber = @5000;
                        _maxNumber = @100000;
                        break;
                        
                    default:
                        break;
                }
            }
            
            break;
            
        case 2:
            if ([_typeString isEqualToString:@"不限类型"] || _typeString == nil) {
                _timeString = nil;
            }else if ([_typeString isEqualToString:@"加工全部类型"] || [_typeString isEqualToString:@"针织"] ||[_typeString isEqualToString:@"梭织"]){
                
                switch (indexPath.row) {
                    case 0:
                        _timeString = @"3天";
                        break;
                    case 1:
                        _timeString = @"5天";
                        break;
                    case 2:
                        _timeString = @"5天以上";
                        break;
                        
                    default:
                        break;
                }
            }else if ([_typeString isEqualToString:@"代裁厂"] || [_typeString isEqualToString:@"锁眼钉扣厂"]){
                switch (indexPath.row) {
                    case 0:
                        _timeString = @"1天";
                        break;
                    case 1:
                        _timeString = @"1-3天";
                        break;
                    case 2:
                        _timeString = @"3天以上";
                        break;
                        
                    default:
                        break;
                }
                
            }
            
            break;
            
        default:
            break;
    }
    
    DLog(@"\n%d,\n%@，\n%@,\n%@,\n%@",_role,_serviceRangeString,_minNumber,_maxNumber,_timeString);
    
    _refrushCount = 1;
    [HttpClient searchOrderWithRole:_role FactoryServiceRange:_serviceRangeString Time:_timeString AmountMin:_minNumber AmountMax:_maxNumber Page:@1 andBlock:^(NSDictionary *responseDictionary) {
        _dataArray = responseDictionary[@"responseArray"];
        [_tableView reloadData];
    }];
    
}



@end
