//
//  ShopViewController.m
//  cofactory-1.1
//
//  Created by 赵广印 on 15/10/8.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "ShopViewController.h"
#import "ShopCollectionViewCell.h"
#import "SupplyViewController.h"
#import "SearchSupplymaterialViewController.h"


static NSString *shopCellIdentifier = @"shopCell";
@interface ShopViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>{
    UILabel *titleLabel;
    UIButton *messageButton;
    UILabel *nameLabel;
    UILabel *addressLabel;
    UICollectionView *shopCollectionView;
    BOOL isDeleteStyle;
    UIButton *deleteBtn;
    FactoryModel  *_userModel;
    int  _refrushCount;
}
@property (nonatomic, strong) NSMutableArray *collectionImage;
@property (nonatomic, strong) NSMutableArray *historyArray;

@end

@implementation ShopViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.historyArray = [@[] mutableCopy];
    [self creatMessage];
    [self creatGobackButton];
    [self creatCollection];
    [self network];
    //[self setupRefresh];
    [shopCollectionView registerClass:[ShopCollectionViewCell class] forCellWithReuseIdentifier:shopCellIdentifier];
}

- (void)network {
    [HttpClient checkMaterialHistoryPublishWithPage:1 completionBlock:^(NSDictionary *responseDictionary) {
        NSArray *jsonArray = (NSArray *)responseDictionary[@"responseObject"];
        for (NSDictionary *dictionary in jsonArray) {
            SupplyHistory *history = [SupplyHistory getModelWith:dictionary];
            [self.historyArray addObject:history];
        }
        //解析工厂信息
        NSNumber *uid = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"selfuid"];
        [HttpClient getUserProfileWithUid:[uid intValue] andBlock:^(NSDictionary *responseDictionary) {
            _userModel = (FactoryModel *)responseDictionary[@"model"];
        }];
        [shopCollectionView reloadData];
    }];
}

- (void)creatMessage {
    UIImageView *bigView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 210)];
    bigView.image = [UIImage imageNamed:@"布背景"];
    bigView.userInteractionEnabled = YES;
    bigView.backgroundColor = [UIColor yellowColor];
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kScreenW - 70) / 2, 20, 70, 20)];
    titleLabel.text = @"面辅料商";
    titleLabel.font = kFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [bigView addSubview:titleLabel];
    
    messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageButton.frame = CGRectMake((kScreenW - 80)/2, CGRectGetMaxY(titleLabel.frame) + 10, 80, 80);
    messageButton.backgroundColor = [UIColor clearColor];
    [messageButton addTarget:self action:@selector(messageEventPress) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenW - 80)/2, CGRectGetMaxY(titleLabel.frame) + 10, 80, 80)];
    photoView.layer.cornerRadius = 40;
    photoView.clipsToBounds = YES;
    NSNumber *uid = (NSNumber *)[[NSUserDefaults standardUserDefaults] valueForKey:@"selfuid"];
    [photoView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/factory/%@.png",PhotoAPI,uid]] placeholderImage:[UIImage imageNamed:@"消息头像"]];

    [bigView addSubview:photoView];
    [bigView addSubview:messageButton];
    
    nameLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, CGRectGetMaxY(messageButton.frame) + 10, kScreenW, 20)];
    NSString *factoryName = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"factoryName"];
    nameLabel.text = factoryName;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = kFont;
    [bigView addSubview:nameLabel];
    
    addressLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, CGRectGetMaxY(nameLabel.frame), kScreenW, 20)];
    NSString *factoryAddress = (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:@"factoryAddress"];
    addressLabel.text = factoryAddress;
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.font = kFont;
    [bigView addSubview:addressLabel];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    editBtn.frame = CGRectMake(kScreenW - 70, CGRectGetMaxY(addressLabel.frame), 60, 25);
    [editBtn addTarget:self action:@selector(editActionEvent:) forControlEvents:UIControlEventTouchUpInside];
    editBtn.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    editBtn.layer.cornerRadius = 4;
    editBtn.clipsToBounds = YES;
    editBtn.tintColor = [UIColor blackColor];
    [bigView addSubview:editBtn];
    [self.view addSubview:bigView];
}

- (void)creatCollection {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    shopCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 210, kScreenW, kScreenH - 210) collectionViewLayout:layout];
    shopCollectionView.dataSource = self;
    shopCollectionView.tag = 1000;
    shopCollectionView.delegate = self;
    shopCollectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:shopCollectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.historyArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shopCellIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.shopImage.image = [UIImage imageNamed:@"发布面辅料+"];
        cell.nameLabel.text = @"添加产品";
    } else {
        SupplyHistory *history = self.historyArray[indexPath.row - 1];
        [cell.shopImage sd_setImageWithURL:[NSURL URLWithString:history.photo] placeholderImage:[UIImage imageNamed:@"placeholder88"]];
        cell.nameLabel.text = history.name;
    }
    
    deleteBtn = [cell valueForKey:@"but"];
    
    deleteBtn.tag = indexPath.row;
    [deleteBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];

    cell.isDeleteButtonHide = !isDeleteStyle;
    if (indexPath.row == 0) {
        [deleteBtn removeFromSuperview];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenW - 40)/3, (kScreenW - 40)/3);
    }
//设置某个分区的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
    }
//设置某个分区的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

//设置某个分区的最小的cell间距

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        DLog(@"发布产品！");
        SupplyViewController *supplyVC = [[SupplyViewController alloc] init];
        [self.navigationController pushViewController:supplyVC animated:YES];
    } else {
        SearchSupplymaterialViewController *searchSupplymaterialVC = [[SearchSupplymaterialViewController alloc] init];
        SupplyHistory *history = self.historyArray[indexPath.row - 1];
        searchSupplymaterialVC.oid = history.oid;
        searchSupplymaterialVC.type = history.type;
        searchSupplymaterialVC.photoArray = [NSMutableArray arrayWithArray:history.photoArray];
        [self.navigationController pushViewController:searchSupplymaterialVC animated:YES];
    }
}

- (void)editActionEvent:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        isDeleteStyle = YES;
    } else {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        isDeleteStyle = NO;
    }
    [shopCollectionView reloadData];
}

- (void)deleteCell:(UIButton*)sender {
    DLog(@"%ld",(long)sender.tag);
    
    SupplyHistory *history = self.historyArray[sender.tag - 1];
    [HttpClient deleteMaterialWithid:[history.oid intValue] completionBlock:^(int statusCode) {
        DLog(@"%d", statusCode);
    }];
    [self.historyArray removeObjectAtIndex:sender.tag - 1];
    [shopCollectionView reloadData];
}

- (void)messageEventPress {
    DLog(@"用户信息");
    CooperationInfoViewController *vc = [CooperationInfoViewController new];
    vc.factoryModel = _userModel;
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)pressCancleButton{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
