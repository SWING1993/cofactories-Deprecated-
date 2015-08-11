//
//  SearchOrderListDetailsVC.m
//  cofactory-1.1
//
//  Created by gt on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "SearchOrderListDetailsVC.h"
@interface SearchOrderListDetailsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_interestCountLabel;
    UILabel *_label;
    UIView *_view;//gt123
}


@end

@implementation SearchOrderListDetailsVC


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"订单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //设置返回按钮
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    self.navigationItem.leftBarButtonItem = backButton;

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-80) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    if (kScreenH>568)
    {
        self.tableView.rowHeight = 50;
    }
    else
    {
        self.tableView.rowHeight = 45;
    }
    self.tableView.backgroundColor = [UIColor whiteColor];

    //表头试图
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 170)];
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = tableHeaderView;

    //表头试图添加UI

    UILabel *comanyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 15, 165, 30)];
    comanyNameLabel.text = self.model.facName;
    NSLog(@"*****+++%@",self.model.facName);
    comanyNameLabel.font = [UIFont systemFontOfSize:15.0f];
    [tableHeaderView addSubview:comanyNameLabel];

    UILabel *orderImageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, kScreenW, 15)];
    orderImageLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
    orderImageLabel.text = [NSString stringWithFormat:@"     %@",@"订单图片"];
    orderImageLabel.textColor = [UIColor whiteColor];
    orderImageLabel.font = [UIFont systemFontOfSize:14.0f];
    [tableHeaderView addSubview:orderImageLabel];

    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.cofactories.com/order/%d.png",self.model.oid]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder232"]];//gt123
    NSLog(@"*****+++%@",[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.cofactories.com/order/%d.png",self.model.oid]]);

    imageButton.frame = CGRectMake((kScreenW-46)/2.0, 85+3, 46, 46);
    imageButton.layer.masksToBounds = YES;
    imageButton.layer.cornerRadius = 5;
    [imageButton addTarget:self action:@selector(imageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:imageButton];

    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 138, kScreenW-40, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    [tableHeaderView addSubview:lineLabel];

    _interestCountLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-120)/2.0, 140, 20, 20)];
    _interestCountLabel.font = [UIFont systemFontOfSize:12.0f];
    _interestCountLabel.textColor = [UIColor orangeColor];
    [tableHeaderView addSubview:_interestCountLabel];

    _label= [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-120)/2.0+25, 140,120 , 20)];
    _label.font = [UIFont systemFontOfSize:12.0f];
    [tableHeaderView addSubview:_label];

    NSLog(@"=====%@",self.model.interest);
    NSLog(@"=====%@",self.model.facName);


    if (self.model.interest == nil)
    {
        _interestCountLabel.hidden = YES;
        _label.hidden = YES;
        NSLog(@"11");
    }
    else
    {
        _interestCountLabel.hidden = NO;
        _label.hidden = NO;
        ////////////////////////////////////////////////////////////////////////
        _interestCountLabel.text = self.model.interest;
        _label.text = @"厂商对此订单感兴趣";
        NSLog(@"22");
    }

    self.contactManufacturerView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW-60, 10, 40,40)];
    self.contactManufacturerView.backgroundColor=[UIColor clearColor];
    [tableHeaderView addSubview:self.contactManufacturerView];

//    //联系厂商按钮
    UIButton *contactManufacturerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactManufacturerButton .frame = CGRectMake(0, 0, 40,40);
    [contactManufacturerButton setBackgroundImage:[UIImage imageNamed:@"PHONE.png"] forState:UIControlStateNormal];
    [contactManufacturerButton addTarget:self action:@selector(contactManufacturerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contactManufacturerView addSubview:contactManufacturerButton];



    for (int i = 0; i<2; i++)
    {
        UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(0, 60+i*100, [UIScreen mainScreen].bounds.size.width, 10)];
        labels.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
        [tableHeaderView addSubview:labels];
    }
}


