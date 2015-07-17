//
//  SearchViewController.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/16.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Header.h"
#import "SearchCell.h"
#import "SearchViewController.h"
#import "JSDropDownMenu.h"
#define CellIdentifier @"Cell"


@interface SearchViewController () <JSDropDownMenuDataSource, JSDropDownMenuDelegate, UISearchBarDelegate>


@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) NSMutableArray *data1;
@property (nonatomic, strong) NSMutableArray *data2;
@property (nonatomic, strong) NSMutableArray *data3;
@property (nonatomic, strong) JSDropDownMenu *menu;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listArray = @[];
    //self.tableView.backgroundColor = [UIColor colorWithHex:0xebeaea];
    self.tableView.rowHeight = 100.0f;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    [self.tableView registerNib:[UINib nibWithNibName:@"SearchCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
    self.title = @"工厂列表";
    // 搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入工厂名称";
    self.navigationItem.titleView = searchBar;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 指定默认选中
    //    _currentData1Index = 0;
    //    _currentData2Index = 0;
    //    _currentData3Index = 0;

    NSArray *clouthes = @[@"服装厂全部分类", @"童装", @"成人装"];
    NSArray *process = @[@"加工厂全部分类", @"针织", @"梭织"];
    _data1 = [NSMutableArray arrayWithObjects:@{@"title": @"全部分类", @"data": @[@"不限类型"]}, @{@"title": @"服装厂", @"data": clouthes}, @{@"title": @"加工厂", @"data": process}, @{@"title": @"代裁厂", @"data": @[@"代裁厂全部分类"]}, @{@"title": @"锁眼钉扣", @"data": @[@"锁眼钉扣全部分类"]}, nil];
    //    _data1 = [NSMutableArray arrayWithObjects:@"不限类型", @"服装厂", @"加工厂", @"代裁厂", @"锁眼钉扣", nil];
    _data2 = [NSMutableArray arrayWithObjects:@"不限规模", nil];
    _data3 = [NSMutableArray arrayWithObjects:@"不限距离", nil];

    self.menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:45];
    self.menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    self.menu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    self.menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    self.menu.dataSource = self;
    self.menu.delegate = self;

    NSDictionary *parameters = nil;
    if (self.currentData1Index != 0) {
        parameters = @{@"type": @(self.currentData1Index - 1)};
    }
    switch (_currentData1Index) {
        case 0:
            _currentData2Index = 0;
            _currentData3Index = 0;
            break;
        case 1:
            _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"10万件-30万件", @"30万件-50万件", @"50万件-100万件", @"100万件-200万件", @"200万件以上", nil];
            _data3 = [NSMutableArray arrayWithObjects:@"不限距离", @"10公里以内", @"50公里以内", @"100公里以内", @"150公里以内", @"200公里以内", @"200公里以上", nil];
            _currentData2Index = 0;
            _currentData3Index = 0;
            break;
        case 2:
            _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"2-4人", @"4-10人", @"10-20人", @"20人以上", nil];
            _data3 = [NSMutableArray arrayWithObjects:@"不限距离", @"10公里以内", @"50公里以内", @"100公里以内", @"150公里以内", @"200公里以内", @"200公里以上", nil];
            _currentData2Index = 0;
            _currentData3Index = 0;
            break;

        default:
            _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"2-4人", @"4人以上", nil];
            _data3 = [NSMutableArray arrayWithObjects:@"不限规模", @"1公里以内", @"5公里以内", @"10公里以内", nil];
            _currentData2Index = 0;
            _currentData3Index = 0;
            break;
    }
    [HttpClient searchWithFactoryName:nil factoryType:nil factoryServiceRange:nil factorySizeMin:nil factorySizeMax:nil factoryDistanceMin:nil factoryDistanceMax:nil andBlock:^(NSDictionary *responseDictionary) {

        NSLog(@"---%@",responseDictionary);
    }];



}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.listArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.menu;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    cell.factoryName.text = [self.listArray[indexPath.row] objectForKey:@"factoryName"] == [NSNull null] ? @"" : [self.listArray[indexPath.row] objectForKey:@"factoryName"];
    cell.location.text = [self.listArray[indexPath.row] objectForKey:@"factoryAddress"] == [NSNull null] ? @"" : [self.listArray[indexPath.row] objectForKey:@"factoryAddress"];
    cell.distance.text = [self.listArray[indexPath.row] objectForKey:@"distance"] == [NSNull null] ? @"" : [NSString stringWithFormat:@"%d公里", [[self.listArray[indexPath.row] objectForKey:@"distance"] intValue]];
    if ([self.listArray[indexPath.row] objectForKey:@"status"] != [NSNull null]) {
        if ([[self.listArray[indexPath.row] objectForKey:@"status"] isEqualToNumber:@2]) {
            // 已认证
            cell.authStatus.hidden = NO;
        } else {
            cell.authStatus.hidden = YES;
        }
    }
    if ([self.listArray[indexPath.row] objectForKey:@"factoryType"] != [NSNull null] && [[self.listArray[indexPath.row] objectForKey:@"factoryType"] isEqualToNumber:@0]) {
        cell.factoryFree.text = @"空闲中";
    } else {
        if ([self.listArray[indexPath.row] objectForKey:@"factoryFree"] != [NSNull null]) {
            if ([[self.listArray[indexPath.row] objectForKey:@"factoryFree"] isEqualToNumber:@1]) {
                // 有空闲
                cell.factoryFree.text = @"空闲中";
            } else {
                cell.factoryFree.text = @"忙碌中";
            }
        }
    }
    if ([self.listArray[indexPath.row] objectForKey:@"factoryPhoto"] != [NSNull null] && [[self.listArray[indexPath.row] objectForKey:@"factoryPhoto"] objectForKey:@"environment"]) {
        NSString *photoName = [[[self.listArray[indexPath.row] objectForKey:@"factoryPhoto"] objectForKey:@"environment"] objectAtIndex:0];
        NSString *fid = [self.listArray[indexPath.row] objectForKey:@"fid"];
        NSString *url = [NSString stringWithFormat:@"http://cofactories.bangbang93.com/storage_path/factory/%@/environment/%@", fid, photoName];
        //[cell.photoImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"list_example"]];
    }

    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//
