//
//  searchOrderListVC.m
//  cofactory-1.1
//
//  Created by gt on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "searchOrderListVC.h"
#import "searchOrderListTVC.h"
#import "SearchOrderListDetailsVC.h"
#import "Header.h"
#import "MJRefresh.h"

@interface searchOrderListVC ()<UITableViewDataSource,UITableViewDelegate, JSDropDownMenuDataSource, JSDropDownMenuDelegate>
{
    UITableView *_tableView;
    int _refrushCount;
}
@property (nonatomic,strong)JSDropDownMenu *JSDropDownMenu;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int role;
@property (nonatomic,strong) NSString *factoryServiceRange;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSNumber *min;
@property (nonatomic,strong) NSNumber *max;



/**创建三个选项栏
 */
@property (nonatomic, strong) NSMutableArray *data1;
@property (nonatomic, strong) NSMutableArray *data2;
@property (nonatomic, strong) NSMutableArray *data3;


@end

@implementation searchOrderListVC


- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor = [UIColor whiteColor];


    /**创建三个选项栏标题数组，初始化时后两个为空
     */
    NSArray *processArray = @[@"加工厂不限类型", @"针织", @"梭织"];
    _data1 = [NSMutableArray arrayWithObjects:@{@"title": @"全部分类", @"data": @[@"订单类型"]}, @{@"title": @"加工厂", @"data": processArray}, @{@"title": @"代裁厂", @"data": @[@"代裁厂全部分类"]}, @{@"title": @"锁眼钉扣", @"data": @[@"锁眼钉扣全部分类"]}, nil];//数组里面的元素是字典
    _data2 = [NSMutableArray arrayWithObjects:@"订单数量", nil];
    _data3 = [NSMutableArray arrayWithObjects:@"订单期限", nil];




    /*创建选项栏，并进行一些设置*/
    self.JSDropDownMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    self.JSDropDownMenu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    self.JSDropDownMenu.separatorColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0];
    self.JSDropDownMenu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    self.JSDropDownMenu.dataSource = self;
    self.JSDropDownMenu.delegate = self;
    [self.view addSubview:self.JSDropDownMenu];


    switch (_currentData1Index) {
        case 0:
            _currentData2Index = 0;
            _currentData3Index = 0;
            break;
        case 1:
            _data2 = [NSMutableArray arrayWithObjects: @"500件以内", @"500-1000件", @"1000-2000件", @"2000-5000件", @"5000件以上", nil];
            _data3 = [NSMutableArray arrayWithObjects:@"3天", @"5天",@"5天以上", nil];
            _currentData2Index = 0;
            _currentData3Index = 0;
            break;
        case 2:
            _data2 = [NSMutableArray arrayWithObjects: @"500件以内", @"500-1000件", @"1000-2000件", @"2000-5000件", @"5000件以上", nil];
            _data3 = [NSMutableArray arrayWithObjects:@"1天", @"1-3天",@"3天以上", nil];

            _currentData2Index = 0;
            _currentData3Index = 0;
            break;

        default:
            _data2 = [NSMutableArray arrayWithObjects: @"500件以内", @"500-1000件", @"1000-2000件", @"2000-5000件", @"5000件以上", nil];
            _data3 = [NSMutableArray arrayWithObjects:@"1天", @"1-3天",@"3天以上", nil];

            _currentData2Index = 0;
            _currentData3Index = 0;
            break;
    }


    _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, 64+44, kScreenW, kScreenH-110) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 130.0f;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[searchOrderListTVC class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];


    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];

    switch (self.orderListType) {
        case 1:
        {
            [HttpClient searchOrderWithRole:1 FactoryServiceRange:nil Time:nil AmountMin:nil AmountMax:nil Page:@1 andBlock:^(NSDictionary *responseDictionary) {
                self.dataArray = responseDictionary[@"responseArray"];
                self.role = 1;

                [_tableView reloadData];
                NSLog(@"+++++responseDictionary==%@",self.dataArray);
            }];
        }
            break;
        case 2:
        {
            [HttpClient searchOrderWithRole:2 FactoryServiceRange:nil Time:nil AmountMin:nil AmountMax:nil Page:@1 andBlock:^(NSDictionary *responseDictionary) {
                self.dataArray = responseDictionary[@"responseArray"];
                self.role = 2;

                [_tableView reloadData];
                NSLog(@"+++++responseDictionary==%@",self.dataArray);
            }];
        }

            break;
        case 3:
        {
            [HttpClient searchOrderWithRole:3 FactoryServiceRange:nil Time:nil AmountMin:nil AmountMax:nil Page:@1 andBlock:^(NSDictionary *responseDictionary) {
                self.dataArray = responseDictionary[@"responseArray"];
                self.role = 3;

                [_tableView reloadData];

                NSLog(@"+++++responseDictionary==%@",self.dataArray);
            }];
        }

            break;

        default:
            break;
    }


    _refrushCount = 1;
    [self setupRefresh];

}


