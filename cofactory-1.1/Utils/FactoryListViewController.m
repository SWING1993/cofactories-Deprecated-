//
//  FactoryListViewController.m
//  22222
//
//  Created by gt on 15/7/20.
//  Copyright (c) 2015年 gt. All rights reserved.
//

#import "Header.h"
#import "FactoryListViewController.h"
#import "FactoryListTableViewCell.h"
#import "THDatePickerViewController.h"
#import "MJRefresh.h"

@interface FactoryListViewController ()<UITableViewDataSource,UITableViewDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate,UISearchBarDelegate,THDatePickerDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UILabel *_lineLabel;//787878
    UIView *_view;
    NSNumber *_number;
    NSDateFormatter *_dateFormatter;
    int _refrushCount;
}

@property (nonatomic,strong)JSDropDownMenu *JSDropDownMenu;
@property (nonatomic,strong)NSMutableArray *factoryModelArray;
/**创建三个选项栏
 */
@property (nonatomic, strong) NSMutableArray *data1;
@property (nonatomic, strong) NSMutableArray *data2;
@property (nonatomic, strong) NSMutableArray *data3;
@property (nonatomic, strong) NSMutableArray *data4;
@property (nonatomic, strong) NSMutableArray *truckBtnArray;
@property (nonatomic, strong) NSMutableArray *dateArray;



//请求参数
@property (nonatomic,copy) NSString *factoryName;
@property (nonatomic,copy) NSString *factoryServiceRange;
@property (nonatomic,copy) NSNumber *factorySizeMin;
@property (nonatomic,assign) NSNumber *factorySizeMax;
@property (nonatomic,assign) NSNumber *factoryDistanceMin;
@property (nonatomic,assign) NSNumber *factoryDistanceMax;

//787878
@property (nonatomic,assign) BOOL isHaveTruck;
@property (nonatomic,assign) NSString *factoryFree;

@property (nonatomic, strong) THDatePickerViewController * datePicker;
@property (nonatomic, strong) NSDate * curDate;
@property (nonatomic, strong) NSDateFormatter * formatter;


@end