//    MBProgressHUD *hud = [Config createHUD];
//    hud.labelText = @"正在加载...";
//    CompanyDetailViewController *companyDetailViewController = [[CompanyDetailViewController alloc] initWithNibName:@"CompanyDetailViewController" bundle:nil];
//    [[HttpClient sharedInstance] getFactoryProfileWithFid:[self.listArray[indexPath.row] objectForKey:@"fid"] andBlock:^(NSDictionary *jsonDic) {
//        if ([[jsonDic objectForKey:@"error"] isKindOfClass:[NSError class]]) {
//            hud.labelText = @"网络错误";
//            [hud hide:YES];
//            return;
//        }
//        hud.labelText = @"加载成功";
//        [hud hide:YES];
//        companyDetailViewController.dataDic = jsonDic;
//        companyDetailViewController.hidesBottomBarWhenPushed = YES;
//        companyDetailViewController.fid = [self.listArray[indexPath.row] objectForKey:@"fid"];
//        [self.navigationController pushViewController:companyDetailViewController animated:YES];
//    }];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.navigationItem.titleView resignFirstResponder];
}

#pragma mark - <JSDropDownMenuDataSource,JSDropDownMenuDelegate>
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 3;
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column {
    //    if (column == 2) {
    //        return YES;
    //    }
    return NO;
}

- (BOOL)haveRightTableViewInColumn:(NSInteger)column {
    if (column == 0) {
        return YES;
    }
    return NO;
}

- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column {
    if (column == 0) {
        return 0.3;
    }
    return 1;
}

