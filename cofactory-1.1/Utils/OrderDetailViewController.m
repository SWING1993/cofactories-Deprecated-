//
//  OrderDetailViewController.m
//  111111
//
//  Created by 宇宙之神 on 15/7/19.
//  Copyright (c) 2015年 宇宙之神. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "Header.h"
#import "OrderPhotoViewController.h"
#import "BidManagerViewController.h"

@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UIView *_view;
    NSArray *_competeFactoryArray;
    UITableView *_tableView;
    NSMutableArray *_buttonArray;
}

@end
static  NSString *const cellIdentifier1 = @"cell1";
@implementation OrderDetailViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [HttpClient getBidOrderWithOid:self.model.oid andBlock:^(NSDictionary *responseDictionary) {
        _competeFactoryArray = responseDictionary[@"responseArray"];
        [_tableView reloadData];
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单详情";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除订单" style:UIBarButtonItemStylePlain target:self action:@selector(deleteOrderClick)];
    
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
        CGSize size = [Tools getSize:[NSString stringWithFormat:@"%d",self.model.interest] andFontOfSize:16.0f];
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
        return 5;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.textColor = [UIColor grayColor];
    
    switch (indexPath.row) {
        case 0:
            switch (self.model.type) {

                case 2:
                    cell.textLabel.text = @"订单类型:  代裁订单";
                    
                    break;
                case 3:
                    cell.textLabel.text = @"订单类型:  锁眼钉扣订单";
                    
                    break;
                default:
                    cell.textLabel.text = @"订单类型:  加工订单";

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
        case 4:
        {
            if ([self.model.comment isEqualToString:@""] || self.model.comment== nil) {
                cell.textLabel.text = [NSString stringWithFormat:@"备注:  暂无备注"];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@",self.model.comment];
            }
            
        }
            break;
        default:
            break;
    }
    
    return cell;
    
    
    //    BidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
    //    FactoryModel *facModel = _competeFactoryArray[indexPath.row];
    //    cell.companyNameLabel.text = facModel.factoryName;
    //
    //    if (self.isHistory == NO) {
    //
    //        cell.competeButton.enabled = YES;
    //        [cell.competeButton setTitle:@"中标" forState:UIControlStateNormal];
    //        cell.competeButton.backgroundColor = [UIColor colorWithRed:205/255.0 green:17/255.0 blue:23/255.0 alpha:1.0];
    //        cell.competeButton.tag = facModel.uid;
    //        [cell.competeButton addTarget:self action:@selector(competeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //    }
    //    if (self.isHistory == YES) {
    //
    //        cell.competeButton.enabled = NO;
    //
    //        if (self.model.bidWinner == facModel.uid) {
    //            [cell.competeButton setTitle:@"已中标" forState:UIControlStateNormal];
    //            cell.competeButton.backgroundColor = [UIColor colorWithRed:205/255.0 green:17/255.0 blue:23/255.0 alpha:1.0];
    //        }else{
    //            [cell.competeButton setTitle:@"未中标" forState:UIControlStateNormal];
    //     cell.competeButton.backgroundColor = [UIColor colorWithRed:154/255.0 green:154/255.0 blue:154/255.0 alpha:1.0];
    //        }
    //    }
    //    return cell;
    //
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
        competeCount.text = [NSString stringWithFormat:@"%ld",(unsigned long)_competeFactoryArray.count];
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
        [competeButton addTarget:self action:@selector(competeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:competeButton];
        
        if (self.isHistory == YES) {
            [competeButton setTitle:@"已完成" forState:UIControlStateNormal];
            competeButton.enabled = NO;
        }
        if (self.isHistory == NO) {
            
            if (_competeFactoryArray.count > 0) {
                [competeButton setTitle:@"投标管理" forState:UIControlStateNormal];
                competeButton.enabled = YES;
                
            }else{
                [competeButton setTitle:@"暂无投标" forState:UIControlStateNormal];
                competeButton.enabled = NO;
            }
            
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
    
    if (indexPath.section == 0 && indexPath.row == 4) {
        if ([self.model.comment isEqualToString:@""] || self.model.comment== nil ) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"备注" message:@"暂无备注" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"备注" message:self.model.comment delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
        
    }
}


#pragma mark -- button
- (void)orderImageButtonClick{
    
    if (self.model.photoArray.count > 0) {
        OrderPhotoViewController *VC = [[OrderPhotoViewController alloc]initWithPhotoArray:self.model.photoArray];
        VC.titleString = @"订单图片";
        [self.navigationController pushViewController:VC animated:YES];
        
    }if (self.model.photoArray.count == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"厂家未上传订单图片" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}


- (void)competeButtonClick:(id)sender{
    BidManagerViewController *vc = [[BidManagerViewController alloc]init];
    vc.bidFactoryArray = _competeFactoryArray;
    vc.oid = self.model.oid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteOrderClick{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"是否取消订单" message:@"订单一旦取消不可恢复，是否取消订单?" delegate:self cancelButtonTitle:@"不取消订单" otherButtonTitles:@"取消订单", nil];
    alert.tag = 2;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //    if (alertView.tag == 1) {
    //        if (buttonIndex == 0) {
    //            [_buttonArray removeObjectAtIndex:0];
    //        }
    //
    //        if (buttonIndex == 1) {
    //            UIButton *button = _buttonArray[0];
    //            [HttpClient closeOrderWithOid:self.model.oid Uid:button.tag andBlock:^(int statusCode) {
    //                DLog(@"statusCode==%d",statusCode);
    //
    //                if (statusCode == 200) {
    //                    [Tools showHudTipStr:@"选择成功"];
    //                    NSArray *navArray = self.navigationController.viewControllers;
    //                    [self.navigationController popToViewController:navArray[1] animated:YES];
    //
    //                }else{
    //                    [Tools showHudTipStr:@"选择失败"];
    //                }
    //            }];
    //
    //
    //        }
    //
    //    }
    
    if (alertView.tag == 2) {
        
        if (buttonIndex == 1) {
            [HttpClient deleteOrderWithOrderOid:self.model.oid completionBlock:^(int statusCode) {
                
                if (statusCode == 200) {
                    
                    [Tools showSuccessWithStatus:@"删除订单成功"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }else{
                    
                    [Tools showErrorWithStatus:@"删除订单失败"];
                    
                }
            }];
        }
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