@implementation FactoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title=@"";
    //创建表
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight = 80;
    [_tableView registerClass:[FactoryListTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    self.factoryModelArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    
    
    //787878根据条件判断是否有货车
    NSArray *btnTitleArray = @[@"有货车",@"无货车"];
    _view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    _tableView.tableHeaderView = _view;
    
    self.truckBtnArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.dateArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i=0; i<2; i++)
    {
        UIButton*typeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        typeBtn.frame = CGRectMake((kScreenW-160)/3+i*((kScreenW-160)/3*2), 5, 80 , 30);
        [typeBtn setBackgroundImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
        //        [typeBtn setTitleColor: [UIColor grayColor] forState:UIControlStateNormal];
        typeBtn.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        [typeBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        typeBtn.tag = i;
        [typeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_view addSubview:typeBtn];
        if (i == 0)
        {
            _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(typeBtn.frame.origin.x, 40, typeBtn.frame.size.width, 2)];
            _lineLabel.backgroundColor = [UIColor redColor];
            [_view addSubview:_lineLabel];
            [self.truckBtnArray addObject:typeBtn];
        }
    }
    
    _tableView.tableHeaderView = nil;
    
    self.curDate = [NSDate date];
    self.formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy年MM月dd日"];
    
    
    _number = nil;
    
    
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    // 搜索栏
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入工厂名称";
    self.navigationItem.titleView = searchBar;
    
    
    /**创建三个选项栏标题数组，初始化时后两个为空
     */
    NSArray *cloutheArray = @[@"服装厂全部分类", @"童装", @"成人装"];
    NSArray *processArray = @[@"加工厂全部分类", @"针织", @"梭织"];
    _data1 = [NSMutableArray arrayWithObjects:@{@"title": @"全部分类", @"data": @[@"不限类型"]}, @{@"title": @"服装厂", @"data": cloutheArray}, @{@"title": @"加工厂", @"data": processArray}, @{@"title": @"锁眼钉扣", @"data": @[@"锁眼钉扣厂全部分类"]}, @{@"title": @"代裁厂", @"data": @[@"代裁厂全部分类"]}, nil];//数组里面的元素是字典
    _data2 = [NSMutableArray arrayWithObjects:@"不限规模", nil];
    _data3 = [NSMutableArray arrayWithObjects:@"不限距离", nil];
    _data4 = [NSMutableArray arrayWithObjects:@"不限时间", nil];
    
    
    /*创建选项栏，并进行一些设置*/
    self.JSDropDownMenu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
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
            _currentData4Index = 0;
            break;
        case 1:
            _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"0万件-10万件", @"10万件-30万件", @"30万件-50万件", @"50万件-100万件", @"100万件以上", nil];
            _data3 = [NSMutableArray arrayWithObjects:@"不限距离", @"10公里以内", @"10-50公里", @"50-100公里", @"100-200公里", @"200-300公里", @"300公里以外", nil];
            _data4 =  [NSMutableArray arrayWithObjects:@"不限时间", nil];
            _currentData2Index = 0;
            _currentData3Index = 0;
            _currentData4Index = 0;
            break;
        case 2:
            _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"2-4人", @"4-10人", @"10-20人", @"20人以上", nil];
            _data3 = [NSMutableArray arrayWithObjects:@"不限距离", @"10公里以内", @"10-50公里", @"50-100公里", @"100-200公里", @"200-300公里", @"300公里以外", nil];
            _data4 = [@[@"时间筛选"] mutableCopy];
            
            _currentData2Index = 0;
            _currentData3Index = 0;
            _currentData4Index = 0;
            break;
            
        default:
            _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"2-4人", @"4人以上", nil];
            _data3 = [NSMutableArray arrayWithObjects:@"不限规模", @"1公里以内", @"1-5公里", @"5-10公里", @"10公里以外",nil];
            _data4 =   [NSMutableArray arrayWithObjects:@"空闲",@"忙碌", nil];
            _currentData2Index = 0;
            _currentData3Index = 0;
            _currentData4Index = 0;
            break;
    }
    
    [HttpClient searchWithFactoryName:nil factoryType:self.factoryType factoryServiceRange:nil factorySizeMin:nil factorySizeMax:nil factoryDistanceMin:nil factoryDistanceMax:nil Truck:nil factoryFree:nil page:(@1)andBlock:^(NSDictionary *responseDictionary) {
        self.factoryModelArray = nil;
        self.factoryModelArray = responseDictionary[@"responseArray"];
        [_tableView reloadData];
        
    }];
    
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
    DLog(@"???????????%d",_refrushCount);
    
    NSNumber *num = [NSNumber numberWithInt:_refrushCount];
    
    
    NSNumber *carNum = [NSNumber numberWithInt:self.isHaveTruck];
    
    
    //  DLog(@"self.factoryName=%@,self.factoryType=%d,self.factoryServiceRange=%@,self.factorySizeMin=%@,self.factorySizeMax=%@,self.factoryDistanceMin=%@,self.factoryDistanceMax=%@,self.isHaveTruck=%d,self.factoryFree=%@",self.factoryName,self.factoryType,self.factoryServiceRange,self.factorySizeMin,self.factorySizeMax,self.factoryDistanceMin,self.factoryDistanceMax,self.isHaveTruck,self.factoryFree);
    
    [HttpClient searchWithFactoryName:nil factoryType:self.factoryType factoryServiceRange:self.factoryServiceRange factorySizeMin:self.factorySizeMin factorySizeMax:self.factorySizeMax factoryDistanceMin:self.factoryDistanceMin factoryDistanceMax:self.factoryDistanceMax Truck:carNum factoryFree:self.factoryFree page:num andBlock:^(NSDictionary *responseDictionary) {
        
        NSArray *array = responseDictionary[@"responseArray"];
        
        for (int i=0; i<array.count; i++)
        {
            FactoryModel *model = array[i];
            
            [self.factoryModelArray addObject:model];
        }
        [_tableView reloadData];
        
    }];
    
    //2,结束刷新
    [_tableView footerEndRefreshing];
}


