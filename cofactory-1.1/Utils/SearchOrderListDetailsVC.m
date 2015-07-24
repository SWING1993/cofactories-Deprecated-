//
//  SearchOrderListDetailsVC.m
//  cofactory-1.1
//
//  Created by gt on 15/7/24.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "SearchOrderListDetailsVC.h"
#import "Header.h"
@interface SearchOrderListDetailsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_interestCountLabel;
    UILabel *_label;
}
@property (nonatomic,strong) OrderModel *model;


@end

@implementation SearchOrderListDetailsVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"订单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [HttpClient getOrderDetailWithOid:self.oid andBlock:^(NSDictionary *responseDictionary) {
        
        self.model = responseDictionary[@"model"];
        [self.tableView reloadData];
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    UIImageView *companyImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 50, 50)];
    companyImage.backgroundColor = [UIColor orangeColor];
    companyImage.layer.masksToBounds = YES;
    companyImage.layer.cornerRadius = 25;
    [tableHeaderView addSubview:companyImage];
    
    UILabel *comanyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 165, 30)];
    comanyNameLabel.text = self.model.facName;
    comanyNameLabel.font = [UIFont systemFontOfSize:13.0f];
    [tableHeaderView addSubview:comanyNameLabel];
    
    UIButton *companyDetailsBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    companyDetailsBtn.frame = CGRectMake(kScreenW-50, 9, 15,15);
    [companyDetailsBtn setBackgroundImage:[UIImage imageNamed:@"箭头.png"] forState:UIControlStateNormal];
    [companyDetailsBtn addTarget:self action:@selector(goToCompanyDetailClick) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:companyDetailsBtn];
    
    UILabel *orderImageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, kScreenW, 15)];
    orderImageLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
    orderImageLabel.text = [NSString stringWithFormat:@"     %@",@"订单图片"];
    orderImageLabel.textColor = [UIColor whiteColor];
    orderImageLabel.font = [UIFont systemFontOfSize:11.0f];
    [tableHeaderView addSubview:orderImageLabel];
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.backgroundColor = [UIColor cyanColor];
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
    //    _interestCountLabel.backgroundColor = [UIColor redColor];
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
        _interestCountLabel.text = self.model.interest;
        _label.text = @"厂商对此订单感兴趣";
        NSLog(@"22");
        
    }
    
    self.contactManufacturerView = [[UIView alloc]initWithFrame:CGRectMake(kScreenW-75-20, 31
                                                                           , 75,25)];
    self.contactManufacturerView.layer.borderWidth = 1;
    self.contactManufacturerView.layer.borderColor = [UIColor colorWithRed:156/255.0 green:208/255.0 blue:131/255.0 alpha:1.0].CGColor;
    self.contactManufacturerView.layer.masksToBounds = YES;
    self.contactManufacturerView.layer.cornerRadius = 5;
    [tableHeaderView addSubview:self.contactManufacturerView];
    
    
    UIImageView *phongImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7,3, 20, 20)];
    phongImageView.image = [UIImage imageNamed:@"PHONE.png"];
    [self.contactManufacturerView addSubview:phongImageView];
    
    UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(28, 3, 50, 20)];
    lb.text = @"联系厂商";
    lb.font = [UIFont systemFontOfSize:10.0f];
    [self.contactManufacturerView addSubview:lb];
    
    //联系厂商按钮
    UIButton *contactManufacturerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    contactManufacturerButton .frame = CGRectMake(0, 0, 75,25);
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
            cell.textLabel.text = [NSString stringWithFormat:@"工期:   %@",self.model.workingTime];
            cell.textLabel.font = [UIFont systemFontOfSize:13];
            cell.textLabel.textColor = [UIColor grayColor];
            break;
        case 5:
            cell.textLabel.text = [NSString stringWithFormat:@"下单时间:   %@",self.model.createTime];
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
    
    UILabel *orderNumlLabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-140, 0, 140, 35)];
    orderNumlLabel.text = [NSString stringWithFormat:@"订单号 :  %d",self.model.oid];
    orderNumlLabel.font = [UIFont systemFontOfSize:10.0f];
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
    NSLog(@"加载订单图片的大图");
}

- (void)contactManufacturerClick
{
    NSLog(@"联系厂商");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
