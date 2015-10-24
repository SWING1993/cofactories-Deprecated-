//
//  FactoryListViewController.m
//  1111111111111
//
//  Created by GTF on 15/10/17.
//  Copyright © 2015年 GTF. All rights reserved.
//

#define SELECTED_COLUMN 100
#import "FactoryListViewController.h"
#import "DOPDropDownMenu.h"
#import "FacTableViewCell.h"
#import "MJRefresh.h"
#import "CooperationInfoViewController.h"

@interface FactoryListViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    // 请求参数 1~7
    NSInteger        _facType;
    NSArray         *_facSize;
    NSString        *_city;
    NSString        *_facServiceRange;
    NSNumber        *_facFreeTime;
    NSString        *_facFreeStatus;
    NSNumber        *_page;
    
    DOPDropDownMenu *_dropDownMenu;
    NSInteger        _selectedColumn;
    UITableView     *_tableView;
    NSMutableArray  *_dataArray;
    NSInteger        _refrushCount;

}

@property (nonatomic, strong) NSArray *factoryTypeArray;  //工厂类型
@property (nonatomic, strong) NSArray *typeArray;        //类型
@property (nonatomic, strong) NSArray *scaleArray;        //规模
@property (nonatomic, strong) NSArray *areaArray;        //区域
@property (nonatomic, strong) NSArray *idleTimeArray;    //空闲时间

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation FactoryListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [HttpClient searchFactoriesWithFactoryType:_selectedFactoryIndex factorySize:nil city:nil factoryServiceRange:nil factoryFreeTime:nil factoryFreeStatus:nil page:@(1) completionBlock:^(NSDictionary *responseDictionary) {
        DLog(@"responseDictionary==%@",responseDictionary);
        _dataArray = responseDictionary[@"responseArray"];
        [_tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"找合作商";
    _city = nil;
    _facFreeStatus = nil;
    _facFreeTime = nil;
    _facServiceRange = nil;
    
    _factoryTypeArray = @[@"全部厂商",@"服装厂",@"加工厂",@"代裁厂",@"锁眼钉扣",@"面辅料商"];
    _scaleArray = @[@"规模不限"];
    _areaArray = @[@"区域不限"];
    _idleTimeArray = @[@"空闲不限"];
    
    _dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    _dropDownMenu.delegate = self;
    _dropDownMenu.dataSource = self;
    [self.view addSubview:_dropDownMenu];
    
    _dataArray = [[NSMutableArray alloc] init];
    [self creatTableView];
    _refrushCount = 1;
    [self setupRefresh];
}

- (void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, kScreenW, kScreenH-44-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 80;
    [_tableView registerClass:[FacTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];

}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FacTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    FactoryModel *model = (FactoryModel *)_dataArray[indexPath.row];
    [cell getFactoryDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FactoryModel *model = (FactoryModel *)_dataArray[indexPath.row];
    CooperationInfoViewController *VC = [[CooperationInfoViewController alloc] init];
    VC.factoryModel = model;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - MJRefesh

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
    DLog(@"???????????%ld",_refrushCount);
    
    [HttpClient searchFactoriesWithFactoryType:_facType factorySize:_facSize city:_city factoryServiceRange:_facServiceRange factoryFreeTime:_facFreeTime factoryFreeStatus:_facFreeStatus page:@(_refrushCount) completionBlock:^(NSDictionary *responseDictionary) {
        DLog(@"responseDictionary==%@",responseDictionary[@"responseArray"]);
        
        NSArray *array = responseDictionary[@"responseArray"];
        
        for (int i=0; i<array.count; i++)
        {
            FactoryModel *model = array[i];
            
            [_dataArray addObject:model];
        }
        [_tableView reloadData];

    }];

    [_tableView footerEndRefreshing];
}

#pragma mark - DOPDropDownMenu

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return 4;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    switch (column) {
        case 0:
            return _factoryTypeArray.count;
            break;
        case 1:
            return _scaleArray.count;
            break;
        case 2:
            return _areaArray.count;
            break;
        case 3:
            return _idleTimeArray.count;
            break;
        default:
            break;
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    switch (indexPath.column) {
        case 0:
            return _factoryTypeArray[indexPath.row];
            break;
        case 1:
            return _scaleArray[indexPath.row];
            break;
        case 2:
            return _areaArray[indexPath.row];
            break;
        case 3:
            return _idleTimeArray[indexPath.row];
            break;
        default:
            break;
    }
    return nil;
    
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column{
    
    if (column == 0) {
        
        [self selcetedToChangeTypeItemWithCondition:row];
        return _typeArray.count;
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.column == 0) {
        
        [self selcetedToChangeTypeItemWithCondition:indexPath.row];
        return _typeArray[indexPath.item];
    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.column == 0 ) {
    return [NSString stringWithFormat:@"imageColumn%ld",indexPath.row];
    }
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.column == 0) {
        switch (indexPath.row) {
            case 1:
                if (indexPath.item == 0) {
                    return @"imageColumn0";
                }else{
                    return [NSString stringWithFormat:@"imageRow1%ld",indexPath.item];
                }
                break;
            case 2:
                if (indexPath.item == 0) {
                    return @"imageColumn0";
                }else{
                    return [NSString stringWithFormat:@"imageRow2%ld",indexPath.item];
                }
                break;
            case 5:
                if (indexPath.item == 0) {
                    return @"imageColumn0";
                }else{
                    return [NSString stringWithFormat:@"imageRow5%ld",indexPath.item];
                }
                break;
            default:
                break;
        }
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{

    if (indexPath.column == 0) {
        _selectedColumn = SELECTED_COLUMN;          //选中第一列
        switch (indexPath.row) {
                
            case 0:
                _scaleArray = @[@"规模不限"];
                _areaArray = @[@"区域不限"];
                _idleTimeArray = @[@"空闲不限"];
                break;
            case 1:
                _scaleArray = @[@"规模不限",@"10万以下",@"10-40万",@"40-100万",@"100-200万",@"200万以上"];
                _areaArray = @[@"区域不限",@"湖州",@"杭州",@"广州",@"苏州",@"宁波",@"绍兴",@"其他"];
                _idleTimeArray = @[@"空闲不限"];
                break;
            case 2:
                _scaleArray = @[@"规模不限",@"2人以下",@"2-10人",@"10-20人",@"20人以上"];
                _areaArray = @[@"区域不限",@"湖州",@"杭州",@"广州",@"苏州",@"宁波",@"绍兴",@"其他"];
                _idleTimeArray = @[@"空闲不限",@"1天后有空",@"3天后有空",@"5天后有空",@"10天后有空"];
                break;
            case 3:
                _scaleArray = @[@"规模不限",@"2人以下",@"2-4人",@"4人以上"];
                _areaArray = @[@"区域不限",@"湖州",@"杭州",@"广州",@"苏州",@"宁波",@"绍兴",@"其他"];
                _idleTimeArray = @[@"空闲不限",@"空闲",@"忙碌"];
                break;
            case 4:
                _scaleArray = @[@"规模不限",@"2人以下",@"2-4人",@"4人以上"];
                _areaArray = @[@"区域不限",@"湖州",@"杭州",@"广州",@"苏州",@"宁波",@"绍兴",@"其他"];
                _idleTimeArray = @[@"空闲不限",@"空闲",@"忙碌"];
                break;
            case 5:
                _scaleArray = @[@"规模不限"];
                _areaArray = @[@"区域不限",@"湖州",@"杭州",@"广州",@"苏州",@"宁波",@"绍兴",@"其他"];
                _idleTimeArray = @[@"空闲不限"];
                break;
            default:
                break;
        }
    }else{
        _selectedColumn = 998;
    }
    
    if (_selectedColumn == SELECTED_COLUMN) {
        
        switch (indexPath.row) {
                _facServiceRange = nil;
            case 0:
                _facType = 0;
                break;
            case 1:
                _facType = 100;
                switch (indexPath.item) {
                    case 0:
                        _facServiceRange = nil;
                        break;
                    case 1:
                        _facServiceRange = @"童装";
                        break;
                    case 2:
                        _facServiceRange = @"成人装";
                        break;
                    default:
                        break;
                }
                break;
            case 2:
                _facType = 1;
                switch (indexPath.item) {
                    case 0:
                        _facServiceRange = nil;
                        break;
                    case 1:
                        _facServiceRange = @"针织";
                        break;
                    case 2:
                        _facServiceRange = @"梭织";
                        break;
                    default:
                        break;
                }

                break;
            case 3:
                _facType = 2;
                break;
            case 4:
                _facType = 3;
                break;
            case 5:
                _facType = 5;
                switch (indexPath.item) {
                    case 0:
                        _facServiceRange = nil;
                        break;
                    case 1:
                        _facServiceRange = @"面料商";
                        break;
                    case 2:
                        _facServiceRange = @"辅料商";
                        break;
                    default:
                        break;
                }

                break;
                
            default:
                break;
        }
    }
    if (indexPath.column == 1) {
        switch (_facType) {
            case 0:
                _facSize = nil;
                break;
            case 100:
                switch (indexPath.row) {
                    case 0:
                        _facSize = nil;
                        break;
                    case 1:
                        _facSize = @[@(0),@(100000)];
                        break;
                    case 2:
                        _facSize = @[@(100000),@(400000)];
                        break;
                    case 3:
                        _facSize = @[@(400000),@(1000000)];
                        break;
                    case 4:
                        _facSize = @[@(1000000),@(2000000)];
                        break;
                    case 5:
                        _facSize = @[@(2000000),@(3000000)];
                        break;
                        
                    default:
                        break;
                }
                break;
            case 1:
                switch (indexPath.row) {
                    case 0:
                        _facSize = nil;
                        break;
                    case 1:
                        _facSize = @[@(0),@(2)];
                        break;
                    case 2:
                        _facSize = @[@(2),@(10)];
                        break;
                    case 3:
                        _facSize = @[@(10),@(20)];
                        break;
                    case 4:
                        _facSize = @[@(20),@(30)];
                        break;
                    default:
                        break;
                }
                break;
            case 2:
                switch (indexPath.row) {
                    case 0:
                        _facSize = nil;
                        break;
                    case 1:
                        _facSize = @[@(0),@(2)];
                        break;
                    case 2:
                        _facSize = @[@(2),@(4)];
                        break;
                    case 3:
                        _facSize = @[@(4),@(30)];
                        break;
                    default:
                        break;
                }
                
                break;
            case 3:
                switch (indexPath.row) {
                    case 0:
                        _facSize = nil;
                        break;
                    case 1:
                        _facSize = @[@(0),@(2)];
                        break;
                    case 2:
                        _facSize = @[@(2),@(4)];
                        break;
                    case 3:
                        _facSize = @[@(4),@(30)];
                        break;
                    default:
                        break;
                }
                
                
                break;
            case 5:
                _facSize = nil;
                break;
            default:
                break;
        }
    }
    if (indexPath.column == 2) {
        if (_facType == 0) {
            _city = nil;
        }else{
            NSArray *cityArray = @[@"",@"湖州",@"杭州",@"广州",@"苏州",@"宁波",@"绍兴",@"其他"];
            _city = cityArray[indexPath.row];
        }
    }
    if (indexPath.column == 3) {
        if (_facType == 1) {
            _facFreeStatus = nil;
            switch (indexPath.row) {
                case 0:
                    _facFreeTime = nil;
                    break;
                case 1:
                    _facFreeTime = @(1);
                    break;

                case 2:
                    _facFreeTime = @(3);
                    break;

                case 3:
                    _facFreeTime = @(5);
                    break;

                case 4:
                    _facFreeTime = @(10);
                    break;

                default:
                    break;
            }
        }
        else if (_facType == 2 || _facType == 3) {
            _facFreeTime = nil;
            switch (indexPath.row) {
                case 0:
                    _facFreeStatus = nil;
                    break;
                case 1:
                    _facFreeStatus = @"空闲";
                    break;
                case 2:
                    _facFreeStatus = @"忙碌";
                    break;
                default:
                    break;
            }
        }else{
            _facFreeTime = nil;
            _facFreeStatus = nil;
        }
    }
    DLog(@"\nfacType=%ld\nfacServiceRange==%@\nfacSize==%@\ncity==%@\nfacFreeStatus==%@\nfacFreeTime%@",_facType,_facServiceRange,_facSize,_city,_facFreeStatus,_facFreeTime);
    
    _refrushCount = 1;
    [HttpClient searchFactoriesWithFactoryType:_facType factorySize:_facSize city:_city factoryServiceRange:_facServiceRange factoryFreeTime:_facFreeTime factoryFreeStatus:_facFreeStatus page:@(1) completionBlock:^(NSDictionary *responseDictionary) {
        DLog(@"responseDictionary==%@",responseDictionary[@"responseArray"]);
        if (!_dataArray) {
            _dataArray = [@[] mutableCopy];
        }
        _dataArray = responseDictionary[@"responseArray"];
        [_tableView reloadData];
    }];
    
    //NSLog(@"indexPath.column==%ld\nindexPath.row==%ld\nindexPath.item==%ld",indexPath.column,indexPath.row,indexPath.item);
}

- (void)selcetedToChangeTypeItemWithCondition:(NSInteger)condition{
    switch (condition) {
        case 0:
            _typeArray = @[];
            break;
        case 1:
            _typeArray = @[@"全部",@"童装",@"成人装"];
            break;
        case 2:
            _typeArray = @[@"全部",@"针织",@"梭织"];
            break;
        case 3:
            _typeArray = @[];
            break;
        case 4:
            _typeArray = @[];
            break;
        case 5:
            _typeArray = @[@"全部",@"面料商",@"辅料商"];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
