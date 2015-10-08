//
//  LookOverShopViewController.m
//  cofactory-1.1
//
//  Created by GTF on 15/10/8.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "LookOverShopViewController.h"
#import "FactoryListTableViewCell.h"
#import "MJRefresh.h"
#import "ShopDetailViewViewController.h"

@interface LookOverShopViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    NSMutableArray     *_dataArray;
    UITableView *_tableView;
    int _refrushCount;
    
}

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation LookOverShopViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"0x28303b"]] forBarMetrics:UIBarMetricsDefault];
    
    [self customSearchBar];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatTableView];
    _dataArray = [@[] mutableCopy];
    [HttpClient searchWithFactoryName:nil factoryType:5 factoryServiceRange:nil factorySizeMin:nil factorySizeMax:nil factoryDistanceMin:nil factoryDistanceMax:nil Truck:nil factoryFree:nil page:@1 andBlock:^(NSDictionary *responseDictionary) {
        _dataArray = (NSMutableArray *)responseDictionary[@"responseArray"];
        [_tableView reloadData];
    }];
    _refrushCount = 1;
    [self setupRefresh];
    
}

- (void)customSearchBar{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入店铺名称";
    [searchBar setShowsCancelButton:YES];
    self.navigationItem.titleView = searchBar;
    
    for (UIView *view in [[searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancelBtn = (UIButton *)view;
            [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
}

- (void)creatTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    [_tableView registerClass:[FactoryListTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
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
    DLog(@"%d",_refrushCount);
    NSNumber *num = [NSNumber numberWithInt:_refrushCount];
    [HttpClient searchWithFactoryName:nil factoryType:5 factoryServiceRange:nil factorySizeMin:nil factorySizeMax:nil factoryDistanceMin:nil factoryDistanceMax:nil Truck:nil factoryFree:nil page:num andBlock:^(NSDictionary *responseDictionary) {
        NSArray *array = (NSArray *)responseDictionary[@"responseArray"];
        if (array.count == 0) {
            
        }else{
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FactoryModel *factoryModel = (FactoryModel *)obj;
                [_dataArray addObject:factoryModel];
            }];
        }
        
        [_tableView reloadData];
    }];
    [_tableView footerEndRefreshing];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [HttpClient searchWithFactoryName:searchBar.text factoryType:5 factoryServiceRange:nil factorySizeMin:nil factorySizeMax:nil factoryDistanceMin:nil factoryDistanceMax:nil Truck:nil factoryFree:nil page:@1 andBlock:^(NSDictionary *responseDictionary) {
        _dataArray = (NSMutableArray *)responseDictionary[@"responseArray"];
        [_tableView reloadData];
    }];
    
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    [self.view endEditing:YES];
}

#pragma mark -- tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FactoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    FactoryModel *factoryModel = _dataArray[indexPath.row];
    cell.isHaveCarLB.hidden = YES;
    if (factoryModel.verifyStatus == 0 ||factoryModel.verifyStatus == 1)
    {
        cell.certifyUserLB.hidden = YES;
    }
    if (factoryModel.verifyStatus == 2)
    {
        cell.certifyUserLB.hidden = NO;
    }
    cell.companyNameLB.text = factoryModel.factoryName;
    cell.companyLocationLB.text = factoryModel.factoryAddress;
    NSString* imageUrlString = [NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,factoryModel.uid];
    [cell.companyImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"placeholder88"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    FactoryModel *factoryModel = _dataArray[indexPath.row];

    [HttpClient getAllMaterialWithUserID:factoryModel.uid completionBlock:^(NSDictionary *responseDictionary) {
         ShopDetailViewViewController *VC = [[ShopDetailViewViewController alloc] initWithLookoverMaterialModel:responseDictionary[@"modelArray"]];
        VC.facModel = factoryModel;
        DLog(@"%@",responseDictionary[@"modelArray"]);
        [self.navigationController pushViewController:VC animated:YES];

    }] ;
    
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
