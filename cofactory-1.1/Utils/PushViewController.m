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


@interface PushViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic,retain)NSMutableArray*cellArray;

@end

@implementation PushViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"dic"] == nil)
    {
    }
    else
    {
        NSMutableDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"dic"];
        [self.cellArray addObject:dic];
        [_tableView reloadData];
        NSLog(@"-----%@",self.cellArray);
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellArray= [[NSMutableArray alloc]initWithCapacity:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"推送助手";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
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
    
    NSDictionary *dic = self.cellArray[indexPath.row];
    int type = [dic[@"facType"] intValue];
    switch (type) {
        case 0:
            cell.typeLB.text = @"服装厂";
            cell.businessLB.text = [NSString stringWithFormat:@"业务类型: %@",dic[@"businessType"]];
            break;
        case 1:
            cell.typeLB.text = @"代裁厂";
            cell.businessLB.hidden = YES;
            break;
        case 2:
            cell.typeLB.text = @"锁眼钉扣厂";
            cell.businessLB.hidden = YES;
            break;
        default:
            break;
    }
    if ( [dic[@"distence"] isEqualToString:@""] )
    {
        cell.distenceLB.text = @"距离: 不限距离";
    }
    else
    {
        cell.distenceLB.text = [NSString stringWithFormat:@"距离: %@",dic[@"distence"]];

    }
    
    if ( [dic[@"scale"] isEqualToString:@""] )
    {
        cell.scaleLB.text = @"规模: 不限规模";
    }
    else
    {
        cell.scaleLB.text = [NSString stringWithFormat:@"规模: %@",dic[@"scale"]];
    }
    
    cell.deletButton.tag = indexPath.row+1;
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
    [buttonImg addTarget:self action:@selector(buttonImgClick) forControlEvents:UIControlEventTouchUpInside];
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

- (void)buttonImgClick
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
    
    [self.cellArray removeObjectAtIndex:button.tag-1];
    [_tableView reloadData];
}

@end
