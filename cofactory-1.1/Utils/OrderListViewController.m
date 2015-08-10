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
//@property (nonatomic,strong)JSDropDownMenu *JSDropDownMenu;

/**创建三个选项栏
 */
@property (nonatomic, strong) NSMutableArray *data1;
@property (nonatomic, strong) NSMutableArray *data2;
@property (nonatomic, strong) NSMutableArray *data3;

@property (nonatomic, retain)NSMutableArray*orderModerArr;


@end

@implementation OrderListViewController {

    int oid;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//   NSLog(@"+++++=====self++==%d",self.userType);

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

    /**创建三个选项栏标题数组，初始化时后两个为空
     */
    NSArray *processArray = @[@"加工厂不限类型", @"针织", @"梭织"];
    _data1 = [NSMutableArray arrayWithObjects:@{@"title": @"全部分类", @"data": @[@"订单类型"]}, @{@"title": @"加工厂", @"data": processArray}, @{@"title": @"代裁厂", @"data": @[@"代裁厂全部分类"]}, @{@"title": @"锁眼钉扣", @"data": @[@"锁眼钉扣全部分类"]}, nil];//数组里面的元素是字典
    _data2 = [NSMutableArray arrayWithObjects:@"订单数量", nil];
    _data3 = [NSMutableArray arrayWithObjects:@"订单期限", nil];
    
    
    if (self.HiddenJSDropDown==YES) {
        _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 130.0f;
        _tableView.showsVerticalScrollIndicator = NO;
        [_tableView registerClass:[OrderListTableViewCell class] forCellReuseIdentifier:@"cell"];
        [self.view addSubview:_tableView];

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
[cell.orderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.cofactories.com/factory/%d.png",model.uid]] placeholderImage:[UIImage imageNamed:@"消息头像"]];//gt123
    cell.amountLabel.text = [NSString stringWithFormat:@"订单数量 :  %d%@",model.amount,@"件"];



    if (model.interest == nil)
    {
        cell.label.hidden = YES;
    }
    else
    {
        cell.interestCountLabel.text = [NSString stringWithFormat:@"%@%@",model.interest,@"家"];
        cell.label.hidden  =NO;
    }
    if (self.isHistory==YES) {
        cell.confirmOrderBtn.hidden=YES;
    }
    [cell.confirmOrderBtn addTarget:self action:@selector(confirmOrderBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.confirmOrderBtn.tag = indexPath.row;
    [cell.orderDetailsBtn addTarget:self action:@selector(orderDetailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderDetailsBtn.tag = indexPath.row;
    return cell;
}



#pragma mark--确认订单按钮与订单详情按钮绑定方法
- (void)confirmOrderBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    FactoryModel*model = self.orderModerArr[button.tag];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否确认订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
    [alertView show];
    oid=model.oid;
}

- (void)orderDetailsBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    OrderModel*model = self.orderModerArr[button.tag];

    NSLog(@"oid--%ld",button.tag);

    OrderDetailViewController *VC = [[OrderDetailViewController alloc]init];
    VC.model=model;
    //gt123
    if (self.isHistory==YES)
    {
        VC.isHistory =YES;
    }
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {

        [HttpClient closeOrderWithOid:oid andBlock:^(NSDictionary *responseDictionary) {
            NSLog(@"oid==%d==%@",oid,responseDictionary);

            if ([responseDictionary[@"statusCode"] intValue]==200) {
                self.isHistory = YES;
                self.title=@"历史订单";
                self.orderModerArr=[[NSMutableArray alloc]initWithCapacity:0];
                [HttpClient listHistoryOrderWithBlock:^(NSDictionary *responseDictionary) {
                    if ([responseDictionary[@"statusCode"] intValue]==200) {
                        self.orderModerArr=responseDictionary[@"responseArray"];
                        [_tableView reloadData];
                    }
                }];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - <JSDropDownMenuDataSource,JSDropDownMenuDelegate>
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    return 3;
}

- (BOOL)displayByCollectionViewInColumn:(NSInteger)column {

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
    } else{
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
                    _data2 = [NSMutableArray arrayWithObjects: @"500件以内", @"5000-1000万件", @"1000-2000件", @"2000-5000件", @"5000件以上", nil];
                    _data3 = [NSMutableArray arrayWithObjects:@"3天", @"5天",@"5天以上", nil];
                    _currentData2Index = 0;
                    _currentData3Index = 0;

                    break;
                case 2:
                    _data2 =[NSMutableArray arrayWithObjects: @"500件以内", @"5000-1000万件", @"1000-2000件", @"2000-5000件", @"5000件以上", nil];
                    _data3 = [NSMutableArray arrayWithObjects:@"1天", @"1-3天",@"3天以上", nil];
                    _currentData2Index = 0;
                    _currentData3Index = 0;

                    break;

                default:
                    _data2 = [NSMutableArray arrayWithObjects: @"500件以内", @"5000-1000万件", @"1000-2000件", @"2000-5000件", @"5000件以上", nil];
                    _data3 = [NSMutableArray arrayWithObjects:@"1天", @"1-3天",@"3天以上", nil];
                    _currentData2Index = 0;
                    _currentData3Index = 0;

                    break;
            }
            return;
        }

        else {
            // 右边
            _currentData1SelectedIndex = indexPath.row;
        }
    } else if (indexPath.column == 1) {
        // 规模行
        _currentData2Index = indexPath.row;
    }
    else{
        // 规模行
        _currentData3Index = indexPath.row;
    }
}
*/

@end