#pragma mark--表的协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"联系人:   %@",self.model.name];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = [UIColor grayColor];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"联系电话:   %@",self.model.phone];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = [UIColor grayColor];
            break;
        case 2:

            if (self.model.type == 1)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"订单类型:   %@",@"加工厂"];
            }
            if (self.model.type == 2)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"订单类型:   %@",@"代裁厂"];
            }if(self.model.type == 3){
                cell.textLabel.text = [NSString stringWithFormat:@"订单类型:   %@",@"锁眼钉扣厂"];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = [UIColor grayColor];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"订单数量:   %d",self.model.amount];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = [UIColor grayColor];
            break;
        case 4:
            cell.textLabel.text = [NSString stringWithFormat:@"工期:   %@天",self.model.workingTime];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = [UIColor grayColor];
            break;
        case 5:
            ;

            cell.textLabel.text = [NSString stringWithFormat:@"下单时间:   %@",[[Tools WithTime:self.model.createTime]firstObject]];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = [UIColor grayColor];
            break;

        default:
            break;
    }

    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    view.backgroundColor = [UIColor whiteColor];

    UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 80, 35)];
    detailLabel.text = @"订单详情";
    [view addSubview:detailLabel];

    UILabel *orderNumlLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-160, 0, 140, 35)];
    orderNumlLabel.text = [NSString stringWithFormat:@"订单号 :  %d",self.model.oid];
    orderNumlLabel.font = [UIFont systemFontOfSize:14.0f];
    orderNumlLabel.textColor = [UIColor grayColor];
    [view addSubview:orderNumlLabel];

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(14, 35, [UIScreen mainScreen].bounds.size.width, 0.8)];
    lineView.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    [view addSubview:lineView];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
//    view.backgroundColor = [UIColor whiteColor];
//
//
//    //确认订单按钮
//    self.confirmOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.confirmOrderButton .frame = CGRectMake((kScreenW-140)/2.0, 10, 140, 35);
//    self.confirmOrderButton .backgroundColor = [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1.0];
//    self.confirmOrderButton .layer.masksToBounds = YES;
//    self.confirmOrderButton .layer.cornerRadius = 3;
//    [self.confirmOrderButton  setTitle:@"确认订单" forState:UIControlStateNormal];
//    [self.confirmOrderButton  addTarget:self action:@selector(confirmOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:self.confirmOrderButton];
//
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 55;
//}

#pragma mark--按钮绑定方法
- (void)goToCompanyDetailClick
{
    NSLog(@"前往公司详情界面");
}

- (void)backButtonClick
{

    [self.navigationController popViewControllerAnimated:YES];

}

- (void)imageButtonClick

{
    //gt123
    _view=[[UIView alloc]initWithFrame:kScreenBounds];
    _view.backgroundColor=[UIColor clearColor];

    UIImageView*photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenH/4, kScreenW, kScreenW)];
    [photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.cofactories.com/order/%d.png",self.model.oid]] placeholderImage:[UIImage imageNamed:@"placeholder232"]];
    photoView.contentMode=UIViewContentModeScaleAspectFill;
    photoView.clipsToBounds=YES;
    [_view addSubview:photoView];
    [self.view addSubview:_view];

    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleBtn.frame = _view.frame;
    [cancleBtn addTarget:self action:@selector(cancleBtn) forControlEvents:UIControlEventTouchUpInside];
    [_view addSubview:cancleBtn];
    
}
-(void)cancleBtn//gt123
{
    [_view removeFromSuperview];
}



- (void)contactManufacturerClick
{
    NSLog(@"联系厂商");
    NSLog(@"%@",self.model.phone);
    NSString *str = [NSString stringWithFormat:@"telprompt://%@", self.model.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

    //感兴趣
    [HttpClient interestOrderWithOid:self.model.oid andBlock:^(int statusCode) {
        NSLog(@"感兴趣状态码%d",statusCode);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
