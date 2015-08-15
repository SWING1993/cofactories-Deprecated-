//
//  OrderDetailViewController.m
//  111111
//
//  Created by 宇宙之神 on 15/7/19.
//  Copyright (c) 2015年 宇宙之神. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "Header.h"
#import "BidTableViewCell.h"
@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIView *_view;
    NSArray *_competeFactoryArray;
    UITableView *_tableView;
    NSMutableArray *_buttonArray;
}

@end
static  NSString *const cellIdentifier1 = @"cell1";
static  NSString *const cellIdentifier2 = @"cell2";
@implementation OrderDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [HttpClient getBidOrderWithOid:self.model.oid andBlock:^(NSDictionary *responseDictionary) {
        _competeFactoryArray = responseDictionary[@"responseArray"];
        DLog(@"_competeFactoryArray==%@",_competeFactoryArray);
        [_tableView reloadData];
    }];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    _buttonArray = [[NSMutableArray alloc]init];
    [self creatTableViewAndTableViewHeaderView];
   
}

- (void)creatTableViewAndTableViewHeaderView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier1];
    [_tableView registerClass:[BidTableViewCell class] forCellReuseIdentifier:cellIdentifier2];
    
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = headerView;
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    backgroundView.backgroundColor = [UIColor colorWithRed:98/255.0 green:190/255.0 blue:181/255.0 alpha:1.0];
    [headerView addSubview:backgroundView];
    
    NSString *facName = [[NSUserDefaults standardUserDefaults] objectForKey:@"factoryName"];
    UILabel *companyName = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, backgroundView.frame.size.width-30, 40)];
    companyName.textColor = [UIColor whiteColor];
    companyName.text = facName;
    companyName.font = [UIFont systemFontOfSize:18.0f];
    [backgroundView addSubview:companyName];
    
    UIButton *orderImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderImageButton.frame = CGRectMake(10, 50, 70, 30);
    orderImageButton.backgroundColor = [UIColor colorWithRed:59/255.0 green:141/255.0 blue:191/255.0 alpha:1.0];
    orderImageButton.layer.masksToBounds = YES;
    orderImageButton.layer.cornerRadius = 5;
    [orderImageButton setTitle:@"订单图片" forState:UIControlStateNormal];
    orderImageButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [orderImageButton addTarget:self action:@selector(orderImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:orderImageButton];
    
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
    
    

    
    
}

#pragma mark -- table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
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
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"订单数量:  %d件",self.model.amount];
                break;
            case 2:
            {
                cell.textLabel.text = [NSString stringWithFormat:@"工期:  %@天",self.model.workingTime];
            }
                break;
            case 3:
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
    
    BidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
    FactoryModel *facModel = _competeFactoryArray[indexPath.row];
    cell.companyNameLabel.text = facModel.factoryName;
    
    if (self.isHistory == NO) {
        
        cell.competeButton.enabled = YES;
        [cell.competeButton setTitle:@"中标" forState:UIControlStateNormal];
        cell.competeButton.backgroundColor = [UIColor colorWithRed:205/255.0 green:17/255.0 blue:23/255.0 alpha:1.0];
        cell.competeButton.tag = facModel.uid;
        [cell.competeButton addTarget:self action:@selector(competeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (self.isHistory == YES) {
        
        cell.competeButton.enabled = NO;
        
        if (self.model.bidWinner == facModel.uid) {
            [cell.competeButton setTitle:@"已中标" forState:UIControlStateNormal];
            cell.competeButton.backgroundColor = [UIColor colorWithRed:205/255.0 green:17/255.0 blue:23/255.0 alpha:1.0];
        }else{
            [cell.competeButton setTitle:@"未中标" forState:UIControlStateNormal];
     cell.competeButton.backgroundColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];
        }
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
        [view addSubview:competeButton];
        
        if (self.isHistory == YES) {
            [competeButton setTitle:@"已选择" forState:UIControlStateNormal];
        }
        if (self.isHistory == NO) {
            [competeButton setTitle:@"未选择" forState:UIControlStateNormal];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        CooperationInfoViewController *VC = [[CooperationInfoViewController alloc]init];
        VC.factoryModel = _competeFactoryArray[indexPath.row];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
#pragma mark -- button
- (void)orderImageButtonClick{
    _view=[[UIView alloc]initWithFrame:kScreenBounds];
    _view.backgroundColor=[UIColor clearColor];
    
    UIImageView*photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenH/4-64, kScreenW, kScreenW)];
//    [photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cofactories-test.p0.upaiyun.com/order/%d.png",self.model.oid]] placeholderImage:[UIImage imageNamed:@"placeholder232"] ];
    [photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/order/%d.png",PhotoAPI,self.model.oid]] placeholderImage:[UIImage imageNamed:@"placeholder232"] ];//图片测试

    photoView.contentMode=UIViewContentModeScaleAspectFill;
    photoView.clipsToBounds=YES;
    [_view addSubview:photoView];
    [self.view addSubview:_view];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_view removeFromSuperview];
    
}

- (void)competeButtonClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    [_buttonArray addObject:button];

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"确定该用户中标?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        [_buttonArray removeObjectAtIndex:0];
    }
    
    if (buttonIndex == 1) {
        
        
        UIButton *button = _buttonArray[0];
//        NSLog(@"tag=%ld",button.tag);
        
        [HttpClient closeOrderWithOid:self.model.oid Uid:button.tag andBlock:^(int statusCode) {
            DLog(@"statusCode==%d",statusCode);
            
            if (statusCode == 200) {
                [Tools showHudTipStr:@"选择成功"];
                NSArray *navArray = self.navigationController.viewControllers;
                [self.navigationController popToViewController:navArray[1] animated:YES];
                
//                double delayInSeconds = 1.5;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                   
//                });
                
            }else{
                [Tools showHudTipStr:@"选择失败"];
            }
        }];
            
        
    }
}

- (void)dealloc{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