- (NSInteger)currentLeftSelectedRow:(NSInteger)column {

    if (column==0) {
        return _currentData1Index;
    }
    if (column==1) {
        return _currentData2Index;
    }
    if (column==2) {
        return _currentData3Index;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow {
    if (column == 0) {
        if (leftOrRight == 0) {
            return _data1.count;
        } else {
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column == 1) {
        return _data2.count;
    } else if (column == 2) {
        return _data3.count;
    }
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{

    switch (column) {
            //        case 0: return _data1[_currentData1Index];
        case 0: return [[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex];
            break;
        case 1: return _data2[_currentData2Index];
            break;
        case 2: return _data3[_currentData3Index];
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {

    if (indexPath.column == 0) {
        if (indexPath.leftOrRight == 0) {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else {
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
        return _data1[indexPath.row];
    } else if (indexPath.column == 1) {
        return _data2[indexPath.row];
    } else {
        return _data3[indexPath.row];
    }
}


- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    //    NSLog(@"%d %d %d %d", indexPath.column, indexPath.leftOrRight, indexPath.leftRow, indexPath.row);

    if (indexPath.column == 0) {
        // 类型列
        if (indexPath.leftOrRight == 0) {
            // 左边
            _currentData1Index = indexPath.row;
            switch (indexPath.row) {
                case 0:
                    _data2 = [NSMutableArray arrayWithObjects:@"不限规模", nil];
                    _data3 = [NSMutableArray arrayWithObjects:@"不限距离", nil];
                    _currentData2Index = 0;
                    _currentData3Index = 0;
                    break;
                case 1:
                    _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"10万件-30万件", @"30万件-50万件", @"50万件-100万件", @"100万件-200万件", @"200万件以上", nil];
                    _data3 = [NSMutableArray arrayWithObjects:@"不限距离", @"10公里以内", @"50公里以内", @"100公里以内", @"150公里以内", @"200公里以内", @"200公里以上", nil];
                    _currentData2Index = 0;
                    _currentData3Index = 0;
                    break;
                case 2:
                    _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"2-4人", @"4-10人", @"10-20人", @"20人以上", nil];
                    _data3 = [NSMutableArray arrayWithObjects:@"不限距离", @"10公里以内", @"50公里以内", @"100公里以内", @"150公里以内", @"200公里以内", @"200公里以上", nil];
                    _currentData2Index = 0;
                    _currentData3Index = 0;
                    break;

                default:
                    _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"2-4人", @"4人以上", nil];
                    _data3 = [NSMutableArray arrayWithObjects:@"不限规模", @"1公里以内", @"5公里以内", @"10公里以内", nil];
                    _currentData2Index = 0;
                    _currentData3Index = 0;
                    break;
            }
            return;
        } else {
            // 右边
            _currentData1SelectedIndex = indexPath.row;
        }
    } else if (indexPath.column == 1) {
        // 规模行
        _currentData2Index = indexPath.row;
    } else {
        _currentData3Index = indexPath.row;
    }
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:4];
    switch (_currentData1Index) {
        case 0:
            // 不需要加参数
            break;

        default:
            [parameters setObject:@(_currentData1Index - 1) forKey:@"type"];
            break;
    }
    // 业务类型
    switch (_currentData1Index) {
        case 1:
            if (_currentData1SelectedIndex == 1) {
                [parameters setObject:@"童装" forKey:@"range"];
            } else if (_currentData1SelectedIndex == 2) {
                [parameters setObject:@"成人装" forKey:@"range"];
            }
            // 规模
            switch (_currentData2Index) {
                case 1:
                    [parameters setObject:@[@"100000", @"300000"] forKey:@"size"];
                    break;
                case 2:
                    [parameters setObject:@[@"300000", @"500000"] forKey:@"size"];
                    break;
                case 3:
                    [parameters setObject:@[@"500000", @"1000000"] forKey:@"size"];
                    break;
                case 4:
                    [parameters setObject:@[@"1000000", @"2000000"] forKey:@"size"];
                    break;

                default:
                    break;
            }
            // 距离
            switch (_currentData3Index) {
                case 1:
                    [parameters setObject:@[@"0", @"10"] forKey:@"distance"];
                    break;
                case 2:
                    [parameters setObject:@[@"0", @"50"] forKey:@"distance"];
                    break;
                case 3:
                    [parameters setObject:@[@"0", @"100"] forKey:@"distance"];
                    break;
                case 4:
                    [parameters setObject:@[@"0", @"150"] forKey:@"distance"];
                    break;
                case 5:
                    [parameters setObject:@[@"0", @"200"] forKey:@"distance"];
                    break;
                case 6:
                    [parameters setObject:@[@"200", @"1000"] forKey:@"distance"];
                    break;

                default:
                    break;
            }
            break;
        case 2:
            if (_currentData1SelectedIndex == 1) {
                [parameters setObject:@"针织" forKey:@"range"];
            } else if (_currentData1SelectedIndex == 2) {
                [parameters setObject:@"梭织" forKey:@"range"];
            }
            // 规模
            switch (_currentData2Index) {
                case 1:
                    [parameters setObject:@[@"2", @"4"] forKey:@"size"];
                    break;
                case 2:
                    [parameters setObject:@[@"4", @"10"] forKey:@"size"];
                    break;
                case 3:
                    [parameters setObject:@[@"10", @"20"] forKey:@"size"];
                    break;
                case 4:
                    [parameters setObject:@[@"20", @"1000"] forKey:@"size"];
                    break;

                default:
                    break;
            }
            // 距离
            switch (_currentData3Index) {
                case 1:
                    [parameters setObject:@[@"0", @"10"] forKey:@"distance"];
                    break;
                case 2:
                    [parameters setObject:@[@"0", @"50"] forKey:@"distance"];
                    break;
                case 3:
                    [parameters setObject:@[@"0", @"100"] forKey:@"distance"];
                    break;
                case 4:
                    [parameters setObject:@[@"0", @"150"] forKey:@"distance"];
                    break;
                case 5:
                    [parameters setObject:@[@"0", @"200"] forKey:@"distance"];
                    break;
                case 6:
                    [parameters setObject:@[@"200", @"1000"] forKey:@"distance"];
                    break;

                default:
                    break;
            }
            break;
        case 3:
        case 4:
            // 规模
            switch (_currentData2Index) {
                case 1:
                    [parameters setObject:@[@"2", @"4"] forKey:@"size"];
                    break;
                case 2:
                    [parameters setObject:@[@"4", @"100"] forKey:@"size"];
                    break;

                default:
                    break;
            }
            // 距离
            switch (_currentData3Index) {
                case 1:
                    [parameters setObject:@[@"0", @"1"] forKey:@"distance"];
                    break;
                case 2:
                    [parameters setObject:@[@"0", @"5"] forKey:@"distance"];
                    break;
                case 3:
                    [parameters setObject:@[@"0", @"10"] forKey:@"distance"];
                    break;

                default:
                    break;
            }
            break;

        default:
            break;
    }

    NSArray*sizeArr = parameters[@"size"];
    NSArray*distanceArr = parameters[@"distance"];


    [HttpClient searchWithFactoryName:nil factoryType:parameters[@"type"] factoryServiceRange:parameters[@"range"] factorySizeMin:parameters[@""] factorySizeMax:parameters[@""] factoryDistanceMin:parameters[@"distance"] factoryDistanceMax:parameters[@"distance"] andBlock:^(NSDictionary *responseDictionary) {

        NSLog(@"---%@",responseDictionary);
    }];
    //    NSLog(@"%@", parameters);
//    [[HttpClient sharedInstance] searchFactory:parameters andBlock:^(NSArray *jsonDic) {
//        if (jsonDic.count == 1 && [jsonDic[0] isKindOfClass:[NSError class]]) {
//            // 错误处理
//            return;
//        }
//        self.listArray = jsonDic;
//        [self.tableView reloadData];
//    }];
}

#pragma mark - <UISearchBarDelegate>
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:4];
    [parameters setObject:searchBar.text forKey:@"name"];
    switch (_currentData1Index) {
        case 0:
            // 不需要加参数
            break;

        default:
            [parameters setObject:@(_currentData1Index - 1) forKey:@"type"];
            break;
    }
    // 业务类型
    switch (_currentData1Index) {
        case 1:
            if (_currentData1SelectedIndex == 1) {
                [parameters setObject:@"童装" forKey:@"range"];
            } else if (_currentData1SelectedIndex == 2) {
                [parameters setObject:@"成人装" forKey:@"range"];
            }
            // 规模
            switch (_currentData2Index) {
                case 1:
                    [parameters setObject:@[@"100000", @"300000"] forKey:@"size"];
                    break;
                case 2:
                    [parameters setObject:@[@"300000", @"500000"] forKey:@"size"];
                    break;
                case 3:
                    [parameters setObject:@[@"500000", @"1000000"] forKey:@"size"];
                    break;
                case 4:
                    [parameters setObject:@[@"1000000", @"2000000"] forKey:@"size"];
                    break;

                default:
                    break;
            }
            // 距离
            switch (_currentData3Index) {
                case 1:
                    [parameters setObject:@[@"0", @"10"] forKey:@"distance"];
                    break;
                case 2:
                    [parameters setObject:@[@"0", @"50"] forKey:@"distance"];
                    break;
                case 3:
                    [parameters setObject:@[@"0", @"100"] forKey:@"distance"];
                    break;
                case 4:
                    [parameters setObject:@[@"0", @"150"] forKey:@"distance"];
                    break;
                case 5:
                    [parameters setObject:@[@"0", @"200"] forKey:@"distance"];
                    break;
                case 6:
                    [parameters setObject:@[@"200", @"1000"] forKey:@"distance"];
                    break;

                default:
                    break;
            }
            break;
        case 2:
            if (_currentData1SelectedIndex == 1) {
                [parameters setObject:@"针织" forKey:@"range"];
            } else if (_currentData1SelectedIndex == 2) {
                [parameters setObject:@"梭织" forKey:@"range"];
            }
            // 规模
            switch (_currentData2Index) {
                case 1:
                    [parameters setObject:@[@"2", @"4"] forKey:@"size"];
                    break;
                case 2:
                    [parameters setObject:@[@"4", @"10"] forKey:@"size"];
                    break;
                case 3:
                    [parameters setObject:@[@"10", @"20"] forKey:@"size"];
                    break;
                case 4:
                    [parameters setObject:@[@"20", @"1000"] forKey:@"size"];
                    break;

                default:
                    break;
            }
            // 距离
            switch (_currentData3Index) {
                case 1:
                    [parameters setObject:@[@"0", @"10"] forKey:@"distance"];
                    break;
                case 2:
                    [parameters setObject:@[@"0", @"50"] forKey:@"distance"];
                    break;
                case 3:
                    [parameters setObject:@[@"0", @"100"] forKey:@"distance"];
                    break;
                case 4:
                    [parameters setObject:@[@"0", @"150"] forKey:@"distance"];
                    break;
                case 5:
                    [parameters setObject:@[@"0", @"200"] forKey:@"distance"];
                    break;
                case 6:
                    [parameters setObject:@[@"200", @"1000"] forKey:@"distance"];
                    break;

                default:
                    break;
            }
            break;
        case 3:
        case 4:
            // 规模
            switch (_currentData2Index) {
                case 1:
                    [parameters setObject:@[@"2", @"4"] forKey:@"size"];
                    break;
                case 2:
                    [parameters setObject:@[@"4", @"100"] forKey:@"size"];
                    break;

                default:
                    break;
            }
            // 距离
            switch (_currentData3Index) {
                case 1:
                    [parameters setObject:@[@"0", @"1"] forKey:@"distance"];
                    break;
                case 2:
                    [parameters setObject:@[@"0", @"5"] forKey:@"distance"];
                    break;
                case 3:
                    [parameters setObject:@[@"0", @"10"] forKey:@"distance"];
                    break;

                default:
                    break;
            }
            break;

        default:
            break;
    }
    //    NSLog(@"%@", parameters);
//    [[HttpClient sharedInstance] searchFactory:parameters andBlock:^(NSArray *jsonDic) {
//        if (jsonDic.count == 1 && [jsonDic[0] isKindOfClass:[NSError class]]) {
//            // 错误处理
//            return;
//        }
//        self.listArray = jsonDic;
//        [self.tableView reloadData];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
