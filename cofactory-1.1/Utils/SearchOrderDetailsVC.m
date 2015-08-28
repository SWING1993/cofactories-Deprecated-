//
//  SearchOrderDetailsVC.m
//  cofactory-1.1
//
//  Created by gt on 15/8/12.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "SearchOrderDetailsVC.h"
#import "CompeteTableViewCell.h"
#import "Header.h"
@interface SearchOrderDetailsVC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    UIView *_view;
    NSArray *_competeFactoryArray;
}
@property (nonatomic,assign) BOOL isCompete;
@end
static  NSString *const cellIdentifier1 = @"cell1";
static  NSString *const cellIdentifier2 = @"cell2";

@implementation SearchOrderDetailsVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self layoutCompeteData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
//    self.automaticallyAdjustsScrollViewInsets = NO;
    [self creatTableViewAndTableViewHeaderView];
}

- (void)creatTableViewAndTableViewHeaderView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier1];
    [_tableView registerClass:[CompeteTableViewCell class] forCellReuseIdentifier:cellIdentifier2];
    
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    backgroundView.backgroundColor = [UIColor colorWithRed:98/255.0 green:190/255.0 blue:181/255.0 alpha:1.0];
    [headerView addSubview:backgroundView];
    
    UILabel *companyName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, backgroundView.frame.size.width-30, 40)];
    companyName.textColor = [UIColor whiteColor];
    companyName.text = self.model.facName;
    companyName.font = [UIFont systemFontOfSize:18.0f];
    [backgroundView addSubview:companyName];
    
    UIButton *contactManufacturerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactManufacturerButton.frame = CGRectMake(10, 55, 70, 25);
    [contactManufacturerButton setBackgroundImage:[UIImage imageNamed:@"联系厂商"] forState:UIControlStateNormal];
    [contactManufacturerButton addTarget:self action:@selector(contactManufacturerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:contactManufacturerButton];
    
    if (self.model.interest > 0) {
        
        UIFont *font = [UIFont systemFontOfSize:16.0f];
        UILabel *interestCount = [[UILabel alloc]init];
        interestCount.textColor = [UIColor orangeColor];
        interestCount.font = font;
        CGSize size = [[NSString stringWithFormat:@"%d",self.model.interest] sizeWithFont:font constrainedToSize:CGSizeMake(280, 100000) lineBreakMode:NSLineBreakByWordWrapping];
        interestCount.frame = CGRectMake(10, 90, size.width, 20);
        interestCount.textAlignment = 2;
        interestCount.text = [NSString stringWithFormat:@"%d",self.model.interest];
        [backgroundView addSubview:interestCount];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(interestCount.frame.size.width+15, 90, 160, 20)];
        label.font = [UIFont systemFontOfSize:14.0f];
        label.text = @"家厂商对此订单感兴趣";
        [backgroundView addSubview:label];
    }
    
    
    UIButton *orderImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderImageButton.frame = CGRectMake(kScreenW-20-70, 85, 70, 30);
    orderImageButton.backgroundColor = [UIColor colorWithRed:59/255.0 green:141/255.0 blue:191/255.0 alpha:1.0];
    orderImageButton.layer.masksToBounds = YES;
    orderImageButton.layer.cornerRadius = 5;
    [orderImageButton setTitle:@"订单图片" forState:UIControlStateNormal];
    orderImageButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [orderImageButton addTarget:self action:@selector(orderImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:orderImageButton];
    
    
}

- (void)layoutCompeteData{
    
    [HttpClient getBidOrderWithOid:self.model.oid andBlock:^(NSDictionary *responseDictionary) {
        _competeFactoryArray = responseDictionary[@"responseArray"];
        //       NSLog(@"_competeFactoryArray==%@",_competeFactoryArray);
        NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfuid"];
        NSLog(@"+++++%@",number);
        int myUid = [number intValue];
        
        [_competeFactoryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            FactoryModel *model = _competeFactoryArray[idx];
            
            if (model.uid == myUid) {
                self.isCompete = YES;
            }else{
                self.isCompete = NO;
            }
            
            if (self.isCompete == YES) {
                *stop = YES;
            }
            NSLog(@"isCompete==%d",self.isCompete);
        }];
        
        [_tableView reloadData];
    }];
    
}

