//
//  OrderDetailViewController.m
//  111111
//
//  Created by 宇宙之神 on 15/7/19.
//  Copyright (c) 2015年 宇宙之神. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "Header.h"
#import "OrderListViewController.h"

@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UILabel *label;
    UILabel *interestCountLabel;
        UIView *_view;//gt123
    UITableView*tableView;
}

@property (nonatomic,strong)UserModel *userModel;
@end

@implementation OrderDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //gt123
    if (self.isHistory == YES)
    {
        self.contactManufacturerView.hidden = YES;
    }
    self.navigationItem.title = @"订单详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:[UIColor whiteColor]}];

//    [HttpClient getOrderDetailWithOid:self.model.uid andBlock:^(NSDictionary *responseDictionary) {
//
//        NSLog(@">>>++%@",responseDictionary);
//
//    }];

    [HttpClient getUserProfileWithBlock:^(NSDictionary *responseDictionary) {

            NSLog(@">>>++==%@",responseDictionary);

        self.userModel = [responseDictionary objectForKey:@"model"];
        [tableView reloadData];

    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    tableView = [[UITableView alloc]initWithFrame:kScreenBounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    if (kScreenH>568)
    {
        tableView.rowHeight = 50;
    }
    else
    {
        tableView.rowHeight = 45;
    }
    tableView.backgroundColor = [UIColor whiteColor];
    
    //表头试图
    UIView *tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 100)]; //170
    tableHeaderView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = tableHeaderView;

    UILabel *orderImageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 15)];
    orderImageLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:106/255.0 blue:106/255.0 alpha:1.0];
    orderImageLabel.text = [NSString stringWithFormat:@"     %@",@"订单图片"];
    orderImageLabel.textColor = [UIColor whiteColor];
    orderImageLabel.font = [UIFont systemFontOfSize:14.0f];
    [tableHeaderView addSubview:orderImageLabel];

//    [[SDImageCache sharedImageCache]clearDisk];
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.cofactories.com/order/%d.png",self.model.oid]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"消息头像"]];//

    NSLog(@"model.uid%d",self.model.uid);

    imageButton.frame = CGRectMake((kScreenW-46)/2.0, 15, 46, 46);
    imageButton.layer.masksToBounds = YES;
    imageButton.layer.cornerRadius = 5;
    [imageButton addTarget:self action:@selector(imageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:imageButton];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 68, kScreenW-40, 1)];
    lineLabel.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    [tableHeaderView addSubview:lineLabel];
    
    interestCountLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenW-120)/2.0-13, 70, 40, 20)];
    interestCountLabel.font = [UIFont systemFontOfSize:13.0f];
    interestCountLabel.textColor = [UIColor orangeColor];
    interestCountLabel.textAlignment = 2;
    [tableHeaderView addSubview:interestCountLabel];
    
    label= [[UILabel alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-120)/2.0+25, 70,120 , 20)];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.text = @"家厂商对此订单感兴趣";
    [tableHeaderView addSubview:label];

//    if (self.model.interest == nil)
//    {
//        label.hidden = YES;
//    }else
//    {
//        interestCountLabel.text = self.model.interest;
//        label.hidden = NO;
//    }


    UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, 10)];
    labels.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:1.0];
    [tableHeaderView addSubview:labels];
    [self.view addSubview:tableView];
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
    cell.textLabel.font = [UIFont systemFontOfSize:14];

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = [NSString stringWithFormat:@"联系人:   %@",self.userModel.name];
            break;
        case 1:
            cell.textLabel.text = [NSString stringWithFormat:@"联系电话:   %@",self.userModel.phone];
            break;
        case 2:
        {
            switch (self.model.type) {
                case 1:
                    cell.textLabel.text = @"订单类型:   加工厂";
                    break;
                case 2:
                    cell.textLabel.text = @"订单类型:   代裁厂";
                    break;
                case 3:
                    cell.textLabel.text = @"订单类型:   锁眼钉扣厂";
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"订单数量:   %d",self.model.amount];
            break;
        case 4:

            cell.textLabel.text = [NSString stringWithFormat:@"工期:   %@天",self.model.workingTime];
            break;
        case 5:{
            NSString*timeString =[[Tools WithTime:self.model.createTime] firstObject];
            cell.textLabel.text =[NSString stringWithFormat:@"下单时间:   %@",timeString];
        }
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

    UILabel *orderNumlLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenW-140, 0, 140, 35)];
    orderNumlLabel.text = [NSString stringWithFormat:@"订单号 :  %d",self.model.oid];
    orderNumlLabel.font = [UIFont systemFontOfSize:15.0f];
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

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35)];
    view.backgroundColor = [UIColor whiteColor];

    if (self.isHistory == YES)
    {
        NSLog(@"2222222");
    }if (self.isHistory == NO)
    {
        //确认订单按钮
        self.confirmOrderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.confirmOrderButton .frame = CGRectMake(20, 10, kScreenW-40, 35);
        self.confirmOrderButton .backgroundColor = [UIColor colorWithHexString:@"0x3bbd79"];
        self.confirmOrderButton .layer.masksToBounds = YES;
        self.confirmOrderButton .layer.cornerRadius = 3;
        [self.confirmOrderButton  setTitle:@"确认订单" forState:UIControlStateNormal];
        [self.confirmOrderButton  addTarget:self action:@selector(confirmOrderButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.confirmOrderButton];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 55;
}

#pragma mark--按钮绑定方法
- (void)goToCompanyDetailClick
{
    NSLog(@"前往公司详情界面");
}

- (void)confirmOrderButtonClick
{
    NSLog(@"确认订单");

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"是否确认订单" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
    [alertView show];


}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {


        [HttpClient closeOrderWithOid:self.model.oid andBlock:^(NSDictionary *responseDictionary) {
            NSLog(@"oid==%d==%@",self.model.oid,responseDictionary);

            if ([responseDictionary[@"statusCode"] intValue]==200) {
                self.isHistory = YES;
                self.title=@"历史订单";
//                self.orderModerArr=[[NSMutableArray alloc]initWithCapacity:0];
                [HttpClient listHistoryOrderWithBlock:^(NSDictionary *responseDictionary) {
                    if ([responseDictionary[@"statusCode"] intValue]==200) {
//                        self.orderModerArr=responseDictionary[@"responseArray"];
//                        [_tableView reloadData];
                        OrderListViewController *vc = [[OrderListViewController alloc]init];
                        vc.isHistory = YES;
                        vc.HiddenJSDropDown = YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                }];
            }
        }];
    }
}
- (void)imageButtonClick

{
    _view=[[UIView alloc]initWithFrame:kScreenBounds];
    _view.backgroundColor=[UIColor clearColor];

    UIImageView*photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenH/4, kScreenW, kScreenW)];
    [photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://cdn.cofactories.com/order/%d.png",self.model.oid]] placeholderImage:[UIImage imageNamed:@"placeholder232"] ];
    photoView.contentMode=UIViewContentModeScaleAspectFill;
    photoView.clipsToBounds=YES;
    [_view addSubview:photoView];
    [self.view addSubview:_view];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_view removeFromSuperview];

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
