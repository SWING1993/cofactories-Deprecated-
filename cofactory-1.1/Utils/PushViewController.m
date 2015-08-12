//
//  PushViewController.m
//  cofactory-1.1
//
//  Created by gt on 15/7/23.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "PushViewController.h"
#import "Header.h"
#import "FactoryAndOrderMessVC.h"
#import "PushTableViewCell.h"
#import "GetPushModel.h"


@interface PushViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic,retain)NSMutableArray*cellArray;

@end

@implementation PushViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.cellArray= [[NSMutableArray alloc]initWithCapacity:0];

    [HttpClient getPushSettingWithBlock:^(NSDictionary *dictionary) {
      //  NSLog(@"++%@",dictionary[@"array"]);
        if ([dictionary[@"statusCode"] intValue] == 200) {
            self.cellArray = dictionary[@"array"];
            [_tableView reloadData];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"推送助手";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 130;
    [_tableView registerClass:[PushTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    label.text = @"请设置您所需要的相关信息";
    label.textAlignment = 1;
    label.textColor = [UIColor blackColor];
    [tableHeaderView addSubview:label];
    _tableView.tableHeaderView = tableHeaderView;
    
}

#pragma mark--tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PushTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    GetPushModel *pushModel = self.cellArray[indexPath.row];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    int facType = [pushModel.factoryTypes intValue];
    switch (facType) {
        case 0:
        {
            if ([pushModel.type isEqualToString:@"factory"]) {
                cell.typeLB.text = @"加工厂信息";
            }else{
                cell.typeLB.text = @"加工厂订单";
            }
            cell.businessLB.hidden = NO;
            cell.businessLB.text = [NSString stringWithFormat:@"业务类型: %@",pushModel.serviceRange];
        }
            break;
        case 1:
            if ([pushModel.type isEqualToString:@"factory"]) {
                cell.typeLB.text = @"代裁厂信息";
            }else{
                cell.typeLB.text = @"代裁厂订单";
            }
            cell.businessLB.hidden = YES;
            break;
        case 2:
            if ([pushModel.type isEqualToString:@"factory"]) {
                cell.typeLB.text = @"锁眼钉扣厂信息";
            }else{
                cell.typeLB.text = @"锁眼钉扣厂订单";
            }
            cell.businessLB.hidden = YES;
            break;
        default:
            break;
    }

    long long indexO = [pushModel.dictanceArray[0] longLongValue];
    long long index1 = [pushModel.dictanceArray[1] longLongValue];
    
    if (indexO == 0 && index1 >=5000000000) {
        cell.distenceLB.text = [NSString stringWithFormat:@"距离:%@",@"不限距离"];
    }else if (indexO == 0 && index1 >=10000) {
        cell.distenceLB.text = [NSString stringWithFormat:@"距离:%@",@"10公里以内"];
    }else if (indexO == 300000 && index1 >=10000000000000000) {
        cell.distenceLB.text = [NSString stringWithFormat:@"距离:%@",@"300公里以外"];
    }else if (indexO == 0 && index1 ==1000) {
        cell.distenceLB.text = [NSString stringWithFormat:@"距离:%@",@"1公里以内"];
    }else{
        long long left = indexO/1000;
        long long right = index1/1000;
        cell.distenceLB.text = [NSString stringWithFormat:@"距离:%lld-%lld公里",left,right];
    }
    long long index2 = [pushModel.sizeArray[0] longLongValue];
    long long index3 = [pushModel.sizeArray[1] longLongValue];
    if (index2 == 0 && index3 >= 500000000) {
        cell.scaleLB.text = [NSString stringWithFormat:@"规模:%@",@"不限规模"];
    }else if (index2 == 20 && index3 >= 400000000000){
        cell.scaleLB.text = [NSString stringWithFormat:@"规模:%@",@"20人以上"];
    }else if (index2 == 4 && index3 >= 400000000000){
        cell.scaleLB.text = [NSString stringWithFormat:@"规模:%@",@"4人以上"];
    }else{
        cell.scaleLB.text = [NSString stringWithFormat:@"规模:%lld-%lld人",index2,index3];
    }


    cell.deletButton.tag = indexPath.row;
//    cell.deletButton.backgroundColor = [UIColor redColor];
    [cell.deletButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    
    UILabel *lineLB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    lineLB.backgroundColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:0.8];
    [view addSubview:lineLB];
    
    UIButton *buttonImg = [[UIButton alloc]initWithFrame:CGRectMake((kScreenW-60)/2.0, 30, 60, 60)];
    [buttonImg setBackgroundImage:[UIImage imageNamed:@"添加.png"] forState:UIControlStateNormal];
    buttonImg.layer.masksToBounds = YES;
    buttonImg.layer.cornerRadius = 30;
    [buttonImg addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:buttonImg];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0 , 90, kScreenW, 20)];
    label.text = @"添加信息";
    label.textAlignment = 1;
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithRed:55/255.0 green:117/255.0 blue:189/255.0 alpha:1.0];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 110;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark--点击添加按钮

- (void)buttonClick
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加工厂信息",@"添加服装厂外发订单", nil];
    [actionSheet showInView:_tableView];
}

#pragma mark <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

        switch (buttonIndex) {
            case 0:
            {
                FactoryAndOrderMessVC *VC = [[FactoryAndOrderMessVC alloc]init];
                UINavigationController*Nav = [[UINavigationController alloc]initWithRootViewController:VC];
                Nav.title=@"推送助手";
                Nav.navigationBar.barStyle=UIBarStyleBlack;
                VC.facType = 0;
                VC.types = @"factory";
                [self presentViewController:Nav animated:YES completion:nil];
            }
                
                break;
            case 1:
            {
                FactoryAndOrderMessVC *VC = [[FactoryAndOrderMessVC alloc]init];
                UINavigationController*Nav = [[UINavigationController alloc]initWithRootViewController:VC];
                Nav.navigationBar.barStyle=UIBarStyleBlack;
                Nav.title=@"推送助手";
                VC.facType = 1;
                VC.types = @"order";
                [self presentViewController:Nav animated:YES completion:nil];
            }
                break;
             default:
                break;
        }
}


- (void)buttonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSNumber *number = [NSNumber numberWithInt:button.tag];
    [HttpClient deletePushSettingWithIndex:number andBlock:^(int statusCode) {
        NSLog(@"statusCode==%d",statusCode);
    }];
    [self.cellArray removeObjectAtIndex:button.tag];
    [_tableView reloadData];
}

- (void)dealloc
{
    NSLog(@"释放内存");
    _tableView.dataSource = nil;
    _tableView.delegate = nil;

}

@end
