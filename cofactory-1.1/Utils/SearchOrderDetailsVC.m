//
//  SearchOrderDetailsVC.m
//  cofactory-1.1
//
//  Created by GTF on 15/10/13.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "SearchOrderDetailsVC.h"
#import "CompeteViewController.h"
#import "OrderPhotoViewController.h"
#import "IMChatViewController.h"

@interface SearchOrderDetailsVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView   *_tableView;
    NSArray       *_competeFactoryArray;
    BOOL           _isMyOrder;
    BOOL           _isCompete;
    UIButton      *_chatButton;
    UIButton      *_bidButton;
}

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";
@implementation SearchOrderDetailsVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self layoutCompeteData];
}

- (void)layoutCompeteData{
    
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfuid"];
    int myUid = [number intValue];
    
    if (myUid == self.model.uid) {
        _isMyOrder = YES;
    }else{
        _isMyOrder = NO;
    }
    
    [HttpClient getBidOrderWithOid:self.model.oid andBlock:^(NSDictionary *responseDictionary) {
        _competeFactoryArray = responseDictionary[@"responseArray"];
        
        if (!_isMyOrder) {
            if (_competeFactoryArray.count > 0) {
                [_competeFactoryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    FactoryModel *model = _competeFactoryArray[idx];
                    if (model.uid == myUid) {
                        _isCompete = YES;
                    }else{
                        _isCompete = NO;
                    }
                    if (_isCompete == YES) {
                        *stop = YES;
                    }
                    DLog(@"isCompete==%d",_isCompete);
                }];
            }
        }
        
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
    [self.view addSubview:_tableView];
    
    UIView *tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 184)];
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
    
    UILabel *facNameLB = [[UILabel alloc]initWithFrame:CGRectMake(imageButton.bounds.size.width+30, 20, kScreenW-imageButton.bounds.size.width-50, 30)];
    facNameLB.font = kLargeFont;
    facNameLB.text = self.model.facName;
    [tableHeadView addSubview:facNameLB];
    
    UILabel *userNameLB = [[UILabel alloc]initWithFrame:CGRectMake(facNameLB.frame.origin.x, 45, kScreenW-imageButton.bounds.size.width-50, 30)];
    userNameLB.font = kFont;
    userNameLB.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    userNameLB.text = [NSString stringWithFormat:@"%@  %@",self.model.name,self.model.phone];
    [tableHeadView addSubview:userNameLB];
    
//    if (self.model.interest > 0) {
//        UILabel *interestLB = [[UILabel alloc]initWithFrame:CGRectMake(facNameLB.frame.origin.x, 105, kScreenW-imageButton.bounds.size.width-50, 20)];
//        interestLB.textColor = [UIColor grayColor];
//        interestLB.font = kFont;
//        NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d  %@",self.model.interest,@"家厂商对此订单感兴趣"]];
//        NSString *lengthString = [NSString stringWithFormat:@"%d",self.model.interest];
//        NSInteger length = lengthString.length;
//        [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,length)];
//        interestLB.attributedText = labelText;
//        [tableHeadView addSubview:interestLB];
//    }
    
    UIImageView *arow = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW-28, 70, 11, 21)];
    arow.image = [UIImage imageNamed:@"箭头"];
    [tableHeadView addSubview:arow];
    
    UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    detailButton.frame = CGRectMake(kScreenW-60, 40, 60, 60);
    [detailButton addTarget:self action:@selector(facDetailClick) forControlEvents:UIControlEventTouchUpInside];
    [tableHeadView addSubview:detailButton];
    
    UILabel *lineLB0 = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW/2.0, 140+5, 0.8, 34)];
    lineLB0.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [tableHeadView addSubview:lineLB0];
    
    NSArray *imgeArray = @[@"实时对话",@"投标"];
    for (int i = 0; i<2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*kScreenW/2.0, 142, kScreenW/2.0, 40);
        [button setBackgroundImage:[UIImage imageNamed:imgeArray[i]] forState:UIControlStateNormal];
        button.tag = i + 100;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [tableHeadView addSubview:button];
        if (i == 0) {
            _chatButton = button;
        }if (i == 1){
            _bidButton = button;
        }
    }

    if (self.model.status == 0) {
        _bidButton.enabled = YES;
        
    }else{
        _bidButton.enabled = NO;
    }
    
    UILabel *lineLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 139, kScreenW, 0.8)];
    lineLB.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    [tableHeadView addSubview:lineLB];
    
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
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
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
        
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.font = kLargeFont;
            if (_competeFactoryArray.count == 0) {
                cell.textLabel.text = @"暂无厂商投标";
            }else{
                NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已参与投标的厂商有%zi家",_competeFactoryArray.count]];
                NSString *lengthString = [NSString stringWithFormat:@"%d",self.model.interest];
                NSInteger length = lengthString.length;
                [labelText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(9,length)];
                cell.textLabel.attributedText = labelText;
            }
            
        }else{
            cell.textLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
            cell.textLabel.font = kFont;
            if (_isMyOrder) {
                if (self.model.status == 0) {
                    cell.textLabel.text = @"订单未完成";
                }else{
                    cell.textLabel.text = @"订单已完成";
                }
            }else{
                
                if (self.model.status == 0) {
                    if (_isCompete) {
                        cell.textLabel.text = @"已投标";
                    }else{
                        cell.textLabel.text = @"未投标";
                    }
                    
                }else{
                    cell.textLabel.text = @"订单已完成";
                }
                
            }
        }
    }
    
    return cell;
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
    return 35;
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

- (void)facDetailClick{
    
    CooperationInfoViewController *vc = [CooperationInfoViewController new];
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
    backItem.title=@"返回";
    backItem.tintColor=[UIColor whiteColor];
    self.navigationItem.backBarButtonItem = backItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [HttpClient getUserProfileWithUid:self.model.uid andBlock:^(NSDictionary *responseDictionary) {
        FactoryModel *facModel = (FactoryModel *)responseDictionary[@"model"];
        vc.factoryModel = facModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];

}

- (void)buttonClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    if (button.tag == 101) {
        if (_isMyOrder) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不可投标自己的订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            
        NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"factoryType"];
        NSInteger facType = [number integerValue];
            if (facType == 5) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"面辅料商不可投标服装厂订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }else if (facType == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服装厂不可投标订单" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }else{
                if (_isCompete) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该订单您已投标" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }else{
                    DLog(@"tobid");
                    CompeteViewController *VC = [[CompeteViewController alloc]init];
                    VC.oid = self.model.oid;
                    [self.navigationController pushViewController:VC animated:YES];
                }
            }
        }
    }else{
        if (_isMyOrder) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不可同自己对话" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
            IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
            conversationVC.conversationType = ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
            conversationVC.targetId = [NSString stringWithFormat:@"%d", self.model.uid]; // 接收者的 targetId，这里为举例。
            conversationVC.userName = self.model.facName; // 接受者的 username，这里为举例。
            conversationVC.title = self.model.name; // 会话的 title。
            conversationVC.hidesBottomBarWhenPushed=YES;
            // 把单聊视图控制器添加到导航栈。
            UIBarButtonItem *backItem=[[UIBarButtonItem alloc]init];
            backItem.title=@"返回";
            self.navigationItem.backBarButtonItem = backItem;
            [self.navigationController.navigationBar setHidden:NO];
            [self.navigationController pushViewController:conversationVC animated:YES];
            DLog(@"chatClick");
        }
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