#pragma mark--表的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.factoryModelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FactoryListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    FactoryModel *factoryModel = self.factoryModelArray[indexPath.row];
    
    NSString* imageUrlString = [NSString stringWithFormat:@"%@/factory/%d.png",PhotoAPI,factoryModel.uid];
    [cell.companyImage sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"placeholder88"]];
    
    cell.companyNameLB.text = factoryModel.factoryName;
    cell.companyLocationLB.text = factoryModel.factoryAddress;
    
    switch (factoryModel.factoryType) {
        case 0:
            //            DLog(@"111111");
            cell.factoryNatureLB.text = @"服装厂";
            cell.isBusyLB.hidden = YES;
            cell.isHaveCarLB.hidden = YES;
            break;
            
        case 1:{
            cell.factoryNatureLB.text = @"加工厂";
            cell.isBusyLB.hidden = NO;
            if (factoryModel.hasTruck == 0)
            {
                cell.isHaveCarLB.hidden = YES;
            }
            if (factoryModel.hasTruck ==1 )
            {
                cell.isHaveCarLB.hidden = NO;
            }
            
            // DLog(@"factoryFreeTime==%@",factoryModel.factoryFreeTime);
            
            if (factoryModel.factoryFreeTime == nil) {
                DLog(@"234");
                cell.isBusyLB.text = @"空闲";

            }else{
                DLog(@"678");
                NSString *dateString = factoryModel.factoryFreeTime;
                NSArray *array = [dateString componentsSeparatedByString:@"T"];
                NSDate *dateForCell = [_dateFormatter dateFromString:array[0]];
                NSString *dateStrings = [Tools compareIfTodayAfterDates:dateForCell];
                NSArray *array1 = [dateStrings componentsSeparatedByString:@"天"];
                int date = [array1[0] intValue];
                if (date < 0)
                {
                    cell.isBusyLB.text = @"空闲";
                }
                if (date == 0)
                {
                    cell.isBusyLB.text = @"今天有空";
                }
                if (date > 0)
                {
                    cell.isBusyLB.text = [NSString stringWithFormat:@"%d天后有空",date];
                }
            }
                /*
                 NSString *dateString = factoryModel.facTypeOneStatus;
                 if ([dateString isEqualToString:@"0"])
                 {
                 cell.isBusyLB.hidden = NO;
                 cell.isBusyLB.text = @"忙碌中";
                 }
                 if (![dateString isEqualToString:@"0"])
                 {
                 NSArray *array = [dateString componentsSeparatedByString:@"T"];
                 NSDate *dateForCell = [_dateFormatter dateFromString:array[0]];
                 NSString *dateStrings = [Tools compareIfTodayAfterDates:dateForCell];
                 NSArray *array1 = [dateStrings componentsSeparatedByString:@"天"];
                 int date = [array1[0] intValue];
                 if (date < 0)
                 {
                 cell.isBusyLB.hidden = NO;
                 cell.isBusyLB.text = @"空闲中";
                 }
                 if (date == 0)
                 {
                 cell.isBusyLB.hidden = NO;
                 cell.isBusyLB.text = @"今天有空";
                 }
                 if (date > 0)
                 {
                 cell.isBusyLB.hidden = NO;
                 cell.isBusyLB.text = [NSString stringWithFormat:@"%d天后有空",date];
                 }
                 }
                 */
                
                
            }
            break;
            
        case 2:
            // DLog(@"factoryFreeStatus==%@",factoryModel.factoryFreeStatus);
            cell.factoryNatureLB.text = @"代裁厂";
            cell.isHaveCarLB.hidden = YES;
            cell.isBusyLB.hidden = NO;
            cell.isBusyLB.text = factoryModel.factoryFreeStatus;
            break;
            
        case 3:
            // DLog(@"factoryFreeStatus==%@",factoryModel.factoryFreeStatus);
            cell.factoryNatureLB.text = @"锁眼钉扣厂";
            cell.isHaveCarLB.hidden = YES;
            cell.isBusyLB.hidden = NO;
            cell.isBusyLB.text = factoryModel.factoryFreeStatus;
            
            break;
            
        default:
            break;
        }
            
            cell.distenceLB.text = [NSString stringWithFormat:@"相距%d公里",factoryModel.distance/1000];
            if (factoryModel.verifyStatus == 0 ||factoryModel.verifyStatus == 1)
            {
                cell.certifyUserLB.hidden = YES;
            }
            if (factoryModel.verifyStatus == 2)
            {
                cell.certifyUserLB.hidden = NO;
            }
            
            if ([factoryModel.tag isEqualToString:@"0"]||[factoryModel.tag isEqualToString:@"(null)"]) {
                cell.tagLB.hidden = YES;
                
            }else{
                cell.tagLB.hidden = NO;
                cell.tagLB.text = factoryModel.tag;
                
            }
            return cell;
    }
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        if ([Tools isTourist]) {
            //游客
            UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"请您登录后才使用这项服务,是否登录？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag=5;
            
            [alertView show];
        }else{
            FactoryModel *factoryModel = self.factoryModelArray[indexPath.row];
            CooperationInfoViewController*cooperationInfoVC = [[CooperationInfoViewController alloc]init];
            cooperationInfoVC.factoryModel=factoryModel;
            cooperationInfoVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:cooperationInfoVC animated:YES];
        }
    }
    - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
        if (buttonIndex==1) {
            if (alertView.tag==5) {
                [ViewController goLogin];
            }
        }
    }
    
#pragma mark -- 有无货车按钮
    - (void)buttonClick:(id)sender
    {
        UIButton *button = (UIButton *)sender;
        
        [UIView animateWithDuration:0.5 animations:^{
            _lineLabel.frame = CGRectMake(button.frame.origin.x, 40, button.frame.size.width, 2);
            
        }];
        
        if (button.tag == 0)
        {
            self.isHaveTruck = YES;
        }
        if (button.tag == 1)
        {
            self.isHaveTruck = NO;
        }
        
        [self.truckBtnArray replaceObjectAtIndex:0 withObject:button];
        
        DLog(@"%d",button.tag);
        
        
      //  DLog(@"self.factoryName=%@,self.factoryType=%d,self.factoryServiceRange=%@,self.factorySizeMin=%@,self.factorySizeMax=%@,self.factoryDistanceMin=%@,self.factoryDistanceMax=%@,self.isHaveTruck=%d,self.factoryFree=%@",self.factoryName,self.factoryType,self.factoryServiceRange,self.factorySizeMin,self.factorySizeMax,self.factoryDistanceMin,self.factoryDistanceMax,self.isHaveTruck,self.factoryFree);
        
        
        
        if (self.isHaveTruck == YES)
        {
            _number = @1;
        }
        if (self.isHaveTruck == NO)
        {
            _number = @0;
        }
        
        
        _refrushCount = 1;
        [HttpClient searchWithFactoryName:self.factoryName factoryType:self.factoryType factoryServiceRange:self.factoryServiceRange factorySizeMin:self.factorySizeMin factorySizeMax:self.factorySizeMax factoryDistanceMin:self.factoryDistanceMin factoryDistanceMax:self.factoryDistanceMax Truck:_number factoryFree:self.factoryFree  page:(@1) andBlock:^(NSDictionary *responseDictionary) {
            
            self.factoryModelArray = nil;
            self.factoryModelArray = responseDictionary[@"responseArray"];
            [_tableView reloadData];
        }];
        
        
    }
    
    
