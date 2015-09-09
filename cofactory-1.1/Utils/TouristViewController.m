//
//  ViewController.m
//  542134
//
//  Created by gt on 15/7/25.
//  Copyright (c) 2015年 gt. All rights reserved.
//

#import "Header.h"
#import "TouristViewController.h"

@interface TouristViewController ()
{
    NSArray *_array;
    NSInteger _selectedRow;
}
@end

@implementation TouristViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"游客登录";
    // Do any additional setup after loading the view from its nib.
    _selectedRow = -1;

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW-64, kScreenH) style:UITableViewStyleGrouped];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.backgroundColor = [UIColor whiteColor];

    UIView*tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 120)];
    tableHeaderView.backgroundColor=[UIColor clearColor];
    UIImageView*logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenW/2-40, 10, 80, 80)];
    logoImage.image=[UIImage imageNamed:@"login_logo"];
    logoImage.layer.cornerRadius = 80/2.0f;
    logoImage.layer.masksToBounds = YES;
    [tableHeaderView addSubview:logoImage];


    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 93, kScreenW-60, 20)];
    label.text = @"请选择您的游客身份";
    label.textColor = [UIColor blackColor];
    label.font=[UIFont systemFontOfSize:15.0f];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];


    self.tableView.tableHeaderView = tableHeaderView;


    _array = @[@"服装厂",@"加工厂",@"代裁厂",@"锁眼钉扣厂"];

    UIView* FooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 60)];
    FooterView.backgroundColor = [UIColor whiteColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(30, 10, kScreenW-60, 40);
    button.layer.cornerRadius=5.0f;
    button.layer.masksToBounds=YES;
    button.layer.borderColor = [UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f].CGColor;
    button.layer.borderWidth = 1.0f;
    button.backgroundColor = [UIColor whiteColor];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:126.0f/255.0f blue:220/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];


    [FooterView addSubview:button];
    self.tableView.tableFooterView = FooterView;

    //返回Btn
    UIBarButtonItem *setButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBackClick)];
    self.navigationItem.rightBarButtonItem = setButton;
}


- (void)okButtonClick
{

    [ViewController TouristLogin];
}

- (void)goBackClick
{    
    DLog(@"toursitTag%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"toursitTag"]);
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 44)];

        cellLabel.textAlignment = NSTextAlignmentCenter;
        cellLabel.textColor = [UIColor blackColor];
        cellLabel.text = _array[indexPath.row];
        cellLabel.font = [UIFont systemFontOfSize:14.0f];
        [cell addSubview:cellLabel];

        if (indexPath.row == _selectedRow)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

    }




    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    _selectedRow = indexPath.row ;
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark ;
    [[NSUserDefaults standardUserDefaults]setInteger:indexPath.row forKey:@"toursitTag"];
     DLog(@"toursitTag=%ld",[[[NSUserDefaults standardUserDefaults]objectForKey:@"toursitTag"]integerValue]);
    [[NSUserDefaults standardUserDefaults]synchronize];
    [Tools showHudTipStr:[NSString stringWithFormat:@"您的游客身份为%@",_array[_selectedRow]]];
    [self.tableView reloadData];
//    [ViewController TouristLogin];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
}
- (void)dealloc {
    DLog(@"游客登录dealloc");
    self.tableView.dataSource = nil;
    self.tableView.delegate = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
