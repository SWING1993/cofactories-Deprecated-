//
//  NeedMaterialViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/9/24.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "NeedMaterialViewController.h"
#import "PHPDetailTableViewCell.h"
#import "PHPDetailMessCell.h"
#import "JKPhotoBrowser.h"
#import "PurchasePublicHistoryModel.h"
#import "CompeteMaterialViewController.h"
#import "LookOverNeedModel.h"

@interface NeedMaterialViewController () <UITableViewDataSource,UITableViewDelegate>{
    
    UITableView    *_tableView;
    UIScrollView   *_scrollView;
    UIView         *_headView;
    FactoryModel   *_userModel;
    NSArray *_competeFactoryArray;
}
@property (nonatomic,assign) BOOL isCompete;

@end

static NSString *const reuseIdentifier1 = @"reuseIdentifier1";
static NSString *const reuseIdentifier2 = @"reuseIdentifier2";

@implementation NeedMaterialViewController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
    [self netWork];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    
    [self prefersStatusBarHidden];
    [self creatTableView];
    [self creatGobackButton];
    
}

- (void)netWork {
    [HttpClient getNeedMaterialDetailMessageWithId:self.oid completionBlock:^(NSDictionary *responseDictionary) {
        self.detail = responseDictionary[@"model"];
        [self layoutCompeteData];
        //解析工厂信息
        [HttpClient getUserProfileWithUid:self.detail.uid andBlock:^(NSDictionary *responseDictionary) {
            _userModel = (FactoryModel *)responseDictionary[@"model"];
        }];

        [_tableView reloadData];
        
    }];
}

- (void)creatTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, kScreenW, kScreenH + 20) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;//去掉tableView的滚动条
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier1];
    [_tableView registerClass:[PHPDetailTableViewCell class] forCellReuseIdentifier:reuseIdentifier2];
    [self.view addSubview:_tableView];
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH)/2.0-30)];
    _tableView.tableHeaderView = _headView;
    
    if (self.photoArray.count == 0) {
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:_headView.frame];
        bgImageView.image = [UIImage imageNamed:@"没有上传图片"];
        [_headView addSubview:bgImageView];
        
    }else{
        [self creatScrollView];
    }
}

- (void)creatGobackButton{
    UIImageView *cancleImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    cancleImage.image = [UIImage imageNamed:@"goback"];
    [self.view addSubview:cancleImage];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, 20, 80, 40);
    [cancleButton addTarget:self action:@selector(pressCancleButton) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cancleButton];
}



- (void)creatScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH)/2.0-30)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_headView addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(kScreenW * self.photoArray.count, (kScreenH)/2.0-30);
    for (int i = 0; i < self.photoArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.photoArray[i]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
        [button setFrame:CGRectMake(i * kScreenW, 0, kScreenW, (kScreenH)/2.0-30)];
        [button addTarget:self action:@selector(MJPhotoBrowserClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_scrollView addSubview:button];
        
    }
}


- (void)layoutCompeteData{
    
    [HttpClient getMaterialBidOrderWithOid:[self.oid intValue] andBlock:^(NSDictionary *responseDictionary) {
        _competeFactoryArray = responseDictionary[@"responseArray"];
        DLog(@"%ld", self.detail.uid);
        NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfuid"];
        int myUid = [number intValue];
        
        
        [_competeFactoryArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            FactoryModel *model = _competeFactoryArray[idx];
            
            if (model.uid == myUid) {
                self.isCompete = YES;
                *stop = YES;
            }else{
                self.isCompete = NO;
            }
            
        }];
        
        [_tableView reloadData];
    }];
    
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        PHPDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier2 forIndexPath:indexPath];
        cell.phoneButton.hidden = NO;
        [cell.phoneButton addTarget:self action:@selector(contactWithFactory) forControlEvents:UIControlEventTouchUpInside];
        [cell getDataWithOtherModel:self.detail.uid isMaterial:YES];
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier1 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
        
        NSString *timeString = [self.detail.createdAt substringToIndex:10];
        
        
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"名称:  %@",self.needName];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"数量:  %ld%@",self.detail.amount, self.amount];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"时间:  %@",timeString];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"备注:  %@",self.detail.info];
                break;
            default:
                break;
        }
        
        return cell;

    }

}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 74+15)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *competeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        competeButton.frame = CGRectMake(30, 20, kScreenW-60, 40);
        competeButton.backgroundColor = [UIColor colorWithHexString:@"0x3bbc79"];
        competeButton.layer.masksToBounds = YES;
        competeButton.layer.cornerRadius = 5;
        [competeButton addTarget:self action:@selector(bidManager) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:competeButton];
        if (self.isCompletion == YES) {
            [competeButton setTitle:@"订单完成" forState:UIControlStateNormal];
            competeButton.enabled = NO;
        } else {
            if (self.isCompete == YES) {
                
                [competeButton setTitle:@"已投标" forState:UIControlStateNormal];
                competeButton.enabled = NO;
            }
            if (self.isCompete == NO) {
                [competeButton setTitle:@"参与投标" forState:UIControlStateNormal];
                competeButton.enabled = YES;
            }
        }
        
        return view;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    } else {
        return 44;
    }
}


    
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else if (section == 1){
        return 80;
    }else {
        return 0;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CooperationInfoViewController *vc = [CooperationInfoViewController new];
        vc.factoryModel = _userModel;
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 1 && indexPath.row == 3) {
        [Tools showString:[NSString stringWithFormat:@"备注:  %@",self.detail.info]];
    }
}





- (void)MJPhotoBrowserClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.detail.photoArray count]];
    [self.detail.photoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.detail.photoArray[idx]]];
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = button.tag;
    browser.photos = photos;
    [browser show];
    
}

- (void)buttonTwoBtnClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        
    }else if (button.tag == 1){
        
    }
}

- (void)bidManager{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"selfuid"];
    int myUid = [number intValue];

    if (self.detail.uid == myUid) {
        [Tools showErrorWithStatus:@"自己的标, 自己不能投"];
        
    } else {
        CompeteMaterialViewController *competeVC = [[CompeteMaterialViewController alloc] init];
        UINavigationController *competeNaVC = [[UINavigationController alloc] initWithRootViewController:competeVC];
        competeNaVC.navigationBar.barStyle = UIBarStyleBlack;
        competeVC.oid = self.detail.oid;
        [self presentViewController:competeNaVC animated:YES completion:nil];
        
 
    }
    
    
    DLog(@"11223");
}

- (void)pressCancleButton{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)contactWithFactory{
    NSString *str = [NSString stringWithFormat:@"telprompt://%@", self.detail.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
