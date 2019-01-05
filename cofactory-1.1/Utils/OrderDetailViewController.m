//
//  OrderDetailViewController.m
//  cofactory-1.1
//
//  Created by GTF on 15/10/15.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderPhotoViewController.h"
#import "OrderDetailTableViewCell.h"
#import "BidManagerViewController.h"

@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView   *_tableView;
    NSArray       *_competeFactoryArray;
    UIButton      *_chatButton;
    UIButton      *_bidButton;
}
@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
static NSString *const reuseIdentifier1 = @"reuseIdentifier1";

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
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0];
    [self creatTableView];
    
}

- (void)creatTableView{
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [_tableView registerClass:[OrderDetailTableViewCell class] forCellReuseIdentifier:reuseIdentifier1];
    [self.view addSubview:_tableView];
    
    UIView *tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 140)];
    tableHeadView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = tableHeadView;
    
    UIButton *imageButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 20, 140, 100)];
    if (self.model.photoArray.count > 0) {
        [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.model.photoArray[0]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder232"]];
        [imageButton addTarget:self action:@selector(orderImageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [imageButton setBackgroundImage:[UIImage imageNamed:@"placeholder232"] forState:UIControlStateNormal];
    }
    [tableHeadView addSubview:imageButton];
    
    NSString *facName = [[NSUserDefaults standardUserDefaults] objectForKey:@"factoryName"];
    NSString *facPhone = [[NSUserDefaults standardUserDefaults] objectForKey:@"factoryPhone"];
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    UILabel *facNameLB = [[UILabel alloc]initWithFrame:CGRectMake(imageButton.bounds.size.width+30, 20, kScreenW-imageButton.bounds.size.width-50, 30)];
    facNameLB.font = kLargeFont;
    facNameLB.text = facName;
    [tableHeadView addSubview:facNameLB];
    
    UILabel *userNameLB = [[UILabel alloc]initWithFrame:CGRectMake(facNameLB.frame.origin.x, 45, kScreenW-imageButton.bounds.size.width-50, 30)];
    userNameLB.font = kFont;
    userNameLB.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    userNameLB.text = [NSString stringWithFormat:@"%@  %@",userName,facPhone];
    [tableHeadView addSubview:userNameLB];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (self.model.type == 1) {
            return 4;
        }else{
            return 3;
        }
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        cell.textLabel.font = kFont;
        if (self.model.type == 1) {
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"订单类型          %@",self.model.serviceRange];
                    break;
                case 1:
                    cell.textLabel.text = [NSString stringWithFormat:@"订单数量          %d件",self.model.amount];
                    break;
                case 2:
                    cell.textLabel.text = [NSString stringWithFormat:@"订单工期          %@天",self.model.workingTime];
                    break;
                case 3:
                {
                    NSString *string = [Tools WithTime:self.model.createTime][0];
                    cell.textLabel.text = [NSString stringWithFormat:@"下单时间          %@",string];
                }
                    break;
                    
                default:
                    break;
            }
        }else{
            switch (indexPath.row) {
                    
                case 0:
                    cell.textLabel.text = [NSString stringWithFormat:@"订单数量          %d件",self.model.amount];
                    break;
                case 1:
                {
                    NSString *string = [NSString stringWithFormat:@"%@",self.model.workingTime];
                    if ([string isEqualToString:@"0"] ) {
                        cell.textLabel.text = [NSString stringWithFormat:@"订单工期          一天以内"];
                    }else{
                        cell.textLabel.text = [NSString stringWithFormat:@"订单工期          %@天",self.model.workingTime];
                    }
                }
                    break;
                case 2:
                {
                    NSString *string = [Tools WithTime:self.model.createTime][0];
                    cell.textLabel.text = [NSString stringWithFormat:@"下单时间          %@",string];
                }
                    break;
                    
                default:
                    break;
            }
        }
        return cell;
        
        
    }else{
        OrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_competeFactoryArray.count == 0) {
            cell.bidAmountLB.text = @"暂无厂商投标";
        }else{
            NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已参与投标的厂商有%zi家",_competeFactoryArray.count]];
            NSString *lengthString = [NSString stringWithFormat:@"%d",self.model.interest];
            NSInteger length = lengthString.length;
            [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9,length)];
            cell.bidAmountLB.attributedText = labelText;
        }
        [cell.bidManagerButton addTarget:self action:@selector(bidManagerClick) forControlEvents:UIControlEventTouchUpInside];
        if (self.isHistory) {
            cell.bidManagerButton.enabled = NO;
        }else{
            cell.bidManagerButton.enabled = YES;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 12+50;
    }
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 120;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 35;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 62)];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, kScreenW, 50)];
        bgView.backgroundColor = [UIColor whiteColor];
        [header addSubview:bgView];
        
        UILabel *LB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 90, 50)];
        LB.font = kLargeFont;
        LB.text = @"订单详情";
        [bgView addSubview:LB];
        
        UILabel *LB1 = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, kScreenW-140, 50)];
        LB1.font = kSmallFont;
        LB1.textColor = [UIColor grayColor];
        LB1.text = [NSString stringWithFormat:@"订单编号: %d",self.model.oid];
        LB1.textAlignment = 2;
        [bgView addSubview:LB1];
        
        UILabel *lineLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 49, kScreenW, 0.8)];
        lineLB.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        [bgView addSubview:lineLB];
        
        
        return header;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 132)];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
        bgView.backgroundColor = [UIColor whiteColor];
        [header addSubview:bgView];
        
        UILabel *lineLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 0.8)];
        lineLB.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        [bgView addSubview:lineLB];
        
        // set warp and line spacing
        NSString *string = [NSString stringWithFormat:@"备注信息: %@",self.model.comment];
        NSDictionary *attribute = @{NSFontAttributeName: kFont};
        CGSize size = [string boundingRectWithSize:CGSizeMake(kScreenW-40, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                        attributes:attribute context:nil].size;
        
        UILabel *LB1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, size.width, size.height+15)];
        LB1.font = kFont;
        LB1.numberOfLines = 0;
        LB1.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        LB1.text = string;
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:LB1.text];;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:5];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, LB1.text.length)];
        LB1.attributedText = attributedString;
        
        [bgView addSubview:LB1];
        
        return header;
    }
    return nil;
    
}

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

- (void)bidManagerClick{
    BidManagerViewController *vc = [[BidManagerViewController alloc]init];
    if (_competeFactoryArray.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"暂无厂商投标" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        vc.bidFactoryArray = _competeFactoryArray;
        vc.oid = self.model.oid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