//开始刷新自定义方法
- (void)setupRefresh
{
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];

    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText = @"加载中。。。";
}
//上拉加载
- (void)footerRereshing
{
    _refrushCount++;
    NSLog(@"???????????%d",_refrushCount);
    NSNumber *num = [NSNumber numberWithInt:_refrushCount];
    [HttpClient searchOrderWithRole:self.role FactoryServiceRange:self.factoryServiceRange Time:self.time AmountMin:self.min AmountMax:self.max Page:num andBlock:^(NSDictionary *responseDictionary) {

        NSArray *array = responseDictionary[@"responseArray"];

        for (int i=0; i<array.count; i++)
        {
            OrderModel *model = array[i];

            [self.dataArray addObject:model];
        }
        [_tableView reloadData];
    }];


    //
    //        NSArray *array = responseDictionary[@"responseArray"];
    //
    //        for (int i=0; i<array.count; i++)
    //        {
    //            FactoryModel *model = array[i];
    //
    //            [self.factoryModelArray addObject:model];
    //        }
    //        [_tableView reloadData];
    //
    //    }];
    //
    //2,结束刷新
    [_tableView footerEndRefreshing];
}


- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    self.JSDropDownMenu = nil;
    NSLog(@"找订单释放内存");
}

#pragma mark--表的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    searchOrderListTVC *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    OrderModel *model = self.dataArray[indexPath.row];

    NSLog(@">>>>>>>>??????%@",model.serviceRange);



    if (self.orderListType == 1)
    {
        cell.orderTypeLabel.hidden = NO;
        cell.orderTypeLabel.text = [NSString stringWithFormat:@"订单类型 :  %@",model.serviceRange];

        cell.workingTimeLabel.hidden = NO;
        cell.workingTimeLabel.text = [NSString stringWithFormat:@"期限 :  %@天",model.workingTime];

    }

    //    if (model.serviceRange == nil)
    //    {
    //        cell.orderTypeLabel.hidden = YES;
    //    }
    else
    {
        cell.orderTypeLabel.hidden = YES;
        cell.workingTimeLabel.hidden = YES;

    }


    if (self.role == 0)
    {

        if (model.type == 1)
        {
            cell.orderTypeLabel.hidden = NO;
            cell.orderTypeLabel.text = [NSString stringWithFormat:@"订单类型 :  %@",model.serviceRange];

            cell.workingTimeLabel.hidden = NO;
            cell.workingTimeLabel.text = [NSString stringWithFormat:@"期限 :  %@",model.workingTime];

        }

        //    if (model.serviceRange == nil)
        //    {
        //        cell.orderTypeLabel.hidden = YES;
        //    }
        else
        {
            cell.orderTypeLabel.hidden = YES;
            cell.workingTimeLabel.hidden = YES;
            
        }
        
    }


    NSMutableArray *arr = [Tools WithTime:model.createTime];//gt123
    cell.timeLabel.text = arr[0];
    [cell.orderImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.cofactories.com/factory/%d.png",model.uid]] placeholderImage:[UIImage imageNamed:@"消息头像"]];//gt123
    self.uid = model.uid;
    cell.orderTypeLabel.text = [NSString stringWithFormat:@"订单类型 :  %@",model.serviceRange];
    cell.amountLabel.text = [NSString stringWithFormat:@"订单数量 :  %d%@",model.amount,@"件"];

    NSString *interestString = [NSString stringWithFormat:@"%@",model.interest];
    if ([interestString isEqualToString:@"(null)"])
    {
        cell.intersestLabelView.hidden = YES;
    }else
    {
        cell.interestCountLabel.text = [NSString stringWithFormat:@"%@%@",model.interest,@"家"];
    }

    [cell.orderDetailsBtn addTarget:self action:@selector(orderDetailsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderDetailsBtn.tag = indexPath.row+1;
    return cell;
}



#pragma mark--订单详情按钮绑定方法

- (void)orderDetailsBtnClick:(id)sender
{
    if ([Tools isTourist]) {
        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"请您登录后查看订单详情" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        UIButton *button = (UIButton *)sender;
        OrderModel *model = self.dataArray [button.tag-1];
        SearchOrderListDetailsVC *vc = [[SearchOrderListDetailsVC alloc]init];
        vc.oid = model.oid;
        vc.uid = self.uid;
        vc.model = model;
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
        backItem.title=@"";
        backItem.tintColor=[UIColor whiteColor];
        self.navigationItem.backBarButtonItem = backItem;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];

    }
}

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


- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath
{
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
                    _data2 = [NSMutableArray arrayWithObjects: @"500件以内", @"500-1000件", @"1000-2000件", @"2000-5000件", @"5000件以上", nil];
                    _data3 = [NSMutableArray arrayWithObjects:@"3天", @"5天",@"5天以上", nil];
                    _currentData2Index = 0;
                    _currentData3Index = 0;

                    break;
                case 2:
                    _data2 =[NSMutableArray arrayWithObjects: @"500件以内", @"500-1000件", @"1000-2000件", @"2000-5000件", @"5000件以上", nil];
                    _data3 = [NSMutableArray arrayWithObjects:@"1天", @"1-3天",@"3天以上", nil];
                    _currentData2Index = 0;
                    _currentData3Index = 0;

                    break;

                default:
                    _data2 = [NSMutableArray arrayWithObjects: @"500件以内", @"500-1000件", @"1000-2000件", @"2000-5000件", @"5000件以上", nil];
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


    //  NSLog(@"%d %d %d %d", indexPath.column, indexPath.leftOrRight, indexPath.leftRow, indexPath.row);


    // 筛选类型
    if (indexPath.column == 0 && indexPath.leftOrRight == 1 )
    {

        if (indexPath.leftRow == 0 && indexPath.row ==0)
        {
            self.role = 0; //所有订单
            self.factoryServiceRange = @"";
            self.time = @"";
            self.min = nil;
            self.max = nil;
        }

        if (indexPath.leftRow == 1)
        {
            self.role = 1;//加工厂
            self.orderListType = 1;

            if (indexPath.row == 0)
            {
                self.factoryServiceRange = @"";
            }
            if (indexPath.row == 1)
            {
                self.factoryServiceRange = @"针织";
            }
            if (indexPath.row == 2)
            {
                self.factoryServiceRange = @"梭织";
            }

        }

        if (indexPath.leftRow == 2)
        {
            self.role = 2; //代裁厂
            self.orderListType = 2;
            self.factoryServiceRange = nil;
        }

        if (indexPath.leftRow ==3)
        {
            self.role = 3;//锁眼钉扣厂
            self.orderListType = 3;
            self.factoryServiceRange = nil;
        }
    }


    if (self.role == 0)
    {
        if (indexPath.column == 1 && indexPath.leftOrRight == 0 && indexPath.leftRow == 0 && indexPath.row == 0)
        {
            self.max = nil;
            self.min = nil;
            self.time = @"";
            self.factoryServiceRange = @"";
        }

        if (indexPath.column == 2 && indexPath.leftOrRight == 0 && indexPath.leftRow == 0 && indexPath.row == 0)
        {
            self.max = nil;
            self.min = nil;
            self.time = @"";
            self.factoryServiceRange = @"";

        }


    }


    if (self.role == 1)
    {
        // 筛选工厂规模
        if (indexPath.column == 1 && indexPath.leftOrRight == 0)
        {
            NSLog(@"11");
            if (indexPath.leftRow ==0 && indexPath.row ==0 )
            {
                self.min = @0;
                self.max = @500;
            }


            if (indexPath.leftRow ==1 && indexPath.row ==1 )
            {
                self.min = @500;
                self.max = @1000;
            }

            if (indexPath.leftRow ==2 && indexPath.row ==2 )
            {
                self.min = @1000;
                self.max = @2000;
            }

            if (indexPath.leftRow ==3 && indexPath.row ==3 )
            {
                self.min = @2000;
                self.max = @5000;
            }

            if (indexPath.leftRow ==4 && indexPath.row ==4 )
            {
                self.min = @5000;
                self.max = nil;
            }

        }

        // 筛选时间
        if (indexPath.column == 2 && indexPath.leftOrRight == 0)
        {
            NSLog(@"12");
            if (indexPath.leftRow ==0 && indexPath.row ==0 )
            {
                self.time = @"3天";
            }

            if (indexPath.leftRow ==1 && indexPath.row ==1 )
            {
                self.time = @"5天";
            }

            if (indexPath.leftRow ==2 && indexPath.row ==2 )
            {
                self.time = @"5天以上";

            }

        }
    }


    if (self.role == 2 || self.role == 3)
    {
        // 筛选规模
        if (indexPath.column == 1 && indexPath.leftOrRight == 0)
        {

            NSLog(@"21");
            if (indexPath.leftRow ==0 && indexPath.row ==0 )
            {
                self.min = @0;
                self.max = @500;
            }


            if (indexPath.leftRow ==1 && indexPath.row ==1 )
            {
                self.min = @500;
                self.max = @1000;
            }

            if (indexPath.leftRow ==2 && indexPath.row ==2 )
            {
                self.min = @1000;
                self.max = @2000;
            }

            if (indexPath.leftRow ==3 && indexPath.row ==3 )
            {
                self.min = @2000;
                self.max = @5000;
            }

            if (indexPath.leftRow ==4 && indexPath.row ==4 )
            {
                self.min = @5000;
                self.max = nil;
            }

        }

        // 筛选时间
        if (indexPath.column == 2 && indexPath.leftOrRight == 0)
        {

            NSLog(@"22");
            if (indexPath.leftRow ==0 && indexPath.row ==0 )
            {
                self.time = @"1天";
            }

            if (indexPath.leftRow ==1 && indexPath.row ==1 )
            {
                self.time = @"1-3天";
            }

            if (indexPath.leftRow ==2 && indexPath.row ==2 )
            {
                self.time = @"3天以上";
            }

        }


    }

    NSLog(@"self.role=%d,self.factoryServiceRange=%@,self.time=%@,self.min=%@,self.max=%@",self.role,self.factoryServiceRange,self.time,self.min,self.max);



    _refrushCount = 1;
    [HttpClient searchOrderWithRole:self.role FactoryServiceRange:self.factoryServiceRange Time:self.time AmountMin:self.min AmountMax:self.max Page:@1 andBlock:^(NSDictionary *responseDictionary) {

        self.dataArray = nil;
        self.dataArray = responseDictionary[@"responseArray"];
        [_tableView reloadData];
        //     NSLog(@"+++++responseDictionary==%@",self.dataArray);
    }];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