#pragma mark - <JSDropDownMenuDataSource,JSDropDownMenuDelegate>
    - (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
        return 4;
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
        if (column==3) {
            return _currentData4Index;
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
        else if (column == 3) {
            return _data4.count;
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
            case 3: return _data4[_currentData4Index];
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
        } else if(indexPath.column == 2){
            return _data3[indexPath.row];
        }
        else {
            return _data4[indexPath.row];
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
                        _data4 = [NSMutableArray arrayWithObjects:@"不限时间", nil];
                        _currentData2Index = 0;
                        _currentData3Index = 0;
                        _currentData4Index = 0;
                        break;
                    case 1:
                        _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"0万件-10万件", @"10万件-30万件", @"30万件-50万件", @"50万件-100万件", @"100万件以上",nil];
                        _data3 = [NSMutableArray arrayWithObjects:@"不限距离", @"10公里以内", @"10-50公里", @"50-100公里", @"100-200公里", @"200-300公里", @"300公里以外", nil];
                        _data4 =  [NSMutableArray arrayWithObjects:@"不限时间", nil];
                        
                        _currentData2Index = 0;
                        _currentData3Index = 0;
                        _currentData4Index = 0;
                        
                        break;
                    case 2:
                        _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"2-4人", @"4-10人", @"10-20人", @"20人以上", nil];
                        _data3 = [NSMutableArray arrayWithObjects:@"不限距离", @"10公里以内", @"10-50公里", @"50-100公里", @"100-200公里", @"200-300公里", @"300公里以外", nil];
                        _data4 = [@[@"时间筛选"] mutableCopy];
                        _currentData2Index = 0;
                        _currentData3Index = 0;
                        _currentData4Index = 0;
                        
                        break;
                        
                    default:
                        _data2 = [NSMutableArray arrayWithObjects:@"不限规模", @"2-4人", @"4人以上", nil];
                        _data3 = [NSMutableArray arrayWithObjects:@"不限距离", @"1公里以内", @"1-5公里", @"5-10公里",@"10公里以外" , nil];
                        _data4 =   [NSMutableArray arrayWithObjects:@"空闲",@"忙碌", nil];
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
        else if (indexPath.column == 2) {
            // 规模行
            _currentData3Index = indexPath.row;
        }
        else {
            _currentData4Index = indexPath.row;
        }
        
        DLog(@"%d %d %d %d", indexPath.column, indexPath.leftOrRight, indexPath.leftRow, indexPath.row);
        //787878
        
        //    if (indexPath.column == 0 && indexPath.leftOrRight == 1 && indexPath.leftRow == 2)
        //    {
        //        self.isHaveTruck = YES;
        //    }else
        //    {
        //        self.isHaveTruck = NO;
        //    }
        
        
        
        // 筛选工厂类型
        if (indexPath.column == 0 && indexPath.leftOrRight == 1 )
        {
            
            
            self.factoryServiceRange = nil;
            
            if (indexPath.leftRow == 0 )
            {
                self.factoryType = nil;
            }
            
            if (indexPath.leftRow == 1)
            {
                self.isHaveTruck = NO;//787878
                self.factoryType = 100;
                if (indexPath.row == 1)
                {
                    self.factoryServiceRange = @"童装";
                }
                if (indexPath.row == 2)
                {
                    self.factoryServiceRange = @"成人装";
                }
                
            }
            
            if (indexPath.leftRow == 2)
            {
                self.isHaveTruck = YES;//787878
                
                for (UIButton *button in self.truckBtnArray)
                {
                    if (button.tag == 0)
                    {
                        self.isHaveTruck = YES;
                    }
                    if (button.tag == 1)
                    {
                        self.isHaveTruck = NO;
                    }
                }
                
                self.factoryType = 1;
                if (indexPath.row == 1)
                {
                    self.factoryServiceRange = @"针织";
                }
                if (indexPath.row == 2)
                {
                    self.factoryServiceRange = @"梭织";
                }
            }
            
            if (indexPath.leftRow == 3)
            {
                self.isHaveTruck = NO;//787878
                self.factoryType = 3;
                self.factoryServiceRange = nil;
                
            }
            
            if (indexPath.leftRow ==4)
            {
                
                
                self.isHaveTruck = NO;//787878
                self.factoryType = 2;
                self.factoryServiceRange = nil;
            }
        }
        
        
        
        if (self.factoryType == 100)
        {
            // 筛选工厂规模
            if (indexPath.column == 1 && indexPath.leftOrRight == 0)
            {
                self.factorySizeMin = nil;
                self.factorySizeMax = nil;
                
                if (indexPath.leftRow ==1 && indexPath.row ==1 )
                {
                    self.factorySizeMin = @0;
                    self.factorySizeMax = @100000;
                }
                
                if (indexPath.leftRow ==2 && indexPath.row ==2 )
                {
                    self.factorySizeMin = @100000;
                    self.factorySizeMax = @300000;
                }
                
                if (indexPath.leftRow ==3 && indexPath.row ==3 )
                {
                    self.factorySizeMin = @300000;
                    self.factorySizeMax = @500000;
                }
                
                if (indexPath.leftRow ==4 && indexPath.row ==4 )
                {
                    self.factorySizeMin = @500000;
                    self.factorySizeMax = @1000000;
                }
                if (indexPath.leftRow ==5 && indexPath.row ==5 )
                {
                    self.factorySizeMin = @1000000;
                    self.factoryDistanceMax = @2000000;
                }
            }
            
            // 筛选工厂距离
            if (indexPath.column == 2 && indexPath.leftOrRight == 0)
            {
                self.factoryDistanceMin = nil;
                self.factoryDistanceMax = nil;
                
                if (indexPath.leftRow ==1 && indexPath.row ==1 )
                {
                    self.factoryDistanceMin = @0;
                    self.factoryDistanceMax = @10000;
                }
                
                if (indexPath.leftRow ==2 && indexPath.row ==2 )
                {
                    self.factoryDistanceMin = @10000;
                    self.factoryDistanceMax = @50000;
                }
                
                if (indexPath.leftRow ==3 && indexPath.row ==3 )
                {
                    self.factoryDistanceMin = @50000;
                    self.factoryDistanceMax = @100000;
                }
                
                if (indexPath.leftRow ==4 && indexPath.row ==4 )
                {
                    self.factoryDistanceMin = @100000;
                    self.factoryDistanceMax = @200000;
                }
                if (indexPath.leftRow ==5 && indexPath.row ==5 )
                {
                    self.factoryDistanceMin = @200000;
                    self.factoryDistanceMax = @300000;
                }
                if (indexPath.leftRow ==6 && indexPath.row ==6 )
                {
                    self.factoryDistanceMin = @300000;
                    self.factoryDistanceMax = @2000000000;
                    
                    
                }
            }
            
            if (self.factoryType == 1)
            {
                // 筛选工厂规模
                if (indexPath.column == 1 && indexPath.leftOrRight == 0)
                {
                    self.factorySizeMin = nil;
                    self.factorySizeMax = nil;
                    
                    if (indexPath.leftRow ==1 && indexPath.row ==1 )
                    {
                        self.factorySizeMin = @2;
                        self.factorySizeMax = @4;
                    }
                    
                    if (indexPath.leftRow ==2 && indexPath.row ==2 )
                    {
                        self.factorySizeMin = @4;
                        self.factorySizeMax = @10;
                    }
                    
                    if (indexPath.leftRow ==3 && indexPath.row ==3 )
                    {
                        self.factorySizeMin = @10;
                        self.factorySizeMax = @20;
                    }
                    
                    if (indexPath.leftRow ==4 && indexPath.row ==4 )
                    {
                        self.factorySizeMin = @20;
                        self.factorySizeMax = @10000;
                        
                    }
                }
                
                // 筛选工厂距离
                if (indexPath.column == 2 && indexPath.leftOrRight == 0)
                    
                {
                    self.factoryDistanceMin = nil;
                    self.factoryDistanceMax = nil;
                    
                    if (indexPath.leftRow ==1 && indexPath.row ==1 )
                    {
                        self.factoryDistanceMin = @0;
                        self.factoryDistanceMax = @10000;
                    }
                    
                    if (indexPath.leftRow ==2 && indexPath.row ==2 )
                    {
                        self.factoryDistanceMin = @10000;
                        self.factoryDistanceMax = @50000;
                    }
                    
                    if (indexPath.leftRow ==3 && indexPath.row ==3 )
                    {
                        self.factoryDistanceMin = @50000;
                        self.factoryDistanceMax = @100000;
                    }
                    
                    if (indexPath.leftRow ==4 && indexPath.row ==4 )
                    {
                        self.factoryDistanceMin = @100000;
                        self.factoryDistanceMax = @200000;
                    }
                    if (indexPath.leftRow ==5 && indexPath.row ==5 )
                    {
                        self.factoryDistanceMin = @200000;
                        self.factoryDistanceMax = @300000;
                    }
                    if (indexPath.leftRow ==6 && indexPath.row ==6 )
                    {
                        self.factoryDistanceMin = @300000;
                        self.factoryDistanceMax = @10000000000;
                    }
                }
            }
            
            if (self.factoryType == 2 || self.factoryType == 3)
            {
                // 筛选工厂规模
                if (indexPath.column == 1 && indexPath.leftOrRight == 0)
                {
                    self.factorySizeMin = nil;
                    self.factorySizeMax = nil;
                    
                    if (indexPath.leftRow ==1 && indexPath.row ==1 )
                    {
                        self.factorySizeMin = @2;
                        self.factorySizeMax = @4;
                    }
                    
                    if (indexPath.leftRow ==2 && indexPath.row ==2 )
                    {
                        self.factorySizeMin = @4;
                        self.factorySizeMax = @10000;
                    }
                }
                
                // 筛选工厂距离
                if (indexPath.column == 2 && indexPath.leftOrRight == 0)
                {
                    self.factoryDistanceMin = nil;
                    self.factoryDistanceMax = nil;
                    
                    if (indexPath.leftRow ==1 && indexPath.row ==1 )
                    {
                        self.factoryDistanceMin = @0;
                        self.factoryDistanceMax = @1000;
                    }
                    
                    if (indexPath.leftRow ==2 && indexPath.row ==2 )
                    {
                        self.factoryDistanceMin = @1000;
                        self.factoryDistanceMax = @5000;
                    }
                    
                    if (indexPath.leftRow ==3 && indexPath.row ==3 )
                    {
                        self.factoryDistanceMin = @5000;
                        self.factoryDistanceMax = @10000;
                    }
                    
                    if (indexPath.leftRow ==4 && indexPath.row ==4 )
                    {
                        self.factoryDistanceMin = @10000;
                        self.factoryDistanceMax = @1000000;
                    }
                }
            }
        }
        
        if (self.factoryType == 100)
        {
            // 筛选工厂规模
            if (indexPath.column == 1 && indexPath.leftOrRight == 0)
            {
                self.factorySizeMin = nil;
                self.factorySizeMax = nil;
                
                if (indexPath.leftRow ==1 && indexPath.row ==1 )
                {
                    self.factorySizeMin = @0;
                    self.factorySizeMax = @100000;
                }
                
                if (indexPath.leftRow ==2 && indexPath.row ==2 )
                {
                    self.factorySizeMin = @100000;
                    self.factorySizeMax = @300000;
                }
                
                if (indexPath.leftRow ==3 && indexPath.row ==3 )
                {
                    self.factorySizeMin = @300000;
                    self.factorySizeMax = @500000;
                }
                
                if (indexPath.leftRow ==4 && indexPath.row ==4 )
                {
                    self.factorySizeMin = @500000;
                    self.factorySizeMax = @1000000;
                }
                if (indexPath.leftRow ==5 && indexPath.row ==5 )
                {
                    self.factorySizeMin = @1000000;
                    self.factoryDistanceMax = @2000000;
                }
            }
            
            // 筛选工厂距离
            if (indexPath.column == 2 && indexPath.leftOrRight == 0)
            {
                self.factoryDistanceMin = nil;
                self.factoryDistanceMax = nil;
                
                if (indexPath.leftRow ==1 && indexPath.row ==1 )
                {
                    self.factoryDistanceMin = @0;
                    self.factoryDistanceMax = @10000;
                }
                
                if (indexPath.leftRow ==2 && indexPath.row ==2 )
                {
                    self.factoryDistanceMin = @10000;
                    self.factoryDistanceMax = @50000;
                }
                
                if (indexPath.leftRow ==3 && indexPath.row ==3 )
                {
                    self.factoryDistanceMin = @50000;
                    self.factoryDistanceMax = @100000;
                }
                
                if (indexPath.leftRow ==4 && indexPath.row ==4 )
                {
                    self.factoryDistanceMin = @100000;
                    self.factoryDistanceMax = @200000;
                }
                if (indexPath.leftRow ==5 && indexPath.row ==5 )
                {
                    self.factoryDistanceMin = @200000;
                    self.factoryDistanceMax = @300000;
                }
                if (indexPath.leftRow ==6 && indexPath.row ==6 )
                {
                    self.factoryDistanceMin = @300000;
                    self.factoryDistanceMax = @2000000000;
                    
                    
                }
                
            }
        }
        
        if (self.factoryType == 1)
        {
            // 筛选工厂规模
            if (indexPath.column == 1 && indexPath.leftOrRight == 0)
            {
                self.factorySizeMin = nil;
                self.factorySizeMax = nil;
                
                if (indexPath.leftRow ==1 && indexPath.row ==1 )
                {
                    self.factorySizeMin = @2;
                    self.factorySizeMax = @4;
                }
                
                if (indexPath.leftRow ==2 && indexPath.row ==2 )
                {
                    self.factorySizeMin = @4;
                    self.factorySizeMax = @10;
                }
                
                if (indexPath.leftRow ==3 && indexPath.row ==3 )
                {
                    self.factorySizeMin = @10;
                    self.factorySizeMax = @20;
                }
                
                if (indexPath.leftRow ==4 && indexPath.row ==4 )
                {
                    self.factorySizeMin = @20;
                    self.factorySizeMax = @10000;
                    
                }
            }
            
            // 筛选工厂距离
            if (indexPath.column == 2 && indexPath.leftOrRight == 0)
                
            {
                self.factoryDistanceMin = nil;
                self.factoryDistanceMax = nil;
                
                if (indexPath.leftRow ==1 && indexPath.row ==1 )
                {
                    self.factoryDistanceMin = @0;
                    self.factoryDistanceMax = @10000;
                }
                
                if (indexPath.leftRow ==2 && indexPath.row ==2 )
                {
                    self.factoryDistanceMin = @10000;
                    self.factoryDistanceMax = @50000;
                }
                
                if (indexPath.leftRow ==3 && indexPath.row ==3 )
                {
                    self.factoryDistanceMin = @50000;
                    self.factoryDistanceMax = @100000;
                }
                
                if (indexPath.leftRow ==4 && indexPath.row ==4 )
                {
                    self.factoryDistanceMin = @100000;
                    self.factoryDistanceMax = @200000;
                }
                if (indexPath.leftRow ==5 && indexPath.row ==5 )
                {
                    self.factoryDistanceMin = @200000;
                    self.factoryDistanceMax = @300000;
                }
                if (indexPath.leftRow ==6 && indexPath.row ==6 )
                {
                    self.factoryDistanceMin = @300000;
                    self.factoryDistanceMax = @10000000000;
                }
            }
        }
        
        if (self.factoryType == 2 || self.factoryType == 3)
        {
            // 筛选工厂规模
            if (indexPath.column == 1 && indexPath.leftOrRight == 0)
            {
                self.factorySizeMin = nil;
                self.factorySizeMax = nil;
                
                if (indexPath.leftRow ==1 && indexPath.row ==1 )
                {
                    self.factorySizeMin = @2;
                    self.factorySizeMax = @4;
                }
                
                if (indexPath.leftRow ==2 && indexPath.row ==2 )
                {
                    self.factorySizeMin = @4;
                    self.factorySizeMax = @10000;
                }
            }
            
            // 筛选工厂距离
            if (indexPath.column == 2 && indexPath.leftOrRight == 0)
            {
                self.factoryDistanceMin = nil;
                self.factoryDistanceMax = nil;
                
                if (indexPath.leftRow ==1 && indexPath.row ==1 )
                {
                    self.factoryDistanceMin = @0;
                    self.factoryDistanceMax = @1000;
                }
                
                if (indexPath.leftRow ==2 && indexPath.row ==2 )
                {
                    self.factoryDistanceMin = @1000;
                    self.factoryDistanceMax = @5000;
                }
                
                if (indexPath.leftRow ==3 && indexPath.row ==3 )
                {
                    self.factoryDistanceMin = @5000;
                    self.factoryDistanceMax = @10000;
                }
                
                if (indexPath.leftRow ==4 && indexPath.row ==4 )
                {
                    self.factoryDistanceMin = @10000;
                    self.factoryDistanceMax = @10000000;
                }
                
            }
            
        }
        
        
        
        //加工厂
        if (self.factoryType == 1 && indexPath.column == 3 && indexPath.row == 0)
        {
            if(!self.datePicker)
                self.datePicker = [THDatePickerViewController datePicker];
            self.datePicker.date = self.curDate;
            self.datePicker.delegate = self;
            [self.datePicker setAllowClearDate:NO];
            [self.datePicker setAutoCloseOnSelectDate:YES];
            [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
            [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
            
            [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
                int tmp = (arc4random() % 30)+1;
                if(tmp % 5 == 0)
                    return YES;
                return NO;
            }];
            UINavigationController*dateNav = [[UINavigationController alloc]initWithRootViewController:self.datePicker];
            dateNav.title=@"选择空闲时间";
            dateNav.navigationBar.barStyle=UIBarStyleBlack;
            [self presentViewController:dateNav animated:NO completion:nil];
            
            
        }
        
        //代裁和锁眼钉扣
        if ( self.factoryType == 2 && indexPath.column == 3)
        {
            if (indexPath.row == 0)
            {
                self.factoryFree = @"空闲";
            }
            if (indexPath.row == 1)
            {
                self.factoryFree = @"忙碌";
            }
        }
        if ( self.factoryType == 3 && indexPath.column == 3)
        {
            if (indexPath.row == 0)
            {
                self.factoryFree = @"空闲";
            }
            if (indexPath.row == 1)
            {
                self.factoryFree = @"忙碌";
            }
        }
        
        //其他
        if (self.factoryType == 100 || self.factoryType == 0)
        {
            self.factoryFree = @"";
        }
        
        
        if (self.factoryType == 1)
        {
            if (self.dateArray.count == 0)
            {
                
            }if (self.dateArray.count>0)
            {
                self.factoryFree = self.dateArray[0];
                
            }
            
            
        }
        
        //       DLog(@">>>>>>>>>>>self.factoryName=%@,self.factoryType=%d,self.factoryServiceRange=%@,self.factorySizeMin=%@,self.factorySizeMax=%@,self.factoryDistanceMin=%@,self.factoryDistanceMax=%@,self.isHaveTruck=%d,self.factoryFree=%@",self.factoryName,self.factoryType,self.factoryServiceRange,self.factorySizeMin,self.factorySizeMax,self.factoryDistanceMin,self.factoryDistanceMax,self.isHaveTruck,self.factoryFree);
        
        
        //    DLog(@">>>>>isHaveTruck=%d",self.isHaveTruck);
        
        if (self.factoryType == 1)
        {
            _tableView.tableHeaderView = _view;
        }
        else
        {
            _tableView.tableHeaderView = nil;
        }
        
        
        
        if (self.isHaveTruck == YES)
        {
            _number = @1;
        }
        if (self.isHaveTruck == NO)
        {
            _number = @0;
        }
        
        
        _refrushCount = 1;
        
        [HttpClient searchWithFactoryName:self.factoryName factoryType:self.factoryType factoryServiceRange:self.factoryServiceRange factorySizeMin:self.factorySizeMin factorySizeMax:self.factorySizeMax factoryDistanceMin:self.factoryDistanceMin factoryDistanceMax:self.factoryDistanceMax Truck:_number factoryFree:self.factoryFree  page:(@1) andBlock:^(NSDictionary *responseDictionary) {
            
            self.factoryModelArray = nil;
            self.factoryModelArray = responseDictionary[@"responseArray"];
            [_tableView reloadData];
        }];
    }
    
    - (void)dealloc
    {
        _tableView.dataSource = nil;
        _tableView.delegate = nil;
        _datePicker=nil;
        
        self.JSDropDownMenu.dataSource = nil;
        self.JSDropDownMenu.delegate = nil;}
    
#pragma mark - <UISearchBarDelegate>
    
//    - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//        [self.navigationItem.titleView endEditing:YES];
//    }
//    
    - (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
    {
        [searchBar resignFirstResponder];
        DLog(@"333%@",searchBar.text);
        
        
        _refrushCount = 1;
        [HttpClient searchWithFactoryName:searchBar.text factoryType:nil factoryServiceRange:nil factorySizeMin:nil factorySizeMax:nil factoryDistanceMin:nil factoryDistanceMax:nil Truck:nil factoryFree:nil page:(@1)andBlock:^(NSDictionary *responseDictionary) {
            
            self.factoryModelArray = nil;
            self.factoryModelArray = responseDictionary[@"responseArray"];
            [_tableView reloadData];
            
            if (self.factoryModelArray.count == 0)
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"搜索结果" message:@"您搜索的工厂暂时不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
        }];
        
    }
    
#pragma mark -- 日期选择器
    
    -(void)datePickerDonePressed:(THDatePickerViewController *)datePicker
    {
        self.curDate = datePicker.date;
        
        NSString *string1 = [NSString stringWithFormat:@"%@",[_formatter stringFromDate:self.curDate]];
        
        DLog(@"+++++%@",string1);
        NSArray *array1 = [string1 componentsSeparatedByString:@"年"];
        DLog(@"+++++%@",array1[0]);
        NSString *string2 = array1[1];
        DLog(@"+++++%@",array1[1]);
        NSArray *array2 = [string2 componentsSeparatedByString:@"月"];
        DLog(@"+++++%@",array2[0]);
        NSString *string3 = array2[1];
        NSArray *array3 = [string3 componentsSeparatedByString:@"日"];
        
        NSString *string = [NSString stringWithFormat:@"%@-%@-%@",array1[0],array2[0],array3[0]];
        
        DLog(@"string===+++++%@",string);
        
        
        self.factoryFree = string;
        
        if (self.dateArray.count == 0)
        {
            [self.dateArray addObject:self.factoryFree];
        }
        if (self.dateArray.count>0)
        {
            [self.dateArray replaceObjectAtIndex:0 withObject:self.factoryFree];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        //    [self dismissViewControllerAnimated:YES completion:nil];
        
            DLog(@"++++++++++========self.factoryName=%@,self.factoryType=%d,self.factoryServiceRange=%@,self.factorySizeMin=%@,self.factorySizeMax=%@,self.factoryDistanceMin=%@,self.factoryDistanceMax=%@,self.isHaveTruck=%d,self.factoryFree=%@",self.factoryName,self.factoryType,self.factoryServiceRange,self.factorySizeMin,self.factorySizeMax,self.factoryDistanceMin,self.factoryDistanceMax,self.isHaveTruck,self.factoryFree);
        
        _refrushCount = 1;
        [HttpClient searchWithFactoryName:self.factoryName factoryType:self.factoryType factoryServiceRange:self.factoryServiceRange factorySizeMin:self.factorySizeMin factorySizeMax:self.factorySizeMax factoryDistanceMin:self.factoryDistanceMin factoryDistanceMax:self.factoryDistanceMax Truck:_number factoryFree:self.factoryFree page:(@1) andBlock:^(NSDictionary *responseDictionary) {
            
            self.factoryModelArray = nil;
            self.factoryModelArray = responseDictionary[@"responseArray"];
            [_tableView reloadData];
        }];
    }
    
    -(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
    @end