#pragma mark -- table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 6;
    }if (section == 1) {
        return _competeFactoryArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.textColor = [UIColor grayColor];
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"联系人:  %@",self.model.name];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"联系电话:  %@",self.model.phone];
                break;
            case 2:
                switch (self.model.type) {
                    case 1:
                        cell.textLabel.text = @"订单类型:  加工订单";
                        
                        break;
                    case 2:
                        cell.textLabel.text = @"订单类型:  代裁订单";
                        
                        break;
                    case 3:
                        cell.textLabel.text = @"订单类型:  锁眼钉扣订单";
                        
                        break;
                    default:
                        break;
                }
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"订单数量:  %d件",self.model.amount];
                break;
            case 4:
            {
                cell.textLabel.text = [NSString stringWithFormat:@"工期:  %@天",self.model.workingTime];
            }
                break;
            case 5:
            {
                 NSMutableArray *array = [Tools WithTime:self.model.createTime];
                cell.textLabel.text = [NSString stringWithFormat:@"下单时间:  %@",array[0]];
            }
                break;
            default:
                break;
        }
        
        return cell;
        
    }
    
    //    if (indexPath.section == 1) {
    //        FactoryModel *model = _competeFactoryArray[indexPath.row];
    //        cell.textLabel.text = model.factoryName;
    //    }
    
    CompeteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
    FactoryModel *model = _competeFactoryArray[indexPath.row];
    cell.companyNameLabel.text = model.factoryName;
    
    if (self.model.status == 1) {
        cell.competeImage.hidden = NO;
        if (self.model.bidWinner == model.uid ) {
            cell.competeImage.text = @"已中标";
            cell.competeImage.backgroundColor = [UIColor colorWithRed:205/255.0 green:17/255.0 blue:23/255.0 alpha:1.0];
        }else{
            cell.competeImage.text = @"未中标";
            cell.competeImage.backgroundColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];
        }
    }else{
        cell.competeImage.hidden = YES;
    }
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 80, 43)];
        label.text = @"订单详情";
        label.font = [UIFont systemFontOfSize:18.0f];
        [view addSubview:label];
        
        UILabel *orderNumber = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-160, 0, 150, 43)];
        orderNumber.text = [NSString stringWithFormat:@"订单号:  %d",self.model.oid];
        orderNumber.font = [UIFont systemFontOfSize:14.0f];
        orderNumber.textColor = [UIColor grayColor];
        [view addSubview:orderNumber];
        
        return view;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
        view.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 43)];
        label.text = @"已参与投标的工厂有";
        label.font = [UIFont systemFontOfSize:16.0f];
        [view addSubview:label];
        
        UILabel *competeCount = [[UILabel alloc]initWithFrame:CGRectMake(160, 0, 30, 43)];
        competeCount.textColor = [UIColor colorWithRed:205/255.0 green:17/255.0 blue:23/255.0 alpha:1.0];
        competeCount.textAlignment = 1;
        competeCount.font = [UIFont systemFontOfSize:18.0f];
        competeCount.text = [NSString stringWithFormat:@"%ld",_competeFactoryArray.count];
        [view addSubview:competeCount];
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(195, 0, 20, 43)];
        label1.text = @"家";
        label.font = [UIFont systemFontOfSize:16.0f];
        [view addSubview:label1];
        
        return view;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 74+15)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *competeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        competeButton.frame = CGRectMake((kScreenW-120)/2.0, 15, 120, 44);
        competeButton.backgroundColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1.0];
        competeButton.layer.masksToBounds = YES;
        competeButton.layer.cornerRadius = 5;
        [competeButton addTarget:self action:@selector(competeButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:competeButton];
        
        if (self.model.status == 0) {
            
            if (self.isCompete == YES) {
                
                [competeButton setTitle:@"已投标" forState:UIControlStateNormal];
                competeButton.enabled = NO;
            }
            if (self.isCompete == NO) {
                [competeButton setTitle:@"参与竞标" forState:UIControlStateNormal];
                competeButton.enabled = YES;
            }
        }
        if (self.model.status == 1) {
            
            [competeButton setTitle:@"订单完成" forState:UIControlStateNormal];
            competeButton.enabled = NO;
            //            NSLog(@"bidWinner==%d",self.model.bidWinner);
        }
        
        
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 74, kScreenW, 15)];
        label.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
        [view addSubview:label];
        
        return view;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 74+15;
    }else{
        return 0;
    }
}

#pragma mark -- ButtonClick
- (void)competeButtonClick{
    NSLog(@"competeButtonClick");
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定投标?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)orderImageButtonClick{
    
    _view=[[UIView alloc]initWithFrame:kScreenBounds];
    _view.backgroundColor=[UIColor clearColor];
    
    UIImageView*photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenH/4-64, kScreenW, kScreenW)];
//    [photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.cofactories.com/order/%d.png",self.model.oid]] placeholderImage:[UIImage imageNamed:@"placeholder232"] ];
    [photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/order/%d.png",PhotoAPI,self.model.oid]] placeholderImage:[UIImage imageNamed:@"placeholder232"] ];//图片测试

    photoView.contentMode=UIViewContentModeScaleAspectFill;
    photoView.clipsToBounds=YES;
    [_view addSubview:photoView];
    [self.view addSubview:_view];
    
    
}

- (void)contactManufacturerButtonClick{
    
    NSString *str = [NSString stringWithFormat:@"telprompt://%@", self.model.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    //感兴趣
    [HttpClient interestOrderWithOid:self.model.oid andBlock:^(int statusCode) {
        NSLog(@"感兴趣状态码%d",statusCode);
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_view removeFromSuperview];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        
        [HttpClient bidOrderWithOid:self.model.oid andBlock:^(int statusCode) {
            if (statusCode == 200) {
                [Tools showHudTipStr:@"投标成功"];
                [self layoutCompeteData];
            }else{
                [Tools showHudTipStr:@"投标失败"];
            }
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end